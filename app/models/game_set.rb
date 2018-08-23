class GameSet < ApplicationRecord

  belongs_to :match

  acts_as_list scope: :match

  default_scope { order(:position) }

end
