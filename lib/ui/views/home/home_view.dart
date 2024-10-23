import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos/app/app.dialogs.dart';
import 'package:pos/app/app.locator.dart';
import 'package:pos/models/menu_item.dart';
import 'package:pos/models/student_item.dart';
import 'package:pos/services/main_service.dart';
import 'package:pos/services/square_service.dart';
import 'package:pos/statemanagement/globalstore.dart';
import 'package:pos/ui/views/home/ProductSkeleton.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../globals/settings.dart';
import '../../../models/cart_item.dart';
import '../../../models/category_item.dart';
import '../../components/status_bar_home.dart';
import 'package:get/get.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalStoreController cartController =
      Get.find<GlobalStoreController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double _categoriesHeight = 50.0;
    const double _searchHeight = 70.0;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VisibilityDetector(
              key: const Key('home_visibility_detector'),
              onVisibilityChanged: (visibilityInfo) async {
                if (visibilityInfo.visibleFraction == 1) {
                  // await viewModel.refreshStudent();
                }
              },
              child: const StatusBarHome(),
            ),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      SizedBox(
                        height: _searchHeight,
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: const MenuSearch(),
                        ),
                      ),
                      SizedBox(
                        height: _categoriesHeight,
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: const MenuCategories(height: _categoriesHeight),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height -
                            Settings.headerHeight -
                            _categoriesHeight -
                            _searchHeight,
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: const MenuView(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Container(
                        // height: double.infinity,
                        height: MediaQuery.of(context).size.height -
                            Settings.headerHeight,
                        color: Colors.grey[300],
                        // width: MediaQuery.of(context).size.width * 0.25,
                        child: Column(
                          children: [
                            Obx(() {
                              if (cartController.selectStudent.isEmpty) {
                                return const NoStudentSelected();
                              }
                              return const StudentTransactions();
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MenuSearch extends StatefulWidget {
  const MenuSearch({super.key});

  @override
  State<MenuSearch> createState() => _MenuSearchState();
}

class _MenuSearchState extends State<MenuSearch> {
  final GlobalStoreController cartController =
      Get.find<GlobalStoreController>();

  @override
  Widget build(BuildContext context) {
    return TextField(
      // focusNode: widget.model.searchFieldFocus,
      controller: cartController.searchController,
      onChanged: (value) {
        cartController.onSearch(value);
      },
      decoration: const InputDecoration(
        hintText: 'Search Menu Items',
        border: OutlineInputBorder(),
      ),
    );
  }
}

class MenuCategories extends StatefulWidget {
  const MenuCategories({super.key, required this.height});

  final double height;

  @override
  State<MenuCategories> createState() => _MenuCategoriesState();
}

class _MenuCategoriesState extends State<MenuCategories> {
  final _mainService = locator<MainService>();
  final GlobalStoreController cartController =
      Get.find<GlobalStoreController>();

  List tabs = [];

  @override
  initState() {
    super.initState();
    getCategoryh();
  }

  Future getCategoryh() async {
    final menu = await _mainService.getCategories();
    setState(() {
      tabs = menu;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: tabs.isEmpty
          ? Row(
              children:
                  List.generate(3, (index) => buildSkeleton(widget.height)))
          : Row(
              children: [
                for (CategoryItem cat in tabs)
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            tabs.forEach((user) {
                              user.selected = false; // Increment the age by 1
                            });
                            var t =
                                tabs.firstWhere((user) => user.id == cat.id);
                            t.selected = true;
                            cartController.menuselected(t);
                          });
                        },
                        child: Container(
                          height: widget.height,
                          width: 170.0,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: cat.selected
                                    ? Colors.black
                                    : Colors.transparent,
                                width: 2.0,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Center(
                              child: Text(
                                cat.name,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: cat.selected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 17.0,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
    );
  }
}

Widget buildSkeleton(double height) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Container(
      width: 170.0,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
  );
}

class MenuView extends StatefulWidget {
  const MenuView({
    super.key,
  });

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  final _mainService = locator<MainService>();
  final GlobalStoreController cartController =
      Get.find<GlobalStoreController>();
  List<MenuItem> filteredProducts = [];
  List<MenuItem> products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    getMenuh();

    ever(cartController.menuselectedvar, (callback) {
      if (cartController.menuselectedvar.isNotEmpty) {
        filterProducts();
      } else {
        showAllItems();
      }
    });

    ever(cartController.onKeyboardEnter, (callback) {
      filterProducts();
    });
  }

  void searchFilter(String searchTerm) {
    setState(() {
      if (searchTerm.isNotEmpty && searchTerm != '') {
        filteredProducts = products
            .where((item) =>
                item.name.toLowerCase().contains(searchTerm.toLowerCase()))
            .toList();
      } else {
        filteredProducts = products;
      }
    });
  }

  void showAllItems() {
    setState(() {
      filteredProducts = products;
    });
  }

  Future getMenuh() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });
    try {
      final productlist = await _mainService.getMenuClone();

      setState(() {
        products = productlist;
        filteredProducts = productlist;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void filterProducts() {
    String selectedCategory = cartController.menuselectedvar.isNotEmpty
        ? cartController.menuselectedvar.first.name
        : '';
    String searchTerm = cartController.searchController.text;

    setState(() {
      filteredProducts = products.where((item) {
        bool matchesCategory = selectedCategory.isEmpty ||
            selectedCategory == "All Items" ||
            item.category == selectedCategory;
        bool matchesSearchTerm = searchTerm.isEmpty ||
            item.name.toLowerCase().contains(searchTerm.toLowerCase());
        return matchesCategory && matchesSearchTerm;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
        child: Obx(() {
          return (cartController.selectStudent.isNotEmpty
              ? GridView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    if (index < 0 || index >= filteredProducts.length) {
                      return const SizedBox.shrink();
                    }
                    return MenuTile(
                        model: filteredProducts[index], index: index);
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                    childAspectRatio: 0.60,
                  ),
                )
              : Center(child: Text("Please Select a Student to Continue")));
        }));
  }
}

class MenuTile extends StatefulWidget {
  const MenuTile({
    super.key,
    required this.model,
    required this.index,
  });

  final MenuItem model;
  //  final HomeViewModel model;

  final int index;

  @override
  State<MenuTile> createState() => _MenuTileState();
}

class _MenuTileState extends State<MenuTile> {
  final _mainService = locator<MainService>();
  final GlobalStoreController cartController =
      Get.find<GlobalStoreController>();
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return InkWell(
      splashFactory: InkRipple.splashFactory,
      splashColor: (widget.model.disabled)
          ? Colors.red
          : Theme.of(context).colorScheme.secondary,
      // onTap: widget.model.preorder
      //     ? null
      //     : () async {
      //         if (!widget.model.disabled) {
      //           // await widget.model.selectItem(widget.model.filteredMenu[widget.index]);
      //           // widget.model.searchFieldFocus.unfocus();
      //           // widget.model.searchController.clear();
      //         }
      //       },
      onTap: () {
        if (!widget.model.disabled) {
          cartController.addtoCart(widget.model);
        }
      },
      child: Card(
        elevation: 3,
        shadowColor: (widget.model.disabled) ? Colors.red : Colors.grey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 120.0,
                child: (widget.model.thumbnail != null)
                    ? Image.memory(widget.model.thumbnail!, fit: BoxFit.contain)
                    : const Icon(Icons.image_not_supported_outlined,
                        size: 80.0, color: Colors.grey),
              ),
              const Divider(),
              if (widget.model.disabled)
                const Text(
                  'ALLERGY CONFLICT',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                ),
              Expanded(
                child: Text(
                  widget.model.name,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '\$${widget.model.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StudentTransactions extends StatefulWidget {
  const StudentTransactions({super.key});

  // final HomeViewModel model;

  @override
  State<StudentTransactions> createState() => _StudentTransactionsState();
}

class _StudentTransactionsState extends State<StudentTransactions> {
  final GlobalStoreController cartController =
      Get.find<GlobalStoreController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Obx(() {
        if (cartController.selectStudent.isEmpty) {
          return Center(child: Text('No students selected'));
        }

        Set<StudentItem> studentsSet =
            cartController.convertSelectStudentToNormalSet();
        StudentItem? student =
            studentsSet.isNotEmpty ? studentsSet.first : null;
        if (student == null) {
          return Center(child: Text('No students available'));
        }
        return Column(
          children: [
            SizedBox(
              child: (student.thumbnail != null)
                  ? Image.memory(student.thumbnail!, fit: BoxFit.contain)
                  : const Icon(Icons.person, size: 90.0, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              '${student.givenName} ${student.familyName}',
              style: const TextStyle(fontSize: 18),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
            Text(
              'Allergies/Dietary Restrictions:',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
            SizedBox(
              height: 68.0,
              child: Text(
                (student!.allergies.isEmpty)
                    ? 'None'
                    : student!.allergies
                        .map((allergy) => allergy.name)
                        .toList()
                        .join(', '),
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
                textAlign: TextAlign.center,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Balance: \$${cartController.carttotal['balance'].toStringAsFixed(2)}',
              // 'Balance: \$${student.balance.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: (cartController.carttotal['balance'] < 0.01)
                    ? Colors.red
                    : Colors.green,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Card on File: ',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                Text(
                  student!.cardOnFile.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: (student!.cardOnFile) ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Auto-Reload: ',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                Text(
                  student!.autoReload.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: (student!.autoReload) ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.white),
            // Cart()
            Container(
              width: double.infinity,
              child: Cart(),
            )
            // cartController.cartobx.isNotEmpty ? Cart() : Container()
          ],
        );
      }),
    );
  }
}

class Cart extends StatefulWidget {
  const Cart({
    super.key,
  });

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final _dialogService = locator<DialogService>();
  final _squareService = locator<SquareService>();
  final _mainService = locator<MainService>();

  final GlobalStoreController cartController =
      Get.find<GlobalStoreController>();
  dynamic fromcartObx = [];
  Set<StudentItem> studentsSet = {};
  dynamic totaldiscountobx = {};

  @override
  void initState() {
    super.initState();
    // fromcartObx = cartController.cartobx.toList();
    // studentsSet = cartController.convertSelectStudentToNormalSet();
    // totaldiscountobx = cartController.carttotal;
  }

  pay({required bool charge}) async {
    if (cartController.carttotal['total'] == 0.0) {
      await _dialogService.showCustomDialog(
        variant: DialogType.infoAlert,
        title: 'Cart Empty',
        description: 'There are no items in the cart.',
      );
      return;
    }

    if (!charge && cartController.selectStudent.first.preorder.isEmpty) {
      if ((cartController.carttotal['total'] >
              cartController.selectStudent.first.balance) &&
          (cartController.selectStudent.first.cardOnFile == false ||
              cartController.selectStudent.first.autoReload == false)) {
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
    int total = (cartController.carttotal['calculatedTotal'] * 100).toInt();
    final String transactionText =
        '${cartController.currentSchool.first.name.trim()} - ${cartController.selectStudent.first.displayName.trim()} ${cartController.selectStudent.first.familyName.trim()}';
    if (charge) {
      total = (total * 1.04).ceil();
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
    } else if (cartController.selectStudent.first.preorder.isNotEmpty) {
      var confirm = await _dialogService.showCustomDialog(
        variant: DialogType.confirm,
        title: 'Balance Transaction',
        description:
            'Are you sure you want to process a balance transaction for ${cartController.selectStudent.first.displayName.trim()} ${cartController.selectStudent.first.familyName.trim()}?',
      );
      if (!confirm!.confirmed) {
        return;
      }
      result = 'Balance Transaction';
    } else {
      result = 'Preorder';
    }

    final body = {
      'cart': {
        "studentId": cartController.selectStudent.first.id,
        "organizationId": cartController.currentSchool.first.id,
        "studentGivenName": cartController.selectStudent.first.displayName,
        "studentFamilyName": cartController.selectStudent.first.familyName,
        "items": cartController.cartobx.toJson(),
        "total": cartController.carttotal['total'],
        "date": DateTime.now().toIso8601String(),
        "discount": cartController.carttotal['discount']
      },
      'charge': charge,
      'result': result,
      'preorderId': cartController.selectStudent.first.preorder.isNotEmpty
          ? cartController.selectStudent.first.preorderId
          : '',
    };
    print('***** PAY BODY: ${jsonEncode(body)}');
    try {
      // final double newBalance =
      //     await _mainService.transaction(body: jsonEncode(body));
      // if (!charge) {
      //   await _mainService.updateStudentBalance(
      //       studentId: cartController.selectStudent.first.id,
      //       amount: newBalance);
      // }
      await _dialogService.showCustomDialog(
        variant: DialogType.infoAlert,
        title: 'Transaction Complete',
        description:
            'Transaction for ${cartController.selectStudent.first.displayName.trim()} ${cartController.selectStudent.first.familyName.trim()} was successful.',
      );
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

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final fromcartObx = cartController.cartobx.toList();
      Set<StudentItem> studentsSet =
          cartController.convertSelectStudentToNormalSet();

      final totaldiscountobx = cartController.carttotal;

      return Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          fromcartObx.isEmpty
              ? Container(
                  child: Text(
                    'No Items',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
                    textAlign: TextAlign.center,
                  ),
                  height: MediaQuery.of(context).size.height * 0.3,
                )
              : Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: ListView.builder(
                    itemCount: fromcartObx.length,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        //  if (studentsSet.first.preorder.isEmpty) {
                        cartController.removeCartItem(
                            fromcartObx[index], index);
                        //  }
                      },
                      child: CartItemCard(item: fromcartObx[index]),
                    ),
                  ),
                ),
          const Divider(color: Colors.white),
          (studentsSet.first.role.toUpperCase() == 'FACULTY')
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Discount:',
                      style:
                          TextStyle(fontSize: 18, color: Colors.grey.shade800),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      '\$${totaldiscountobx['discount'].toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.right,
                    ),
                  ],
                )
              : const SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total:',
                style: TextStyle(fontSize: 18, color: Colors.grey.shade800),
                textAlign: TextAlign.left,
              ),
              Text(
                '\$${totaldiscountobx['calculatedTotal']?.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
            ],
          ),
          studentsSet.first.preorder.isNotEmpty
              ? const Column(
                  children: [
                    SizedBox(height: 10.0),
                    Text(
                      'HAS PREORDER',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                )
              : const SizedBox(),
          const SizedBox(height: 10.0),
          TextButton(
            onPressed: () {
              if (studentsSet.first.preorder.isEmpty) {
                pay(charge: true);
              }
            },
            style: TextButton.styleFrom(
              fixedSize: Size(
                MediaQuery.of(context).size.width * 0.25 - 40.0,
                40.0,
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.payment, size: 20.0),
                SizedBox(width: 5.0),
                Text(
                  'PAY CARD',
                  style: TextStyle(fontSize: 13.0),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          TextButton(
            onPressed: () {
              if (studentsSet.first.preorder == false) {
                pay(charge: false);
              }
            },
            style: TextButton.styleFrom(
              fixedSize: Size(
                MediaQuery.of(context).size.width * 0.25 - 40.0,
                40.0,
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.monetization_on_outlined, size: 20.0),
                SizedBox(width: 5.0),
                Text(
                  'PAY BALANCE',
                  style: TextStyle(fontSize: 13.0),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          ElevatedButton.icon(
              onPressed: () {
                cartController.clearCart();
              },
              icon: Icon(
                Icons.cancel_outlined,
                color: Colors.white,
              ), // The icon you want to display
              label: Text(
                'CANCEL',
                style: TextStyle(color: Colors.white),
              ), // The text you want to display
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(
                    MediaQuery.of(context).size.width * 0.25 - 40.0,
                    40.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        12.0), // Set border radius to zero for rectangle
                  ),
                  backgroundColor: Color(0xff0B1731)))
        ],
      );
    });
  }
}

class CartItemCard extends StatelessWidget {
  const CartItemCard({
    super.key,
    required this.item,
  });

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                item.menuItemName,
                style: const TextStyle(fontSize: 14),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '\$${item.menuItemPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NoStudentSelected extends StatelessWidget {
  const NoStudentSelected({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: [
          Icon(Icons.person, size: 100, color: Colors.grey),
          SizedBox(height: 5),
          Text(
            'Search for customer',
            style: TextStyle(fontSize: 18, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
