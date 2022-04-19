import 'package:flutter/widgets.dart';

abstract class DisposableProvider with ChangeNotifier {
  void disposeValues();
}