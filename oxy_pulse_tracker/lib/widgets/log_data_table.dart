import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oxy_pulse_tracker/assets/constants.dart';
import 'package:oxy_pulse_tracker/entities.dart';

import '../utils/user_settings.dart';

class MemberLogDataTable extends StatefulWidget {
  final List<MemberLog> logs;
  final UserSetting userSetting;
  final Function(int id) deleteRow;
  final bool isEditMode;
  final void Function(int columnIndex, bool ascending) onSort;
  final void Function(MemberLog log) onLogEdit;
  const MemberLogDataTable({
    super.key,
    required this.logs,
    required this.userSetting,
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
  @override
  Widget build(BuildContext context) {
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
    String tempUnit = log.tempUnit == TemperatureUnit.fahrenheit ? "°F" : "°C";
    List<DataCell> defaultDataCells = [
      DataCell(
        Text(
          _getDisplayDate(log.timestamp),
        ),
      ),
      DataCell(
        Text(
          _getDisplayTime(log.timestamp),
        ),
      ),
      DataCell(
        widget.isEditMode
            ? TextFormField(
                key: ValueKey("${log.id}-oxygen"),
                initialValue: log.oxygenSaturation.toString(),
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontSize: 14,
                ),
                // onChanged: ((value) {
                //   var updatedValue = double.tryParse(value);
                //   print(updatedValue);
                //   if (updatedValue != null) {
                //     log.oxygenSaturation = updatedValue;
                //     widget.onLogEdit(log);
                //   }
                // }),
                onSaved: (newValue) {
                  var updatedValue = double.tryParse(newValue ?? "");
                  print(updatedValue);
                  if (updatedValue != null) {
                    log.oxygenSaturation = updatedValue;
                    widget.onLogEdit(log);
                  }
                },
              )
            : Text(
                log.oxygenSaturation.toString(),
              ),
      ),
      DataCell(
        widget.isEditMode
            ? TextFormField(
                key: ValueKey("${log.id}-pulse"),
                initialValue: log.pulse.toString(),
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontSize: 14,
                ),
                onChanged: ((value) {
                  var updatedValue = double.tryParse(value);
                  if (updatedValue != null) {
                    log.pulse = updatedValue;
                    widget.onLogEdit(log);
                  }
                }),
              )
            : Text(
                log.pulse.toString(),
              ),
      ),
      DataCell(
        widget.isEditMode
            ? TextFormField(
                key: ValueKey("${log.temp}-temp"),
                initialValue: log.temp.toString(),
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontSize: 14,
                ),
                onChanged: ((value) {
                  var updatedValue = double.tryParse(value);
                  if (updatedValue != null) {
                    log.temp = updatedValue;
                    widget.onLogEdit(log);
                  }
                }),
              )
            : Text(
                "${log.temp}$tempUnit",
              ),
      ),
    ];
    if (widget.isEditMode) {
      defaultDataCells.add(
        DataCell(
          const Icon(
            Icons.save,
            color: Colors.deepPurple,
          ),
          onTap: () {},
        ),
      );
      defaultDataCells.add(
        DataCell(
          const Icon(Icons.delete, color: Colors.red),
          onTap: () {
            widget.deleteRow(log.id);
          },
        ),
      );
    }
    return defaultDataCells;
  }

  String _getDisplayDate(DateTime date) {
    return DateFormat(widget.userSetting.dateFormat).format(date);
  }

  String _getDisplayTime(DateTime date) {
    return DateFormat("h:mm a").format(date);
  }

  void _onDataColumnSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
    widget.onSort(columnIndex, ascending);
  }
}
