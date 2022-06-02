class ProductDataSource < TestCentricity::DataSource
  def find_product(product_id)
    ProductData.current = ProductData.new(environs.read('Products', product_id.to_i))
  end
end


class ProductData < TestCentricity::DataPresenter
  attribute :id, Integer
  attribute :name, String
  attribute :description, String
  attribute :price, String
  attribute :review, Integer
  attribute :colors, Array
  attribute :default_color, String

  def initialize(data)
    @id            = data[:id]
    @name          = data[:name]
    @description   = data[:description]
    @price         = data[:price]
    @review        = data[:review]
    @colors        = data[:colors]
    @default_color = data[:defaultColor]
    super
  end
end
