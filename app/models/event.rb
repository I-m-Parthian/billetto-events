class Event < ApplicationRecord
  validates :billetto_id, :title, :description, :image_link, :start_date, :end_date, presence: true
  validates :billetto_id, uniqueness: true
end
