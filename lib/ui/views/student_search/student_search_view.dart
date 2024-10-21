import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'student_search_viewmodel.dart';

class StudentSearchView extends StackedView<StudentSearchViewModel> {
  const StudentSearchView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    StudentSearchViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Student Search'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                autofocus: true,
                controller: viewModel.searchController,
                decoration: const InputDecoration(
                  hintText: 'Search student name or ID',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.separated(
            separatorBuilder: (context, index) => const Divider(),
            itemCount: viewModel.filteredStudents.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  if (viewModel.filteredStudents[index].hasParent) {
                    viewModel.selectStudent(viewModel.filteredStudents[index]);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Student has no parent in the system'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 90.0,
                              width: 70.0,
                              child: (viewModel
                                          .filteredStudents[index].thumbnail !=
                                      null)
                                  ? Image.memory(
                                      viewModel
                                          .filteredStudents[index].thumbnail!,
                                      fit: BoxFit.contain)
                                  : const Icon(Icons.person,
                                      size: 80.0, color: Colors.grey),
                            ),
                            const SizedBox(width: 20.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                (!viewModel.filteredStudents[index].hasParent)
                                    ? const Text(
                                        'Student has no parent in the system',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : const SizedBox(),
                                Text(
                                  '${viewModel.filteredStudents[index].givenName} ${viewModel.filteredStudents[index].familyName} ${viewModel.filteredStudents[index].grade}',
                                  style: Theme.of(context).textTheme.titleLarge,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5.0),
                                Row(
                                  children: [
                                    Text(
                                      'Issued ID: ${viewModel.filteredStudents[index].issuedId}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(width: 10.0),
                                    viewModel.filteredStudents[index].preorder
                                            .isNotEmpty
                                        ? const Text(
                                            'Has a Preorder',
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      viewModel.filteredStudents[index].role.toUpperCase(),
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  @override
  void onViewModelReady(StudentSearchViewModel viewModel) =>
      viewModel.initialize();

  @override
  StudentSearchViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      StudentSearchViewModel();
}
