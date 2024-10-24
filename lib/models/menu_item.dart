import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

class MenuItem {
  final String id;
  final String name;
  final String menuName;
  final String groupName;
  final List<int> grades;
  final double price;
  final String description;
  final String category;
  final String categoryId;
  final List<int> allergies;
  String imageUrl;
  Uint8List? thumbnail;
  final String? thumbnail_path;
  bool disabled = false; // used to disable menu items that contain allergens

  MenuItem(
      {required this.id,
      required this.name,
      required this.menuName,
      required this.groupName,
      required this.grades,
      required this.price,
      required this.description,
      required this.category,
      required this.categoryId,
      required this.allergies,
      required this.imageUrl,
      this.thumbnail_path});

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    String _name = '';
    String _menuName = '';
    String _groupName = '';
    List<int> _grades = [];
    double _price = 0.0;
    String _description = '';
    String _category = '';
    String _categoryId = '';
    List<int> _allergies = [];
    String _imageUrl = '';
    Uint8List? _bytes;

    if (json.containsKey('name') && json['name'] != null) {
      _name = json['name'].toString();
    }
    if (json.containsKey('menuName') && json['menuName'] != null) {
      _menuName = json['menuName'].toString();
    }
    if (json.containsKey('groupName') && json['groupName'] != null) {
      _groupName = json['groupName'].toString();
    }
    if (json.containsKey('grades') &&
        json['grades'] != null &&
        json['grades'] != '') {
      try {
        final _gradeList = json['grades'] as List;
        for (final item in _gradeList) {
          _grades.add(item as int);
        }
      } catch (e) {
        log('***** GRADES ERROR: $e');
        log('***** GRADES: ${json['grades']}');
      }
    }
    if (json.containsKey('price') &&
        json['price'] != null &&
        (double.tryParse(json['price'].toString()) != null)) {
      _price = double.parse(json['price'].toString());
    }
    if (json.containsKey('description') && json['description'] != null) {
      _description = json['description'].toString();
    }
    if (json.containsKey('category') && json['category'] != null) {
      _category = json['category'].toString();
    }
    if (json.containsKey('categoryId') && json['categoryId'] != null) {
      _categoryId = json['categoryId'].toString();
    }
    if (json.containsKey('allergies') &&
        json['allergies'] != null &&
        json['allergies'] != '') {
      try {
        final _list = json['allergies'] as List;
        for (final item in _list) {
          _allergies.add(item as int);
        }
      } catch (e) {
        log('***** ALLERGIES ERROR: $e');
        log('***** ALLERGIES: ${json['allergies']}');
      }
    }
    if (json.containsKey('thumbnail') &&
        (json['thumbnail'] != null) &&
        (json['thumbnail'] != '')) {
      if ((json['thumbnail'] as String).contains('/images/menu/')) {
        print('***** MENU ITEM IMAGE URL: ${json['thumbnail']}');
        _imageUrl = json['thumbnail'].toString();
      } else {
        // print('***** MENU ITEM THUMBNAIL}');
        _bytes = const Base64Decoder().convert(json['thumbnail']);
      }
    } else {
      print('***** MENU ITEM NO THUMBNAIL}');
    }
    return MenuItem(
        id: json['uuid'] as String,
        name: _name,
        menuName: _menuName,
        groupName: _groupName,
        grades: _grades,
        price: _price,
        description: _description,
        category: _category,
        categoryId: _categoryId,
        allergies: _allergies,
        imageUrl: _imageUrl,
        thumbnail_path: json['thumbnail_path']);
  }
}
