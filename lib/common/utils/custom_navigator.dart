import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions_item.dart';
import 'package:go_mep_application/common/utils/extension.dart';
import 'package:go_mep_application/common/utils/progress_dialog.dart';
import 'package:go_mep_application/common/widgets/widget.dart';

class CustomNavigator {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static push(BuildContext context, Widget screen,
      {bool root = true, bool opaque = true}) {
    Navigator.of(context, rootNavigator: root).removeHUD();
    return Navigator.of(context, rootNavigator: root).push(opaque
        ? CustomRoute(
            page: screen,
          )
        : CustomRouteDialog(page: screen));
  }

  static popToScreen(BuildContext context, Widget screen, {bool root = true}) {
    Navigator.of(context, rootNavigator: root).popUntil(
        (route) => route.settings.name == screen.runtimeType.toString());
  }

  static popToRoot(BuildContext context, {bool root = true}) {
    Navigator.of(context, rootNavigator: root)
        .popUntil((route) => route.isFirst);
  }

  static pop(BuildContext? context, {dynamic object, bool root = true}) {
    if (object == null) {
      Navigator.of(context!, rootNavigator: root).pop();
    } else {
      Navigator.of(context!, rootNavigator: root).pop(object);
    }
  }

  static canPop(BuildContext context) {
    ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    return parentRoute?.canPop ?? false;
  }

  static pushReplacement(BuildContext context, Widget screen,
      {bool root = true, bool isHero = false}) {
    Navigator.of(context, rootNavigator: root).removeHUD();
    Navigator.of(context, rootNavigator: root).pushReplacement(
        isHero ? CustomRouteHero(page: screen) : CustomRoute(page: screen));
  }

  static popToRootAndPushReplacement(BuildContext context, Widget screen,
      {bool root = true, bool isHero = false}) {
    Navigator.of(context, rootNavigator: root)
        .popUntil((route) => route.isFirst);
    Navigator.of(context, rootNavigator: root).pushReplacement(
        isHero ? CustomRouteHero(page: screen) : CustomRoute(page: screen));
  }

  static showCustomPopupDialog(
    BuildContext context,
    Widget child, {
    bool root = true,
    bool isExpanded = false,
    bool cancelable = true,
    List<KeyboardActionsItem>? actions,
  }) {
    return push(
        context,
        CustomDialog(
          screen: CustomPopupDialog(
            isExpanded: isExpanded,
            child: child,
          ),
          actions: actions,
          cancelable: cancelable,
        ),
        opaque: false,
        root: root);
  }

  static showCustomPopup(
    BuildContext context,
    String title, {
    String content = '',
    bool showCloseIcon = true,
    bool root = true,
    bool cancelable = true,
    GestureTapCallback? onConfirm,
  }) {
    return push(
        context,
        CustomPopup(
          title: title,
          content: content,
          showActionButtons: false,
          showCloseIcon: showCloseIcon,
          onConfirm: onConfirm,
        ),
        opaque: false,
        root: root);
  }

  static showCustomPopupAction(
    BuildContext context,
    String title, {
    String content = '',
    bool root = true,
    bool cancelable = true,
    String? titleSubmit,
    String? titleUnSubmit,
    TextAlign? textAlign,
    required VoidCallback onConfirm,
    required VoidCallback onClose,
  }) {
    return push(
        context,
        CustomPopup(
            title: title,
            content: content,
            showActionButtons: true,
            titleSubmit: titleSubmit,
            titleUnSubmit: titleUnSubmit,
            onConfirm: onConfirm,
            onClose: onClose,
            textAlign: textAlign),
        opaque: false,
        root: root);
  }

  static showCustomPopupActionImage(
    BuildContext context,
    String title, {
    String content = '',
    bool root = true,
    bool cancelable = true,
    required VoidCallback onConfirm,
    required VoidCallback onClose,
  }) {
    return push(
        context,
        CustomPopupImage(
            title: title,
            content: content,
            showActionButtons: true,
            onConfirm: onConfirm,
            onClose: onClose),
        opaque: false,
        root: root);
  }

  static showCustomPopupImage(
    BuildContext context,
    String title, {
    String content = '',
    bool showCloseIcon = true,
    bool root = true,
    bool cancelable = true,
    required VoidCallback onConfirm,
  }) {
    return push(
        context,
        CustomPopupImage(
          title: title,
          content: content,
          showActionButtons: false,
          showCloseIcon: showCloseIcon,
          onConfirm: onConfirm,
        ),
        opaque: false,
        root: root);
  }

  static showCustomPopupWarning(
    BuildContext context, {
    String content = '',
    bool showCloseIcon = true,
    bool root = true,
    bool cancelable = true,
  }) {
    return push(
        context,
        CustomPopupWarning(
          content: content,
        ),
        opaque: false,
        root: root);
  }

  static showCustomBottomDialog(BuildContext context, Widget screen,
      {bool root = true, isScrollControlled = true}) {
    return showModalBottomSheet(
        context: context,
        useRootNavigator: root,
        isScrollControlled: isScrollControlled,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return GestureDetector(
            child: screen,
            onTap: () {},
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  static showCustomAlertDialog(BuildContext context, String? content,
      {bool root = true,
      String? title,
      GestureTapCallback? onSubmitted,
      String? textSubmitted,
      Color? colorSubmitted,
      String? textSubSubmitted,
      GestureTapCallback? onSubSubmitted,
      bool enableCancel = true,
      bool cancelable = true,
      TextStyle? styleSubmitted,
      TextStyle? styleSubSubmitted,
      CustomAlertDialogType type = CustomAlertDialogType.info}) {
    return push(
        context,
        CustomDialog(
          screen: CustomAlertDialog(
            title: title,
            content: content,
            textSubmitted: textSubmitted,
            colorSubmitted: colorSubmitted,
            onSubmitted: onSubmitted,
            textSubSubmitted: textSubSubmitted,
            onSubSubmitted: onSubSubmitted,
            enableCancel: enableCancel,
            styleSubSubmitted: styleSubSubmitted,
            styleSubmitted: styleSubmitted,
            type: type,
          ),
          cancelable: cancelable,
        ),
        opaque: false,
        root: root);
  }

  static ProgressDialog? _pr;
  static showProgressDialog(BuildContext? context) {
    if (_pr == null) {
      _pr = ProgressDialog(context);
      _pr!.show();
    }
  }

  static hideProgressDialog() {
    if (_pr != null && _pr!.isShowing()) {
      _pr!.hide();
      _pr = null;
    }
  }
}
