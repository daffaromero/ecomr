class Product < ActiveRecord::Base
    validates :name, :price, :stock, presence: true

    has_many :order_items
    has_many :orders, through: :order_items
end
