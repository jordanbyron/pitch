class Pitch.Group
  constructor: (@proposal, @group) ->
    @position = @group.find('input[name*=position]:first')
    @id       = @group.data('id')

    @group.attr('draggable', true)

    @group.on 'click', 'h2, div.name a', (e) ->
      container = $(this).parents('div.name')
      textField = container.find('input')
      display   = container.find('h2')

      display.text(textField.val())

      container.toggleClass 'edit'
      e.preventDefault()

    @proposal.groups[@id] = this

  updatePosition: =>
    @position.val $('#list li').index(@group)
