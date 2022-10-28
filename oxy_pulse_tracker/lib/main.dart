import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'screens/members.dart';
import 'screens//member_log.dart';
import 'screens/settings.dart';
import './routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Oxy Pulse Tracker',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      routes: {
        AppRoutes.membersPage: (context) => const MembersPage(),
        AppRoutes.memberLogPage: (context) => const MemberLogPage(),
        AppRoutes.settings: (context) => const Settings(),
      },
      initialRoute: AppRoutes.membersPage,
    );
  }
}
