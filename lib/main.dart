import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/supabase/supabase_config.dart';
import 'data/repositories/auth_repository.dart';
import 'features/auth/auth_screen.dart';
import 'features/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  // Supabase is the only backend. There is no Firebase in this project.
  await initSupabase();

  runApp(const TheFiftyYardChallengeApp());
}

class TheFiftyYardChallengeApp extends StatelessWidget {
  const TheFiftyYardChallengeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The 50 Yard Challenge',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(brightness: Brightness.light, useMaterial3: true),
      home: const AuthGate(),
    );
  }
}

/// Shows the auth screen or the home screen based on the Supabase session.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    const auth = AuthRepository();

    return StreamBuilder<AuthState>(
      stream: auth.onAuthStateChange,
      builder: (context, snapshot) {
        // Read currentSession directly so a session restored from storage
        // renders immediately, without waiting for a stream event.
        final session = snapshot.data?.session ?? auth.currentSession;
        return session == null ? const AuthScreen() : const HomeScreen();
      },
    );
  }
}
