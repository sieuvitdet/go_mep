import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class StartBloc {
  late BuildContext context;
  final streamIsLoading = BehaviorSubject<bool>();

  StartBloc(BuildContext context) {
    this.context = context;
    streamIsLoading.add(false);
  }

  void dispose() {
    streamIsLoading.close();
  }
}
