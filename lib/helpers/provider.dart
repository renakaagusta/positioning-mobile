import 'package:flutter/widgets.dart';
import 'package:positioning/helpers/disposable_provider.dart';
import 'package:positioning/provider/auth/auth_provider.dart';
import 'package:positioning/provider/user/user_profile_provider.dart';
import 'package:provider/provider.dart';

class AppProviders {
  static List<DisposableProvider> getDisposableProviders(BuildContext context) {
    return [
      Provider.of<AuthProvider>(context, listen: false),
      Provider.of<UserProfileProvider>(context, listen: false),
      Provider.of<AuthProvider>(context, listen: false),
    ];
  }

  static void disposeAllDisposableProviders(BuildContext context) {
    getDisposableProviders(context).forEach((disposableProvider) {
      disposableProvider.disposeValues();
    });
  }
}