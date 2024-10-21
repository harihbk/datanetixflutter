class StudentAllergyItem {
  final int id;
  final String name;

  StudentAllergyItem({
    required this.id,
    required this.name,
  });

  factory StudentAllergyItem.fromJson(Map<String, dynamic> json) {
    int _id = 0;
    String _name = '';

    if (json.containsKey('id') && json['id'] != null) {
      _id = int.parse(json['id'].toString());
    }
    if (json.containsKey('name') && json['name'] != null) {
      _name = json['name'].toString();
    }

    return StudentAllergyItem(
      id: _id,
      name: _name,
    );
  }
}
