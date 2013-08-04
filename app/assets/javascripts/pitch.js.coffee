app = angular.module("Pitch", ['restangular'])

app.config ["$httpProvider", ($httpProvider) ->
  csrfToken = $('meta[name=csrf-token]').attr('content')
  $httpProvider.defaults.headers.post['X-CSRF-Token'] = csrfToken
  $httpProvider.defaults.headers.put['X-CSRF-Token'] = csrfToken
  $httpProvider.defaults.headers.delete ||= {}
  $httpProvider.defaults.headers.delete['X-CSRF-Token'] = csrfToken
]

app.config ["RestangularProvider", (RestangularProvider) ->
  RestangularProvider.extendModel 'proposals', (proposal) ->
    proposal.subtotal = ->
      sum = 0.0
      angular.forEach this.rows, (row) ->
        sum += row.extended_price()
      sum

    proposal.tax = ->
      this.subtotal() * 0.07 # RI Tax

    proposal.total = ->
      this.tax() + this.subtotal()

    proposal.getList('rows').then (rows) ->
      proposal.rows = rows

    proposal.save = ->
      this.put()

      angular.forEach this.rows, (row) ->
        row.save()

    proposal

  RestangularProvider.extendModel 'rows', (row) ->
    row.extended_price = ->
      if this.price? and this.quantity?
        this.price * this.quantity
      else
        0

    row.save = ->
      row.put()

    row.rate_save = _.debounce(row.save, 500)

    row
]

@PitchCtrl = ($scope, Restangular) ->
  Restangular.one("proposals", 1).get().then (proposal) ->
    $scope.proposal = proposal

  $scope.addRow = ->
    rowPromise = $scope.proposal.rows.post(position: $scope.proposal.rows.length)
    rowPromise.then (row) ->
      $scope.proposal.rows.push(row)

  $scope.deleteRow = (index) ->
    promise = $scope.proposal.rows[index].remove()
    promise.then (row) ->
      $scope.proposal.rows.splice(index, 1)

  $scope.save = ->
    $scope.proposal.save()
