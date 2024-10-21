import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pos/app/app.locator.dart';
import 'package:pos/models/student_item.dart';
import 'package:pos/services/main_service.dart';
import 'package:pos/statemanagement/globalstore.dart';
import 'package:get/get.dart';
import 'package:pos/ui/views/school/studentSkeleton.dart';
import 'package:stacked/stacked.dart';

class StudentSearch extends StatefulWidget {
  const StudentSearch({super.key});

  @override
  State<StudentSearch> createState() => _StudentSearchState();
}

class _StudentSearchState extends State<StudentSearch> {
  final TextEditingController _searchController = TextEditingController();
  final _mainService = locator<MainService>();
  final List<StudentItem> _items = []; // All student items
  List<StudentItem> _filteredItems = []; // Filtered student items
  final GlobalStoreController cartController =
      Get.find<GlobalStoreController>();
  bool _isLoading = false; // Loading state

  @override
  void initState() {
    super.initState();
    fetchStudents();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = _items
          .where((student) =>
              student.givenName.toLowerCase().contains(query) ||
              student.familyName.toLowerCase().contains(query) ||
              student.issuedId.toLowerCase().contains(query))
          .toList();
    });
  }

  Future fetchStudents() async {
    setState(() {
      _isLoading = true; // Start loading
    });
    try {
      if (cartController.StudentItems.isNotEmpty) {
        List<StudentItem> normalList = cartController.StudentItems.toList();
        setState(() {
          _items.addAll(normalList);
          _filteredItems = List.from(_items);
          _isLoading = false;
        });
        return;
      }
      final response = await _mainService.getStudentsclone();
      if (response.statusCode == 200) {
        final parsed = json.decode(response.body) as Map<String, dynamic>;
        final items = parsed['data'] as List;
        bool printStudents = true;
        for (final item in items) {
          if (printStudents &&
              item['allergies'] != null &&
              item['allergies'] != '') {
            printStudents = false;
          }
          _items.add(StudentItem.fromJson(item as Map<String, dynamic>));
        }
        cartController.studentput(_items);
        setState(() {
          _filteredItems = List.from(_items); // Update filtered list
          _isLoading = false; // Stop loading
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // Stop loading if error occurs
      });
      print('Error fetching students: $e');
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Student Search"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search student name or ID',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: _isLoading
            ? StudentSkeleton()
            : _filteredItems.isEmpty
                ? const Center(child: Text('No students found'))
                : ListView.builder(
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      final student = _filteredItems[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        margin: const EdgeInsets.only(bottom: 8.0),
                        child: ListTile(
                          onTap: () async {
                            {
                              if (student.hasParent) {
                                try {
                                  final newStudentInfo =
                                      await _mainService.refreshStudentclone(
                                          studentId: student.id,
                                          studentflit: _filteredItems);
                                  print('--------cc---');
                                  print(student.role);
                                  cartController
                                      .selectStudentfn(newStudentInfo);
                                  print('--------cc---');
                                  Navigator.pop(context);
                                } catch (e) {
                                  print(e);
                                }

                                // viewModel.selectStudent(viewModel.filteredStudents[index]);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Student has no parent in the system'),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              }
                            }
                          },
                          leading: ClipOval(
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: student.thumbnail != null
                                    ? Image.memory(
                                        student.thumbnail!,
                                        fit: BoxFit.cover,
                                        width: 40.0,
                                        height: 40.0,
                                      )
                                    : const Icon(
                                        Icons.person,
                                        size: 30.0,
                                        color: Color.fromARGB(255, 6, 78, 137),
                                      ),
                              ),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              !student.hasParent
                                  ? const Text(
                                      'Student has no parent in the system',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : const SizedBox(),
                              Text(
                                'Issued ID: ${student.issuedId}',
                                style: Theme.of(context).textTheme.titleMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          title: Text(
                            '${student.givenName} ${student.familyName} ${student.grade}',
                            style: Theme.of(context).textTheme.titleLarge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Column(
                            children: [
                              Text(
                                student.role.toUpperCase(),
                                style: Theme.of(context).textTheme.titleMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              student.preorder.isNotEmpty
                                  ? const Text(
                                      'Has a Preorder',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
