class CartItem {
  final String menuItemId;
  final String menuItemName;
  int quantity;
  final double menuItemPrice;

  CartItem({
    required this.menuItemId,
    required this.menuItemName,
    required this.quantity,
    required this.menuItemPrice,
  });

  Map<String, dynamic> toJson() => {
        'menuItemId': menuItemId,
        'menuItemName': menuItemName,
        'quantity': quantity,
        'menuItemPrice': menuItemPrice,
      };
}
