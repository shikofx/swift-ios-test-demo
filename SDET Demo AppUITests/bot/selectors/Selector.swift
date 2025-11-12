import Foundation

enum Selector: String {
    // Tab Bar
    case tabBarItemCart = "Cart-tab-item"
    case tabBarItemMenu = "More-tab-item"

    
    // Menu
    case menuItemLogin = "Login Button"

    // LoginScreen
    case loginButton = "Login"

    // ProductsCatalogScreen
    case productsHeaderText = "title"
    
    // SortProductsScreen
    case sortPopupView = "sortPopupView"
    case sortButton = "sortButton"
    case sortByNameAscendingButton = "sortByNameAscendingButton"
    case sortByNameDescendingButton = "sortByNameDescendingButton"
    case sortByPriceAscendingButton = "sortByPriceAscendingButton"
    case sortByPriceDescendingButton = "sortByPriceDescendingButton"
    
    // ProductDetailsScreen
    case addToCartButton = "addToCartButton"
    case cartCountLabel = "cartCountLabel"
    
    // CartScreen
    case proceedToCheckoutButton = "GoShopping"
}
