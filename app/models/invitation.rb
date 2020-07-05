class Invitation < ApplicationRecord
  def self.use_index(index)
    from("#{table_name} USE INDEX(#{index})")
  end
end
