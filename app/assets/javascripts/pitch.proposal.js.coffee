class Pitch.Proposal
  constructor: (@form) ->
    @rows   = {}
    @groups = {}

    @form.on 'cocoon:after-insert', (e, item) =>
      if item.hasClass('prow')
        new Pitch.Row(this, item)
      else if item.hasClass('group')
        new Pitch.Group(this, item)

    # Initialize Rows
    @form.find('li.prow').each (i, row) =>
      new Pitch.Row(this, $(row))

    # Initialize Groups
    @form.find('li.group').each (i, group) =>
      new Pitch.Group(this, $(group))

    new Pitch.Sortable($('#list'))

  updatePositions: =>
    $.each [@rows, @groups], (i, set) ->
      $.each set, (i, row) ->
        row.updatePosition()

$ ->
  form = $('form.edit_proposal, form.new_proposal')

  if form.length == 1
    Pitch.Proposal.current = new Pitch.Proposal(form)
