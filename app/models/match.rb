class Match < ApplicationRecord

  belongs_to :court
  has_many :game_sets, dependent: :destroy
  delegate :tournament, to: :court

  MAX_PARTICIPANT_NAME_LENGTH = 30

  validates :participant1, :participant2, presence: true, length: { maximum: MAX_PARTICIPANT_NAME_LENGTH }
  validates :court, presence: true
  validate :court_occupied

  acts_as_list scope: :court

  scope :upcoming, -> { where(started_at: nil, finished_at: nil) }
  scope :in_progress, -> { where(finished_at: nil).where.not(started_at: nil) }
  scope :finished, -> { where.not(finished_at: nil) }
  scope :started, -> { where('started_at is not null or finished_at is not null') }
  scope :sorted, -> { includes(:court, :game_sets).order(:finished_at, :started_at, :position) }

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


  private

  def court_occupied
    return unless self.in_progress?

    other_matches_on_court = self.court.matches.in_progress.where.not(id: self.id)

    if other_matches_on_court.any?
      errors.add :started_at, 'Court is occupied by other match'
    end
  end
end
