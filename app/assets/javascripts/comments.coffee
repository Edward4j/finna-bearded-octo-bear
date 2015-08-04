ready = ->
  $('.add-comment-link').click (e) ->
    e.preventDefault();
    comentable_id = $(this).data('commentableId')
    comentable_type= $(this).data('commentableType')
    $('form#add-comment-' + comentable_id + '-' + comentable_type).show()

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)