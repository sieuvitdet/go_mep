import 'package:flutter/material.dart';
import 'package:go_mep_application/common/theme/app_colors.dart';
import 'package:go_mep_application/presentation/auth/register/bloc/register_controller.dart';
import 'package:go_mep_application/presentation/auth/register/ui/register_phone_screen.dart';
import 'package:go_mep_application/presentation/auth/register/ui/register_otp_screen.dart';
import 'package:go_mep_application/presentation/auth/register/ui/register_password_screen.dart';
import 'package:go_mep_application/presentation/auth/register/ui/register_information_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late RegisterController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RegisterController(context);

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: AppColors.getBackgroundColor(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.getTextColor(context),
          ),
          onPressed: _controller.goBack,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: StreamBuilder<RegisterState>(
            stream: _controller.stateStream,
            initialData: RegisterState(step: RegisterStep.phone),
            builder: (context, snapshot) {
              final state = snapshot.data;
              if (state == null) {
                return const SizedBox.shrink();
              }

              switch (state.step) {
                case RegisterStep.phone:
                  return RegisterPhoneScreen(controller: _controller);
                case RegisterStep.otp:
                  return RegisterOTPScreen(controller: _controller);
                case RegisterStep.password:
                  return RegisterPasswordScreen(controller: _controller);
                case RegisterStep.information:
                  return RegisterInformationScreen(controller: _controller);
              }
            },
          ),
        ),
      ),
    );
  }
}
