import "dart:async";

import "package:flutter/material.dart";
import "package:rover_dashboard/mini.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";

/// Logs tab for the mini dashboard
///
/// Displays the same content of the normal logs page but without the extra header and footer
class MiniLogs extends StatefulWidget {
  /// MiniViewModel used to control the widget on the footer of the mini dashboard
  final MiniViewModel miniViewModel;

  /// Constructor for mini logs
  const MiniLogs({required this.miniViewModel, super.key});

  @override
  State<MiniLogs> createState() => _MiniLogsState();
}

class _MiniLogsState extends State<MiniLogs> {
  /// [LogsViewModel] used to view the different elements of the logs page
  final LogsViewModel logsViewModel = LogsViewModel();

  @override
  void initState() {
    // The footer has to be set in Timer.run since otherwise it will try to rebuild during build
    Timer.run(
      () => widget.miniViewModel.footerWidget = (context) => Row(
            children: getLogsActions(context, logsViewModel),
          ),
    );
    super.initState();
  }

  @override
  void dispose() {
    Timer.run(() => widget.miniViewModel.footerWidget = null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          const SizedBox(height: 12),
          LogsOptions(logsViewModel.options),
          const Divider(),
          Expanded(child: LogsBody(logsViewModel)),
        ],
      );
}
