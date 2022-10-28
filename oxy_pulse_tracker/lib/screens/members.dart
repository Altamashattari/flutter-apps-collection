import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../entities.dart';
import '../routes.dart';
import '../objectbox.g.dart';
import '../widgets/create_member_form.dart';
import '../widgets/member_list.dart';

class MembersPage extends StatefulWidget {
  const MembersPage({super.key});

  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  late Store _store;
  bool isStoreInitialized = false;

  late Stream<List<Member>> _stream;

  @override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((dir) {
      _store = Store(
        getObjectBoxModel(),
        directory: join(dir.path, 'objectbox'),
      );
      setState(() {
        _stream = _store
            .box<Member>()
            .query()
            .watch(triggerImmediately: true)
            .map((query) => query.find());
        isStoreInitialized = true;
      });
    }).catchError((err) {
      print(err);
    });
  }

  @override
  void dispose() {
    _store.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Oxy Pulse Tracker"),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // _addNewMember();
          _showAddNewMemberDialog(context);
        },
      ),
      body: isStoreInitialized
          ? StreamBuilder(
              stream: _stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return MemberList(
                  members: snapshot.data!,
                  onMemberDelete: _removeMember,
                  onMemberEdit: _onEditMember,
                  store: _store,
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  _showAddNewMemberDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Add Member",
              style: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: CreateMemberForm(
              onSubmit: ((name, age, relation) {
                _hideDialog(context);
                _onMemberSave(name, age, relation);
              }),
              onCancel: () => _hideDialog(context),
            ),
            // actions: [
            //   TextButton(
            //     onPressed: () => Navigator.of(context).pop(),
            //     child: const Text(
            //       "CANCEL",
            //       style: TextStyle(
            //         color: Colors.deepPurple,
            //       ),
            //     ),
            //   ),
            //   TextButton(
            //     onPressed: () => Navigator.of(context).pop(),
            //     child: const Text(
            //       "SAVE",
            //       style: TextStyle(
            //         color: Colors.deepPurple,
            //       ),
            //     ),
            //   ),
            // ],
          );
        });
  }

  _hideDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  _removeMember(int id) {
    _store.box<Member>().remove(id);
  }

  _onEditMember(int id) {}

  String _getMemberInitials(String name) {
    return name.trim().split(' ').map((e) => e[0]).take(2).join();
  }

  _onMemberSave(String name, int age, String relation) {
    final member = Member(
      name: name,
      relation: relation,
      age: age,
      avatar: _getMemberInitials(name),
      isAvatarImage: false,
    );
    _store.box<Member>().put(member);
  }
}
