import 'package:flutter/material.dart';
import 'package:oxy_pulse_tracker/entities.dart';
import 'package:oxy_pulse_tracker/objectbox.g.dart';
import 'package:oxy_pulse_tracker/widgets/create_member_log_form.dart';
import 'package:oxy_pulse_tracker/widgets/log_data_table.dart';

class MemberLogPage extends StatefulWidget {
  const MemberLogPage({super.key});

  @override
  State<MemberLogPage> createState() => _MemberLogPageState();
}

class _MemberLogPageState extends State<MemberLogPage> {
  bool editMode = false;
  bool _sortAscending = false;
  int _sortColumnIndex = 0;

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    Member member = arg['member'];
    Store store = arg['store'];
    final sortField = _getColumnToBeSorted(_sortColumnIndex);
    final queryBuilder =
        store.box<MemberLog>().query(MemberLog_.member.equals(member.id));
    queryBuilder.order(
      sortField,
      flags: _sortAscending ? 0 : Order.descending,
    );
    var stream = queryBuilder
        .watch(triggerImmediately: true)
        .map((query) => query.find());

    return Scaffold(
        appBar: AppBar(
          title: const Text("Logs"),
          actions: _getAppbarActions(),
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          label: const Text("Add Observation"),
          tooltip: "Add Member Observation",
          onPressed: () {
            _showAddNewMemberLogDialog(
              context,
              store,
              member,
            );
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
            return MemberLogDataTable(
              logs: snapshot.data!,
              deleteRow: (id) {
                store.box<MemberLog>().remove(id);
              },
              isEditMode: editMode,
              onSort: (columnIndex, ascending) {
                setState(() {
                  _sortColumnIndex = columnIndex;
                  _sortAscending = ascending;
                });
              },
              onLogEdit: (log) {
                store.box<MemberLog>().put(log);
              },
            );
          },
        ));
  }

  List<Widget> _getAppbarActions() {
    var defaultActions = [
      IconButton(
        icon: !editMode ? const Icon(Icons.edit) : const Icon(Icons.edit_off),
        tooltip: "Switch to edit mode",
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
      ),
    ];
    if (!editMode) {
      defaultActions.add(
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.picture_as_pdf_sharp),
          tooltip: "Save as PDF",
        ),
      );
    }
    return defaultActions;
  }

  dynamic _getColumnToBeSorted(int columnIndex) {
    switch (columnIndex) {
      case 0:
        return MemberLog_.timestamp;
      case 2:
        return MemberLog_.oxygenSaturation;
      case 3:
        return MemberLog_.pulse;
      case 4:
        return MemberLog_.temp;
      default:
        return null;
    }
  }

  _showAddNewMemberLogDialog(
    BuildContext context,
    Store store,
    Member member,
  ) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Add Observation",
              style: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: CreateMemberLogForm(
              onSubmit: (log) => _onCreateMemberLog(log, member, store),
              onCancel: () => Navigator.of(context).pop(),
            ),
          );
        });
  }

  _onCreateMemberLog(
    MemberLog log,
    Member member,
    Store store,
  ) {
    Navigator.of(context).pop();
    log.member.target = member;
    store.box<MemberLog>().put(log);
  }
}
