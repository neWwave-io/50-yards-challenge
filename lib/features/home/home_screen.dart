import 'package:flutter/material.dart';

import '../../data/models/profile.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/profile_repository.dart';

/// Signed-in home. Reads the user's own row from Supabase, including the
/// totals and badge that the database derives from approved lawns.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = const AuthRepository();
  final _profiles = const ProfileRepository();

  late Future<Profile?> _future = _profiles.fetchMine();

  void _reload() => setState(() => _future = _profiles.fetchMine());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('The 50 Yard Challenge'),
        actions: [
          IconButton(
            tooltip: 'Reload',
            icon: const Icon(Icons.refresh),
            onPressed: _reload,
          ),
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout),
            onPressed: () => _auth.signOut(),
          ),
        ],
      ),
      body: FutureBuilder<Profile?>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('Could not load profile:\n${snapshot.error}',
                    textAlign: TextAlign.center),
              ),
            );
          }

          final profile = snapshot.data;
          if (profile == null) {
            return const Center(child: Text('No profile row found.'));
          }

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text('Signed in as', style: theme.textTheme.bodySmall),
              const SizedBox(height: 4),
              Text(
                profile.displayName?.isNotEmpty == true
                    ? profile.displayName!
                    : profile.email,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              _Row(label: 'Email', value: profile.email),
              _Row(label: 'Lawns mowed', value: '${profile.totalLawns}'),
              _Row(
                label: 'Hours',
                value: profile.totalHours.toStringAsFixed(1),
              ),
              _Row(label: 'Badge', value: profile.badgeLevel ?? '—'),
              _Row(label: 'State', value: profile.state ?? '—'),
              _Row(label: 'Region', value: profile.region ?? '—'),
              const SizedBox(height: 24),
              Text(
                'Lawns, hours and badge are calculated by the database from '
                'approved lawns. The app cannot write them.',
                style: theme.textTheme.bodySmall,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Flexible(
            child: Text(
              value,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
