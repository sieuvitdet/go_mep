import 'package:flutter/material.dart';
import 'package:go_mep_application/common/theme/app_colors.dart';
import 'package:go_mep_application/common/widgets/widget.dart';
import 'package:go_mep_application/data/model/res/user_me_res_model.dart';

class AccountDetailScreen extends StatefulWidget {
  final UserMeResModel user;

  const AccountDetailScreen({super.key, required this.user});

  @override
  State<AccountDetailScreen> createState() => _AccountDetailScreenState();
}

class _AccountDetailScreenState extends State<AccountDetailScreen> {
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _phoneController.text = widget.user.phoneNumber ?? '0778393935';
    _nameController.text = widget.user.fullName ?? 'Nguyễn Phan Anh';
    _dobController.text = widget.user.birthday ?? '09-12-1986';
    _addressController.text = widget.user.address ?? '15/02 Công Quỳnh phường Nguyễn Cư Trinh\nQuận 1 Thành phố Hồ Chí Minh';
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    super.dispose();
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
            onPressed: () {
              // TODO: Save user info
              Navigator.pop(context);
            },
            child: CustomText(
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
        child: Column(
          children: [
            // Phone Number
            _buildInfoField(
              icon: Icons.smartphone,
              value: _phoneController.text,
              isEditable: false,
            ),
            // Full Name
            _buildInfoField(
              icon: Icons.person_outline,
              value: _nameController.text,
              onTap: () {
                // TODO: Show edit dialog for name
              },
            ),
            // Date of Birth
            _buildInfoField(
              icon: Icons.calendar_today_outlined,
              value: _dobController.text,
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
              value: _addressController.text,
              maxLines: 2,
              onTap: () {
                // TODO: Show edit dialog for address
              },
            ),
          ],
        ),
      ),
    );
  }
}
