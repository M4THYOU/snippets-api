class Snippet < ApplicationRecord
  has_and_belongs_to_many :lessons

  validates :title, presence: true
  validates :snippet_type, presence: true
  validates :course, presence: true
  validates :raw, presence: true
  validates :created_by_uid, presence: true

  def user_has_access?(user)
    success = false
    if created_by_uid == user.id
      success = true
    else
      valid_roles = [Rails.configuration.x.u_role_types.owner, Rails.configuration.x.u_role_types.member]
      lessons.each do |lesson|
        return true if user.role_actions?(lesson.group_id, valid_roles)
      end
    end
    success
  end
end
