class CommentsController < ApplicationController
  before_action :authenticate_user!
  #before_action :load_question
  before_action :load_commentable, only: [:create]
  
  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    
    if @comment.save
      flash.now[:notice] = 'Your comment successfully created.'
    else
      flash.now[:notice] = "Body can't be blank"
    end
  end
  
  private
  
  def load_question
    @question = Question.find(params[:question_id])
  end
  
  def commentable_name
    params[:commentable]
  end
  
  def comment_params
    params.require(:comment).permit(:body, :question_id)
  end
  
  def load_commentable
    @commentable = commentable_name.classify.
                     constantize.find(params["#{commentable_name.singularize}_id".to_sym])
  end
end