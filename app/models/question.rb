class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  validates :title, :body, :user_id, presence: true
end
