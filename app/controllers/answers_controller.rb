class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [ :create, :destroy ]
  before_action :load_question, only: :create

  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.new(answers_params)
    @answer.user = current_user

    if @answer.save
      flash[:notice] = 'Your answer successfully created.'
      #redirect_to @question
    else
      flash[:notice] = "Answer body can't be blank."
      redirect_to @question
      #render 'questions/show'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    @question = @answer.question
    if @answer.user_id == current_user.id
      @answer.destroy
      redirect_to question_path(@question), notice: "Your answer successfully deleted."
    else
      redirect_to @question, alert: "It's not your answer!"
    end
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answers_params
    params.require(:answer).permit(:body, :question_id)
  end
end
