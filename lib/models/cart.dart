import 'cart_item.dart';

class Cart {
  final String studentId;
  final String organizationId;
  final String studentGivenName;
  final String studentFamilyName;
  final DateTime date;
  double total;
  double discount;
  final List<CartItem> items;

  Cart({
    required this.studentId,
    required this.organizationId,
    required this.studentGivenName,
    required this.studentFamilyName,
    required this.date,
    required this.total,
    required this.discount,
    required this.items,
  });

  List<Map<String, dynamic>> get itemsJson => items.map((item) => item.toJson()).toList();

  Map<String, dynamic> toJson() => {
        'studentId': studentId,
        'organizationId': organizationId,
        'studentGivenName': studentGivenName,
        'studentFamilyName': studentFamilyName,
        'date': date.toIso8601String(),
        'total': total,
        'discount': discount,
        'items': itemsJson,
      };

  void addItem(CartItem item) {
    items.add(item);
    total = double.parse((total + item.menuItemPrice).toStringAsFixed(2));
  }
}
