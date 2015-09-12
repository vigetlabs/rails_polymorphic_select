class Planet < ActiveRecord::Base
  belongs_to :star

  validates :name, :star, presence: true
end
