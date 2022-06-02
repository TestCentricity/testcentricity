class ProductListItem < TestCentricity::ScreenSection
  trait(:section_name)    { 'Product List Item' }
  trait(:section_locator) { { xpath: '//android.view.ViewGroup[@content-desc="store item"]' } }

  # Product Cell Item UI elements
  labels  product_name:  { xpath: '//android.widget.TextView[@content-desc="store item text"]' },
          product_price: { xpath: '//android.widget.TextView[@content-desc="store item price"]' }
  buttons review_star_1: { xpath: '//android.view.ViewGroup[@content-desc="review star 1"]' },
          review_star_2: { xpath: '//android.view.ViewGroup[@content-desc="review star 2"]' },
          review_star_3: { xpath: '//android.view.ViewGroup[@content-desc="review star 3"]' },
          review_star_4: { xpath: '//android.view.ViewGroup[@content-desc="review star 4"]' },
          review_star_5: { xpath: '//android.view.ViewGroup[@content-desc="review star 5"]' }
end
