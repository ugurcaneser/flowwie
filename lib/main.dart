import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/transaction_provider.dart';
import './providers/category_provider.dart';
import './screens/home_screen.dart';
import './screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ],
      child: MaterialApp(
        title: 'Flowwie',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          textTheme: TextTheme(
            bodyLarge: TextStyle(fontFamily: 'Poppins', fontSize: 14),
            bodyMedium: TextStyle(fontFamily: 'Poppins', fontSize: 12),
            titleLarge: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w600),
            titleMedium: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w500),
            titleSmall: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}
