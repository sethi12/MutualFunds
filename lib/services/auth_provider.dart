import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider with ChangeNotifier {
  Session? _session;

  Session? get session => _session;

  AuthProvider() {
    _session = Supabase.instance.client.auth.currentSession;

    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      if (event == AuthChangeEvent.signedIn ||
          event == AuthChangeEvent.tokenRefreshed) {
        _session = session;
      } else if (event == AuthChangeEvent.signedOut || session == null) {
        _session = null;
      }
      notifyListeners();
    });
  }
}
