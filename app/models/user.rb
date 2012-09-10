require 'email_validator'
class User < ActiveRecord::Base
  include Clearance::User
  has_and_belongs_to_many :groups
  has_many :servers, :through => :groups
  validates_with ::EmailValidator
  validates :email, :uniqueness => true
  attr_accessible :email
end
