class User < ApplicationRecord
  before_create :confirmation_token
  has_secure_password

  validates :email, uniqueness: { message: 'A user with that email already exists.', case_sensitive: true }

  def self.role_action?(uid, group_id, role_type)
    roles = URole.where(['group_id = ? and uid = ? and role_type = ? and is_revoked = ?', group_id, uid, role_type, 0])
    puts roles
    success = true
    success = false unless roles
    success
  end

  def add_role(created_by_uid, role, group_id)
    role = {
      role_type: role, uid: id, group_id: group_id, created_by_uid: created_by_uid, is_revoked: 0
    }
    URole.create(role)
  end

  def self.use_index(index)
    from("#{table_name} USE INDEX(#{index})")
  end

  def confirmation_token
    self.confirm_token = SecureRandom.urlsafe_base64.to_s if confirm_token.blank?
  end

  def email_activate
    self.is_active = true
    self.confirm_token = nil
    save!(validate: false)
  end

end
