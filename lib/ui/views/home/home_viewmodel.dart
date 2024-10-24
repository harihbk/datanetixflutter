import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.dialogs.dart';
import '../../../models/cart.dart';
import '../../../models/cart_item.dart';
import '../../../models/category_item.dart';
import '../../../models/menu_item.dart';
import '../../../models/student_allergy_item.dart';
import '../../../services/square_service.dart';
import '/models/student_item.dart';
import '/services/main_service.dart';
import '/app/app.locator.dart';

class HomeViewModel extends BaseViewModel {
  final _mainService = locator<MainService>();
  final _dialogService = locator<DialogService>();
  final _squareService = locator<SquareService>();
  final searchController = TextEditingController();
  FocusNode searchFieldFocus = FocusNode();

  StudentItem? student;
  double balance = 0.0;
  double calculatedTotal = 0.0;

  Cart? cart;

  final bool preorder = false;

  final List<MenuItem> _masterMenu = [];
  final List<MenuItem> filteredMenu = [];

  get categories => _mainService.categories;

  Future<void> initialize() async {
    _masterMenu.addAll(_mainService.menu);
    await filterMenuItems();
    searchController.addListener(() => filterMenuItems());
    notifyListeners();
  }

  Future<void> filterMenuItems() async {
    final List<MenuItem> _matchingItems = [];
    final CategoryItem activeCategory =
        categories?.firstWhere((cat) => cat.selected == true);

    if (student == null) {
      // log('***** STUDENT IS NULL CLEAR MENU');
      filteredMenu.clear();
      searchController.clear();
      notifyListeners();
      return;
    }

    if (searchController.text.isNotEmpty) {
      // print('***** SEARCH IS NOT EMPTY CLEAR MENU');
      if (!categories.first.selected) {
        setCategory(categories.first);
        notifyListeners();
      }
    }

    try {
      for (MenuItem item in _masterMenu) {
        // log('***** CATEGORY: ITEM: ${item.categoryId} | ACTIVE: ${activeCategory.id}');
        // print('***** ITEM NAME: ${item.name}');
        // print('***** CONTAINS SEARCH: ${item.name.toLowerCase().contains(searchController.text.toLowerCase())}');
        item.disabled = false;
        if ((searchController.text.isNotEmpty &&
                item.name
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase())) ||
            ((item.categoryId == activeCategory.id ||
                    activeCategory.id == 'all') &&
                searchController.text.isEmpty)) {
          // print('***** CATEGORY MATCH');
          if (student!.allergies.isEmpty) {
            // log('***** NO ALLERGIES');
            // log('***** ADDING ITEM: ${item.name}');
            _matchingItems.add(item);
          } else {
            // log('***** CHECKING ALLERGIES');
            bool allergyMatch = false;
            for (StudentAllergyItem allergy in student!.allergies) {
              // log('***** ALLERGY: ${allergy.id.toString()} | ${allergy.name} ITEM: ${item.allergies.toString()}');
              if (!item.allergies.contains(allergy.id) && !allergyMatch) {
                // do not set allergyMatch to false to not hide
                // allergyMatch = true;
                // set disabled flag on item to true to show as Allergy
                item.disabled = true;
              } else {
                item.disabled = false;
              }
            }
            if (!allergyMatch) {
              // log('***** NO ALLERGY MATCH');
              // log('***** ADDING ITEM: ${item.name}');
              _matchingItems.add(item);
            }
          }
        }
      }
    } catch (e) {
      log('***** ERROR FILTERING MENU: $e');
    }

