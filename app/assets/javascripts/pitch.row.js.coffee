class Pitch.Row
  @indexCounter = 0

  constructor: (@row) ->
    @inputs       = @row.find(':input')
    @_uniqueIndex = new Date().getTime() + Pitch.Row.indexCounter++
  toggle: =>
    inMainList = @row.parent('#list').length == 1

    if inMainList
      this.unGroup()
    else
      this.group()

  group: =>
    groupID = @row.parents('li.group').data('index')
    return false unless groupID?

    this._renameInputs "[groups_attributes][#{groupID}][rows_attributes]" +
      "[#{@_uniqueIndex}]"

  unGroup: =>
    this._renameInputs "[rows_attributes][#{@_uniqueIndex}]"

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
