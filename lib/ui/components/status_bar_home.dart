import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pos/app/app.router.dart';
import 'package:pos/ui/views/school/studentsearch.dart';
import 'package:square_reader_sdk/reader_sdk.dart';
// import 'package:square_reader_sdk/reader_sdk.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../app/app.locator.dart';
import '../../globals/settings.dart';
import '../../services/main_service.dart';
import '../../services/square_service.dart';
import '/themes/main_theme.dart';
import 'online_indicator.dart';

class StatusBarHome extends StatefulWidget {
  const StatusBarHome({
    super.key,
  });

  @override
  State<StatusBarHome> createState() => _StatusBarHomeState();
}

class _StatusBarHomeState extends State<StatusBarHome> {
  final _squareService = locator<SquareService>();
  bool readerIsAuthorized = false;

  @override
  void initState() {
    super.initState();
    checkAuth();
  }

  Future<void> checkAuth() async {
    var isAuthorized = await ReaderSdk.isAuthorized;
    print('***** CHECK AUTH: $isAuthorized');
    setState(() {
      readerIsAuthorized = isAuthorized;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _navigationService = locator<NavigationService>();
    final _mainService = locator<MainService>();
    return Container(
      height: Settings.headerHeight,
      width: double.infinity,
      color: colors(context).button,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    VisibilityDetector(
                      key: const Key('home_bar_visibility_detector'),
                      onVisibilityChanged: (visibilityInfo) {
                        if (visibilityInfo.visibleFraction == 1) {
                          checkAuth();
                        }
                      },
                      child: InkWell(
                        // onTap: _navigationService.navigateToStudentSearchView,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StudentSearch()),
                          );
                        },

                        child: const SizedBox(
                          height: 40.0,
                          width: 350.0,
                          child: Row(
                            children: [
                              Icon(Icons.search,
                                  color: Colors.white, size: 20.0),
                              SizedBox(width: 5.0),
                              Text(
                                'Search Name or ID',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_mainService.currentSchool!.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                            )),
                        Text(
                          'User: ${_mainService.user!.firstName} ${_mainService.user!.lastName}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10.0),
                    IconButton(
                      onPressed: readerIsAuthorized
                          ? () {}
                          : () async {
                              print('***** AUTHORIZING READER');
                              await _squareService.initializeReader();
                              checkAuth();
                            },
                      icon: Icon(
                        Icons.credit_card,
                        color: readerIsAuthorized ? Colors.green : Colors.red,
                        size: 20.0,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    const OnlineIndicator(),
                    const SizedBox(width: 10.0),
                    IconButton(
                      onPressed: () async {
                        await _mainService.logout();
                        _navigationService.navigateTo(Routes.authView);
                      },
                      icon: const Icon(Icons.logout,
                          color: Colors.white, size: 20.0),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
