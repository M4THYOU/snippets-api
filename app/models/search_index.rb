class SearchIndex < ApplicationRecord
  validates :word, presence: true
  validates :snippet_id, presence: true
  validates :weight, presence: true
end
