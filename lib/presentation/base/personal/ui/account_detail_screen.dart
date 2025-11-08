import 'package:flutter/material.dart';
import 'package:go_mep_application/common/theme/app_colors.dart';
import 'package:go_mep_application/common/utils/utility.dart';
import 'package:go_mep_application/common/widgets/widget.dart';
import 'package:go_mep_application/data/model/req/update_profile_req_model.dart';
import 'package:go_mep_application/data/model/res/user_me_res_model.dart';
import 'package:go_mep_application/net/api/interaction.dart';
import 'package:go_mep_application/net/repository/repository.dart';
import 'package:go_mep_application/presentation/base/personal/bloc/account_bloc.dart';

class AccountDetailScreen extends StatefulWidget {
  final AccountBloc accountBloc;
  final UserMeResModel user;

  const AccountDetailScreen({super.key, required this.user, required this.accountBloc});

  @override
  State<AccountDetailScreen> createState() => _AccountDetailScreenState();
}

class _AccountDetailScreenState extends State<AccountDetailScreen> {
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _addressController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.fullName ?? '';
    _dobController.text = widget.user.dateOfBirth ?? '';
    _addressController.text = widget.user.address ?? '';
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_isLoading) return;

    final fullName = _nameController.text.trim();
    final dateOfBirth = _dobController.text.trim();
    final address = _addressController.text.trim();

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

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await widget.accountBloc.updateProfile(fullName: fullName, dateOfBirth: dateOfBirth, address: address);
      if (result) {
        Utility.toast('Cập nhật thông tin thành công!');
        Navigator.pop(context, true);
      } else {
        Utility.toast('Cập nhật thông tin thất bại, vui lòng thử lại');
      }
    } catch (e) {
      Utility.toast('Đã có lỗi xảy ra, vui lòng thử lại');
    } finally {
      setState(() {
        _isLoading = false;
      });
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
                        Navigator.of(dialogContext).pop();
                        widget.accountBloc.updateProfile(fullName: _nameController.text, dateOfBirth: _dobController.text, address: _addressController.text);
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
                text: value,
                fontSize: 16,
                color: AppColors.getTextColor(context),
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
            onPressed: _isLoading ? null : _saveProfile,
            child: _isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.getTextColor(context),
                    ),
                  )
                : CustomText(
                    text: 'Lưu',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.getTextColor(context),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder(
          stream: widget.accountBloc.userInfoStream,
          builder: (context, asyncSnapshot) {
            UserMeResModel user = asyncSnapshot.data ?? widget.user;
            return Column(
              children: [
                // Phone Number
                _buildInfoField(
                  icon: Icons.smartphone,
                  value: user.phoneNumber ?? '',
                  isEditable: false,
                ),
                // Full Name
                _buildInfoField(
                  icon: Icons.person_outline,
                  value: user.fullName ?? '',
                  onTap: () {
                    _showEditDialog('Chỉnh sửa họ tên', _nameController);
                  },
                ),
                // Date of Birth
                _buildInfoField(
                  icon: Icons.calendar_today_outlined,
                  value: user.dateOfBirth ?? '',
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      lastDate: DateTime.now(),
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData.dark().copyWith(
                            colorScheme: ColorScheme.dark(
                              primary: AppColors.getTextColor(context),
                              surface: Color(0xFF1E1E1E),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (date != null) {
                      setState(() {
                        _dobController.text = '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
                      });
                    }
                  },
                ),
                // Address
                _buildInfoField(
                  icon: Icons.location_on_outlined,
                  value: user.address ?? '',
                  maxLines: 2,
                  onTap: () {
                    _showEditDialog('Chỉnh sửa địa chỉ', _addressController, maxLines: 3);
                  },
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}
