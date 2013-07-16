$ ->

  $('#list')
    .on 'cocoon:after-insert', (e, item) ->
      item.children('input[name*=position]').val(item.index())
    .sortable(items: 'li.prow', connectWith: '.row-sorts')
    .on 'sortupdate', ->
      $('#list li').each (i, item) ->
        $(item).children('input[name*=position]').val(i)

  $('#list li.group ul.group-rows').sortable(connectWith: '.row-sorts')

  $('#list').on 'click', 'li.group h2, li.group div.name a', (e) ->
    container = $(this).parents('div.name')
    textField = container.find('input')
    display   = container.find('h2')

    display.text(textField.val())

    container.toggleClass 'edit'
    e.preventDefault()

