# Zip Candidate Mobile Challenge: iOS


## Outline

Create a simple giftcard shopping application with follow functionalities:

1.  The app shows a list of giftcards and each giftcard item need to display image (thumbnail size), brand, discount, vendor and a `detail` button.
2. Once clicks the `detail` button, it will navigate to a detail page, which is another **ViewController**.
3. The detail page should include image(match screen width), brand, discount, terms, denominations (customer should be able to select different amount of giftcards) and two buttons -- one `buy now` button to allow to buy directly and an `add to cart` button to save into the shopping cart.
4. If the customer clicks `buy now` button, a successful page with confirmation information shows.
5. If the customer clicks `add to cart` button, the item will be added into the cart and users can checkout later from cart page.

**Notes**

* The giftcard data can be fetched from this API: [here](https://zip.co/giftcards/api/giftcards)
* You can mock up an API for checkout action
* You are **ALLOWED** to use any libraries
* Feel free to use the preset project in this folder or create your own

## Prerequisites

* Swift 5.0+
* iOS 13.0+ support
* Programmatical AutoLayout (Don't use Storyboard or Xib)
* Documentation: Update `DEVELOPERS.md` with information you'd give to other members of your team about how to work with the solution

## Reference Apps

* [Zip App](https://apps.apple.com/au/app/zip-shop-now-pay-later/id1411824359)
* [Amazon](https://apps.apple.com/au/app/amazon-shopping-made-easy/id297606951)
* [eBay](https://apps.apple.com/au/app/ebay-buy-sell-and-save/id282614216)

## Bonus Questions

* Cache the cart to local device if customers exists the app
* Demonstrate how you would test your code or make it more testable
