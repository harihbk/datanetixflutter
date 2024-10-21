class CategoryItem {
  final String id;
  final String name;
  bool selected;

  CategoryItem({
    required this.id,
    required this.name,
    required this.selected,
  });

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    String _id = '';
    String _name = '';

    if (json.containsKey('uuid') && json['uuid'] != null) {
      _id = json['uuid'].toString();
    }
    if (json.containsKey('name') && json['name'] != null) {
      _name = json['name'].toString();
    }

    return CategoryItem(
      id: _id,
      name: _name,
      selected: false,
    );
  }
}
