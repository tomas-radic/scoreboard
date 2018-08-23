class Court < ApplicationRecord

  belongs_to :tournament
  has_many :matches, dependent: :destroy

  validates :label, presence: true

  default_scope { order(:label) }

  def current_match
    self.matches.where(completed_at: nil).where.not(started_at: nil).first
  end

  def next_match
    self.matches.where(completed_at: nil, started_at: nil).first
  end
end
