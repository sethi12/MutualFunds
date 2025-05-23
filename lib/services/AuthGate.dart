// screens/auth_gate.dart

import 'package:flutter/material.dart';
import 'package:mutua_funds/screens/dashboard_screen.dart';
import 'package:mutua_funds/screens/loginscreen.dart';
import 'package:mutua_funds/services/auth_provider.dart';
import 'package:provider/provider.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.session == null) {
      return const Loginscreen();
    } else {
      return DashboardScreen();
    }
  }
}
