class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :user, index: true, foreign_key: true
      t.string :stripe_session_id
      t.decimal :total, precision: 10, scale: 2
      t.string :status, default: 'pending'

      t.timestamps null: false
    end
  end
end
