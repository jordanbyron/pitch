app = angular.module("Pitch", ['restangular', 'ui.sortable'])

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

    proposal.save = -> this.put()

    proposal.update = (data) -> new Pitch.StreamUpdater(proposal, data)

    proposal.destroy = ->
      # TODO Show a message alerting the user that the proposal has been deleted
      window.location.href = "/proposals"

    proposal.rate_save = _.debounce(proposal.save, 500)

    proposal

  RestangularProvider.extendModel 'rows', (row) ->
    row.extended_price = ->
      if this.price? and this.quantity?
        this.price * this.quantity
      else
        0

    row.save = ->
      row.put()

    row.update = (data) -> new Pitch.StreamUpdater(row, data)

    row.rate_save = _.debounce(row.save, 500)

    row
]

@PitchCtrl = ($scope, Restangular) ->
  $scope.id = $('#proposal').data('id')

  new Pitch.Stream($scope)

  Restangular.one("proposals", $scope.id).get().then (proposal) ->
    $scope.proposal = proposal

  $scope.sortableOptions =
    axis: 'y'
    stop: (e, ui) ->
      $.each $scope.proposal.rows, (position, row) ->
        if row.position != position
          row.position = position
          row.save()

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

  $scope.$on 'update', (e, data) ->
    if data.item == "row"
      row = _.find $scope.proposal.rows, (row) -> row.id == data.id

      switch data.action
        when 'create'  then $scope.addRow(data.id)
        when 'update'  then row.update(data)
        when 'destroy' then $scope.removeRow($scope.proposal.rows.indexOf(row))

    else if data.item == "proposal"
      switch data.action
        when 'update'  then $scope.proposal.update(data)
        when 'destroy' then $scope.proposal.destroy()

    $scope.$apply()

