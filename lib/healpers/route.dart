import 'package:get/get.dart';
import '../views/auth/create_account_screen.dart';
import '../views/auth/signin_screen.dart';
import '../views/auth/teen_invite_login_screen.dart';
import '../views/auth/teen_username_login_screen.dart';
import '../views/bottom_nav/bottom_nav.dart';
import '../views/calendar/calendar_screen.dart';
import '../views/home/home_screen.dart';
import '../views/meals/grocery_list_screen.dart';
import '../views/meals/meals_screen.dart';
import '../views/notes/notes_screen.dart';
import '../views/splash/splash_screen.dart';
import '../views/task/tasks_screen.dart';

class AppRoutes {
  /// Auth Screens
  static const String splashScreen = "/splash_screen";
  static const String signInScreen = "/signin_screen";
  static const String createAccountScreen = "/create_account";
  static const String teenLogin = "/teen_login";
  static const String teenInvite = "/teen_invite";

  /// Bottom Nav Screens
  static const String bottomNavScreen = "/bottom_nav";
  static const String calendarScreen = "/calendar_screen";
  static const String homeScreen = "/home_screen";
  static const String taskScreen = "/tasks_screen";
  static const String noteScreen = "/notes_screen";
  static const String mealScreen = "/meals_screen";
  static const String grocery = "/grocery_list_screen";

  /// Routes
  static List<GetPage> routes = [
    /// Auth Screens
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: signInScreen, page: () => SignInScreen()),
    GetPage(name: createAccountScreen, page: () => CreateAccountScreen()),
    GetPage(name: teenLogin, page: () => TeenInviteLoginScreen()),
    GetPage(name: teenInvite, page: () => TeenUsernameLoginScreen()),

    /// Bottom Nav Screens
    GetPage(name: bottomNavScreen, page: () => BottomNavScreen()),
    GetPage(name: calendarScreen, page: () => CalendarScreen()),
    GetPage(name: homeScreen, page: () => HomeScreen()),
    GetPage(name: taskScreen, page: () => TaskScreen()),
    GetPage(name: noteScreen, page: () => NotesScreen()),
    GetPage(name: mealScreen, page: () => MealsScreen()),
    GetPage(name: grocery, page: () => GroceryListScreen()),
  ];
}
