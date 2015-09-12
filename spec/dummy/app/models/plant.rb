class Plant < ActiveRecord::Base
  validates :name, :scientific_name, presence: true
end
