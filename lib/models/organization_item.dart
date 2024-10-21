import 'dart:convert';
import 'dart:typed_data';

class OrganizationItem {
  final String id;
  final String name;
  final int facultyDiscount;
  final Uint8List? thumbnail;

  OrganizationItem({
    required this.id,
    required this.name,
    required this.facultyDiscount,
    this.thumbnail,
  });

  factory OrganizationItem.fromJson(Map<String, dynamic> json) {
    int _facultyDiscount = 0;
    if (json.containsKey('facultyDiscount') && (json['facultyDiscount'] != null)) {
      _facultyDiscount = json['facultyDiscount'] as int;
    }
    Uint8List? _bytes;
    if (json.containsKey('thumbnail') && (json['thumbnail'] != null) && (json['thumbnail'] != '')) {
      _bytes = const Base64Decoder().convert(json['thumbnail']);
    }
    return OrganizationItem(
      id: json['uuid'] as String,
      name: json['name'] as String,
      facultyDiscount: _facultyDiscount,
      thumbnail: _bytes,
    );
  }
}
