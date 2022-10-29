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
  const MemberLogDataTable({
    super.key,
    required this.logs,
    required this.userSetting,
    required this.deleteRow,
    required this.isEditMode,
    required this.onSort,
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
        ? DataTable(
            columns: _createColumns(),
            rows: _createRows(),
            sortAscending: _sortAscending,
            sortColumnIndex: _sortColumnIndex,
          )
        : const Center(
            heightFactor: 30,
            child: Text(
              "No Data found for the member",
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
          );
  }

  List<DataColumn> _createColumns() {
    String temperatureUnit =
        widget.userSetting.tempUnit == TemperatureUnit.fahrenheit ? "°F" : "°C";
    var defaultColumns = [
      DataColumn(
        label: const Text('Date'),
        onSort: _onDataColumnSort, // 0
      ),
      const DataColumn(
        label: Text('Time'),
      ),
      DataColumn(
        label: const Text('SPO₂'),
        numeric: true,
        onSort: _onDataColumnSort, // 2
      ),
      DataColumn(
        label: const Text('Pulse'),
        numeric: true,
        onSort: _onDataColumnSort, // 3
      ),
      DataColumn(
        label: Text('Temp($temperatureUnit)'),
        numeric: true,
        onSort: _onDataColumnSort, // 4
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

  void _onDataColumnSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
    widget.onSort(columnIndex, ascending);
  }
}
