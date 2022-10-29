import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:oxy_pulse_tracker/assets/constants.dart';
import 'package:oxy_pulse_tracker/entities.dart';
import 'package:oxy_pulse_tracker/objectbox.g.dart';
import 'package:oxy_pulse_tracker/utils/user_settings.dart';
import 'package:oxy_pulse_tracker/widgets/log_data_table.dart';

class MemberLogPage extends StatefulWidget {
  const MemberLogPage({super.key});

  @override
  State<MemberLogPage> createState() => _MemberLogPageState();
}

class _MemberLogPageState extends State<MemberLogPage> {
  bool editMode = false;

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
              onPressed: () {
                setState(() {
                  editMode = !editMode;
                });
                String editModeText = editMode ? "enabled" : "disabled";
                final snackBar = SnackBar(
                  content: Text(
                    'Edit Mode $editModeText',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  backgroundColor: (Colors.deepPurple),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              icon: const Icon(Icons.edit),
            ),
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
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: MemberLogDataTable(
                    logs: snapshot.data!,
                    userSetting: UserSetting(
                      dateFormat: "dd/MM/yyyy",
                      tempUnit: TemperatureUnit.fahrenheit,
                    ),
                    deleteRow: (id) => store.box<MemberLog>().remove(id),
                    isEditMode: editMode,
                  ),
                ),
              ),
            );
          },
        ));
  }
}
