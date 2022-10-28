import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:oxy_pulse_tracker/entities.dart';
import 'package:oxy_pulse_tracker/objectbox.g.dart';

class MemberLogPage extends StatelessWidget {
  const MemberLogPage({super.key});

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    Member member = arg['member'];
    Store store = arg['store'];
    var stream = store
        .box<MemberLog>()
        .query(MemberLog_.member.equals(member.id))
        .watch(triggerImmediately: true)
        .map((query) => query.find());
    return Scaffold(
        appBar: AppBar(
          title: const Text("Logs"),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.picture_as_pdf_sharp),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.note_add),
          onPressed: () {
            var generator = faker.randomGenerator.integer;
            final log = MemberLog(
              oxygenSaturation: generator(100, min: 80).toDouble(),
              pulse: generator(100, min: 50).toDouble(),
              temp: generator(100, min: 50).toDouble(),
            );
            log.member.target = member;
            store.box<MemberLog>().put(log);
          },
        ),
        body: StreamBuilder(
          stream: stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Center(
              child: Text(
                "${member.name} has ${snapshot.data?.length} logs",
              ),
            );
          },
        ));
  }
}
