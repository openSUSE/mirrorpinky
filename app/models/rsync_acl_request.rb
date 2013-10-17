class RsyncAclRequest < ActiveRecord::Base
  belongs_to :server
  validates :host, presence: true, uniqueness: true
  validates :server, presence: true
  validate :host_not_already_used

  private
  def host_not_already_used
    if RsyncAcl.where(host: self.host).count > 0
      errors.add(:host, "'#{self.host}' is already used by a mirror")
    end
  end
end
