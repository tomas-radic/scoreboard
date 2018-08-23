class Match < ApplicationRecord

  belongs_to :court
  has_many :game_sets, dependent: :destroy

  validates :label, presence: true

  acts_as_list scope: :court

  default_scope { order(:position) }

  def started?
    self.started_at.present? || self.completed_at.present?
  end

  def completed?
    self.completed_at.present?
  end
end
