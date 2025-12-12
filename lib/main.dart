import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mom_app/viewmodels/auth_view_mode.dart';
import 'package:mom_app/viewmodels/meal_view_model.dart';
import 'package:mom_app/viewmodels/grocery_view_model.dart';
import 'healpers/route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Set visible background color
      statusBarIconBrightness: Brightness.light, // Android: dark icons
      statusBarBrightness: Brightness.dark, // iOS: light background
    ),
  );
  Get.put(AuthViewModel());
  Get.put(MealViewModel());
  Get.put(GroceryViewModel());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Ensure orientation is locked when app starts
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    // Allow all orientations when app is disposed (optional)
    // SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      designSize: const Size(393, 852),
      child: GetMaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            toolbarHeight: 65,
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
          ),
        ),
        debugShowCheckedModeBanner: false,
        transitionDuration: const Duration(milliseconds: 200),
        initialRoute: AppRoutes.splashScreen,
        navigatorKey: Get.key,
        getPages: AppRoutes.routes,
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mom_app/utils/app_colors.dart';
// import 'healpers/route.dart';
// import 'routes/app_routes.dart'; // corrected import
// import 'theme/app_colors.dart'; // keep single AppColors
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'My App',
//       theme: ThemeData(
//         scaffoldBackgroundColor: AppColors.mainAppColor,
//         primaryColor: AppColors.primary,
//         fontFamily: 'Prompt',
//         textTheme: const TextTheme(
//           bodyText1: TextStyle(color: AppColors.textDark),
//           bodyText2: TextStyle(color: AppColors.textDark),
//         ),
//       ),
//       initialRoute: AppRoutes.splashScreen,
//       getPages: AppRoutes.routes,
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'viewmodels/auth_view_mode.dart';
// import 'views/auth/splash_screen.dart';
//
// void main() {
//   runApp(const MomApp());
// }
//
// class MomApp extends StatelessWidget {
//   const MomApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthViewModel()),
//       ],
//       child: const MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'The Mom App',
//         home: SplashScreen(),
//       ),
//     );
//   }
// }
