// import 'package:go_mep_application/common/theme/app_colors.dart';
// import 'package:go_mep_application/common/theme/app_dimens.dart';
// import 'package:go_mep_application/common/widgets/widget.dart';
// import 'package:go_mep_application/presentation/base/home/bloc/home_bloc.dart';
// import 'package:go_mep_application/presentation/main/bloc/main_bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class HomeScreen extends StatefulWidget {
//   final MainBloc mainBloc;

//   const HomeScreen({Key? key, required this.mainBloc}) : super(key: key);

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   late HomeBloc _bloc;

//   @override
//   void initState() {
//     super.initState();
//     _bloc = HomeBloc(context);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
//     return CustomScaffold(
     
//     );
//   }

//   _buildSkeleton() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: AppSizes.medium),
//       child: Row(
//         children: [
//           LoadingWidget(
//             padding: EdgeInsets.only(top: AppSizes.regular),
//             child: CircleAvatar(
//               radius: 30,
//               backgroundColor: AppColors.greyLight,
//             ),
//           ),
//           Gaps.hGap8,
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 LoadingWidget(
//                   padding: EdgeInsets.only(top: AppSizes.regular),
//                   child: CustomSkeleton(
//                     radius: 8.0,
//                     height: AppSizes.semiMedium,
//                     width: AppSizes.maxWidth * 1 / 3,
//                   ),
//                 ),
//                 LoadingWidget(
//                   padding: EdgeInsets.only(top: AppSizes.regular),
//                   child: CustomSkeleton(
//                     radius: 8.0,
//                     height: AppSizes.semiMedium,
//                     width: AppSizes.maxWidth * 2 / 3,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