    filteredMenu.clear();
    filteredMenu.addAll(_matchingItems);
    notifyListeners();
  }

  Future<void> refreshStudent() async {
    student = _mainService.currentStudent;
    balance = student!.balance;
    calculatedTotal = 0.0;
    if (student != null) {
      cart = Cart(
        studentId: student!.id,
        organizationId: _mainService.currentSchool!.id,
        studentGivenName: student!.givenName,
        studentFamilyName: student!.familyName,
        date: DateTime.now(),
        total: 0.0,
        discount: 0.0,
        items: [],
      );
      if (student!.preorder.isNotEmpty) {
        // for (String menuItemId in student!.preorder) {
        //   print('***** PREORDER ITEM: $menuItemId');
        //   MenuItem item = _masterMenu.firstWhere((element) => element.id == menuItemId);
        //   cart!.addItem(CartItem(
        //     menuItemId: item.id,
        //     menuItemName: item.name,
        //     quantity: 1,
        //     menuItemPrice: item.price,
        //   ));
        // }
        // updateCartDiscount();
        // calculateTotal();
        // preorder = true;
      } else {
        // preorder = false;
      }
    } else {
      cart = null;
      // preorder = false;
    }
    searchController.clear();
    await filterMenuItems();
    print('***** PREORDER: ${preorder.toString()}');
  }

  Future<void> calculateTotal() async {
    calculatedTotal = 3.0;
    if (student!.role.toUpperCase() == 'FACULTY') {
      // print('***** CALCULATING FACULTY DISCOUNT: ${cart!.discount}');
      calculatedTotal = cart!.total + cart!.discount; // discount is negative
    } else {
      calculatedTotal = cart!.total;
    }
    notifyListeners();
  }

  Future<void> selectItem(MenuItem item) async {
    log('***** SELECTED ITEM: ${item.id}');
    cart!.addItem(CartItem(
      menuItemId: item.id,
      menuItemName: item.name,
      quantity: 1,
      menuItemPrice: item.price,
    ));
    updateCartDiscount();
    calculateTotal();
    updateBalanceDisplay();
    notifyListeners();
  }

  Future<void> updateCartDiscount() async {
    if (student!.role.toUpperCase() == 'FACULTY') {
      // final double percent = (1 - (_mainService.currentSchool!.facultyDiscount / 100));
      // print('***** FACULTY DISCOUNT: $percent');
      // print('***** ORG DISCOUNT: ${_mainService.currentSchool!.facultyDiscount}');
      cart!.discount = double.parse(((cart!.total *
                  (1 - (_mainService.currentSchool!.facultyDiscount / 100))) -
              cart!.total)
          .toStringAsFixed(2));
    }
  }

  Future<void> updateBalanceDisplay() async {
    balance = student!.balance - calculatedTotal;
  }

  Future<void> setCategory(CategoryItem category) async {
    for (CategoryItem cat in categories) {
      if (cat == category) {
        cat.selected = true;
      } else {
        cat.selected = false;
      }
    }
    await filterMenuItems();
  }

  Future<void> selectCategory(CategoryItem category) async {
    setCategory(category);
    searchFieldFocus.unfocus();
    searchController.clear();
  }

  Future<void> clearCart() async {
    cart!.items.clear();
    cart!.total = 0.0;
    updateCartDiscount();
    calculateTotal();
    updateBalanceDisplay();
    notifyListeners();
  }

  Future<void> removeItem(CartItem item) async {
    cart!.items.remove(item);
    cart!.total -= item.menuItemPrice;
    updateCartDiscount();
    calculateTotal();
    updateBalanceDisplay();
    notifyListeners();
  }

  Future<void> pay({required bool charge}) async {
    if (cart!.total == 0.0) {
      await _dialogService.showCustomDialog(
        variant: DialogType.infoAlert,
        title: 'Cart Empty',
        description: 'There are no items in the cart.',
      );
      return;
    }

    if (!charge && !preorder) {
      if ((cart!.total > student!.balance) &&
          (student!.cardOnFile == false || student!.autoReload == false)) {
        await _dialogService.showCustomDialog(
          variant: DialogType.infoAlert,
          title: 'Insufficient Funds',
          description:
              'There are not have enough funds to complete the transaction.',
        );
        return;
      }
    }

    Object result = '';
    int total = (calculatedTotal * 100).toInt();
    // print('***** TOTAL: $total');
    final String transactionText =
        '${_mainService.currentSchool!.name.trim()} - ${cart!.studentGivenName.trim()} ${cart!.studentFamilyName.trim()}';
    if (charge) {
      total = (total * 1.04).ceil(); // add 4% for processing fee
      // print('***** TOTAL WITH SURCHARGE: $total');
      try {
        result = await _squareService.charge(
            amount: total, transactionText: transactionText);
      } catch (e) {
        await _dialogService.showCustomDialog(
          variant: DialogType.error,
          title: 'TRANSACTION ERROR',
          description: e.toString(),
        );
        return;
      }
    } else if (!preorder) {
      var confirm = await _dialogService.showCustomDialog(
        variant: DialogType.confirm,
        title: 'Balance Transaction',
        description:
            'Are you sure you want to process a balance transaction for ${cart!.studentGivenName.trim()} ${cart!.studentFamilyName.trim()}?',
      );
      if (!confirm!.confirmed) {
        return;
      }
      result = 'Balance Transaction';
    } else {
      result = 'Preorder';
    }

    Object body = {
      'cart': cart!.toJson(),
      'charge': charge,
      'result': result,
      'preorderId': preorder ? student!.preorderId : '',
    };
    print('***** PAY BODY: ${jsonEncode(body)}');
    try {
      final double newBalance =
          await _mainService.transaction(body: jsonEncode(body));
      if (!charge) {
        await _mainService.updateStudentBalance(
            studentId: cart!.studentId, amount: newBalance);
        notifyListeners();
      }
      await _dialogService.showCustomDialog(
        variant: DialogType.infoAlert,
        title: 'Transaction Complete',
        description:
            'Transaction for ${cart!.studentGivenName.trim()} ${cart!.studentFamilyName.trim()} was successful.',
      );
      // clear cart
      cancel();
    } catch (e) {
      // TODO: charge was made, but transaction failed to save to server.
      await _dialogService.showCustomDialog(
        variant: DialogType.error,
        title: 'TRANSACTION SAVING ERROR',
        description: e.toString(),
      );
      return;
    }
  }

  Future<void> cancel() async {
    // preorder = false;
    clearCart();
  }

  // @override
  // void dispose() {
  //   searchController.dispose();
  //   super.dispose();
  // }
}
