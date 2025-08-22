// ignore_for_file: avoid_print

import "dart:io";

Future<bool> hasFlutterPiTool() async {
  const command = "dart";
  const args = ["pub", "global", "list"];
  final result = await Process.run(command, args);
  return result.stdout.contains("flutterpi_tool");
}

Future<void> installFlutterPiTool() async {
  const command = "dart";
  const args = ["pub", "global", "activate", "flutterpi_tool"];
  final process = await Process.start(command, args);
  process.stdout.listen((output) {
    final line = String.fromCharCodes(output).trim();
    if (line.isNotEmpty) {
      print("- $line");
    }
  });
  if (await process.exitCode != 0) {
    print("\nError: Could not install flutterpi_tool from Pub");
    await process.stderr.forEach((e) => print(String.fromCharCodes(e).trim()));
    exit(1); // could not install flutterpi_tool
  }
}

Future<void> buildMiniDashboard() async {
  const command = "flutterpi_tool";
  const args = [
    "build",
    "-t",
    "lib/mini.dart",
    "--release",
    "--arch=arm64",
    "--dart-define=rover.mini_dashboard=true",
  ];
  final process = await Process.start(command, args, runInShell: true);
  process.stdout.listen((output) {
    final line = String.fromCharCodes(output).trim();
    if (line.isNotEmpty) {
      print("- $line");
    }
  });
  if (await process.exitCode != 0) {
    print("\nError: Could not build mini dashboard");
    await process.stderr.forEach((e) => print(String.fromCharCodes(e).trim()));
    exit(2); // could not build
  }
}

void main() async {
  if (!await hasFlutterPiTool()) {
    print("Installing flutterpi_tool");
    await installFlutterPiTool();
  }

  print("Building Mini Dashboard for Raspberry Pi");
  await buildMiniDashboard();
}
