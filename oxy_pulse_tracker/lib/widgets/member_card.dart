import 'package:flutter/material.dart';
import 'package:oxy_pulse_tracker/routes.dart';
import 'package:oxy_pulse_tracker/widgets/create_member_form.dart';

import '../entities.dart';
import '../objectbox.g.dart';

class MemberCard extends StatelessWidget {
  final Member member;
  final Function(String name, int age, String relation, int? id) onMemberEdit;
  final Function(int memberId) onMemberDelete;
  final Function(Member member) onEditMember;
  final Store store;

  const MemberCard({
    super.key,
    required this.member,
    required this.onEditMember,
    required this.onMemberEdit,
    required this.onMemberDelete,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        child: Center(child: Text(member.avatar)),
      ),
      title: Text(
        member.name,
      ),
      subtitle: Text(
        member.relation,
      ),
      trailing: PopupMenuButton(
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Icon(
                    Icons.edit,
                  ),
                  Text("Edit"),
                ],
              ),
              onTap: () {
                // onEditMember(member);
                Future.delayed(
                  const Duration(seconds: 0),
                  () {
                    // onEditMember(member)
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              "Edit Member",
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: CreateMemberForm(
                              onSubmit: (name, age, relation, id) {
                                Navigator.of(context).pop();
                                onMemberEdit(name, age, relation, id);
                              },
                              onCancel: () => Navigator.of(context).pop(),
                              member: member,
                            ),
                          );
                        });
                  },
                );
              },
            ),
            PopupMenuItem(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Icon(
                    Icons.delete,
                  ),
                  Text("Delete"),
                ],
              ),
              onTap: () => onMemberDelete(member.id),
            ),
          ].toList();
        },
        child: const Icon(
          Icons.more_vert,
        ),
      ),
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.memberLogPage,
        arguments: {'member': member, 'store': store},
      ),
    );
  }
}
