import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pos/models/student_item.dart';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '/services/main_service.dart';
import '/app/app.locator.dart';

class StudentSearchViewModel extends BaseViewModel {
  final _mainService = locator<MainService>();
  final _navigationService = locator<NavigationService>();
  final searchController = TextEditingController();

  final List<StudentItem> _masterStudents = [];
  final List<StudentItem> filteredStudents = [];

  Future<void> initialize() async {
    log('***** STUDENT SEARCH VIEW MODEL INITIALIZE');
    await loadStudentItems();
    searchController
        .addListener(() => filterStudentItems(searchController.text));
  }

  Future<void> loadStudentItems() async {
    // print('***** LOAD STUDENT ITEMS CALLED');
    _masterStudents.clear();
    _masterStudents.addAll(_mainService.students);
    filteredStudents.clear();
    filteredStudents.addAll(_masterStudents);
    notifyListeners();
  }

  void filterStudentItems(String filter) {
    final List<StudentItem> _matchingItems = [];

    if (filter.isNotEmpty) {
      for (final item in _masterStudents) {
        bool added = false;
        try {
          if (item.givenName.toLowerCase().contains(filter.toLowerCase())) {
            _matchingItems.add(item);
            added = true;
          }
          if (item.familyName.toLowerCase().contains(filter.toLowerCase()) &&
              !added) {
            _matchingItems.add(item);
            added = true;
          }
          if (item.displayName.toLowerCase().contains(filter.toLowerCase()) &&
              !added) {
            _matchingItems.add(item);
            added = true;
          }
          if (item.issuedId.toLowerCase().contains(filter.toLowerCase()) &&
              !added) {
            _matchingItems.add(item);
            added = true;
          }
          if (filter.contains(' ')) {
            if ('${item.givenName} ${item.familyName}'
                    .toLowerCase()
                    .contains(filter.toLowerCase()) &&
                !added) {
              _matchingItems.add(item);
              added = true;
            }
          }
        } catch (e) {
          // print('***** FILTER ITEMS ERROR: ${e.toString()}');
        }
      }

      return populateStudentFilteredItemList(_matchingItems);
    } else {
      return populateStudentFilteredItemList(_masterStudents);
    }
  }

  void populateStudentFilteredItemList(List<StudentItem> items) {
    filteredStudents.clear();
    filteredStudents.addAll(items);
    notifyListeners();
  }

  Future<void> selectStudent(StudentItem student) async {
    log('***** STUDENT SEARCH VIEW MODEL SELECT STUDENT: ${student.givenName}');
    // TODO: update student balance and preorders from API
    await _mainService.refreshStudent(studentId: student.id);
    _mainService.currentStudent = student;
    print('***** CURRENT STUDENT: ${_mainService.currentStudent!.preorder}');
    _navigationService.back();
  }
}
