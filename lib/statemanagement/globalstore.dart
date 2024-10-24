import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/app/app.locator.dart';
import 'package:pos/models/cart.dart';
import 'package:pos/models/cart_item.dart';
import 'package:pos/models/category_item.dart';
import 'package:pos/models/menu_item.dart';
import 'package:pos/models/organization_item.dart';
import 'package:pos/models/student_item.dart';
import 'package:pos/services/main_service.dart';

class GlobalStoreController extends GetxController {
  // ignore: non_constant_identifier_names
  var StudentItems = <StudentItem>[].obs;
  var selectStudent = <StudentItem>{}.obs;
  var menuselectedvar = <CategoryItem>{}.obs;
  var currentSchool = <OrganizationItem>{}.obs;
  var categorymenu = <CategoryItem>[].obs;
  var cartobx = <dynamic>[].obs;
  var preorder = false.obs;
  var carttotal = <String, dynamic>{
    "total": 0.00,
    "discount": 0.00,
    "calculatedTotal": 0.00,
    "balance": 0.00
  }.obs;
  var onKeyboardEnter = ''.obs;
  final TextEditingController searchController = TextEditingController();

  clearGlobalaState() {
    // if (Get.isRegistered<GlobalStoreController>()) {
    StudentItems.clear();
    categorymenu.clear();
    cartobx.clear();

    selectStudent.clear();
    // menuselectedvar.clear();
    currentSchool.clear();

    preorder.value = false;

// Reset a map (like carttotal)
    carttotal.value = {
      "total": 0.00,
      "discount": 0.00,
      "calculatedTotal": 0.00,
      "balance": 0.00
    };
  }

  studentput(dynamic students) {
    StudentItems.assignAll(students);
    return true;
  }

  selectStudentfn(StudentItem student) async {
    selectStudent.clear();
    selectStudent.add(student);
    carttotal['balance'] = student.balance;
    cartobx.clear();
    clearCart();
    update();

    return true;
  }

  clearCart() {
    cartobx.clear();

    carttotal['total'] = 0.00;
    carttotal['discount'] = 0.00;
    carttotal['calculatedTotal'] = 0.00;
    carttotal['balance'] = selectStudent.first.balance;
  }

  Set<StudentItem> convertSelectStudentToNormalSet() {
    return selectStudent.toSet(); // Converts RxSet to a normal Set
  }

  menuselected(CategoryItem data) {
    menuselectedvar.clear();
    menuselectedvar.add(data);
    update();
    return true;
  }

  addtoCart(MenuItem item) {
    cartobx.add(CartItem(
      menuItemId: item.id,
      menuItemName: item.name,
      quantity: 1,
      menuItemPrice: item.price,
    ));
    carttotal['total'] = carttotal['total'] + item.price;
    update();
    print('--storeaddess--');
    print(carttotal['total']);
    print('--storeaddess--');

    calculation();
  }

  removeCartItem(dynamic item, int index) {
    cartobx.removeAt(index);
    // carttotal['total'] = carttotal['total'] - item.menuItemPrice;

    if (carttotal['total'] >= item.menuItemPrice) {
      carttotal['total'] -= item.menuItemPrice;

      // Fix floating-point precision by rounding to 2 decimal places
      carttotal['total'] = double.parse(carttotal['total'].toStringAsFixed(2));
    } else {
      carttotal['total'] = 0.00; // Prevent negative total
    }

    // carttotal['total'] = 0.00; // Prevent negative total

    print('--store--');
    print(item.menuItemPrice);
    print(carttotal['total']);
    print('--store--');
    update();
    calculation();
    update();
    return true;
  }

  calculation() {
    carttotal['discount'] = currentSchool.first.facultyDiscount;

    if (selectStudent.first.role.toUpperCase() == 'FACULTY') {
      carttotal['discount'] = double.parse(((carttotal['total'] *
                  (1 - (currentSchool.first.facultyDiscount / 100))) -
              carttotal['total'])
          .toStringAsFixed(2));
      carttotal["calculatedTotal"] = carttotal['total'] + carttotal['discount'];
    } else {
      carttotal["calculatedTotal"] = carttotal['total'];
    }
    carttotal['balance'] =
        selectStudent.first.balance - carttotal["calculatedTotal"];
    return true;
  }

  // set Current School
  currentSchoolobx(OrganizationItem school) {
    currentSchool.clear();
    currentSchool.add(school);
    return true;
  }

  // @override
  // void onClose() {
  //   searchController.dispose(); // Dispose the controller when not in use
  //   super.onClose();
  // }

  onSearch(value) {
    onKeyboardEnter.value = value;
    update();
  }

  storeCategorygetx(List<CategoryItem> data) {
    categorymenu.clear();
    categorymenu.addAll(data);
  }
}
