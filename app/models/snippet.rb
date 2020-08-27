class Snippet < ApplicationRecord
  has_and_belongs_to_many :lessons

  validates :title, presence: true
  validates :snippet_type, presence: true
  validates :course, presence: true
  validates :raw, presence: true
  validates :created_by_uid, presence: true
end
