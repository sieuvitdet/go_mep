import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_mep_application/common/theme/app_colors.dart';
import 'package:go_mep_application/common/theme/globals/globals.dart';
import 'package:go_mep_application/common/utils/custom_navigator.dart';
import 'package:go_mep_application/common/utils/gps_utils.dart';
import 'package:go_mep_application/common/utils/utility.dart';
import 'package:go_mep_application/common/widgets/widget.dart';
import 'package:go_mep_application/data/local/local/shared_prefs/shared_prefs_key.dart';
import 'package:go_mep_application/presentation/main/ui/main_screen.dart';
import 'package:rxdart/rxdart.dart';

/// Screen để hoàn thiện thông tin profile sau khi login
/// Dùng khi user skip information trong registration
class ProfileCompletionScreen extends StatefulWidget {
  const ProfileCompletionScreen({Key? key}) : super(key: key);

  @override
  State<ProfileCompletionScreen> createState() =>
      _ProfileCompletionScreenState();
}

class _ProfileCompletionScreenState extends State<ProfileCompletionScreen> {
  final fullNameController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final addressController = TextEditingController();

  final streamEnableSubmit = BehaviorSubject<bool>();
  final streamFetchingLocation = BehaviorSubject<bool>();

  @override
  void initState() {
    super.initState();
    streamEnableSubmit.add(false);
    streamFetchingLocation.add(false);
    fullNameController.addListener(_validateFields);

    // Load current user data if exists
    _loadCurrentUserData();
  }

  void _loadCurrentUserData() {
    final user = Globals.userMeResModel;
    if (user != null) {
      fullNameController.text = user.fullName ?? '';
      dateOfBirthController.text = user.dateOfBirth ?? '';
      addressController.text = user.address ?? '';
    }
  }

  void _validateFields() {
    final isValid = fullNameController.text.trim().isNotEmpty;
    streamEnableSubmit.add(isValid);
  }

