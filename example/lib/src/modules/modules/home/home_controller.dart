import 'package:flutter_triple/flutter_triple.dart';

class HomeController extends NotifierStore<Exception, int> {
  HomeController() : super(0);

  int value = 0;

  void increment() {
    value++;
    update(value);
  }
}
