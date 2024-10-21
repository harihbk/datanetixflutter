import 'package:flutter/material.dart';
import 'package:pos/ui/components/spinner.dart';
import 'package:stacked/stacked.dart';

import '../../../globals/settings.dart';
import '../../components/basic_text_field.dart';
import '../../components/button_processing_indicator.dart';
import '../../components/header.dart';
import '../../components/status_bar_date.dart';
import 'auth_viewmodel.dart';

class AuthView extends StackedView<AuthViewModel> {
  const AuthView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AuthViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      bottomNavigationBar: const BottomAppBar(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('version ${Settings.appVersion}'),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const StatusBarDate(),
            const Header(),
            viewModel.isLoading
                ? const SpinnerWidget(
                    height: 40, width: 40, color: Colors.black)
                : viewModel.isCheckingPermissions
                    ? PermissionsCard(model: viewModel)
                    : HomeLoginCard(model: viewModel),
          ],
        ),
      ),
    );
  }

  @override
  void onViewModelReady(AuthViewModel viewModel) => viewModel.initialize();

  @override
  AuthViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AuthViewModel();
}

class PermissionsCard extends StatelessWidget {
  const PermissionsCard({
    super.key,
    required this.model,
  });

  final AuthViewModel model;

  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Grant the Card Reader the required permissions.',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 20.0),
        ButtonContainer(model: model)
      ],
    );
  }
}

class ButtonContainer extends StatelessWidget {
  const ButtonContainer({
    super.key,
    required this.model,
  });

  final AuthViewModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OutlinedButton(
          child: Text(
            model.microphoneButtonText,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed:
              model.hasMicrophoneAccess ? null : model.onRequestAudioPermission,
          style: OutlinedButton.styleFrom(
            fixedSize: const Size(250.0, 40.0),
          ),
        ),
        const SizedBox(height: 20.0),
        OutlinedButton(
          child: Text(
            model.locationButtonText,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: model.hasLocationAccess
              ? null
              : model.onRequestLocationPermission,
          style: OutlinedButton.styleFrom(
            fixedSize: const Size(250.0, 40.0),
          ),
        ),
        const SizedBox(height: 20.0),
        if (model.requireBluetoothPermission)
          OutlinedButton(
            child: Text(
              model.bluetoothButtonText,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed:
                model.hasBluetoothAccess ? null : model.onRequestBluetooth,
            style: OutlinedButton.styleFrom(
              fixedSize: const Size(250.0, 40.0),
            ),
          ),
      ],
    );
  }
}

class HomeLoginCard extends StatelessWidget {
  final AuthViewModel model;
  const HomeLoginCard({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          width: 400.0,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                Text('Point of Sale Login',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 20.0),
                BasicTextField(
                  controller: model.userController,
                  name: 'Email',
                  email: true,
                  errorString: model.userNameError,
                ),
                const SizedBox(height: 10.0),
                BasicTextField(
                  controller: model.passController,
                  password: true,
                  name: 'Password',
                  errorString: model.passwordError,
                ),
                const SizedBox(height: 20.0),
                if (model.isProcessing)
                  const ButtonProcessingIndicator()
                else
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: const Size(
                        double.infinity,
                        50.0,
                      ),
                    ),
                    onPressed: model.submit,
                    child: const Text(
                      'Login',
                      textScaleFactor: 1.0,
                    ),
                  ),
                const SizedBox(height: 15.0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
