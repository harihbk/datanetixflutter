import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:pos/models/organization_item.dart';
import 'package:pos/statemanagement/globalstore.dart';

import '../models/category_item.dart';
import '/models/menu_item.dart';

import '/models/student_item.dart';
import '/models/user_item.dart';
import '/globals/settings.dart';
import 'package:get/get.dart';

class MainService {
  final GlobalStoreController cartController =
      Get.find<GlobalStoreController>();

  String? token;
  late DateTime? _tokenExpireTime;

  String? tokenFCM;

  String? userName;
  String? userPass;

  UserItem? user;

  OrganizationItem? currentSchool;

  StudentItem? currentStudent;
  final List<StudentItem> students = [];

  final List<MenuItem> menu = [];

  final List<CategoryItem> categories = [];

  int totalUrlImages = 0;
  int totalUrlImagesLoaded = 0;

  bool isLoggedIn() {
    if (token == null) {
      return false;
    }
    return true;
  }

  Future<void> logout() async {
    token = null;
    tokenFCM = null;
    userName = null;
    userPass = null;
    user = null;
    currentSchool = null;
    currentStudent = null;
    students.clear();
    menu.clear();
    categories.clear();

    cartController.StudentItems.clear();
    cartController.cartobx.clear();
    cartController.carttotal = {
      "total": 0.00,
      "discount": 0.00,
      "calculatedTotal": 0.00,
      "balance": 0.00
    } as RxMap<String, dynamic>;
    cartController.currentSchool.clear();
    cartController.menuselectedvar.clear();
  }

