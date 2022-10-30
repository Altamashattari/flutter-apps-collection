import 'package:flutter/material.dart';
import 'package:oxy_pulse_tracker/models/user_settings_model.dart';
import 'package:oxy_pulse_tracker/utils/user_settings.dart';
import 'package:oxy_pulse_tracker/utils/utils.dart';
import 'package:oxy_pulse_tracker/utils/validator.dart';
import 'package:provider/provider.dart';

import '../entities.dart';

class CreateMemberLogForm extends StatefulWidget {
  final Function(MemberLog) onSubmit;
  final Function() onCancel;
  const CreateMemberLogForm({
    super.key,
    required this.onSubmit,
    required this.onCancel,
  });

  @override
  State<CreateMemberLogForm> createState() => _CreateMemberLogFormState();
}

class _CreateMemberLogFormState extends State<CreateMemberLogForm> {
  final _form = GlobalKey<FormState>();
  MemberLog log = MemberLog(
    oxygenSaturation: 0,
    pulse: 0,
  );
  late UserSetting _userSetting;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _userSetting = Provider.of<UserSettingModel>(context).userSettings;
    return SizedBox(
      height: 300,
      child: Form(
        key: _form,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Oxygen Saturation (SPO₂)",
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: const TextInputType.numberWithOptions(),
                textInputAction: TextInputAction.next,
                onSaved: (newValue) {
                  if (InputValidator.isValidNumber(newValue)) {
                    log.oxygenSaturation = double.parse(newValue!);
                  }
                },
                validator: (value) => InputValidator.isValidNumber(value)
                    ? null
                    : "Please enter valid number",
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Pulse Rate",
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: const TextInputType.numberWithOptions(),
                textInputAction: TextInputAction.next,
                onSaved: (newValue) {
                  if (InputValidator.isValidNumber(newValue)) {
                    log.pulse = double.parse(newValue!);
                  }
                },
                validator: (value) => InputValidator.isValidNumber(value)
                    ? null
                    : "Please enter valid pulse value",
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText:
                      "Temparature in ${Utils.getTemperatureUnitString(_userSetting.tempUnit)}",
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: const TextInputType.numberWithOptions(),
                textInputAction: TextInputAction.next,
                onSaved: (newValue) {
                  if (InputValidator.isValidNumber(newValue)) {
                    log.temp = double.parse(newValue!);
                  }
                },
                validator: (value) => InputValidator.isValidNumber(value)
                    ? null
                    : "Please enter valid temperature",
              ),
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
      log.tempUnit = _userSetting.tempUnit;
      widget.onSubmit(log);
    }
  }
}
