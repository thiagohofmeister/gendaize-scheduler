import 'package:flutter/material.dart';
import 'package:manager/screens/authentication/sign_in_screen.dart';
import 'package:manager/screens/authentication/sign_up_screen.dart';
import 'package:manager/screens/customer/customer_add_screen.dart';
import 'package:manager/screens/customer/customer_address_add_screen.dart';
import 'package:manager/screens/customer/customer_details_screen.dart';
import 'package:manager/screens/customer/customer_list_screen.dart';
import 'package:manager/screens/headquarter/headquarter_add_location_screen.dart';
import 'package:manager/screens/headquarter/headquarter_add_screen.dart';
import 'package:manager/screens/headquarter/headquarter_list_locations_screen.dart';
import 'package:manager/screens/headquarter/headquarter_list_screen.dart';
import 'package:manager/screens/main_screen.dart';
import 'package:manager/screens/scheduled/scheduled_add_screen.dart';
import 'package:manager/screens/scheduled/scheduled_list_screen.dart';
import 'package:manager/screens/service/service_add_screen.dart';
import 'package:manager/screens/service/service_budget_screen.dart';
import 'package:manager/screens/service/service_list_screen.dart';
import 'package:manager/screens/splash_screen.dart';
import 'package:manager/screens/tax/tax_add_screen.dart';
import 'package:manager/screens/tax/tax_list_screen.dart';
import 'package:manager/store/authentication_store.dart';
import 'package:manager/store/customer_store.dart';
import 'package:manager/store/headquarter_store.dart';
import 'package:manager/store/location_store.dart';
import 'package:manager/store/navigation_store.dart';
import 'package:manager/store/organization_store.dart';
import 'package:manager/store/scheduled_store.dart';
import 'package:manager/store/service_store.dart';
import 'package:manager/store/tax_store.dart';
import 'package:manager/store/user_logged_store.dart';
import 'package:manager/store/user_store.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserLoggedStore()),
      ChangeNotifierProvider(create: (_) => AuthenticationStore()),
      ChangeNotifierProvider(create: (_) => NavigationStore()),
      ChangeNotifierProvider(create: (_) => ScheduledStore()),
      ChangeNotifierProvider(create: (_) => CustomerStore()),
      ChangeNotifierProvider(create: (_) => LocationStore()),
      ChangeNotifierProvider(create: (_) => OrganizationStore()),
      ChangeNotifierProvider(create: (_) => ServiceStore()),
      ChangeNotifierProvider(create: (_) => HeadquarterStore()),
      ChangeNotifierProvider(create: (_) => UserStore()),
      ChangeNotifierProvider(create: (_) => TaxStore()),
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
          seedColor: Colors.lightBlue,
        ),
        useMaterial3: true,
      ),
      initialRoute: 'splash',
      routes: {
        'splash': (context) => const SplashScreen(),
        'signin': (context) => const SignInScreen(),
        'signup': (context) => const SignUpScreen(),
        'main': (context) => const MainScreen(),
        'scheduled-list': (context) => const ScheduledListScreen(),
        'scheduled-add': (context) => const ScheduledAddScreen(),
        'service-budget': (context) => const ServiceBudgetScreen(),
        'customer-list': (context) => const CustomerListScreen(),
        'customer-add': (context) => const CustomerAddScreen(),
        'customer-details': (context) => const CustomerDetailsScreen(),
        'customer-address-add': (context) => const CustomerAddressAddScreen(),
        'headquarter-list': (context) => const HeadquarterListScreen(),
        'headquarter-add': (context) => const HeadquarterAddScreen(),
        'headquarter-list-locations': (context) =>
            const HeadquarterListLocationsScreen(),
        'headquarter-add-location': (context) =>
            const HeadquarterAddLocationScreen(),
        'tax-list': (context) => const TaxListScreen(),
        'tax-add': (context) => const TaxAddScreen(),
        'service-list': (context) => const ServiceListScreen(),
        'service-add': (context) => const ServiceAddScreen(),
      },
    );
  }
}
