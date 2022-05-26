class ProductCellItem < TestCentricity::ScreenSection
  trait(:section_name)    { 'Product Cell Item' }
  trait(:section_locator) { { xpath: "//XCUIElementTypeOther[@name='store item']" } }

  # Product Cell Item UI elements
  labels  product_name:  { xpath: '(//XCUIElementTypeOther)[1]' },
          product_price: { xpath: "//XCUIElementTypeStaticText[@name='store item price']" }
  buttons review_star_1: { xpath: "//XCUIElementTypeOther[@name='review star 1']" },
          review_star_2: { xpath: "//XCUIElementTypeOther[@name='review star 2']" },
          review_star_3: { xpath: "//XCUIElementTypeOther[@name='review star 3']" },
          review_star_4: { xpath: "//XCUIElementTypeOther[@name='review star 4']" },
          review_star_5: { xpath: "//XCUIElementTypeOther[@name='review star 5']" }
end
