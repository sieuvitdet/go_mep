import 'package:flutter/material.dart';
import 'package:go_mep_application/common/theme/theme.dart';
import 'package:rxdart/rxdart.dart';
import 'custom_navigator.dart';

extension NumberParsing on String? {
  String removeAccents() {
    List<String> chars = this?.toLowerCase().split("") ?? [];
    String a = "áàảạãăắằẳặẵâấầẩẫậ";
    String d = "đ";
    String e = "éèẻẽẹêếềểễệ";
    String i = "íìỉĩị";
    String o = "óòỏõọôốồổỗộơớờởỡợ";
    String u = "úùủũụưứừửữự";
    String y = "ýỳỷỹỵ";
    String result = "";
    chars.forEach((element) {
      if (a.contains(element))
        element = "a";
      else if (d.contains(element)) {
        element = "d";
      } else if (e.contains(element)) {
        element = "e";
      } else if (i.contains(element)) {
        element = "i";
      } else if (o.contains(element)) {
        element = "o";
      } else if (u.contains(element)) {
        element = "u";
      } else if (y.contains(element)) {
        element = "y";
      }
      result += element;
    });
    return result;
  }
}

extension BehaviorSubjectExtension<T> on BehaviorSubject<T> {
  set(T event, {Function? function}) {
    function?.call();
    if (!this.isClosed) this.sink.add(event);
  }

  setError(String event, {Function? function}) {
    function?.call();
    if (!this.isClosed) this.sink.addError(event);
  }

  ValueStream<T> get output => this.stream;
}

extension AppContext on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);

  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;

  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => Theme.of(this).textTheme;

  Brightness get brightness => MediaQuery.of(this).platformBrightness;
}

extension AppColor on String {
  Color get toColor => Color(int.parse('0XFF${substring(1)}'));
}

extension NavigatorStateExtension on NavigatorState {
  removeHUD() {
    bool isHUDOn = false;
    popUntil((route) {
      if (route.settings.name == AppKeys.keyHUD) {
        isHUDOn = true;
      }
      return true;
    });

    if (isHUDOn) CustomNavigator.hideProgressDialog();
  }
}
