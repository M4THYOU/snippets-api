class URole < ApplicationRecord
  validates :role_type, presence: true
  validates :uid, presence: true
  validates :group_id, presence: true
  validates :created_by_uid, presence: true
end
