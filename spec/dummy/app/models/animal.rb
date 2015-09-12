class Animal < ActiveRecord::Base
  belongs_to :eats, polymorphic: true

  validates :name, :scientific_name, presence: true
end