  Future<void> selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final formattedDate =
          '${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}';
      dateOfBirthController.text = formattedDate;
    }
  }

  Future<void> getCurrentLocation() async {
    streamFetchingLocation.add(true);
    try {
      final position = await GpsUtils.determinePosition();

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        final addressParts = [
          placemark.street,
          placemark.subLocality,
          placemark.locality,
          placemark.administrativeArea,
          placemark.country,
        ].where((part) => part != null && part.isNotEmpty).join(', ');

        if (addressParts.isNotEmpty) {
          addressController.text = addressParts;
          Utility.toast('Đã lấy địa chỉ hiện tại');
        } else {
          Utility.toast('Không thể lấy địa chỉ từ vị trí hiện tại');
        }
      } else {
        Utility.toast('Không thể lấy địa chỉ từ vị trí hiện tại');
      }
    } catch (e) {
      Utility.toast('Lỗi khi lấy vị trí: ${e.toString()}');
    }
    streamFetchingLocation.add(false);
  }

  Future<void> submitInformation() async {
    final fullName = fullNameController.text.trim();
    final dateOfBirth = dateOfBirthController.text.trim();
    final address = addressController.text.trim();

    if (fullName.isEmpty) {
      Utility.toast('Vui lòng nhập họ và tên');
      return;
    }

    final user = Globals.userMeResModel;
    if (user == null || user.phoneNumber == null) {
      Utility.toast('Không tìm thấy thông tin user');
      return;
    }

    try {
      // Update user information
      final updatedUser = await Globals.userRepository?.updateUserInfo(
        phoneNumber: user.phoneNumber!,
        fullName: fullName,
        dateOfBirth: dateOfBirth.isEmpty ? null : dateOfBirth,
        address: address.isEmpty ? null : address,
      );

      if (updatedUser != null) {
        // Update global user
        Globals.userMeResModel = updatedUser;

        // Mark profile as completed
        await Globals.prefs.setBool(SharedPrefsKey.is_profile_completed, true);

        Utility.toast('Hoàn thành cập nhật thông tin!');
        CustomNavigator.pushReplacement(context, MainScreen());
      } else {
        Utility.toast('Không thể cập nhật thông tin');
      }
    } catch (e) {
      Utility.toast('Đã có lỗi xảy ra: ${e.toString()}');
    }
  }

  Future<void> skipInformation() async {
    // Still mark as incomplete, user can complete later
    await Globals.prefs.setBool(SharedPrefsKey.is_profile_completed, false);

    Utility.toast('Bạn có thể hoàn thiện thông tin trong Cài đặt');
    CustomNavigator.pushReplacement(context, MainScreen());
  }

  @override
  void dispose() {
    fullNameController.dispose();
    dateOfBirthController.dispose();
    addressController.dispose();
    streamEnableSubmit.close();
    streamFetchingLocation.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: AppColors.getBackgroundColor(context),
        elevation: 0,
        title: Text(
          '',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.getTextColor(context),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const Spacer(),
              _buildLogo(),
              const SizedBox(height: 24),
              Text(
                'Thông tin cá nhân',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.getTextColor(context),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Hoàn thiện thông tin để sử dụng đầy đủ tính năng',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              // Full Name field
              CustomTextField(
                maxLines: 1,
                controller: fullNameController,
                hintText: 'Họ và tên *',
                backgroundColor: Colors.white,
                borDerColor: AppColors.grey,
                textInputColor: const Color(0xFF616161),
                fontSizeHint: 16,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              const SizedBox(height: 16),
              // Date of Birth field
              GestureDetector(
                onTap: selectDateOfBirth,
                child: AbsorbPointer(
                  child: CustomTextField(
                    maxLines: 1,
                    controller: dateOfBirthController,
                    hintText: 'Ngày sinh (DD-MM-YYYY)',
                    backgroundColor: Colors.white,
                    borDerColor: AppColors.grey,
                    textInputColor: const Color(0xFF616161),
                    fontSizeHint: 16,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Address field với button lấy location
              Stack(
                children: [
                  CustomTextField(
                    maxLines: 1,
                    controller: addressController,
                    hintText: 'Địa chỉ',
                    backgroundColor: Colors.white,
                    borDerColor: AppColors.grey,
                    textInputColor: const Color(0xFF616161),
                    fontSizeHint: 16,
                    contentPadding: EdgeInsets.only(top: 12, bottom: 12, left: 12, right: 40),
                  ),
                  Positioned(
                    right: 8,
                    top: 0,
                    bottom: 0,
                    child: StreamBuilder<bool>(
                      stream: streamFetchingLocation,
                      initialData: false,
                      builder: (context, snapshot) {
                        final isFetching = snapshot.data ?? false;
                        return GestureDetector(
                          onTap: isFetching ? null : getCurrentLocation,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            alignment: Alignment.center,
                            child: isFetching
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Icon(
                                    Icons.my_location,
                                    color: AppColors.primary,
                                    size: 24,
                                  ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Submit button
              StreamBuilder<bool>(
                stream: streamEnableSubmit,
                initialData: false,
                builder: (context, snapshot) {
                  final isEnabled = snapshot.data ?? false;
                  return CustomButton(
                    text: 'Hoàn thành',
                    onTap: isEnabled ? submitInformation : null,
                    color: isEnabled
                        ? null
                        : AppColors.grey.withValues(alpha: 0.3),
                    textColor: isEnabled ? Colors.white : AppColors.grey,
                    radius: 8,
                    enable: isEnabled,
                  );
                },
              ),
              const SizedBox(height: 16),
              // Skip button
              TextButton(
                onPressed: skipInformation,
                child: Text(
                  'Bỏ qua',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.grey,
                  ),
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return SizedBox(
      width: 127,
      height: 127,
      child: Stack(
        children: [
          // Outer circle map
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/figma/logo_map_circle.svg',
              width: 127,
              height: 127,
            ),
          ),
          // Inner gradient shape
          Positioned(
            left: 35,
            top: 13,
            child: SvgPicture.asset(
              'assets/figma/logo_pin_shape.svg',
              width: 57,
              height: 71,
            ),
          ),
          // Car icon
          Positioned(
            left: 55,
            top: 84,
            child: SvgPicture.asset(
              'assets/figma/logo_car_icon.svg',
              width: 17,
              height: 17,
            ),
          ),
        ],
      ),
    );
  }
}
