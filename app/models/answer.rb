class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :body, :user_id, :question_id, presence: true

  default_scope { order('best DESC') }

  def select_best
    question.answers.update_all(best: false)
    update!(best: true)
  end

  def cancel_best
    update!(best: false)
  end
end
