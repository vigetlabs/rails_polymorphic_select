class Star < ActiveRecord::Base
  validates :name, presence: true
end
