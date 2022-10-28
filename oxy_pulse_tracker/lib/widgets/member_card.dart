import 'package:flutter/material.dart';
import 'package:oxy_pulse_tracker/routes.dart';

import '../entities.dart';

class MemberCard extends StatelessWidget {
  final Member member;
  final Function(int memberId) onMemberEdit;
  final Function(int memberId) onMemberDelete;

  const MemberCard({
    super.key,
    required this.member,
    required this.onMemberEdit,
    required this.onMemberDelete,
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
              onTap: () => onMemberEdit(member.id),
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
        arguments: {'id': member.id},
      ),
    );
  }
}
