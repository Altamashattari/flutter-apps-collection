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
  const MemberLogDataTable({
    super.key,
    required this.logs,
    required this.userSetting,
    required this.deleteRow,
    required this.isEditMode,
  });

  @override
  State<MemberLogDataTable> createState() => _MemberLogDataTableState();
}

class _MemberLogDataTableState extends State<MemberLogDataTable> {
  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: _createColumns(),
      rows: _createRows(),
    );
  }

  List<DataColumn> _createColumns() {
    String temperatureUnit =
        widget.userSetting.tempUnit == TemperatureUnit.fahrenheit ? "°F" : "°C";
    var defaultColumns = [
      const DataColumn(
        label: Text('Date'),
      ),
      const DataColumn(
        label: Text('Time'),
      ),
      const DataColumn(
        label: Text('SPO₂'),
        numeric: true,
      ),
      const DataColumn(
        label: Text('Pulse'),
        numeric: true,
      ),
      DataColumn(
        label: Text('Temp($temperatureUnit)'),
        numeric: true,
      ),
    ];
    if (widget.isEditMode) {
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
        .map((log) => DataRow(
              cells: _getDataCells(log),
            ))
        .toList();
  }

  List<DataCell> _getDataCells(MemberLog log) {
    List<DataCell> defaultDataCells = [
      DataCell(Text(_getDisplayDate(log.timestamp))),
      DataCell(Text(_getDisplayTime(log.timestamp))),
      DataCell(Text(log.oxygenSaturation.toString())),
      DataCell(Text(log.pulse.toString())),
      DataCell(Text(log.temp.toString())),
    ];
    if (widget.isEditMode) {
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
}
