class EnableExtensions < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'pgcrypto'
    enable_extension 'hstore'
  end
end
