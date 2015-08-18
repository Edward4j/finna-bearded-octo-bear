class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [ :index, :create, :update, :destroy, :best, :cancel_best ]
  before_action :load_question_and_answer, only: [:index, :new, :create, :update, :destroy, :best, :cancel_best]

  include Voted

  def index; end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answers_params)
    @answer.user = current_user
    respond_to do |format|
      if @answer.save
        format.js do
          PrivatePub.publish_to "/questions/#{@question.id}/answers", answer: @answer.to_json(include: :attachments) #, rating: @answer.rating, attachments: @answer.attachments }.to_json
          #render json: { answer: @answer, rating: @answer.rating, attachments: @answer.attachments }
          #PrivatePub.publish_to "/questions/#{@question.id}/answers", answer: @answer.to_json
          #render @answer if user_id == @answer.user
          render nothing: true
        end
      else
        #format.json { render json: @answer.errors.full_messages, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def update
    @answer.update(answers_params)
    @question = @answer.question
  end

  def destroy
    if @answer.user_id == current_user.id
      @answer.destroy
    end
  end

  def best
    if @question.user == current_user
      @answer.select_best
      @answers = @question.answers
      render 'answers'
    else
      redirect_to root_url
    end
  end

  def cancel_best
    if @question.user == current_user
      @answer.cancel_best
      @answers = @question.answers
      render 'answers'
    else
      redirect_to root_url
    end
  end

  private

  def load_question_and_answer
    @question = Question.find(params[:question_id])
    @answer = @question.answers.find(params[:id]) if params[:id]
  end

  def answers_params
    params.require(:answer).permit(:body, :question_id, attachments_attributes: [ :id, :file, :_destroy ])
  end
end
