class Answer < ActiveRecord::Base
  include Voteable

  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

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
