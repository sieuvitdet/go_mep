import 'package:flutter/material.dart';
import '../../../../common/theme/figma_colors.dart';
import '../../../../common/widgets/figma_button.dart';
import '../../../../common/widgets/figma_logo.dart';
import '../../../../common/widgets/responsive_container.dart';

class ResponsiveLoginScreen extends StatefulWidget {
  const ResponsiveLoginScreen({super.key});

  @override
  State<ResponsiveLoginScreen> createState() => _ResponsiveLoginScreenState();
}

class _ResponsiveLoginScreenState extends State<ResponsiveLoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FigmaColors.backgroundPrimary,
      body: SafeArea(
        child: ResponsiveContainer(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: FigmaDimensions.spacingXLarge),
                
                // Status Bar
                const FigmaStatusBar(),
                const SizedBox(height: FigmaDimensions.spacingXLarge),
                
                // Logo Section
                const FigmaLogo(),
                const SizedBox(height: FigmaDimensions.spacingXLarge * 2),
                
                // Login Form
                _buildLoginForm(),
                const SizedBox(height: FigmaDimensions.spacingLarge),
                
                // Forgot Password
                _buildForgotPassword(),
                const SizedBox(height: FigmaDimensions.spacingLarge),
                
                // Login Button
                _buildLoginButton(),
                const SizedBox(height: FigmaDimensions.spacingMedium),
                
                // Skip Button
                _buildSkipButton(),
                const SizedBox(height: FigmaDimensions.spacingXLarge),
                
                // Register Link
                _buildRegisterLink(),
                
                const SizedBox(height: FigmaDimensions.spacingXLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: FigmaDimensions.spacingMedium),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Phone input
            ResponsiveInputField(
              hintText: 'Nhập số điện thoại',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập số điện thoại';
                }
                if (value.length < 10) {
                  return 'Số điện thoại phải có ít nhất 10 số';
                }
                return null;
              },
            ),
            const SizedBox(height: FigmaDimensions.spacingMedium),
            
            // Password input
            ResponsiveInputField(
              hintText: 'Nhập mật khẩu',
              controller: _passwordController,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập mật khẩu';
                }
                if (value.length < 6) {
                  return 'Mật khẩu phải có ít nhất 6 ký tự';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForgotPassword() {
    return FigmaLinkButton(
      text: 'Quên mật khẩu?',
      onPressed: () {
        _showForgotPasswordDialog();
      },
    );
  }

  Widget _buildLoginButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: FigmaDimensions.spacingMedium),
      child: ResponsiveButton(
        text: 'Đăng nhập',
        type: FigmaButtonType.primary,
        isLoading: _isLoading,
        onPressed: _handleLogin,
      ),
    );
  }

  Widget _buildSkipButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: FigmaDimensions.spacingMedium),
      child: ResponsiveButton(
        text: 'Bỏ qua',
        type: FigmaButtonType.secondary,
        onPressed: () {
          _handleSkip();
        },
      ),
    );
  }

  Widget _buildRegisterLink() {
    return FigmaLinkButton(
      text: 'Bạn chưa có tài khoản? Đăng ký',
      onPressed: () {
        _showRegisterDialog();
      },
    );
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đăng nhập thành công!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _handleSkip() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bỏ qua đăng nhập'),
        content: const Text('Bạn có chắc chắn muốn bỏ qua đăng nhập không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to main screen
            },
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quên mật khẩu'),
        content: const Text('Tính năng quên mật khẩu sẽ được triển khai sớm.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _showRegisterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đăng ký tài khoản'),
        content: const Text('Tính năng đăng ký sẽ được triển khai sớm.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }
}
