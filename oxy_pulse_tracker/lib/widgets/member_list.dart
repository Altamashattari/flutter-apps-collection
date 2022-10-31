import 'package:flutter/material.dart';
import 'package:oxy_pulse_tracker/objectbox.g.dart';

import '../widgets/member_card.dart';
import '../entities.dart';

class MemberList extends StatelessWidget {
  final List<Member> members;
  final Function(String name, int age, String relation, int? id) onMemberEdit;
  final Function(int memberId) onMemberDelete;
  final Function(Member member) onEditMember;
  final Store store;

  const MemberList({
    super.key,
    required this.members,
    required this.onMemberEdit,
    required this.onMemberDelete,
    required this.store,
    required this.onEditMember,
  });

  @override
  Widget build(BuildContext context) {
    return members.isEmpty
        ? const Center(
            child: Text("No Members Available"),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(
                  top: 16,
                  left: 20,
                  bottom: 10,
                ),
                child: Text(
                  "Members",
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: members.length,
                  itemBuilder: (context, index) => MemberCard(
                    member: members[index],
                    onMemberDelete: onMemberDelete,
                    onMemberEdit: onMemberEdit,
                    onEditMember: onEditMember,
                    store: store,
                  ),
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                ),
              ),
            ],
          );
  }
}
