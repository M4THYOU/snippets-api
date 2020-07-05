class User < ApplicationRecord
  has_secure_password
  
  def self.role_action?(uid, group_id, role_type)
    roles = URole.where(['group_id = ? and uid = ? and role_type = ? and is_revoked = ?', group_id, uid, role_type, 0])
    puts roles
    success = true
    success = false unless roles
    success
  end

  def self.use_index(index)
    from("#{table_name} USE INDEX(#{index})")
  end

end
