import "dart:io";

// See Google Doc for up-to-date assignments: 
// https://docs.google.com/document/d/1U6GxcYGpqUpSgtXFbiOTlMihNqcg6RbCqQmewx7cXJE

/// The port used by the dashboard to send data from.
const dashboardSendPort = 8007;

/// The IP address of the Subsystems Pi.
final subsystemsPiAddress = InternetAddress("192.168.1.20");

/// The port used by the subsystems program.
const subsystemsPort = 8002;

/// The IP address of the Secondary Pi, for video and autonomy.
final secondaryPiAddress = InternetAddress("192.168.1.30");

/// The port used by the video program.
const videoPort = 8004;

/// The port used by the autonomy program.
const autonomyPort = 8006;
