import "dart:io";

// See Google Doc for up-to-date assignments: 
// https://docs.google.com/document/d/1U6GxcYGpqUpSgtXFbiOTlMihNqcg6RbCqQmewx7cXJE
const dashboardSendPort = 8007;

final subsystemsPiAddress = InternetAddress("192.168.1.20");
const subsystemsPort = 8002;

final secondaryPiAddress = InternetAddress("192.168.1.30");
const videoPort = 8004;
const autonomyPort = 8006;
