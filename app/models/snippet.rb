class Snippet < ApplicationRecord
  validates :title, presence: true
  validates :snippet_type, presence: true
  validates :course, presence: true
  validates :raw, presence: true
  validates :created_by_uid, presence: true
end
