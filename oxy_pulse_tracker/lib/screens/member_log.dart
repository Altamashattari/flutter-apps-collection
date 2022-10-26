import 'package:flutter/material.dart';

class MemberLogPage extends StatefulWidget {
  const MemberLogPage({super.key});

  @override
  State<MemberLogPage> createState() => _MemberLogPageState();
}

class _MemberLogPageState extends State<MemberLogPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Member Log Page",
      ),
    );
  }
}
