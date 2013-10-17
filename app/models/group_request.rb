class GroupRequest < ActiveRecord::Base
  belongs_to :user
  validates :name, presence: true, uniqueness: true
  validates :user, presence: true
  validate :group_doesnt_exists

  private
  def group_doesnt_exists
    if Group.where(name: self.name).count > 0
      errors.add(:name, "Group #{self.name} already exists.")
    end
  end
end
