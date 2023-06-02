import 'package:flutter/material.dart';
import 'package:mobile/screens/home_page.dart';
import 'package:mobile/screens/sign_in_page.dart';
import 'package:mobile/screens/sign_up_page.dart';
import 'package:mobile/store/authentication_store.dart';
import 'package:mobile/store/user_logged_store.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserLoggedStore()),
      ChangeNotifierProvider(create: (_) => AuthenticationStore()),
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
      title: 'Gendaize Delivery',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      initialRoute: 'home',
      routes: {
        'signin': (context) => const SignInPage(),
        'signup': (context) => const SignUpPage(),
        'home': (context) => const HomePage(),
      },
    );
  }
}
