class Tournament < ApplicationRecord

  belongs_to :user
  has_many :courts, inverse_of: :tournament, dependent: :destroy
  has_many :matches, through: :courts
  accepts_nested_attributes_for :courts, reject_if: :all_blank, allow_destroy: true

  validates :label, presence: true
end
