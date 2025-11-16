import 'package:go_mep_application/common/localization/app_localizations.dart';
import 'package:go_mep_application/common/localization/localizations_config.dart';
import 'package:go_mep_application/common/theme/app_dimens.dart';
import 'package:go_mep_application/common/theme/globals/config.dart';
import 'package:go_mep_application/common/theme/globals/globals.dart';
import 'package:go_mep_application/common/theme/globals/theme_provider.dart';
import 'package:go_mep_application/common/utils/custom_navigator.dart';
import 'package:go_mep_application/common/utils/extension.dart';
import 'package:go_mep_application/common/utils/utility.dart';
import 'package:go_mep_application/common/widgets/widget.dart';
import 'package:go_mep_application/presentation/auth/splash_screen/ui/splash_screen.dart';
import 'package:go_mep_application/data/local/database/app_database.dart';
import 'package:go_mep_application/data/repositories/notification_repository.dart';
import 'package:go_mep_application/data/repositories/user_repository.dart';
import 'package:go_mep_application/data/repositories/places_repository.dart';
import 'package:go_mep_application/data/repositories/auth_repository.dart';
import 'package:go_mep_application/data/repositories/waterlogging_repository.dart';
import 'package:go_mep_application/data/local/database/database_maintenance_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //     name: 'Delta'
  // );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  Globals.myApp = GlobalKey<_MyAppState>();

  await Config.getPreferences();

  await _initializeDatabase();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MyApp(key: Globals.myApp),
    ),
  );
}

/// Initialize database, repositories, and maintenance service
Future<void> _initializeDatabase() async {
  try {
    final database = AppDatabase();

    final notificationDao = database.notificationDao;
    final userDao = database.userDao;
    final placesDao = database.placesDao;

    final notificationRepo = NotificationRepository(notificationDao);
    final userRepo = UserRepository(userDao);
    final placesRepo = PlacesRepository(placesDao);
    final authRepo = AuthRepository(userDao);
    final waterloggingRepo = WaterloggingRepository(database);

    final maintenanceService = DatabaseMaintenanceService(
      database: database,
      notificationRepo: notificationRepo,
      userRepo: userRepo,
      placesRepo: placesRepo,
    );

    Globals.database = database;
    Globals.notificationRepository = notificationRepo;
    Globals.userRepository = userRepo;
    Globals.placesRepository = placesRepo;
    Globals.authRepository = authRepo;
    Globals.waterloggingRepository = waterloggingRepo;
    Globals.maintenanceService = maintenanceService;

    await authRepo.seedDefaultUser();
    await waterloggingRepo.initializeSampleData();
    maintenanceService.schedulePeriodicMaintenance();
    debugPrint('✅ Database initialized successfully');
  } catch (e) {
    debugPrint('❌ Failed to initialize database: $e');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget? child;
  GlobalKey _key = GlobalKey();
  @override
  void initState() {
    super.initState();
    child = const SplashScreen();
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
        return OverlaySupport.global(
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: Colors.transparent,
              statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
              systemNavigationBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
            ),
            child: MaterialApp(
               key: _key,
              debugShowCheckedModeBanner: false,
              navigatorKey: CustomNavigator.navigatorKey,
              theme: ThemeData.light(),
              darkTheme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
              themeMode: themeProvider.themeMode,
              locale: LocalizationsConfig.getCurrentLocale(),
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              builder: (context, child) {
                ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
                  return Container();
                };
                AppSizes.init(context);
                return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.noScaling),
              child: Stack(
                children: [
                GestureDetector(
                  onTap: Utility.hideKeyboard,
                  child: child ?? Container(),
                ),
                Builder(
                  builder: (_) {
                    bool isShowDraggableStack = Globals.prefs.getBool("isShowDraggableStack");
                    return StreamBuilder(
                        stream: DraggableStackService().isShowDraggableStack,
                        initialData: true,
                        builder: (_, snapshot) {
                          if (snapshot.hasData && snapshot.data == true) {
                            return Positioned.fill(
                              child: DraggableStackWidget(
                                initialDraggableOffset: Offset(AppSizes.maxWidth - 20, AppSizes.maxHeight * 0.8),
                              ),
                            );
                          }
                          return SizedBox();
                        }
                      );
                  }
                ),
              ]),
            );
              },
              supportedLocales: const [
                Locale('vi'),
                Locale('en'),
              ],
              home: const SplashScreen(),
            ),
          ),
        );
      },
    );
  }
}


class DraggableStackService {
  static final DraggableStackService _instance =
      DraggableStackService._internal();
  factory DraggableStackService() => _instance;

  DraggableStackService._internal() {
    isShowDraggableStack = BehaviorSubject<bool?>.seeded(null);
  }

  late final BehaviorSubject<bool?> isShowDraggableStack;

  void updateIsShowDraggableStack(bool isShow) {
    // Globals.prefs.setBool("isShowDraggableStack", isShow);
    isShowDraggableStack.set(isShow);
  }

  void dispose() {
    isShowDraggableStack.close();
  }
}