class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :load_question, only: [:show, :edit, :update, :destroy]

  include Voted

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @answer.attachments.build
    gon.user_id = current_user.id if current_user
  end

  def new
    @question = Question.new
    @attachments = @question.attachments.build
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
    #@answer = @question.answers.find(params[:id])
    @question.update(question_params)
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
    params.require(:question).permit(:title, :body, attachments_attributes: [ :id, :file, :_destroy ])
  end
end
