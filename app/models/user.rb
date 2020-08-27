class User < ApplicationRecord
  before_create :confirmation_token
  has_secure_password

  validates :email, uniqueness: { message: 'A user with that email already exists.', case_sensitive: true }

  def role_action?(group_id, role_type)
    roles = URole.where(['group_id = ? and uid = ? and role_type = ? and is_revoked = ?', group_id, id, role_type, 0])
    success = true
    success = false if roles.blank?
    success
  end

  # role_types is an array of role_types that will return true if any match.
  def role_actions?(group_id, role_types)
    puts group_id
    puts role_types
    roles = URole.where(['group_id = ? and uid = ? and role_type = ? and is_revoked = ?', group_id, id, role_types, 0])
    success = true
    success = false if roles.blank?
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
