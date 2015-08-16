# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $(document).on 'click', '.edit-answer-link', (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId');
    $('form#edit-answer-' + answer_id).show();

  questionId = $(".answers").data("questionId");
  PrivatePub.subscribe "/questions/" + questionId + "/answers", (data, channel) ->
    console.log(data);
    answer = $.parseJSON(data["answer"])
    $(".answers").append("<p>" + answer.body + "</p>")
    $(".new_answer #answer_body").val("");

#ready = ->
#  $(".edit-answer-link").click (e) ->
#    e.preventDefault()
#    $(this).hide()
#    answer_id = $(this).data('answerId')
#    $('form#edit-answer-' + answer_id).show()
#

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)


