import 'dart:typed_data';

import 'package:oxy_pulse_tracker/entities.dart';
import 'package:oxy_pulse_tracker/utils/user_settings.dart';
import 'package:oxy_pulse_tracker/utils/utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<Uint8List> makePdf(
    Member member, List<MemberLog> logs, UserSetting userSetting) async {
  final pdf = Document();
  final imageLogo = MemoryImage(
      (await rootBundle.load('assets/app-icon.png')).buffer.asUint8List());
  var logChunks = Utils.chunk(
    array: logs,
    chunkSize: 15,
  );
  for (int i = 0; i < logChunks.length; i++) {
    List<MemberLog> chunk = logChunks[i];
    var header = [];
    if (i == 0) {
      header.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                RichText(
                  text: TextSpan(
                      text: "Name: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: member.name,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                        )
                      ]),
                ),
                SizedBox(
                  height: 10,
                ),
                RichText(
                  text: TextSpan(
                      text: "Age: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: member.age.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                        )
                      ]),
                ),
                SizedBox(
                  height: 10,
                ),
                RichText(
                  text: TextSpan(
                    text: "Relation: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: member.relation,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      )
                    ],
                  ),
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
            Column(children: [
              SizedBox(
                height: 80,
                width: 80,
                child: Image(imageLogo),
              ),
              SizedBox(height: 10),
              Text(
                "Generated by Oxy Pulse Tracker App",
                style: TextStyle(
                  color: PdfColor.fromHex("#808080"),
                ),
              ),
            ])
          ],
        ),
      );
      header.add(
        Container(height: 50),
      );
    }
    pdf.addPage(
      Page(
        build: (context) {
          return Column(
            children: [
              ...header,
              Table(
                border: TableBorder.all(color: PdfColors.purple700),
                children: [
                  TableRow(
                    children: [
                      Padding(
                        child: Text(
                          'Date',
                          style: Theme.of(context).tableHeader,
                          textAlign: TextAlign.center,
                        ),
                        padding: const EdgeInsets.all(20),
                      ),
                      Padding(
                        child: Text(
                          'Time',
                          style: Theme.of(context).tableHeader,
                          textAlign: TextAlign.center,
                        ),
                        padding: const EdgeInsets.all(20),
                      ),
                      Padding(
                        child: Text(
                          'SPO2',
                          style: Theme.of(context).tableHeader,
                          textAlign: TextAlign.center,
                        ),
                        padding: const EdgeInsets.all(20),
                      ),
                      Padding(
                        child: Text(
                          'Pulse Rate',
                          style: Theme.of(context).tableHeader,
                          textAlign: TextAlign.center,
                        ),
                        padding: const EdgeInsets.all(20),
                      ),
                      Padding(
                        child: Text(
                          'Temperature',
                          style: Theme.of(context).tableHeader,
                          textAlign: TextAlign.center,
                        ),
                        padding: const EdgeInsets.all(20),
                      ),
                    ],
                  ),
                  ...chunk.map(
                    (log) => TableRow(
                      children: [
                        Expanded(
                          child: PaddedText(
                            Utils.getDisplayDate(
                              log.timestamp,
                              userSetting.dateFormat,
                            ),
                          ),
                          flex: 3,
                        ),
                        Expanded(
                          child: PaddedText(
                            Utils.getDisplayTime(
                              log.timestamp,
                            ),
                          ),
                          flex: 3,
                        ),
                        Expanded(
                          child: PaddedText(
                            log.oxygenSaturation.toString(),
                          ),
                          flex: 3,
                        ),
                        Expanded(
                          child: PaddedText(
                            log.pulse.toString(),
                          ),
                          flex: 3,
                        ),
                        Expanded(
                          child: PaddedText(
                            log.temp == null
                                ? "-"
                                : "${log.temp.toString()}${Utils.getTemperatureUnitString(log.tempUnit)}",
                          ),
                          flex: 4,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  return pdf.save();
}

// ignore: non_constant_identifier_names
Widget PaddedText(
  final String text, {
  final TextAlign align = TextAlign.left,
}) =>
    Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        text,
        textAlign: align,
      ),
    );
