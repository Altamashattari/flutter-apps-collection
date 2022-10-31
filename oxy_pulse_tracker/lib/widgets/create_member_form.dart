import 'package:flutter/material.dart';
import 'package:oxy_pulse_tracker/utils/validator.dart';

import '../constants.dart';
import '../entities.dart';

class CreateMemberForm extends StatefulWidget {
  final Function(String name, int age, String relation, int? id) onSubmit;
  final Function() onCancel;
  final Member? member;

  const CreateMemberForm({
    super.key,
    required this.onSubmit,
    required this.onCancel,
    this.member,
  });

  @override
  State<CreateMemberForm> createState() => _CreateMemberFormState();
}

class _CreateMemberFormState extends State<CreateMemberForm> {
  bool _isOtherRelation = false;
  final _ageFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  late Member member;
  String customRelation = '';

  @override
  void initState() {
    if (widget.member != null) {
      if (!defaultRelations.contains(widget.member!.relation)) {
        customRelation = widget.member!.relation;
        _isOtherRelation = true;
      } else {
        _isOtherRelation = false;
      }
    }

    member = Member(
      name: widget.member?.name ?? '',
      age: widget.member?.age,
      relation: _isOtherRelation ? "Other" : widget.member?.relation ?? "Self",
      avatar: widget.member?.avatar ?? '',
      isAvatarImage: false,
    );
    if (widget.member?.id != null) {
      member.id = widget.member!.id;
    }

    super.initState();
  }

  @override
  void dispose() {
    _ageFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _isOtherRelation ? 350 : 300,
      child: Form(
        key: _form,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: member.name,
                autocorrect: false,
                autofocus: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  labelText: "Name",
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_ageFocusNode);
                },
                onSaved: (newValue) {
                  if (newValue != null && newValue.trim().isNotEmpty) {
                    member.name = newValue;
                  }
                },
                validator: (value) => InputValidator.isValueEmpty(value)
                    ? "Please enter name"
                    : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: member.age == null ? "" : member.age.toString(),
                decoration: const InputDecoration(
                  labelText: "Age",
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: false),
                textInputAction: TextInputAction.next,
                focusNode: _ageFocusNode,
                onSaved: (newValue) {
                  if (newValue != null && newValue.trim().isNotEmpty) {
                    member.age = double.tryParse(newValue)?.round();
                  }
                },
                validator: (value) => InputValidator.isValidNumber(value)
                    ? null
                    : "Please enter valid age",
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField(
                decoration: const InputDecoration(
                  labelText: "Select Relation",
                ),
                value: member.relation,
                items: defaultRelations.map((relation) {
                  return DropdownMenuItem(
                    value: relation,
                    child: Text(relation),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _isOtherRelation = val == "Other";
                    if (!_isOtherRelation) {
                      customRelation = "";
                    }
                    if (val != null) {
                      member.relation = val;
                    }
                  });
                },
              ),
              const SizedBox(height: 10),
              _isOtherRelation
                  ? TextFormField(
                      autofocus: true,
                      autocorrect: false,
                      initialValue: customRelation,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        labelText: "Enter Relation",
                      ),
                      textInputAction: TextInputAction.done,
                      onSaved: (newValue) {
                        if (newValue != null && newValue.trim().isNotEmpty) {
                          customRelation = newValue;
                        }
                      },
                      validator: (value) {
                        if (_isOtherRelation &&
                            InputValidator.isValueEmpty(value)) {
                          return "Please enter relation";
                        }
                        return null;
                      },
                    )
                  : const SizedBox(),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: widget.onCancel,
                    child: const Text(
                      "CANCEL",
                      style: TextStyle(
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _saveForm,
                    child: const Text(
                      "SAVE",
                      style: TextStyle(
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _saveForm() {
    _form.currentState?.save();
    final isValid = _form.currentState?.validate() ?? false;
    if (isValid) {
      widget.onSubmit(
        member.name,
        member.age!,
        customRelation.isNotEmpty ? customRelation : member.relation,
        widget.member?.id,
      );
    }
  }
}
