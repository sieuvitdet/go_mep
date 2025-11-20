import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_mep_application/common/theme/app_colors.dart';
import 'package:go_mep_application/common/utils/utility.dart';
import 'package:go_mep_application/common/widgets/widget.dart';
import 'package:go_mep_application/data/model/res/user_me_res_model.dart';
import 'package:go_mep_application/presentation/base/personal/bloc/account_bloc.dart';

class AccountDetailScreen extends StatefulWidget {
  final AccountBloc accountBloc;
  final UserMeResModel user;

  const AccountDetailScreen({
    super.key,
    required this.user,
    required this.accountBloc,
  });

  @override
  State<AccountDetailScreen> createState() => _AccountDetailScreenState();
}

class _AccountDetailScreenState extends State<AccountDetailScreen> {
  // Form controllers
  late TextEditingController _nameController;
  late TextEditingController _dobController;
  late TextEditingController _addressController;

  // Track if data was modified
  bool _hasChanges = false;

  // Pending avatar for preview (not yet saved)
  String? _pendingAvatar;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _nameController = TextEditingController(text: widget.user.fullName ?? '');
    _dobController = TextEditingController(text: widget.user.dateOfBirth ?? '');
    _addressController = TextEditingController(text: widget.user.address ?? '');

    // Listen for changes
    _nameController.addListener(_onFieldChanged);
    _dobController.addListener(_onFieldChanged);
    _addressController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    final hasChanges = _nameController.text != (widget.accountBloc.currentUser?.fullName ?? '') ||
        _dobController.text != (widget.accountBloc.currentUser?.dateOfBirth ?? '') ||
        _addressController.text != (widget.accountBloc.currentUser?.address ?? '') ||
        _pendingAvatar != null;

