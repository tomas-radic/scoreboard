class Match < ApplicationRecord

  belongs_to :court
  has_many :game_sets, dependent: :destroy

  validates :label, presence: true

  acts_as_list scope: :court

  def started?
    self.started_at.present? || self.finished_at.present?
  end

  def finished?
    self.finished_at.present?
  end

  def scheduled?
    self.not_before.present?
  end
end
