import '/ui/dialogs/info_alert/info_alert_dialog.dart';
import '/ui/views/home/home_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import '/ui/dialogs/confirm/confirm_dialog.dart';
import '/services/main_service.dart';
import '/ui/dialogs/error/error_dialog.dart';
import '/ui/views/auth/auth_view.dart';
import '/ui/views/school/school_view.dart';
import 'package:pos/services/square_service.dart';
import 'package:pos/ui/views/student_search/student_search_view.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: AuthView, initial: true),
    MaterialRoute(page: HomeView),
    MaterialRoute(page: SchoolView),
    MaterialRoute(page: StudentSearchView),
// @stacked-route
  ],
  dependencies: [
    Singleton(classType: MainService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: SquareService),
// @stacked-service
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    StackedDialog(classType: ErrorDialog),
    StackedDialog(classType: ConfirmDialog),
    // @stacked-dialog
  ],
)
class App {}
