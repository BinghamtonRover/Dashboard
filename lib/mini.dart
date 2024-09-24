/// The entrypoint of the app.
///
/// These `library` declarations are not needed, the default name for a Dart library is simply the
/// name of the file. However, DartDoc comments placed above a library declaration will show up on
/// the libraries page in the generated documentation.
///
/// This library's main purpose is to execute the app defined in the app library and is designed to
/// be as simple as possible.
library main;

import "dart:async";
import "dart:io";
import "package:flutter/material.dart";

import "package:rover_dashboard/app.dart";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";
import "package:rover_dashboard/src/pages/logs.dart";
import "package:rover_dashboard/src/pages/mini_home.dart";
import "package:device_preview/device_preview.dart";
import "package:rover_dashboard/src/pages/mini_metrics.dart";
import "package:rover_dashboard/widgets.dart";

class MiniHomePage extends StatefulWidget {
  const MiniHomePage({super.key});

  @override
  State<MiniHomePage> createState() => _MiniHomePageState();
}

class _MiniHomePageState extends State<MiniHomePage> {
  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    await services.init();
    await models.init();
    await models.sockets.setRover(RoverType.localhost);
    await models.sockets.disable();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Dashboard v${models.home.version ?? ''}"),
          actions: const [
            PowerButton(),
          ],
        ),
        body: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              const TabBar(
                tabs: [
                  Tab(text: "Home"),
                  Tab(text: "Metrics & Controls"),
                  Tab(text: "Logs"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    const MiniHome(),
                    MiniMetrics(models.rover.metrics),
                    LogsPage(),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: MiniFooter(),
      );
}

class PowerButton extends StatelessWidget {
  const PowerButton({super.key});

  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.zero,
        child: IconButton(
          icon: const Icon(
            Icons.power_settings_new,
            color: Colors.red,
          ),
          onPressed: () async {
            await showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (_) => AlertDialog(
                title: const Text("Are you sure?"),
                content: const Text("This will turn off the rover and you must physically turn it back on again"),
                actions: [
                  TextButton(child: const Text("Cancel"), onPressed: () => Navigator.of(context).pop()),
                  ElevatedButton(
                    onPressed: () {
                      models.rover.settings.setStatus(RoverStatus.POWER_OFF);
                      Navigator.of(context).pop();
                    },
                    child: const Text("Continue"),
                  ),
                ],
              ),
            );
          },
        ),
      );
}

class MiniFooter extends StatelessWidget {
  const MiniFooter({super.key});

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: context.colorScheme.secondary,
        child: MessageDisplay(showLogs: false),
      );
}

class MiniDashboard extends StatelessWidget {
  const MiniDashboard({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: "Binghamton University Rover Team",
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: ThemeData(
          colorScheme: const ColorScheme.light(
            primary: binghamtonGreen,
            secondary: binghamtonGreen,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: binghamtonGreen,
            foregroundColor: Colors.white,
          ),
        ),
        darkTheme: ThemeData.from(
          colorScheme: const ColorScheme.dark(
            primary: binghamtonGreen,
            secondary: binghamtonGreen,
          ),
        ),
        home: const MiniHomePage(),
      );
}

/// Network errors that can be fixed by a simple reset.
const networkErrors = {1234, 1231};

void main() async {
  runZonedGuarded(
      () => runApp(
            DevicePreview(
              enabled: false,
              builder: (context) => const MiniDashboard(),
            ),
          ), (error, stack) async {
    if (error is SocketException && networkErrors.contains(error.osError!.errorCode)) {
      models.home.setMessage(severity: Severity.critical, text: "Network error, restart by clicking the network icon");
    } else {
      models.home.setMessage(severity: Severity.critical, text: "Dashboard error. See the logs");
      await services.files.logError(error, stack);
      Error.throwWithStackTrace(error, stack);
    }
  });
}
