import "dart:async";
import "dart:io";
import "package:flutter/material.dart";

import "package:rover_dashboard/app.dart";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/services.dart";
import "package:rover_dashboard/src/pages/mini_home.dart";
import "package:rover_dashboard/src/pages/mini_logs.dart";
import "package:rover_dashboard/src/pages/mini_metrics.dart";
import "package:rover_dashboard/src/pages/mini_screensaver.dart";
import "package:rover_dashboard/widgets.dart";

/// View model for the Mini dashboard home page
///
/// Stores the function to define the extra widget displayed on the
/// footer, and initializes all necessary data, services, and other
/// view models
class MiniViewModel with ChangeNotifier {
  Widget Function(BuildContext context)? _footerWidget;

  /// Constructor for [MiniViewModel], calls [init] to setup mini dashboard
  MiniViewModel() {
    init();
  }

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
    await models.sockets.setRover(RoverType.rover);
    models.sockets.disable();

    models.settings.addListener(notifyListeners);

    notifyListeners();
  }

  @override
  void dispose() {
    models.settings.removeListener(notifyListeners);
    super.dispose();
  }
}

/// The main app page for the Mini dashboard
///
/// Displays a header with the dashboard version, a tab bar view
/// to select between the home page, metrics/controls, logs, and
/// a page to display a view
class MiniHomePage extends StatelessWidget {
  /// The Mini Dashboard view model
  final MiniViewModel model;

  /// A const constructor for the mini home page
  const MiniHomePage({required this.model});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      automaticallyImplyLeading: false,
      title: Text("Dashboard v${models.home.version ?? ''}"),
      actions: [
        IconButton(
          onPressed: () => Navigator.of(context).pushNamed(Routes.settings),
          icon: const Icon(Icons.settings),
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
                MiniHome(miniViewModel: model),
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
      icon: const Icon(Icons.power_settings_new, color: Colors.red),
      onPressed: () async {
        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder:
              (_) => AlertDialog(
                title: const Text("Are you sure?"),
                content: const Text(
                  "This will turn off the rover and you must physically turn it back on again",
                ),
                actions: [
                  TextButton(
                    child: const Text("Cancel"),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
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

/// The footer for the mini dashboard
///
/// Displays any necessary messages in the left of the footer, and
/// a custom defined widget on the right side. The custom widget space
/// is used by pages such as the Logs page to display extra information
/// in a small amount of space
class MiniFooter extends ReusableReactiveWidget<MiniViewModel> {
  /// Const constructor for the mini dashboard footer
  const MiniFooter(super.model) : super();

  @override
  Widget build(BuildContext context, MiniViewModel model) => ColoredBox(
    color: binghamtonGreen,
    child: Row(
      children: [
        MessageDisplay(showLogs: false),
        const Spacer(),
        if (model.footerWidget != null) model.footerWidget!.call(context),
      ],
    ),
  );
}

/// The main widget for the mini dashboard
///
/// Initializes the Material App, necessary themes, and defines the
/// routes to the home and settings page
class MiniDashboard extends ReactiveWidget<MiniViewModel> {
  /// Const constructor for the mini dashboard
  const MiniDashboard();

  @override
  MiniViewModel createModel() => MiniViewModel();

  @override
  Widget build(BuildContext context, MiniViewModel model) => MaterialApp(
    initialRoute: Routes.screenSaver,
    title: "Binghamton University Rover Team",
    debugShowCheckedModeBanner: false,
    themeMode:
        models.isReady ? models.settings.dashboard.themeMode : ThemeMode.system,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: binghamtonGreen),
      appBarTheme: const AppBarTheme(
        backgroundColor: binghamtonGreen,
        foregroundColor: Colors.white,
      ),
    ),
    darkTheme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: binghamtonGreen,
        surface: const Color.fromRGBO(25, 25, 25, 1),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: binghamtonGreen,
        foregroundColor: Colors.white,
      ),
    ),
    home: MiniHomePage(model: model),
    routes: {
      Routes.home: (_) => MiniHomePage(model: model),
      Routes.screenSaver: (_) => const MiniScreenSaver(),
      Routes.settings: (_) => SettingsPage(),
    },
  );
}

/// Network errors that can be fixed by a simple reset.
const networkErrors = {1234, 1231};

void main() async {
  runZonedGuarded(() => runApp(const MiniDashboard()), (error, stack) async {
    if (error is SocketException &&
        networkErrors.contains(error.osError!.errorCode)) {
      models.home.setMessage(
        severity: Severity.critical,
        text: "Network error, restart by toggling dashboard enabled switch",
      );
    } else {
      models.home.setMessage(
        severity: Severity.critical,
        text: "Dashboard error. See the logs",
        logMessage: false,
      );
      models.logs.handleLog(
        BurtLog(
          level: BurtLogLevel.critical,
          title: "Dashboard Error",
          body: "$error\n$stack",
          device: Device.DASHBOARD,
        ),
        display: false,
      );
      Error.throwWithStackTrace(error, stack);
    }
  });
}
