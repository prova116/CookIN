/// A single food/restaurant listing. There's no backend, so this is a fixed
/// local catalogue shared by the Home, Menu, and Offer screens.
class FoodItem {
  final String image;
  final String name;
  final double price;
  final String rate;
  final String rating;
  final String type;
  final String foodType;
  final String category;

  /// 0-100, or null if this item isn't discounted.
  final int? discountPercent;

  const FoodItem({
    required this.image,
    required this.name,
    required this.price,
    required this.rate,
    required this.rating,
    required this.type,
    required this.foodType,
    required this.category,
    this.discountPercent,
  });

  bool get isOnOffer => discountPercent != null;

  double get discountedPrice =>
      isOnOffer ? price * (100 - discountPercent!) / 100 : price;

  /// The shape FoodDetailView/CartService expect - price is the price the
  /// user actually pays (after any discount).
  Map<String, dynamic> toMap() => {
        "image": image,
        "name": name,
        "price": discountedPrice,
        "original_price": isOnOffer ? price : null,
        "rate": rate,
        "rating": rating,
        "type": type,
        "food_type": foodType,
      };
}

class FoodData {
  FoodData._();

  static const List<Map<String, String>> categories = [
    {"image": "assets/img/cat_offer.png", "name": "Offers"},
    {"image": "assets/img/cat_sri.png", "name": "Sri Lankan"},
    {"image": "assets/img/cat_3.png", "name": "Italian"},
    {"image": "assets/img/cat_4.png", "name": "Indian"},
  ];

  static const List<FoodItem> allItems = [
    FoodItem(
      image: "assets/img/res_1.png",
      name: "Minute by tuk tuk",
      price: 12.99,
      rate: "4.9",
      rating: "124",
      type: "Cafe",
      foodType: "Western Food",
      category: "Sri Lankan",
      discountPercent: 15,
    ),
    FoodItem(
      image: "assets/img/res_2.png",
      name: "Café de Noir",
      price: 9.49,
      rate: "4.9",
      rating: "124",
      type: "Cafe",
      foodType: "Western Food",
      category: "Italian",
    ),
    FoodItem(
      image: "assets/img/res_3.png",
      name: "Bakes by Tella",
      price: 14.25,
      rate: "4.9",
      rating: "124",
      type: "Cafe",
      foodType: "Western Food",
      category: "Indian",
    ),
    FoodItem(
      image: "assets/img/m_res_1.png",
      name: "Tuk Tuk Express",
      price: 15.99,
      rate: "4.9",
      rating: "124",
      type: "Cafe",
      foodType: "Western Food",
      category: "Sri Lankan",
    ),
    FoodItem(
      image: "assets/img/m_res_2.png",
      name: "Noir Bistro",
      price: 11.49,
      rate: "4.9",
      rating: "124",
      type: "Cafe",
      foodType: "Western Food",
      category: "Italian",
      discountPercent: 20,
    ),
    FoodItem(
      image: "assets/img/item_1.png",
      name: "Mulberry Pizza by Josh",
      price: 8.99,
      rate: "4.9",
      rating: "124",
      type: "Cafe",
      foodType: "Western Food",
      category: "Italian",
    ),
    FoodItem(
      image: "assets/img/item_2.png",
      name: "Barita",
      price: 6.49,
      rate: "4.9",
      rating: "124",
      type: "Cafe",
      foodType: "Western Food",
      category: "Sri Lankan",
    ),
    FoodItem(
      image: "assets/img/item_3.png",
      name: "Pizza Rush Hour",
      price: 13.99,
      rate: "4.9",
      rating: "124",
      type: "Cafe",
      foodType: "Western Food",
      category: "Italian",
      discountPercent: 10,
    ),
  ];

  static List<FoodItem> get offers =>
      allItems.where((item) => item.isOnOffer).toList();
}
