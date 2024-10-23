import 'dart:developer';

import 'package:flutter/foundation.dart';
// import 'package:square_reader_sdk/reader_sdk.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../models/menu_item.dart';
import '/app/app.router.dart';
import '/app/app.dialogs.dart';
import '/services/main_service.dart';
import '/app/app.locator.dart';

class AuthViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _mainService = locator<MainService>();
  final _dialogService = locator<DialogService>();

  // final userController = TextEditingController(text: "laurenr@sapphirellc.com");
  // final passController = TextEditingController(text: "SASportal20!");
  final userController = TextEditingController();
  final passController = TextEditingController();

  bool tryingLogin = true;
  bool isProcessing = false;

  String userNameError = '';
  String passwordError = '';

  final List<MenuItem> menuItems = [];

  bool isCheckingPermissions = true;
  bool isLoading = true;

  Future<List<PermissionStatus>> get _permissionsStatus => Future.wait([
        Permission.locationWhenInUse.status,
        Permission.microphone.status,
        if (requireBluetoothPermission) ...[
          Permission.bluetoothConnect.status,
          Permission.bluetoothScan.status,
        ]
      ]);

  final bool requireBluetoothPermission =
      (TargetPlatform.android == defaultTargetPlatform);

  bool hasLocationAccess = false;
  String locationButtonText = 'Enable Location Access';

  bool hasMicrophoneAccess = false;
  String microphoneButtonText = 'Enable Microphone Access';

  bool hasBluetoothAccess = !(TargetPlatform.android == defaultTargetPlatform);
  String bluetoothButtonText = 'Enable Bluetooth Access';

  void updateLocationStatus(PermissionStatus status) {
    hasLocationAccess = (status == PermissionStatus.granted);
    switch (status) {
      case PermissionStatus.granted:
        locationButtonText = 'Location Enabled';
        break;
      case PermissionStatus.permanentlyDenied:
        locationButtonText = 'Enable Location in Settings';
        break;
      case PermissionStatus.restricted:
        locationButtonText = 'Location permission is restricted';
        break;
      case PermissionStatus.denied:
        locationButtonText = 'Enable Location Access';
        break;
      case PermissionStatus.limited:
        microphoneButtonText = 'Location permission is limited';
        break;
      default:
        locationButtonText = 'Unknown Location Status';
    }
    notifyListeners();
  }

  void updateMicrophoneStatus(PermissionStatus status) {
    hasMicrophoneAccess = (status == PermissionStatus.granted);
    switch (status) {
      case PermissionStatus.granted:
        microphoneButtonText = 'Microphone Enabled';
        break;
      case PermissionStatus.permanentlyDenied:
        microphoneButtonText = 'Enable Microphone in Settings';
        break;
      case PermissionStatus.restricted:
        microphoneButtonText = 'Microphone permission is restricted';
        break;
      case PermissionStatus.denied:
        microphoneButtonText = 'Enable Microphone Access';
        break;
      case PermissionStatus.limited:
        microphoneButtonText = 'Microphone permission is limited';
        break;
      default:
        microphoneButtonText = 'Unknown Microphone Status';
    }
    notifyListeners();
  }

  void updateBluetoothStatus(Iterable<PermissionStatus> statuses) {
    if (statuses.isEmpty) {
      return;
    }
    hasBluetoothAccess = statuses.every((status) => status.isGranted);
    if (hasBluetoothAccess) {
      bluetoothButtonText = 'Bluetooth Enabled';
      notifyListeners();
      return;
    }
    if (statuses.any((status) => status.isPermanentlyDenied)) {
      bluetoothButtonText = 'Enable Bluetooth in Settings';
      notifyListeners();
      return;
    }
    if (statuses.any((status) => status.isRestricted)) {
      bluetoothButtonText = 'Bluetooth permission is restricted';
      notifyListeners();
      return;
    }
    if (statuses.any((status) => status.isDenied)) {
      bluetoothButtonText = 'Enable Bluetooth Access';
      notifyListeners();
      return;
    }
    if (statuses.any((status) => status.isLimited)) {
      bluetoothButtonText = 'Bluetooth permission is limited';
      notifyListeners();
      return;
    }
  }

  Future<void> checkPermissionsAndNavigate() async {
    var permissionsStatus = await _permissionsStatus;

    updateLocationStatus(permissionsStatus[0]);
    updateMicrophoneStatus(permissionsStatus[1]);
    updateBluetoothStatus(permissionsStatus.sublist(2));

    // log('***** CHECK PERMISSIONS AND NAVIGATE - LOCATION: $hasLocationAccess | MICROPHONE: $hasMicrophoneAccess | BLUETOOTH: $hasBluetoothAccess');

    if (hasLocationAccess && hasMicrophoneAccess && hasBluetoothAccess) {
      // log('***** CHECK PERMISSIONS AND NAVIGATE - ALL PERMISSIONS GRANTED');
      isCheckingPermissions = false;
      notifyListeners();
    }
  }

  void requestPermission(Permission permission) async {
    switch (await permission.status) {
      //Works in ios
      case PermissionStatus.permanentlyDenied:
        openAppSettings();
        break;
      default:
        //This condition is to check 'Don't ask again' on android'
        if (await permission.request().isPermanentlyDenied) {
          openAppSettings();
        }
        break;
    }
    checkPermissionsAndNavigate();
  }

  void onRequestLocationPermission() {
    requestPermission(Permission.locationWhenInUse);
  }

  void onRequestAudioPermission() {
    requestPermission(Permission.microphone);
  }

  void onRequestBluetooth() async {
    // iOS
    if ((await _permissionsStatus)
        .sublist(2)
        .any((status) => status.isPermanentlyDenied)) {
      openAppSettings();
      return;
    }

    final statuses =
        await [Permission.bluetoothScan, Permission.bluetoothConnect].request();

    if (statuses.values.any((status) => status.isPermanentlyDenied)) {
      openAppSettings();
      return;
    }

    checkPermissionsAndNavigate();
  }

  Future<void> initialize() async {
    log('***** START AUTH VIEW MODEL');

    // final bool isAuthorized = await ReaderSdk.isAuthorized;
    // log('***** isAuthorized: $isAuthorized');
    // if (isAuthorized) {
    //   await ReaderSdk.startReaderSettings();
    // }

    var hasPermissions = await _permissionsStatus
        .then((statuses) => statuses.every((status) => status.isGranted));
    log('***** INITIALIZE HAS PERMISSIONS: $hasPermissions');
    if (hasPermissions) {
      isCheckingPermissions = false;
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> showInfoMessage(String message) async {
    _dialogService.showCustomDialog(
      variant: DialogType.error,
      title: 'Login Error',
      description: message,
    );
  }

  Future<void> submit() async {
    isProcessing = true;
    notifyListeners();
    bool _hasError = false;
    userNameError = '';
    passwordError = '';
    if (!userController.text.isNotEmpty) {
      _hasError = true;
      userNameError = 'Please enter your username';
    }
    if (!passController.text.isNotEmpty) {
      _hasError = true;
      passwordError = 'Please enter your password';
    }
    notifyListeners();
    if (_hasError) {
      isProcessing = false;
      notifyListeners();
      return;
    }

    try {
      _mainService.userName = userController.text;
      _mainService.userPass = passController.text;
      final String result = await runErrorFuture(_mainService.getAccessToken(),
          throwException: true);
      if (result.isEmpty) {
        // login success
        await runErrorFuture(_mainService.getUser(), throwException: true);
        // TODO: if school is not defaulted, goto school selection
        // TODO: if school is defaulted, set school, get students, and goto home
        isProcessing = false;
        notifyListeners();
        navigateToSchoolSelection();
      } else {
        await showInfoMessage(result);
        isProcessing = false;
        notifyListeners();
        return;
      }
    } catch (e) {
      showInfoMessage(e.toString());
      isProcessing = false;
      notifyListeners();
      return;
    }
  }

  void navigateToSchoolSelection() {
    _navigationService.navigateTo(Routes.schoolView);
  }

  Future<void> navigateToHome() async {
    await _navigationService.clearStackAndShow(Routes.homeView);
  }

  @override
  void dispose() {
    userController.dispose();
    passController.dispose();
    super.dispose();
  }
}
