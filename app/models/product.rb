class Product < ActiveRecord::Base
    validates :name, :price, :stock, presence: true
end
