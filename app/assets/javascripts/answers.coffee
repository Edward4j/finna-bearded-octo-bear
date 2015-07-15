# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'click', '.edit-answer-link', (e) ->
  e.preventDefault();
  $(this).hide();
  answer_id = $(this).data('answerId');
  $('form#edit-answer-' + answer_id).show();

ready = ->
  $('form.new_answer').bind 'ajax:success', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    $('.answers').append('<p>' + answer.body + '</p>')
    $('form.new_answer').find('input:text,textarea').val('')
    $('form.new_answer').find('.container.answer_errors').empty()
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $('.container.answer_errors').append(value)
$(document).on('page:update', ready)

#ready = ->
#  $(".edit-answer-link").click (e) ->
#    e.preventDefault()
#    $(this).hide()
#    answer_id = $(this).data('answerId')
#    $('form#edit-answer-' + answer_id).show()
#
#$(document).ready(ready)
#$(document).on('page:load', ready)
#$(document).on('page:update', ready)