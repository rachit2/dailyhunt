class AddDesktopDeviceIdToAccount < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :desktop_device_id, :string
  end
end
