module ProductsHelper

  def price_tag_for product
    "#{number_to_currency product.price, unit: 'R', delimiter: ' '} / #{product.unit}"
  end

end