    if (hasChanges != _hasChanges) {
      setState(() {
        _hasChanges = hasChanges;
      });
    }
  }

  @override
  void dispose() {
    // Clear pending avatar if not saved
    widget.accountBloc.clearPendingAvatar();
    _nameController.removeListener(_onFieldChanged);
    _dobController.removeListener(_onFieldChanged);
    _addressController.removeListener(_onFieldChanged);
    _nameController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final fullName = _nameController.text.trim();
    final dateOfBirth = _dobController.text.trim();
    final address = _addressController.text.trim();

    // Validation
    if (fullName.isEmpty) {
      Utility.toast('Vui lòng nhập họ tên');
      return;
    }

    if (dateOfBirth.isEmpty) {
      Utility.toast('Vui lòng nhập ngày sinh');
      return;
    }

    if (address.isEmpty) {
      Utility.toast('Vui lòng nhập địa chỉ');
      return;
    }

    // Save to API and database
    final result = await widget.accountBloc.updateProfile(
      fullName: fullName,
      dateOfBirth: dateOfBirth,
      address: address,
    );

    if (result != null) {
      Utility.toast('Cập nhật thông tin thành công!');
      setState(() {
        _hasChanges = false;
      });
      Navigator.pop(context, true);
    } else {
      Utility.toast('Cập nhật thông tin thất bại, vui lòng thử lại');
    }
  }

  void _showEditDialog(String title, TextEditingController controller, {int maxLines = 1}) {
    final tempController = TextEditingController(text: controller.text);

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: AppColors.getBackgroundCard(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: title,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.getTextColor(context),
              ),
              Gaps.vGap16,
              CustomTextField(
                controller: tempController,
                maxLines: maxLines,
                textInputColor: AppColors.getTextColor(context),
                backgroundColor: AppColors.getBackgroundCard(context),
                borDerColor: AppColors.getTextColor(context).withOpacity(0.3),
                hintText: '',
              ),
              Gaps.vGap20,
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.getTextColor(context).withOpacity(0.1),
                        foregroundColor: AppColors.getTextColor(context),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: CustomText(
                        text: 'Hủy',
                        fontSize: 16,
                        color: AppColors.getTextColor(context),
                      ),
                    ),
                  ),
                  Gaps.hGap12,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        controller.text = tempController.text;
                        Navigator.of(dialogContext).pop();
                        setState(() {
                          _hasChanges = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: CustomText(
                        text: 'Lưu',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime initialDate = DateTime.now();

    // Parse existing date if available
    if (_dobController.text.isNotEmpty) {
      try {
        final parts = _dobController.text.split('-');
        if (parts.length == 3) {
          initialDate = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
        }
      } catch (_) {}
    }

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(useMaterial3: true).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.blue,
              surface: AppColors.getBackgroundCard(context),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      _dobController.text = '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
      setState(() {
        _hasChanges = true;
      });
    }
  }

  Uint8List _base64ToImage(String base64String) {
    final base64Data = base64String.contains(',')
        ? base64String.split(',').last
        : base64String;
    return base64Decode(base64Data);
  }

  Widget _buildAvatarSection() {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.blue,
                width: 3,
              ),
            ),
            child: ClipOval(
              child: _buildAvatarImage(),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                widget.accountBloc.pickAndUploadAvatar(
                  onAvatarSelected: (avatarData) {
                    setState(() {
                      _pendingAvatar = avatarData;
                      _hasChanges = true;
                    });
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.blue,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.getBackgroundColor(context),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarImage() {
    // Show pending avatar if exists, otherwise show current user avatar
    final avatarToShow = _pendingAvatar ?? widget.user.avatar;

    if (avatarToShow != null && avatarToShow.isNotEmpty) {
      if (avatarToShow.startsWith('data:image')) {
        return Image.memory(
          _base64ToImage(avatarToShow),
          fit: BoxFit.cover,
          width: 120,
          height: 120,
        );
      } else {
        return Image.network(
          avatarToShow,
          fit: BoxFit.cover,
          width: 120,
          height: 120,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.person,
              color: AppColors.getTextColor(context),
              size: 60,
            );
          },
        );
      }
    }

    return Icon(
      Icons.person,
      color: AppColors.getTextColor(context),
      size: 60,
    );
  }

  Widget _buildInfoField({
    required IconData icon,
    required String value,
    bool isEditable = true,
    int maxLines = 1,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: isEditable ? onTap : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.getBackgroundCard(context),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.getTextColor(context), size: 24),
            Gaps.hGap16,
            Expanded(
              child: CustomText(
                text: value.isEmpty ? 'Chưa cập nhật' : value,
                fontSize: 16,
                color: value.isEmpty
                    ? AppColors.getTextColor(context).withOpacity(0.5)
                    : AppColors.getTextColor(context),
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
                height: 1.4,
              ),
            ),
            if (isEditable)
              Icon(Icons.edit, color: AppColors.getTextColor(context), size: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: AppColors.getBackgroundColor(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.getTextColor(context), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: CustomText(
          text: 'Thông tin tài khoản',
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: AppColors.getTextColor(context),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _hasChanges ? _saveProfile : null,
            child: CustomText(
              text: 'Lưu',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: _hasChanges
                  ? AppColors.blue
                  : AppColors.getTextColor(context).withOpacity(0.5),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar section with stream
            _buildAvatarSection(),
            Gaps.vGap24,

            // Phone Number (not editable)
            StreamBuilder<UserMeResModel>(
              stream: widget.accountBloc.userInfoStream,
              initialData: widget.user,
              builder: (context, snapshot) {
                return _buildInfoField(
                  icon: Icons.smartphone,
                  value: snapshot.data?.phoneNumber ?? '',
                  isEditable: false,
                );
              },
            ),

            // Full Name
            _buildInfoField(
              icon: Icons.person_outline,
              value: _nameController.text,
              onTap: () {
                _showEditDialog('Chỉnh sửa họ tên', _nameController);
              },
            ),

            // Date of Birth
            _buildInfoField(
              icon: Icons.calendar_today_outlined,
              value: _dobController.text,
              onTap: _selectDate,
            ),

            // Address
            _buildInfoField(
              icon: Icons.location_on_outlined,
              value: _addressController.text,
              maxLines: 2,
              onTap: () {
                _showEditDialog('Chỉnh sửa địa chỉ', _addressController, maxLines: 3);
              },
            ),
          ],
        ),
      ),
    );
  }
}
