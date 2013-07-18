class Pitch.Row
  @idCounter = 0

  constructor: (@proposal, @row) ->
    @inputs   = @row.find(':input')
    @id       = new Date().getTime() + Pitch.Row.idCounter++
    @position = @row.find('input[name*=position]:first')

    @row.attr('draggable', true)
    @row.attr('data-id', @id)

    @proposal.rows[@id] = this
  toggle: =>
    inMainList = @row.parent('#list').length == 1

    if inMainList
      this.unGroup()
    else
      this.group()

  group: =>
    groupID = @row.parents('li.group').data('id')
    return false unless groupID?

    this._renameInputs "[groups_attributes][#{groupID}][rows_attributes]" +
      "[#{@id}]"

  unGroup: =>
    this._renameInputs "[rows_attributes][#{@id}]"

  updatePosition: =>
    @position.val $('#list li').index(@row)

  # Private

  _renameInputs: (replacement) =>
    regex = ///
      proposal(
        \[rows_attributes\]\[\d+\]
        |
        \[groups_attributes\]\[\d+\]\[rows_attributes\]\[\d+\])
    ///

    @inputs.each (i, input) =>
      $input = $(input)
      name   = $input.attr('name').replace(regex, "proposal#{replacement}")
      $input.attr 'name', name
