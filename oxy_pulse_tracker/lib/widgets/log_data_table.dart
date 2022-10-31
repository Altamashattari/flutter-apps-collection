import 'package:flutter/material.dart';

import 'package:oxy_pulse_tracker/entities.dart';
import 'package:oxy_pulse_tracker/models/user_settings_model.dart';
import 'package:oxy_pulse_tracker/utils/utils.dart';
import 'package:oxy_pulse_tracker/utils/validator.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../utils/user_settings.dart';

class LogEditableFields {
  final String oxygenSaturation;
  final String pulse;
  final String? temp;

  LogEditableFields({
    required this.oxygenSaturation,
    required this.pulse,
    this.temp,
  });
}

class MemberLogDataTable extends StatefulWidget {
  final List<MemberLog> logs;
  final Function(int id) deleteRow;
  final bool isEditMode;
  final void Function(int columnIndex, bool ascending) onSort;
  final void Function(MemberLog log) onLogEdit;
  const MemberLogDataTable({
    super.key,
    required this.logs,
    required this.deleteRow,
    required this.isEditMode,
    required this.onSort,
    required this.onLogEdit,
  });

  @override
  State<MemberLogDataTable> createState() => _MemberLogDataTableState();
}

class _MemberLogDataTableState extends State<MemberLogDataTable> {
  bool _sortAscending = true;
  int _sortColumnIndex = 0;
  late UserSetting _userSetting;
  final Map<int, LogEditableFields> logMap = {};
  @override
  Widget build(BuildContext context) {
    _userSetting = Provider.of<UserSettingModel>(context).userSettings;
    return widget.logs.isNotEmpty
        ? SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: _createColumns(),
                  rows: _createRows(),
                  sortAscending: _sortAscending,
                  sortColumnIndex: _sortColumnIndex,
                ),
              ),
            ),
          )
        : Container(
            margin: const EdgeInsets.only(top: 30),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "No Data found for the member",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          );
  }

  List<DataColumn> _createColumns() {
    var defaultColumns = [
      DataColumn(
        label: const Text('Date'),
        tooltip: "Record creation date",
        onSort: widget.isEditMode ? null : _onDataColumnSort, // 0
      ),
      const DataColumn(
        label: Text('Time'),
        tooltip: "Record creation time",
      ),
      DataColumn(
          label: const Text('SPO₂'),
          numeric: true,
          onSort: widget.isEditMode ? null : _onDataColumnSort, // 2
          tooltip: "Oxygen Saturation"),
      DataColumn(
          label: const Text('Pulse'),
          numeric: true,
          onSort: widget.isEditMode ? null : _onDataColumnSort, // 3
          tooltip: "Pulse"),
      DataColumn(
        label: const Text('Temp'),
        numeric: true,
        onSort: widget.isEditMode ? null : _onDataColumnSort, // 4
        tooltip: "Temperature",
      ),
    ];
    if (widget.isEditMode) {
      defaultColumns.add(
        DataColumn(
          label: Container(),
        ),
      );
      defaultColumns.add(
        DataColumn(
          label: Container(),
        ),
      );
    }
    return defaultColumns;
  }

  List<DataRow> _createRows() {
    return widget.logs
        .map((log) => DataRow(cells: _getDataCells(log)))
        .toList();
  }

  List<DataCell> _getDataCells(MemberLog log) {
    String tempUnit = Utils.getTemperatureUnitString(log.tempUnit);
    logMap[log.id] = LogEditableFields(
      oxygenSaturation: log.oxygenSaturation.toString(),
      pulse: log.pulse.toString(),
      temp: log.temp?.toString(),
    );
    List<DataCell> defaultDataCells = [
      DataCell(
        Text(
          key: ValueKey("${log.id}-date"),
          _getDisplayDate(log.timestamp),
        ),
      ),
      DataCell(
        Text(
          key: ValueKey("${log.id}-time"),
          _getDisplayTime(log.timestamp),
        ),
      ),
      DataCell(
        widget.isEditMode
            ? TextFormField(
                key: ValueKey("${log.id}-oxygen"),
                initialValue: log.oxygenSaturation.toString(),
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                style: const TextStyle(
                  fontSize: 14,
                ),
                onChanged: (newValue) {
                  final previousValue = logMap[log.id];
                  logMap[log.id] = LogEditableFields(
                    oxygenSaturation: newValue,
                    pulse: previousValue!.pulse,
                    temp: previousValue.temp,
                  );
                },
                validator: (value) {
                  if (InputValidator.isValidNumber(value)) {
                    return null;
                  }
                  return "";
                },
              )
            : Text(
                key: ValueKey("${log.id}-oxygen"),
                log.oxygenSaturation.toString(),
              ),
      ),
      DataCell(
        widget.isEditMode
            ? TextFormField(
                key: ValueKey("${log.id}-pulse"),
                initialValue: log.pulse.toString(),
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                style: const TextStyle(
                  fontSize: 14,
                ),
                onChanged: ((value) {
                  final previousValue = logMap[log.id];
                  logMap[log.id] = LogEditableFields(
                    oxygenSaturation: previousValue!.oxygenSaturation,
                    pulse: value,
                    temp: previousValue.temp,
                  );
                }),
                validator: (value) {
                  if (InputValidator.isValidNumber(value)) {
                    return null;
                  }
                  return "";
                },
              )
            : Text(
                key: ValueKey("${log.id}-pulse"),
                log.pulse.toString(),
              ),
      ),
      DataCell(
        widget.isEditMode
            ? TextFormField(
                key: ValueKey("${log.id}-temp"),
                initialValue: log.temp?.toString() ?? "",
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontSize: 14,
                ),
                onChanged: ((value) {
                  final previousValue = logMap[log.id];
                  logMap[log.id] = LogEditableFields(
                    oxygenSaturation: previousValue!.oxygenSaturation,
                    pulse: previousValue.pulse,
                    temp: value,
                  );
                }),
                validator: (value) {
                  if (value == null || InputValidator.isValidNumber(value)) {
                    return null;
                  }
                  return "";
                },
              )
            : Text(
                key: ValueKey("${log.id}-temp"),
                log.temp != null ? "${log.temp}$tempUnit" : "-",
              ),
      ),
    ];
    if (widget.isEditMode) {
      defaultDataCells.add(
        DataCell(
          Icon(
            key: ValueKey("${log.id}-save"),
            Icons.save,
            color: Colors.deepPurple,
          ),
          onTap: () {
            var editedFields = logMap[log.id];
            if (editedFields == null) {
              return;
            }
            var isOxygenSaturationValid =
                InputValidator.isValidNumber(editedFields.oxygenSaturation);
            var isPulseValid = InputValidator.isValidNumber(editedFields.pulse);
            var isTempValid = editedFields.temp == null ||
                editedFields.temp!.isEmpty ||
                InputValidator.isValidNumber(editedFields.temp);
            if (isOxygenSaturationValid && isPulseValid && isTempValid) {
              log.oxygenSaturation =
                  double.parse(editedFields.oxygenSaturation);
              log.pulse = double.parse(editedFields.pulse);
              log.temp = double.tryParse(editedFields.temp ?? "");
              widget.onLogEdit(log);
              showTopSnackBar(
                context,
                const CustomSnackBar.success(
                  message: "Successfully edited the log",
                  backgroundColor: Colors.deepPurple,
                ),
              );
            } else {
              showTopSnackBar(
                context,
                const CustomSnackBar.error(
                  message: "Please enter valid log value",
                ),
              );
            }
          },
        ),
      );
      defaultDataCells.add(
        DataCell(
          Icon(
            Icons.delete,
            color: Colors.red,
            key: ValueKey("${log.id}-delete"),
          ),
          onTap: () {
            widget.deleteRow(log.id);
            showTopSnackBar(
              context,
              const CustomSnackBar.success(
                message: "Successfully deleted the log",
                backgroundColor: Color.fromARGB(255, 172, 95, 102),
              ),
            );
          },
        ),
      );
    }
    return defaultDataCells;
  }

  String _getDisplayDate(DateTime date) {
    return Utils.getDisplayDate(date, _userSetting.dateFormat);
  }

  String _getDisplayTime(DateTime date) {
    return Utils.getDisplayTime(date);
  }

  void _onDataColumnSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
    widget.onSort(columnIndex, ascending);
  }
}
