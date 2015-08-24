# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $(document).on 'click', '.edit-answer-link', (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId');
    $('form#edit-answer-' + answer_id).show();

  add_answer = (answer) ->

    if gon.user_id
      answer.isSigned = gon.user_id;
      answer.isAnswerAuthor = gon.user_id == answer.user_id;
      answer.isQuestionAuthor = gon.question_author == gon.user_id;

    for attach in answer.attachments
      attach.name = attach.file.url.split('/').slice(-1)[0]
    console.log(answer)
    $('.answers').append ->
      HandlebarsTemplates['answers/answer'](answer)

    $commentForm = $('.new_comment:first').clone()
    $commentForm.removeAttr('id')
    .attr('id',"add-comment-#{answer.id}-Answer")
    .attr('action',"/answers/#{answer.id}/comments")
    $($commentForm).insertAfter("#comments_Answer_#{answer.id} .add-comment-link")

    $editForm = $('#new_answer').clone();
    $editForm.removeClass('new_answer').addClass('edit_answer')
    .attr('action',"/questions/#{answer.question_id}/answers/#{answer.id}")
    .attr('id',"edit-answer-#{answer.id}")
    .html('<input name="utf8" type="hidden" value="✓">' +
        '<input type="hidden" name="_method" value="patch">' +
        '<p><label for="answer_body">Edit Answer</label></p><p><textarea name="answer[body]" ' +
        'id="answer_body">' +
        answer.body +
        '</textarea></p><p><input type="submit" name="commit" value="Save"></p></form>')
    $($editForm).insertAfter(".answer_#{answer.id} .edit-answer-link")

  $('form.new_answer').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    add_answer(response) if !$("#answer-#{response.answer.id}").length
    $("form.new_answer #answer_body").val("");
    $("#total-answer-rating-#{response.answer.id}").html(response.rating);

  questionId = $(".question").data("questionId");
  console.log(questionId)
  PrivatePub.subscribe "/questions/" + questionId + "/answers", (data, channel) ->
    console.log(data);
    answer = $.parseJSON(data["answer"])
    #$(".answers").append("<p>" + answer.body + "</p>")
    add_answer(answer)
    $("#total-answer-rating-#{answer.id}").html(answer.rating);
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


