import 'package:flutter/material.dart';
import 'package:mutua_funds/services/AuthGate.dart';
import 'package:mutua_funds/services/auth_provider.dart';
import 'package:mutua_funds/services/fund_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Supabase.initialize(
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZkaWhoemZja2VhYmNubGt6bGl0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc4MzYxMzMsImV4cCI6MjA2MzQxMjEzM30.dmYPoTUzdgqFnRBVO8wVOquVmNG_Sr0jyON19l3WrLk",
      url: "https://fdihhzfckeabcnlkzlit.supabase.co",
    );
  } catch (e) {
    // You might want to show an error page or retry logic here
    debugPrint('Supabase initialization failed: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FundProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Mutual Funds',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AuthGate(),
    );
  }
}
