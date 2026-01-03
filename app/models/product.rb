class Product < ActiveRecord::Base
  include SoftDeletable  

  has_many :order_items
  has_many :orders, through: :order_items

  validates :name, presence: true, length: { maximum: 100 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :description, length: { maximum: 1000 }  

  scope :in_stock, -> { where('stock > ?', 0) }
  scope :out_of_stock, -> { where(stock: 0) }
  scope :by_price, ->(direction = :asc) { order(price: direction) }
  scope :by_name, -> { order(:name) }
  scope :newest_first, -> { order(created_at: :desc) }  

  def in_stock?
      stock > 0 && !deleted?
  end  

  def can_be_deleted?
      order_items.empty?
  end
end
