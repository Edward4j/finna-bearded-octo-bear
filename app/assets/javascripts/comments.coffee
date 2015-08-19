ready = ->
  $('.add-comment-link').click (e) ->
    e.preventDefault();
    comentable_id = $(this).data('commentableId')
    comentable_type= $(this).data('commentableType')
    $('form#add-comment-' + comentable_id + '-' + comentable_type).show()

  $('a.cancel-comment').on 'click', (e) ->
    e.preventDefault()
    $commentForm = $(this).closest('form')
    $commentForm.hide()

  add_comment = (comment) ->
    $commentable = $('#comments_' + comment.commentable_type + '_' + comment.commentable_id)
    $commentable.append ->
      HandlebarsTemplates['comments/comment'](comment) if !$('div#comment-' + comment.id).length

  $('form.new_comment').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    add_comment(response)
    $('textarea#comment_body').val("")
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    console.log($(this))
    form = $(this)
    $.each errors, (index, value) ->
      form.find('.comment-errors').append('<p>' + index + ' ' + value + '</p>')


  questionId = $('.question').data('questionId')
  PrivatePub.subscribe "/questions/" + questionId + "/comments", (data, channel) ->
    comment = $.parseJSON(data["comment"])
    add_comment(comment)

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)