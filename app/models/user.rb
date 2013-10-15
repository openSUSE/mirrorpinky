# TODO: require 'email_validator'
# class User < ActiveRecord::Base
#   include Clearance::User
#   has_and_belongs_to_many :groups
#   has_many :servers, :through => :groups
#   # validates_with ::EmailValidator
#   validates :email, :uniqueness => true
#   attr_accessible :email
# end

class User < ActiveRecord::Base
  devise :ichain_authenticatable, :ichain_registerable

  has_and_belongs_to_many :groups
  has_many :servers, :through => :groups
  has_many :rsync_acls, :through => :servers
  belongs_to :role
  validates :email, :uniqueness => true
  # attr_accessible :email

  def self.for_ichain_username(username, attributes)
    if user = where(login: username).first
      user.update_column(:email, attributes[:email]) if user.email != attributes[:email]
      user
    else
      user = create(login: username, email: attributes[:email])
    end
  end
end