  Future<String> getAccessToken() async {
    print('***** START GET ACCESS TOKEN');
    print('***** GET ACCESS TOKEN USER PASS: $userName $userPass');
    Map<String, String> _headers = {};
    Map<String, String> _body = {};
    try {
      _headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json'
      };
      _body = {
        'email': userName!,
        'password': userPass!,
        'device_name': 'POS Tablet v1',
      };

      final http.Response response = await http.post(
        Uri.parse(Settings.authUrl),
        body: _body,
        headers: _headers,
      );

      final jsonData = jsonDecode(response.body);
      print('***** GET ACCESS TOKEN JSONDATA: ${jsonData.toString()}');

      print('***** GET ACCESS TOKEN URL: ${response.request!.url}');
      print('***** GET ACCESS TOKEN STATUS CODE: ${response.statusCode}');
      print('***** GET ACCESS TOKEN BODY: ${response.body}');
      print('***** GET ACCESS TOKEN: ${jsonData['token']}');
      print('***** GET ACCESS TOKEN EXPIRES IN: ${jsonData['ttl']}'); // seconds
      if (response.statusCode == 200) {
        token = jsonData['token'] as String;
        final DateTime today = DateTime.now();
        _tokenExpireTime = today.add(Duration(seconds: jsonData['ttl'] as int));
        print('***** GET ACCESS TOKEN EXPIRES TIME: $_tokenExpireTime');
        return '';
      } else {
        token = null;
        print('***** GET ACCESS TOKEN BODY: ${jsonData.toString()}');
        return 'Access Denied';
      }
    } catch (e) {
      print('***** GET ACCESS TOKEN ERROR: ${e.toString()}');
      token = null;
      return e.toString();
    }
  }

  Future<void> confirmValidToken() async {
    final DateTime today = DateTime.now();
    final Duration difference = _tokenExpireTime!.difference(today);
    print('***** CONFIRM VALID TOKEN DIFFERENCE: ${difference.inMinutes}');
    if (difference.inMinutes < 2) {
      print('***** CONFIRM VALID TOKEN SHOULD REFRESH');
      await getAccessToken();
    }
  }

  Future<void> getUser() async {
    await confirmValidToken();
    print('***** GET USER START');
    try {
      final http.Response response = await http.get(
        Uri.parse(Settings.userUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      print('***** GET USER URL: ${response.request!.url}');
      print('***** GET USER STATUS CODE: ${response.statusCode}');
      print('***** GET USER BODY: ${response.body}');

      if (response.statusCode == 200) {
        // print('***** GET USER BODY: ${response.body}');
        final parsed = json.decode(response.body);
        final jsonUser = parsed['data'];
        // print('***** GET USER: $jsonUser');
        user = UserItem.fromJson(jsonUser as Map<String, dynamic>);
      } else {
        String _errorString = '${response.statusCode}: ${response.body}';
        throw _errorString;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<OrganizationItem>> getOrganizations() async {
    await confirmValidToken();
    // log('***** GET ORGANIZATIONS START');
    final List<OrganizationItem> _items = [];
    try {
      final http.Response response = await http.get(
        Uri.parse(Settings.organizationUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      // log('***** GET ORGANIZATIONS URL: ${response.request!.url}');
      // log('***** GET ORGANIZATIONS STATUS CODE: ${response.statusCode}');
      // log('***** GET ORGANIZATIONS BODY: ${response.body}');

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body) as Map<String, dynamic>;
        final items = parsed['data'] as List;
        for (final item in items) {
          _items.add(OrganizationItem.fromJson(item as Map<String, dynamic>));
        }
        return _items;
      } else {
        String _errorString = '${response.statusCode}: ${response.body}';
        throw _errorString;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<OrganizationItem>> getOrganizationsclone() async {
    await confirmValidToken();
    final List<OrganizationItem> _items = [];
    try {
      final http.Response response = await http.get(
        Uri.parse(Settings.organizationUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body) as Map<String, dynamic>;
        final items = parsed['data'] as List;
        for (final item in items) {
          _items.add(OrganizationItem.fromJson(item as Map<String, dynamic>));
        }
        return _items;
      } else {
        String _errorString = '${response.statusCode}: ${response.body}';
        throw _errorString;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future getStudentsclone() async {
    await confirmValidToken();

    try {
      final response = await http.get(
        Uri.parse('${Settings.organizationUrl}/${currentSchool!.id}/people'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      return response;
    } catch (e) {
      return e;
    }

    // final List<StudentItem> _items = [];
    // try {

    //   if (response.statusCode == 200) {
    //     // final parsed = json.decode(response.body) as Map<String, dynamic>;
    //     // final items = parsed['data'] as List;
    //     // bool printStudents = true; // TODO: set to false
    //     // for (final item in items) {
    //     //   if (printStudents &&
    //     //       item['allergies'] != null &&
    //     //       item['allergies'] != '') {
    //     //     print('***** GET STUDENTS ITEM: $item');
    //     //     printStudents = false;
    //     //   }
    //     //   _items.add(StudentItem.fromJson(item as Map<String, dynamic>));
    //     // }
    //     // students.clear();
    //     // students.addAll(_items);
    //   } else {
    //     String _errorString = '${response.statusCode}: ${response.body}';
    //     throw _errorString;
    //   }
    // } catch (e) {
    //   rethrow;
    // }
  }

  Future<void> getStudents() async {
    await confirmValidToken();
    print('***** GET STUDENTS START');
    final List<StudentItem> _items = [];
    try {
      final http.Response response = await http.get(
        Uri.parse('${Settings.organizationUrl}/${currentSchool!.id}/people'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      print('***** GET STUDENTS URL: ${response.request!.url}');
      print('***** GET STUDENTS STATUS CODE: ${response.statusCode}');
      // print('***** GET STUDENTS BODY: ${response.body}');

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body) as Map<String, dynamic>;
        final items = parsed['data'] as List;
        bool printStudents = true; // TODO: set to false
        for (final item in items) {
          if (printStudents &&
              item['allergies'] != null &&
              item['allergies'] != '') {
            print('***** GET STUDENTS ITEM: $item');
            printStudents = false;
          }
          _items.add(StudentItem.fromJson(item as Map<String, dynamic>));
        }
        students.clear();
        students.addAll(_items);
      } else {
        String _errorString = '${response.statusCode}: ${response.body}';
        throw _errorString;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future getMenuClone() async {
    print("-------------------------------${currentSchool!.id}");
    await confirmValidToken();
    try {
      final List<MenuItem> _items = [];
      final http.Response response = await http.get(
        Uri.parse('${Settings.organizationUrl}/${currentSchool!.id}/menu'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      if (response.statusCode == 200) {
        final parsed = json.decode(response.body) as Map<String, dynamic>;
        final items = parsed['data'];
        bool printMenu = false;
        for (final item in items) {
          if (printMenu) {
            printMenu = false;
          }
          _items.add(MenuItem.fromJson(item as Map<String, dynamic>));
        }
        totalUrlImages = 0;
        totalUrlImagesLoaded = 0;
        // menu.clear();
        // menu.addAll(_items);
        // for (MenuItem item in menu) {
        //   if (item.thumbnail == null && item.imageUrl != '') {
        //     totalUrlImages++;
        //     item.thumbnail = await getThumbnail(url: item.imageUrl);
        //   }
        // }
        return _items;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getMenu() async {
    await confirmValidToken();
    // log('***** GET MENU START');
    final List<MenuItem> _items = [];
    try {
      final http.Response response = await http.get(
        Uri.parse('${Settings.organizationUrl}/${currentSchool!.id}/menu'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      // log('***** GET MENU URL: ${response.request!.url}');
      // log('***** GET MENU STATUS CODE: ${response.statusCode}');
      // log('***** GET MENU BODY: ${response.body}');

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body) as Map<String, dynamic>;
        final items = parsed['data'] as List;
        bool printMenu = false;
        for (final item in items) {
          if (printMenu) {
            // log('***** GET MENU ITEM: $item');
            printMenu = false;
          }
          _items.add(MenuItem.fromJson(item as Map<String, dynamic>));
        }
        totalUrlImages = 0;
        totalUrlImagesLoaded = 0;
        menu.clear();
        menu.addAll(_items);
        for (MenuItem item in menu) {
          if (item.thumbnail == null && item.imageUrl != '') {
            totalUrlImages++;
            item.thumbnail = await getThumbnail(url: item.imageUrl);
          }
        }
        print('***** TOTAL URL IMAGES: $totalUrlImages');
        print('***** TOTAL URL IMAGES LOADED: $totalUrlImagesLoaded');
      } else {
        String _errorString = '${response.statusCode}: ${response.body}';
        throw _errorString;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Uint8List?> getThumbnail({required String url}) async {
    // get image from server
    final response = await http.get(Uri.parse('${Settings.instanceUrl}/'));
    if (response.statusCode == 200) {
      // convert image to bytes
      totalUrlImagesLoaded++;
      return response.bodyBytes;
    } else {
      return null;
    }
  }

  Future getCategories() async {
    await confirmValidToken();
    // print('***** GET CATEGORIES START');
    final List<CategoryItem> _items = [];
    try {
      final http.Response response = await http.get(
        Uri.parse('${Settings.organizationUrl}/${currentSchool!.id}/category'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body) as Map<String, dynamic>;
        final items = parsed['data'] as List;
        bool printCategory = false;
        _items.add(CategoryItem(
          id: 'all',
          name: 'All Items',
          selected: true,
        ));
        for (final item in items) {
          if (printCategory) {
            printCategory = false;
          }
          _items.add(CategoryItem.fromJson(item as Map<String, dynamic>));
        }
        return _items;
        // categories.clear();
        // categories.addAll(_items);
      } else {
        String _errorString = '${response.statusCode}: ${response.body}';
        throw _errorString;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getCategoriescopy() async {
    await confirmValidToken();
    // print('***** GET CATEGORIES START');
    final List<CategoryItem> _items = [];
    try {
      final http.Response response = await http.get(
        Uri.parse('${Settings.organizationUrl}/${currentSchool!.id}/category'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      // print('***** GET CATEGORIES URL: ${response.request!.url}');
      // print('***** GET CATEGORIES STATUS CODE: ${response.statusCode}');
      // print('***** GET CATEGORIES BODY: ${response.body}');

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body) as Map<String, dynamic>;
        final items = parsed['data'] as List;
        bool printCategory = false;
        _items.add(CategoryItem(
          id: 'all',
          name: 'All Items',
          selected: true,
        ));
        for (final item in items) {
          if (printCategory) {
            // log('***** GET CATEGORIES ITEM: $item');
            printCategory = false;
          }
          _items.add(CategoryItem.fromJson(item as Map<String, dynamic>));
        }
        categories.clear();
        categories.addAll(_items);
      } else {
        String _errorString = '${response.statusCode}: ${response.body}';
        throw _errorString;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<double> transaction({required String body}) async {
    print('***** START TRANSACTION');

    try {
      http.Response response = await http.post(
        Uri.parse(Settings.transactionUrl),
        body: body,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('***** TRANSACTION STATUS CODE: ${response.statusCode}');
      print('***** TRANSACTION BODY: ${response.body}');
      // print('***** TRANSACTION URL: ${response.request!.url.toString()}');

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body) as Map<String, dynamic>;
        final results = parsed['data'];
        if (double.tryParse(results['balance']) == null) {
          throw FormatException(
              '${response.statusCode}: ${results['balance']} is not a double');
        }
        final double balance = double.parse(results['balance']);
        print('***** TRANSACTION RESULTS AMOUNT: $balance');
        return balance;
      } else {
        throw FormatException('${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateStudentBalance(
      {required String studentId, required double amount}) async {
    // find student in students list
    final StudentItem? student =
        students.firstWhere((element) => element.id == studentId);
    if (student != null) {
      // update student balance
      student.balance = amount;
    }
  }

  Future refreshStudentclone(
      {required String studentId,
      required List<StudentItem> studentflit}) async {
    await confirmValidToken();
    try {
      final http.Response response = await http.get(
        Uri.parse('${Settings.peopleUrl}/$studentId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body);
        final jsonStudent = parsed['data'];
        final newStudentInfo =
            StudentItem.fromJson(jsonStudent as Map<String, dynamic>);

        final StudentItem? student =
            studentflit.firstWhere((element) => element.id == studentId);
        if (student != null) {
          // update student balance and preorder
          student.balance = newStudentInfo.balance;
          student.preorder = newStudentInfo.preorder;
          student.preorderId = newStudentInfo.preorderId;
        }
        // print(student);
        return student;
      } else {
        String _errorString = '${response.statusCode}: ${response.body}';
        throw _errorString;
      }
    } catch (e) {
      rethrow;
    }
  }

  // Future refreshStudentclone({required String studentId}) async {
  //   await confirmValidToken();
  //   try {
  //     final http.Response response = await http.get(
  //       Uri.parse('${Settings.peopleUrl}/$studentId'),
  //       headers: {
  //         'Accept': 'application/json',
  //         'Authorization': 'Bearer $token'
  //       },
  //     );
  //     if (response.statusCode == 200) {
  //       final parsed = json.decode(response.body);
  //       final jsonStudent = parsed['data'];
  //       print(jsonStudent);
  //       final newStudentInfo = StudentItem.fromJson(jsonStudent);
  //       print(newStudentInfo);

  //       final StudentItem? student =
  //           students.firstWhere((element) => element.id == studentId);
  //       // if (student != null) {
  //       //   student.balance = newStudentInfo.balance;
  //       //   student.preorder = newStudentInfo.preorder;
  //       //   student.preorderId = newStudentInfo.preorderId;
  //       // }
  //       // print("dfs");
  //       return 'ddsf';
  //     } else {
  //       String _errorString = '${response.statusCode}: ${response.body}';
  //       throw _errorString;
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future<void> refreshStudent({required String studentId}) async {
    await confirmValidToken();
    print('***** REFRESH STUDENT START');
    try {
      final http.Response response = await http.get(
        Uri.parse('${Settings.peopleUrl}/$studentId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      print('***** REFRESH STUDENT URL: ${response.request!.url}');
      print('***** REFRESH STUDENT STATUS CODE: ${response.statusCode}');
      print('***** REFRESH STUDENT BODY: ${response.body}');

      if (response.statusCode == 200) {
        // print('***** REFRESH STUDENT BODY: ${response.body}');
        final parsed = json.decode(response.body);
        final jsonStudent = parsed['data'];
        print('***** REFRESH STUDENT: $jsonStudent');
        final newStudentInfo =
            StudentItem.fromJson(jsonStudent as Map<String, dynamic>);
        final StudentItem? student =
            students.firstWhere((element) => element.id == studentId);
        if (student != null) {
          // update student balance and preorder
          student.balance = newStudentInfo.balance;
          student.preorder = newStudentInfo.preorder;
          student.preorderId = newStudentInfo.preorderId;
        }
      } else {
        String _errorString = '${response.statusCode}: ${response.body}';
        throw _errorString;
      }
    } catch (e) {
      rethrow;
    }
  }
}
