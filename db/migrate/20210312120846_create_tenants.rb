class CreateTenants < ActiveRecord::Migration[5.2]
  def change
    create_table :tenants do |t|
      t.string :name
      t.string :subdomain
      t.string :email
      t.string :mobile_number
      t.string :address
      t.boolean :is_active
      t.string :timezone

      t.timestamps
    end
  end
end
