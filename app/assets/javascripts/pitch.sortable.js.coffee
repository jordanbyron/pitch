class Pitch.Sortable
  constructor: (@list) ->
    selector  = '.dz-top, .dz-bottom, .dz-middle'
    @dragging = null
    $(document)
      .on('dragover',  selector,      this.dragOver)
      .on('dragenter', selector,      this.dragEnter)
      .on('dragleave', selector,      this.dragLeave)
      .on('drop',      selector,      this.drop)
      .on('dragstart', '[draggable]', this.dragStart)
      .on('dragend',   '[draggable]', this.dragEnd)

  dragStart: (e) =>
    e.stopPropagation()
    return false if @dragging
    @dragging = $(e.target)

    @dragging.addClass('dragging')
    $('body').addClass('dragging')

    # Add Drop Zones
    $('[draggable]')
      .append("<div class='dz-top' />")
      .append("<div class='dz-bottom' />")

    e.originalEvent.dataTransfer.effectAllowed = 'move'
    e.originalEvent.dataTransfer.setData('text/x-row', @dragging.data('id'))

    setTimeout =>
      @dragging.hide()
      if @dragging.hasClass('group')
        $('li.group li div.dz-top, li.group li div.dz-bottom').remove()
        $('body').addClass('group-drag')
      else
        $('ul.group-rows:not(:has(li))').parent().append("<div class='dz-middle' />")
      @placeholder ||= $("<li id='drag-placeholder'/>").insertAfter(@dragging)
    , 0

  dragEnd: (e) =>
    this.drop(e) if @placeholder?

    $('[draggable] .dz-top, [draggable] .dz-bottom, [draggable] .dz-middle')
      .remove()

  dragOver: (e) ->
    e.preventDefault()
    e.originalEvent.dataTransfer.dropEffect = 'move'

    return false

  dragEnter: (e) =>
    $target = $(e.target)
    $target.addClass('over')

    if $target.hasClass('dz-middle')
      $target.siblings('ul.group-rows').append @placeholder
    else if $target.hasClass('dz-top')
      @placeholder.insertBefore $target.closest('[draggable]')
    else
      @placeholder.insertAfter $target.closest('[draggable]')

  dragLeave: (e) ->
    this.classList.remove('over')

  drop: (e) =>
    id = e.originalEvent.dataTransfer.getData('text/x-row')
    e.stopPropagation()
    e.preventDefault()

    $target = $(e.target)
    id ||= $target.data('id')

    $('body').removeClass('dragging').removeClass('group-drag')
    $target.removeClass('over')

    @dragging.removeClass('dragging')

    @placeholder.replaceWith(@dragging)
    @placeholder = null
    @dragging.show()

    if @dragging.hasClass('prow')
      Pitch.Proposal.current.rows[id].toggle()

    Pitch.Proposal.current.updatePositions()
    @dragging = null
