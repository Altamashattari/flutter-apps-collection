import 'package:flutter/material.dart';
import 'package:oxy_pulse_tracker/entities.dart';
import 'package:oxy_pulse_tracker/models/user_settings_model.dart';
import 'package:oxy_pulse_tracker/objectbox.g.dart';
import 'package:oxy_pulse_tracker/screens/pdfexport/pdf_export.dart';
import 'package:oxy_pulse_tracker/utils/user_settings.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class PdfPreviewPage extends StatelessWidget {
  final Member member;
  final Store store;

  const PdfPreviewPage({Key? key, required this.member, required this.store})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserSetting userSetting =
        Provider.of<UserSettingModel>(context).userSettings;
    final queryBuilder =
        store.box<MemberLog>().query(MemberLog_.member.equals(member.id));
    queryBuilder.order(
      MemberLog_.timestamp,
      flags: Order.descending,
    );
    var stream = queryBuilder
        .watch(triggerImmediately: true)
        .map((query) => query.find());
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Preview'),
      ),
      body: StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return PdfPreview(
            build: (context) => makePdf(member, snapshot.data!, userSetting),
          );
        },
      ),
    );
  }
}
