import 'package:flutter/material.dart';
import 'package:oxy_pulse_tracker/models/user_settings_model.dart';
import 'package:oxy_pulse_tracker/screens/intro.dart';
import 'package:oxy_pulse_tracker/utils/shared_pref.dart';
import 'package:oxy_pulse_tracker/utils/utils.dart';
import 'package:provider/provider.dart';

import 'screens/members.dart';
import 'screens//member_log.dart';
import 'screens/settings.dart';
import './routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceUtils.init();
  bool isFirstTime = await Utils.isUsingAppForFirstTime();
  runApp(
    ChangeNotifierProvider<UserSettingModel>(
      create: (context) => UserSettingModel(),
      child: MyApp(
        isFirstTime: isFirstTime,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;
  const MyApp({super.key, required this.isFirstTime});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Oxy Pulse Tracker',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      routes: {
        AppRoutes.homePage: (context) =>
            isFirstTime ? const IntroductionScreens() : const MembersPage(),
        AppRoutes.memberLogPage: (context) => const MemberLogPage(),
        AppRoutes.settings: (context) => const Settings(),
      },
      initialRoute: AppRoutes.homePage,
    );
  }
}
