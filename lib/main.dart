import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tripmate/screens/splash_screen.dart';
import 'firebase_options.dart';

import 'package:tripmate/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize notification service
  await NotificationService.initialize();
  
  runApp(const TripmateApp());
}

class TripmateApp extends StatefulWidget {
  const TripmateApp({super.key});

  @override
  State<TripmateApp> createState() => _TripmateAppState();
}

class _TripmateAppState extends State<TripmateApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tripmate',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      navigatorObservers: [routeObserver],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4A6FA5),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Color(0xFF4A6FA5),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/busAgencies') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => BusAgenciesScreen(
              from: args['from'],
              to: args['to'],
              date: args['date'],
              time: args['time'],
              passengers: args['passengers'],
            ),
          );
        }
        if (settings.name == '/seatSelection') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => SeatSelectionScreen(
              agency: args['agency'],
              passengers: args['passengers'],
            ),
          );
        }
        if (settings.name == '/payment') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => PaymentScreen(
              agency: args['agency'],
              selectedSeats: args['selectedSeats'],
              totalAmount: args['totalAmount'],
            ),
          );
        }
        return null;
      },
    );
  }
}
