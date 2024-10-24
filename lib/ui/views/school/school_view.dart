import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:pos/services/main_service.dart';
import 'package:pos/statemanagement/globalstore.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '/themes/main_theme.dart';
import '../../components/header.dart';
import '../../components/status_bar_date.dart';
import 'school_viewmodel.dart';
// import 'package:get/get.dart';

class SchoolView extends StackedView<SchoolViewModel> {
  const SchoolView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    SchoolViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          StatusBarDate(),
          SizedBox(
            height: 50,
          ),
          Image.asset(
            'assets/images/icon.png',
            fit: BoxFit.contain,
            width: 300,
          ),
          SizedBox(height: 30.0),
          Text('Select your School',
              style: Theme.of(context).textTheme.headlineSmall),
          Container(
            child: viewModel.schools.isNotEmpty
                ? SchoolSearch(model: viewModel)
                : const CircularProgressIndicator(),
          )
        ],
      ),
    );
  }

  @override
  void onViewModelReady(SchoolViewModel viewModel) => viewModel.initialize();

  @override
  SchoolViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SchoolViewModel();
}

class SchoolSearch extends StatefulWidget {
  var model;

  SchoolSearch({required this.model, super.key});

  @override
  State<SchoolSearch> createState() => _SchoolSearchState();
}

// hari did
class _SchoolSearchState extends State<SchoolSearch> {
  // final _mainService = locator<MainService>();

  // final GlobalStoreController cartController =
  //     Get.find<GlobalStoreController>();

  @override
  void initState() {
    super.initState();
    //  getOrganization();
  }

  // Future getOrganization() async {
  //   final data = await _mainService.getOrganizations();
  // }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.only(left: 100, right: 50, bottom: 20),
        child: ListView.builder(
            
            itemCount: widget.model.schools?.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                    Container(
                  margin: EdgeInsets.only(bottom: 8, left: 12, right: 12),
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  decoration: BoxDecoration(
                      // color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0)),
                  child: ListTile(
                    onTap: () {
                      widget.model.confirmSchool(widget.model.schools[index]);
                    },
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: (widget.model.schools[index].thumbnail != null)
                          ? Image.memory(
                              widget.model.schools[index].thumbnail!,
                              fit: BoxFit.contain,
                              width: 60,
                              height: 60,
                            )
                          : SizedBox(
                              width: 60,
                              height: 60,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    ),
                    title: Text(
                      widget.model.schools[index].name,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: colors(context).textLink),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                widget.model.schools?.length - 1 != index
                ? 
                  Divider(
                    color: Colors.white,
                    thickness: 5.0,
                  )
                :
                  Container()
                ],
              );
            }),
      ),
    );
  }
}
