# Step 9: Custom Popup Dialogs & UI Polish

## Overview
This step focuses on creating custom popup dialog components and polishing the entire UI to achieve 100% Figma design compliance. This includes implementing success, error, and confirmation dialogs, refining animations, adding loading states, and ensuring pixel-perfect design implementation across all screens.

## Duration
**2-3 days**

## Status
**⏳ Pending**

## Dependencies
- All previous steps (1-8)

## Objectives
- Create custom dialog components
- Implement success dialogs
- Build error dialogs
- Add confirmation dialogs
- Create info dialogs
- Build loading dialogs
- Implement bottom sheets
- Refine all animations
- Add transition effects
- Polish loading states
- Enhance error states
- Create empty states
- Add shimmer effects
- Ensure 100% Figma compliance

---

## Tasks To Complete

### 1. Custom Dialog System

#### Success Dialog (common/widgets/dialogs/success_dialog.dart):
```dart
class SuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onPressed;

  const SuccessDialog({
    Key? key,
    this.title = 'Success',
    required this.message,
    this.buttonText = 'OK',
    this.onPressed,
  }) : super(key: key);

  static Future<void> show(
    BuildContext context, {
    String title = 'Success',
    required String message,
    String buttonText = 'OK',
    VoidCallback? onPressed,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SuccessDialog(
        title: title,
        message: message,
        buttonText: buttonText,
        onPressed: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.large),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: FigmaColors.success.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                size: 64,
                color: FigmaColors.success,
              ),
            ),
            Gaps.vGap24,

            // Title
            Text(
              title,
              style: AppTextStyles.h2,
              textAlign: TextAlign.center,
            ),
            Gaps.vGap12,

            // Message
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: FigmaColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            Gaps.vGap24,

            // Button
            ResponsiveButton(
              text: buttonText,
              type: FigmaButtonType.primary,
              onPressed: () {
                Navigator.pop(context);
                onPressed?.call();
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

---

#### Error Dialog (common/widgets/dialogs/error_dialog.dart):
```dart
class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onRetry;

  const ErrorDialog({
    Key? key,
    this.title = 'Error',
    required this.message,
    this.buttonText = 'Try Again',
    this.onRetry,
  }) : super(key: key);

  static Future<void> show(
    BuildContext context, {
    String title = 'Error',
    required String message,
    String buttonText = 'Try Again',
    VoidCallback? onRetry,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ErrorDialog(
        title: title,
        message: message,
        buttonText: buttonText,
        onRetry: onRetry,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.large),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Error Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: FigmaColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error,
                size: 64,
                color: FigmaColors.error,
              ),
            ),
            Gaps.vGap24,

            // Title
            Text(
              title,
              style: AppTextStyles.h2,
              textAlign: TextAlign.center,
            ),
            Gaps.vGap12,

            // Message
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: FigmaColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            Gaps.vGap24,

            // Button
            ResponsiveButton(
              text: buttonText,
              type: FigmaButtonType.primary,
              onPressed: () {
                Navigator.pop(context);
                onRetry?.call();
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

---

#### Confirm Dialog (common/widgets/dialogs/confirm_dialog.dart):
```dart
class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String cancelText;
  final String confirmText;
  final VoidCallback? onConfirm;

  const ConfirmDialog({
    Key? key,
    this.title = 'Confirm',
    required this.message,
    this.cancelText = 'Cancel',
    this.confirmText = 'Confirm',
    this.onConfirm,
  }) : super(key: key);

  static Future<bool> show(
    BuildContext context, {
    String title = 'Confirm',
    required String message,
    String cancelText = 'Cancel',
    String confirmText = 'Confirm',
    VoidCallback? onConfirm,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConfirmDialog(
        title: title,
        message: message,
        cancelText: cancelText,
        confirmText: confirmText,
        onConfirm: onConfirm,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.large),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Warning Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: FigmaColors.warning.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.warning,
                size: 64,
                color: FigmaColors.warning,
              ),
            ),
            Gaps.vGap24,

            // Title
            Text(
              title,
              style: AppTextStyles.h2,
              textAlign: TextAlign.center,
            ),
            Gaps.vGap12,

            // Message
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: FigmaColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            Gaps.vGap24,

            // Buttons
            Row(
              children: [
                Expanded(
                  child: ResponsiveButton(
                    text: cancelText,
                    type: FigmaButtonType.outlined,
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                  ),
                ),
                Gaps.hGap12,
                Expanded(
                  child: ResponsiveButton(
                    text: confirmText,
                    type: FigmaButtonType.primary,
                    onPressed: () {
                      Navigator.pop(context, true);
                      onConfirm?.call();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

---

#### Info Dialog (common/widgets/dialogs/info_dialog.dart):
```dart
class InfoDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;

  const InfoDialog({
    Key? key,
    this.title = 'Information',
    required this.message,
    this.buttonText = 'OK',
  }) : super(key: key);

  static Future<void> show(
    BuildContext context, {
    String title = 'Information',
    required String message,
    String buttonText = 'OK',
  }) {
    return showDialog(
      context: context,
      builder: (context) => InfoDialog(
        title: title,
        message: message,
        buttonText: buttonText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.large),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Info Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: FigmaColors.info.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.info,
                size: 64,
                color: FigmaColors.info,
              ),
            ),
            Gaps.vGap24,

            // Title
            Text(
              title,
              style: AppTextStyles.h2,
              textAlign: TextAlign.center,
            ),
            Gaps.vGap12,

            // Message
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: FigmaColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            Gaps.vGap24,

            // Button
            ResponsiveButton(
              text: buttonText,
              type: FigmaButtonType.primary,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

---

#### Loading Dialog (common/widgets/dialogs/loading_dialog.dart):
```dart
class LoadingDialog extends StatelessWidget {
  final String message;

  const LoadingDialog({
    Key? key,
    this.message = 'Loading...',
  }) : super(key: key);

  static void show(BuildContext context, {String message = 'Loading...'}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LoadingDialog(message: message),
    );
  }

  static void hide(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.large),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: FigmaColors.primaryBlue,
            ),
            Gaps.vGap16,
            Text(
              message,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
```

---

### 2. Custom Bottom Sheet

```dart
class CustomBottomSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool isScrollControlled = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.getBackgroundCard(context),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppSizes.radiusLarge),
            topRight: Radius.circular(AppSizes.radiusLarge),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              margin: EdgeInsets.symmetric(vertical: AppSizes.small),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: FigmaColors.textHint,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Content
            child,
          ],
        ),
      ),
    );
  }
}
```

---

### 3. UI Polish Checklist

#### Animation Refinements:
- [ ] Page transition animations
- [ ] Button press animations (scale down on tap)
- [ ] List item fade-in animations
- [ ] Dialog entrance/exit animations
- [ ] Bottom sheet slide animations
- [ ] Image fade-in on load
- [ ] Shimmer animation for loading
- [ ] Pull-to-refresh animation
- [ ] Scroll physics and overscroll effects

#### Loading States:
- [ ] Shimmer placeholders for lists
- [ ] Skeleton screens for content
- [ ] Progress indicators for operations
- [ ] Loading overlays for full-screen
- [ ] Button loading states
- [ ] Image loading placeholders

#### Error States:
- [ ] Error screens with retry buttons
- [ ] Error messages with icons
- [ ] Form field error indicators
- [ ] Network error banners
- [ ] Empty state illustrations

#### Empty States:
- [ ] Empty list illustrations
- [ ] No data placeholders
- [ ] Search no results
- [ ] Empty cart/favorites
- [ ] Connection lost screens

#### Visual Effects:
- [ ] Ripple effects on buttons
- [ ] Shadow effects on cards
- [ ] Border radius consistency
- [ ] Color opacity for overlays
- [ ] Gradient backgrounds where needed

---

### 4. Figma Design Compliance

#### Color Matching:
```dart
// Verify all colors match Figma exactly
class FigmaColorVerification {
  static void verifyColors() {
    // Primary Colors
    assert(FigmaColors.primaryBlue == Color(0xFF3478F6));
    assert(FigmaColors.primaryYellow == Color(0xFFFFD700));

    // Background Colors
    assert(FigmaColors.backgroundPrimary == Color(0xFFFFFFFF));
    assert(FigmaColors.backgroundSecondary == Color(0xFFF5F5F5));

    // Text Colors
    assert(FigmaColors.textPrimary == Color(0xFF000000));
    assert(FigmaColors.textSecondary == Color(0xFF666666));
    assert(FigmaColors.textHint == Color(0xFF999999));

    // Status Colors
    assert(FigmaColors.success == Color(0xFF4CAF50));
    assert(FigmaColors.error == Color(0xFFFF3B30));
    assert(FigmaColors.warning == Color(0xFFFFC107));
    assert(FigmaColors.info == Color(0xFF2196F3));
  }
}
```

#### Typography Matching:
```dart
// Verify text styles match Figma
class FigmaTypographyVerification {
  static void verifyTypography() {
    // Heading 1: 32px, Bold
    assert(AppTextStyles.h1.fontSize == 32);
    assert(AppTextStyles.h1.fontWeight == FontWeight.bold);

    // Heading 2: 24px, Bold
    assert(AppTextStyles.h2.fontSize == 24);
    assert(AppTextStyles.h2.fontWeight == FontWeight.bold);

    // Heading 3: 20px, SemiBold
    assert(AppTextStyles.h3.fontSize == 20);
    assert(AppTextStyles.h3.fontWeight == FontWeight.w600);

    // Body Large: 16px, Normal
    assert(AppTextStyles.bodyLarge.fontSize == 16);

    // Body Medium: 14px, Normal
    assert(AppTextStyles.bodyMedium.fontSize == 14);

    // Body Small: 12px, Normal
    assert(AppTextStyles.bodySmall.fontSize == 12);
  }
}
```

#### Spacing Verification:
```dart
class FigmaSpacingVerification {
  static void verifySpacing() {
    // Verify spacing constants match Figma
    assert(AppSizes.tiny == 4.0);
    assert(AppSizes.small == 8.0);
    assert(AppSizes.regular == 12.0);
    assert(AppSizes.medium == 16.0);
    assert(AppSizes.semiMedium == 20.0);
    assert(AppSizes.large == 24.0);
    assert(AppSizes.xLarge == 32.0);
    assert(AppSizes.xxLarge == 48.0);

    // Border radius
    assert(AppSizes.radiusSmall == 4.0);
    assert(AppSizes.radiusMedium == 8.0);
    assert(AppSizes.radiusLarge == 12.0);
    assert(AppSizes.radiusXLarge == 16.0);
  }
}
```

---

### 5. Usage Examples

#### Show Success Dialog:
```dart
await SuccessDialog.show(
  context,
  title: 'Success',
  message: 'Your password has been changed successfully',
  buttonText: 'OK',
  onPressed: () {
    // Navigate somewhere
  },
);
```

#### Show Error Dialog:
```dart
await ErrorDialog.show(
  context,
  title: 'Error',
  message: 'Failed to connect to server. Please try again.',
  buttonText: 'Retry',
  onRetry: () {
    // Retry the operation
    bloc.retryOperation();
  },
);
```

#### Show Confirm Dialog:
```dart
bool confirmed = await ConfirmDialog.show(
  context,
  title: 'Delete Account',
  message: 'Are you sure you want to delete your account? This action cannot be undone.',
  cancelText: 'Cancel',
  confirmText: 'Delete',
  onConfirm: () {
    // Delete account
    bloc.deleteAccount();
  },
);

if (confirmed) {
  // User confirmed
}
```

#### Show Loading Dialog:
```dart
// Show loading
LoadingDialog.show(context, message: 'Uploading...');

// Perform operation
await uploadFile();

// Hide loading
LoadingDialog.hide(context);
```

#### Show Bottom Sheet:
```dart
await CustomBottomSheet.show(
  context: context,
  child: Container(
    padding: EdgeInsets.all(AppSizes.large),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Select Option', style: AppTextStyles.h3),
        Gaps.vGap16,
        ListTile(title: Text('Option 1')),
        ListTile(title: Text('Option 2')),
        ListTile(title: Text('Option 3')),
      ],
    ),
  ),
);
```

---

## Key Deliverables

⏳ **Success Dialog**: User-friendly success feedback
⏳ **Error Dialog**: Clear error messages with retry option
⏳ **Confirm Dialog**: User confirmation for critical actions
⏳ **Info Dialog**: Information display
⏳ **Loading Dialog**: Loading state indication
⏳ **Bottom Sheet**: Action sheet component
⏳ **Animation Polish**: Smooth transitions and effects
⏳ **Loading States**: Shimmer and skeleton screens
⏳ **Error States**: Helpful error messages
⏳ **Empty States**: Friendly empty screens
⏳ **100% Figma Compliance**: Pixel-perfect implementation

---

## UI Polish Checklist

### Visual Consistency:
- [ ] All colors from Figma palette
- [ ] Correct font sizes and weights
- [ ] Proper spacing and margins
- [ ] Consistent border radius
- [ ] Matching shadows and elevations
- [ ] Proper icon sizes
- [ ] Correct button heights
- [ ] Input field styling

### Interactions:
- [ ] Smooth button animations
- [ ] Ripple effects
- [ ] Hover states (web)
- [ ] Focus states
- [ ] Disabled states
- [ ] Loading states
- [ ] Success feedback
- [ ] Error feedback

### Responsiveness:
- [ ] Adapts to screen sizes
- [ ] Safe area handling
- [ ] Keyboard handling
- [ ] Orientation support
- [ ] Tablet layouts
- [ ] Large text support
- [ ] RTL support (if needed)

---

## Success Criteria

⏳ All custom dialogs implemented
⏳ Dialogs match Figma design 100%
⏳ Animations are smooth and performant
⏳ Loading states provide good UX
⏳ Error states are clear and helpful
⏳ Empty states are friendly
⏳ All colors match Figma exactly
⏳ Typography matches Figma specifications
⏳ Spacing and layout match Figma
⏳ No visual inconsistencies across app

---

**Step Status**: ⏳ Pending
**Next Step**: [Step 10: Testing, Optimization & Deployment](STEP_10_TESTING_DEPLOYMENT.md)
