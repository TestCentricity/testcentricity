class CartDataSource < TestCentricity::DataSource
  def load_cart
    CartData.current = CartData.new(environs.read('Cart_data', 'deep_link_test'))
  end
end


class CartData < TestCentricity::DataPresenter
  attribute :cart_items_deep_link, String
  attribute :num_items, Integer
  attribute :total_quantity, String
  attribute :total_price, String

  def initialize(data)
    @cart_items_deep_link = data[:cart_items_deep_link]
    @num_items            = data[:num_items]
    @total_quantity       = data[:total_quantity]
    @total_price          = data[:total_price]
    super
  end
end
