class RsyncAcl < ActiveRecord::Base
  belongs_to :server
  validates :host, presence: true, uniqueness: true
  validates :server, presence: true
end
