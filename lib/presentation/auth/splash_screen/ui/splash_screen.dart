import 'package:flutter_svg/svg.dart';
import 'package:go_mep_application/common/theme/globals/globals.dart';
import 'package:go_mep_application/common/utils/utility.dart';
import 'package:go_mep_application/data/local/local/shared_prefs/shared_prefs_key.dart';
import 'package:go_mep_application/presentation/auth/change_password/ui/change_password_screen.dart';
import 'package:go_mep_application/presentation/boarding/src/ui/start_screen.dart';
import 'package:go_mep_application/presentation/main/ui/main_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {


  late final AnimationController _fadeController;
  late final AnimationController _scaleController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
   static const Duration _animationDuration = Duration(seconds: 2);

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));
    
    _fadeController.forward();
    _scaleController.forward();
  }

  @override
  void initState() {
    super.initState();

    _initializeAnimations();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    String deviceId = await Utility.getDeviceId();
    Globals.prefs.setString(SharedPrefsKey.device_id, deviceId);
    if (Globals.prefs.getString(SharedPrefsKey.token) != "") {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MainScreen()));
        });
      } else {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => StartScreen()));
        });
      }
    });
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: Listenable.merge([_fadeAnimation, _scaleAnimation]),
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: child!,
          ),
        );
      },
      child: SizedBox(
              width: 127,
              height: 127,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                      'assets/figma/logo_map_circle.svg',
                      width: 127,
                      height: 127,
                    ),
                  // Inner gradient shape
                  SvgPicture.asset(
                      'assets/figma/logo_pin_shape.svg',
                      width: 57,
                      height: 71,
                    ),
                  // Car icon
                  SvgPicture.asset(
                      'assets/figma/logo_car_icon.svg',
                      width: 17,
                      height: 17,
                    ),
                ],
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: _buildAnimatedLogo()));
  }
}
