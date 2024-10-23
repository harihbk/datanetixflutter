import 'dart:developer';

import 'package:pos/models/organization_item.dart';
import 'package:pos/statemanagement/globalstore.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../services/main_service.dart';
import '/app/app.router.dart';
import '/app/app.dialogs.dart';
import '/app/app.locator.dart';
import 'package:get/get.dart';

class SchoolViewModel extends BaseViewModel {
  final _dialogService = locator<DialogService>();
  final _navigationService = locator<NavigationService>();
  final _mainService = locator<MainService>();

  final GlobalStoreController cartController =
      Get.find<GlobalStoreController>();

  bool isLoading = false;

  List<OrganizationItem> schools = [];

  Future<void> initialize() async {
    log('***** START SCHOOL VIEW MODEL');
    try {
      final schoolsres = await _mainService.getOrganizations();
      schools.addAll(schoolsres);
      notifyListeners();
    } catch (e) {
      log('***** ERROR GETTING SCHOOLS: $e');
      await _dialogService.showCustomDialog(
        variant: DialogType.error,
        title: 'Error',
        description: 'Error getting schools: $e',
      );
    }
  }

  Future<void> confirmSchool(OrganizationItem school) async {
    DialogResponse? result = await _dialogService.showCustomDialog(
      variant: DialogType.confirm,
      title: 'Confirm School',
      description: school.name,
    );
    if (result != null && result.confirmed) {
      isLoading = true;
      cartController.currentSchoolobx(school);
      notifyListeners();
      _mainService.currentSchool = school;
      try {
        // await _mainService.getStudents();
        // await _mainService.getMenu();
        //  await _mainService.getMenu();
        final response = await _mainService.getCategories();
        print('----mm----');
        print(response);
        print('----mm----');
        cartController.storeCategorygetx(response);
        navigateToHome();
      } catch (e) {
        await _dialogService.showCustomDialog(
          variant: DialogType.error,
          title: 'Error',
          description: 'Error getting school data: $e',
        );
      }
    }
  }

  Future<void> navigateToHome() async {
    await _navigationService.clearStackAndShow(Routes.homeView);
  }
}
