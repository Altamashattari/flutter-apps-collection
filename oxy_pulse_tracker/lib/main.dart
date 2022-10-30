import 'package:flutter/material.dart';
import 'package:oxy_pulse_tracker/models/user_settings_model.dart';
import 'package:oxy_pulse_tracker/utils/shared_pref.dart';
import 'package:provider/provider.dart';

import 'screens/members.dart';
import 'screens//member_log.dart';
import 'screens/settings.dart';
import './routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceUtils.init();
  runApp(
    ChangeNotifierProvider<UserSettingModel>(
      create: (context) => UserSettingModel(),
      child: const MyApp(),
    ),
  );
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
