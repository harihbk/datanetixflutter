import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:pos/models/student_allergy_item.dart';

class StudentItem {
  final String id;
  final String displayName;
  final String familyName;
  final String givenName;
  final String issuedId;
  double balance;
  final List<StudentAllergyItem> allergies;
  List<String> preorder;
  String preorderId;
  final String role;
  final String grade;
  final int gradeLevel;
  final bool cardOnFile;
  final bool autoReload;
  final bool hasParent;
  Uint8List? thumbnail;

  StudentItem(
      {required this.id,
      required this.displayName,
      required this.familyName,
      required this.givenName,
      required this.issuedId,
      required this.balance,
      required this.allergies,
      required this.preorder,
      required this.preorderId,
      required this.role,
      required this.grade,
      required this.gradeLevel,
      required this.cardOnFile,
      required this.autoReload,
      required this.hasParent,
      this.thumbnail});

  factory StudentItem.fromJson(Map<String, dynamic> json) {
    String _displayName = '';
    String _familyName = '';
    String _givenName = '';
    String _issuedId = '';
    double _balance = 0.0;
    List<StudentAllergyItem> _allergies = [];
    List<String> _preorder = [];
    String _preorderId = '';
    String _role = '';
    String _grade = '';
    int _gradeLevel = 0;
    bool _cardOnFile = false;
    bool _autoReload = false;
    bool _hasParent = false;
    Uint8List? _bytes;

    if (json.containsKey('allergies') &&
        json['allergies'] != null &&
        json['allergies'] != '') {
      final _allergyList = json['allergies'] as List;
      for (Map<String, dynamic> item in _allergyList) {
        log('***** ALLERGY ITEM: ${item.toString()}');
        _allergies.add(StudentAllergyItem.fromJson(item));
      }
    }

    if (json.containsKey('displayName') && json['displayName'] != null) {
      _displayName = json['displayName'].toString();
    }
    if (json.containsKey('familyName') && json['familyName'] != null) {
      _familyName = json['familyName'].toString();
    }
    if (json.containsKey('givenName') && json['givenName'] != null) {
      _givenName = json['givenName'].toString();
    }
    if (json.containsKey('balance') && json['balance'] != null) {
      _balance = double.parse(json['balance'].toString());
    }
    if (json.containsKey('issuedId') && json['issuedId'] != null) {
      _issuedId = json['issuedId'].toString();
    }
    if (json.containsKey('role') && json['role'] != null) {
      _role = json['role'].toString();
    }
    if (json.containsKey('thumbnail') &&
        (json['thumbnail'] != null) &&
        (json['thumbnail'] != '')) {
      _bytes = const Base64Decoder().convert(json['thumbnail']);
    }
    if (json.containsKey('grade') &&
        json['grade'] != null &&
        (int.tryParse(json['grade'].toString()) != null)) {
      _gradeLevel = int.parse(json['grade'].toString());
    }
    if (json.containsKey('grade') && json['grade'] != null) {
      _grade = '- ${json['grade'].toString()}th Grade';
      switch (json['grade'].toString()) {
        case '0':
          _grade = '- Pre-K or Kindergarten';
          break;
        case '1':
          _grade = '- 1st Grade';
          break;
        case '2':
          _grade = '- 2nd Grade';
          break;
        case '3':
          _grade = '- 3rd Grade';
          break;
        case '4':
        case '5':
        case '6':
        case '7':
        case '8':
        case '9':
        case '10':
        case '11':
        case '12':
          _grade = '- ${json['grade'].toString()}th Grade';
          break;
        case '13':
        case '14':
          _grade = '- Graduate';
          break;
        case '15':
          _grade = '15';
          break;
        default:
          _grade = '';
          break;
      }
    }
    if (json.containsKey('cardOnFile') && json['cardOnFile'] != null) {
      _cardOnFile = json['cardOnFile'] as bool;
    }
    if (json.containsKey('autoReload') && json['autoReload'] != null) {
      _autoReload = json['autoReload'] as bool;
    }
    if (json.containsKey('hasParent') && json['hasParent'] != null) {
      _hasParent = json['hasParent'] as bool;
    }
    if (json.containsKey('preorder') && json['preorder'] != null) {
      final _preorderList = json['preorder'] as List;
      for (String item in _preorderList) {
        _preorder.add(item);
      }
    }
    if (json.containsKey('preorderId') && json['preorderId'] != null) {
      _preorderId = json['preorderId'].toString();
    }

    return StudentItem(
      id: json['uuid'] as String,
      displayName: _displayName,
      familyName: _familyName,
      givenName: _givenName,
      thumbnail: _bytes,
      balance: _balance,
      issuedId: _issuedId,
      allergies: _allergies,
      preorder: _preorder,
      preorderId: _preorderId,
      role: _role,
      grade: _grade,
      gradeLevel: _gradeLevel,
      cardOnFile: _cardOnFile,
      autoReload: _autoReload,
      hasParent: _hasParent,
    );
  }
}
