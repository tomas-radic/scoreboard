class Court < ApplicationRecord

  belongs_to :tournament
  has_many :matches, dependent: :destroy

  validates :label,
            :public_key, presence: true

  before_validation :set_defaults

  scope :sorted, -> { order(:label) }

  def current_match
    self.matches.where(finished_at: nil).where.not(started_at: nil).first
  end

  def next_match
    self.matches.where(finished_at: nil, started_at: nil).order(:position).first
  end

  private

  def set_defaults
    self.public_key ||= SecureRandom.hex
  end
end
