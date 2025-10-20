import 'package:go_mep_application/common/theme/app_colors.dart';
import 'package:go_mep_application/common/theme/app_dimens.dart';
import 'package:go_mep_application/common/utils/extension.dart';
import 'package:go_mep_application/presentation/base/google_map/ui/map_screen.dart';
import 'package:go_mep_application/presentation/base/news/ui/news_screen.dart';
import 'package:go_mep_application/presentation/base/restaurant/ui/restaurant_screen.dart';
import 'package:go_mep_application/presentation/main/bloc/main_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_mep_application/presentation/base/personal/ui/account_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late MainBloc _bloc;

  List<Widget> _widgetOptions = [];

  @override
  void initState() {
    super.initState();
    _bloc = MainBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    });
    _widgetOptions = [
      MapScreen(mainBloc: _bloc),
      RestaurantScreen(mainBloc: _bloc),
      NewsScreen(mainBloc: _bloc),
      AccountScreen(mainBloc: _bloc),
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onTabTapped(int index) {
    _bloc.streamCurrentIndex.set(index);
  }

   Widget _buildBottomNavItem(IconData icon, String label, bool isSelected, Function() onTap, double width) {
    return SizedBox(
      width: width,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSelected)
              Container(
                height: 2,
                width: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF5691FF), Color(0xFFDE50D0)],
                  ),
                ),
              ),
            const SizedBox(height: 8),
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) => isSelected
                  ? LinearGradient(
                      colors: [Color(0xFF5691FF), Color(0xFFDE50D0)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ).createShader(bounds)
                  : LinearGradient(
                      colors: [AppColors.getTextColor(context), AppColors.getTextColor(context)],
                    ).createShader(bounds),
              child: Icon(
                icon,
                color: isSelected ? AppColors.getTextColor(context) : AppColors.getBottomNavigationBarColor(context),
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) => isSelected
                  ? LinearGradient(
                      colors: [Color(0xFF5691FF), Color(0xFFDE50D0)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ).createShader(bounds)
                  : LinearGradient(
                      colors: [AppColors.getTextColor(context), AppColors.getTextColor(context)],
                    ).createShader(bounds),
              child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.getTextColor(context),
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    double width = AppSizes.screenSize(context).width / 4;
    return StreamBuilder(
      stream: _bloc.streamCurrentIndex.output,
      initialData: 0,
      builder: (context, asyncSnapshot) {
        int currentIndex = asyncSnapshot.data ?? 0;
        return Container(
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.getBottomNavigationBarColor(context),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBottomNavItem(Icons.map_outlined, 'Bản đồ', currentIndex == 0, () {
                _onTabTapped(0);
              }, width),
              _buildBottomNavItem(Icons.restaurant, 'Quán ăn', currentIndex == 1, () {
                _onTabTapped(1);
              }, width),
              _buildBottomNavItem(Icons.article_outlined, 'Tin tức', currentIndex == 2, () {
                _onTabTapped(2);
              }, width),
              _buildBottomNavItem(Icons.account_circle_outlined, 'Tài khoản', currentIndex == 3, () {
                _onTabTapped(3);
              }, width),
            ],
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          body: Stack(clipBehavior: Clip.none, children: [
            StreamBuilder(
              stream: _bloc.streamCurrentIndex.output,
              initialData: 0,
              builder: (context, asyncSnapshot) {
                return IndexedStack(
                  index: asyncSnapshot.data ?? 0,
                  children: _widgetOptions,
                );
              }
            ),
          ]),
          bottomNavigationBar: _buildBottomNavigationBar(),
        ),
      ),
    );
  }
}
