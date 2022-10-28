import 'package:flutter/material.dart';

class MemberLogPage extends StatefulWidget {
  const MemberLogPage({super.key});

  @override
  State<MemberLogPage> createState() => _MemberLogPageState();
}

class _MemberLogPageState extends State<MemberLogPage> {
  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Logs"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.picture_as_pdf_sharp),
          ),
          // OutlinedButton(
          //   onPressed: () {},
          //   child: Text("Share as PDF"),
          // )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.note_add),
        onPressed: () {},
      ),
      body: Center(
        child: Text(
          "${arg['id']} Log Page",
        ),
      ),
    );
  }
}
