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

    row.update = (data) ->
      changes = _.pairs data.changes

      _.each changes, (change) ->
        attribute = change[0]
        new_value = change[1][1]
        old_value = change[1][0]

        if row[attribute] == old_value
          row[attribute] = new_value

    row.rate_save = _.debounce(row.save, 500)

    row
]

@PitchCtrl = ($scope, Restangular) ->
  $scope.id = $('#proposal').data('id')

  new Pitch.Stream($scope)

  Restangular.one("proposals", $scope.id).get().then (proposal) ->
    $scope.proposal = proposal

  # TODO These methods sound like they do the same thing, but in reality are
  # doing very different things.
  $scope.createRow = ->
    $scope.proposal.rows.post(position: $scope.proposal.rows.length)

  $scope.addRow = (id) ->
    rowPromise = $scope.proposal.one('rows', id).get()

    rowPromise.then (row) ->
      $scope.proposal.rows.push(row)

  $scope.deleteRow = (index) ->
    $scope.proposal.rows[index].remove()

  $scope.removeRow = (index) ->
    $scope.proposal.rows.splice(index, 1)

  $scope.save = ->
    $scope.proposal.save()

  $scope.$on 'update', (e, data) ->
    if data.item == "row"
      row = _.find $scope.proposal.rows, (row) -> row.id == data.id

      switch data.action
        when 'create'  then $scope.addRow(data.id)
        when 'update'  then row.update(data)
        when 'destroy' then $scope.removeRow($scope.proposal.rows.indexOf(row))

    $scope.$apply()

