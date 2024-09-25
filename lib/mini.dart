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
import "package:rover_dashboard/src/pages/mini_home.dart";
import "package:rover_dashboard/src/pages/mini_logs.dart";
import "package:rover_dashboard/src/pages/mini_metrics.dart";
import "package:rover_dashboard/widgets.dart";

class MiniViewModel with ChangeNotifier {
  bool _darkMode = false;
  Widget Function(BuildContext context)? _footerWidget;

  /// Constructor for [MiniViewModel], calls [init] to setup mini dashboard
  MiniViewModel() {
    init();
  }

  set darkMode(bool darkMode) {
    _darkMode = darkMode;
    notifyListeners();
  }

  /// Whether or not dark mode is enabled
  bool get darkMode => _darkMode;

  set footerWidget(Widget Function(BuildContext context)? footerWidget) {
    _footerWidget = footerWidget;
    notifyListeners();
  }

  /// The builder for the footer widget
  Widget Function(BuildContext context)? get footerWidget => _footerWidget;

  /// Initializes necessary systems and models for the Mini Dashboard
  ///
  /// Sets the rover type to localhost and disables the sockets until
  /// it is manually turned on by the user
  Future<void> init() async {
    await services.init();
    await models.init();
    await models.sockets.setRover(RoverType.localhost);
    await models.sockets.disable();

    notifyListeners();
  }
}

class MiniHomePage extends StatelessWidget {
  final MiniViewModel model;

  /// A const constructor
  const MiniHomePage({required this.model});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Dashboard v${models.home.version ?? ''}"),
          actions: [
            Row(
              children: [
                const Text(
                  "Dark Mode",
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(width: 5),
                Switch(value: model.darkMode, onChanged: (value) => model.darkMode = value),
              ],
            ),
            const SizedBox(width: 10),
            const PowerButton(),
            const SizedBox(width: 5),
          ],
        ),
        body: DefaultTabController(
          length: 4,
          child: Column(
            children: [
              const TabBar(
                tabs: [
                  Tab(text: "Home"),
                  Tab(text: "Metrics & Controls"),
                  Tab(text: "Logs"),
                  Tab(text: "View"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    const MiniHome(),
                    MiniMetrics(models.rover.metrics),
                    MiniLogs(miniViewModel: model),
                    ViewsWidget(),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: MiniFooter(model),
      );
}

/// Button to set the rover status to [RoverStatus.POWER_OFF], shutting off the rover
///
/// Displays a confirmation dialog before shutting down
class PowerButton extends StatelessWidget {
  /// Constructor for power button
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

class MiniFooter extends ReusableReactiveWidget<MiniViewModel> {
  const MiniFooter(super.model) : super();

  @override
  Widget build(BuildContext context, MiniViewModel model) => ColoredBox(
        color: context.colorScheme.secondary,
        child: Row(
          children: [
            MessageDisplay(showLogs: false),
            const Spacer(),
            if (model.footerWidget != null) model.footerWidget!.call(context),
          ],
        ),
      );
}

class MiniDashboard extends ReactiveWidget<MiniViewModel> {
  const MiniDashboard();

  @override
  MiniViewModel createModel() => MiniViewModel();

  @override
  Widget build(BuildContext context, MiniViewModel model) => MaterialApp(
        title: "Binghamton University Rover Team",
        debugShowCheckedModeBanner: false,
        themeMode: model.darkMode ? ThemeMode.dark : ThemeMode.light,
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
        home: MiniHomePage(model: model),
      );
}

/// Network errors that can be fixed by a simple reset.
const networkErrors = {1234, 1231};

void main() async {
  runZonedGuarded(() => runApp(const MiniDashboard()), (error, stack) async {
    if (error is SocketException && networkErrors.contains(error.osError!.errorCode)) {
      models.home.setMessage(severity: Severity.critical, text: "Network error, restart by clicking the network icon");
    } else {
      models.home.setMessage(severity: Severity.critical, text: "Dashboard error. See the logs");
      await services.files.logError(error, stack);
      Error.throwWithStackTrace(error, stack);
    }
  });
}
