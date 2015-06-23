class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :load_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build unless current_user.nil?
  end

  def new
    @question = Question.new
  end

  def edit
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user

    if @question.save
      flash[:notice] = "Successfully created question."
      redirect_to @question
    else
      render :new
    end
  end

  def update
    if @question.update(question_params)
    redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    flash[:notice] = "Your question successfully deleted."
    redirect_to questions_path
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
