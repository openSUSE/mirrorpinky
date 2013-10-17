class Group < ActiveRecord::Base
  # attr_accessible :name
  has_and_belongs_to_many :users
  has_and_belongs_to_many :servers
  validates :name, presence: true, uniqueness: true
end