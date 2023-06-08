import 'package:flutter/material.dart';
import 'package:mobile/screens/calendar_screen.dart';
import 'package:mobile/screens/home_screen.dart';
import 'package:mobile/screens/sign_in_screen.dart';
import 'package:mobile/screens/sign_up_screen.dart';
import 'package:mobile/screens/splash_screen.dart';
import 'package:mobile/store/authentication_store.dart';
import 'package:mobile/store/navigation_store.dart';
import 'package:mobile/store/user_logged_store.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserLoggedStore()),
      ChangeNotifierProvider(create: (_) => AuthenticationStore()),
      ChangeNotifierProvider(create: (_) => NavigationStore()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gendaize Scheduler',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      initialRoute: 'splash',
      routes: {
        'splash': (context) => const SplashScreen(),
        'signin': (context) => const SignInScreen(),
        'signup': (context) => const SignUpScreen(),
        'home': (context) => const HomeScreen(),
        'calendar': (context) => const CalendarScreen(),
      },
    );
  }
}
