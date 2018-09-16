class Match < ApplicationRecord

  belongs_to :court
  has_many :game_sets, dependent: :destroy
  delegate :tournament, to: :court

  validates :participant1, :participant2, presence: true

  acts_as_list scope: :court

  scope :upcoming, -> { where(started_at: nil, finished_at: nil) }
  scope :in_progress, -> { where(finished_at: nil).where.not(started_at: nil) }
  scope :finished, -> { where.not(finished_at: nil) }

  def label
    "#{participant1} vs #{participant2}"
  end

  def in_progress?
    self.finished_at.nil? && !self.started_at.nil?
  end

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
