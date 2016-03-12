class Event < ActiveRecord::Base
  belongs_to :host, class_name: "User"

  default_scope -> { order(event_date: :desc) }
  validates :name, presence: true
  validates :description, presence: true
  validates :event_date, presence: true
  validates :host_id, presence: true
end
