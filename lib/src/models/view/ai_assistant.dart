import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:burt_network/protobuf.dart';
import 'package:rover_dashboard/data.dart';
import 'package:rover_dashboard/models.dart';
import 'package:rover_dashboard/pages.dart';
import 'package:rover_dashboard/src/services/ai/ollama.dart';

/// The AI assistant model.
///
/// This model manages the AI assistant conversation and provides bindings
/// for all rover operations that the LLM can perform.
class AiAssistantModel with ChangeNotifier {
  /// The Ollama service for communicating with the AI.
  late final OllamaService _ollama;

  /// The current conversation messages.
  final List<AiMessage> _messages = [];

  /// All messages in the conversation (including system messages).
  List<AiMessage> get messages => List.unmodifiable(_messages);

  /// Whether the AI is currently generating a response.
  bool _isGenerating = false;

  /// Whether the AI is currently generating a response.
  bool get isGenerating => _isGenerating;

  /// Whether unrestricted task completion is enabled.
  bool _unrestrictedMode = false;

  /// Whether unrestricted task completion is enabled.
  bool get unrestrictedMode => _unrestrictedMode;

  /// Whether Ollama is available.
  bool _ollamaAvailable = false;

  /// Whether the availability check has finished.
  bool _isCheckingAvailability = true;

  /// Whether Ollama is available.
  bool get ollamaAvailable => _ollamaAvailable;

  /// Whether the availability check is still running.
  bool get isCheckingAvailability => _isCheckingAvailability;

  /// The current model name.
  String _modelName = OllamaService.defaultModel;

  /// The current model name.
  String get modelName => _modelName;

  /// Pending user confirmations for actions.
  final List<PendingAction> _pendingActions = [];

  /// Pending user confirmations for actions.
  List<PendingAction> get pendingActions => List.unmodifiable(_pendingActions);

  /// Controls for all rover operations.
  final Map<String, int> _bindings = {};

  /// What the last executed binding actually did, when it changed the UI.
  String? _lastActionResult;

  /// The chat controller for the input field.
  final TextEditingController chatController = TextEditingController();

  /// The scroll controller for the message list.
  final ScrollController scrollController = ScrollController();

  /// Timer for polling Ollama availability.
  Timer? _availabilityTimer;

  /// Whether the page has been removed and the model disposed.
  bool _isDisposed = false;

  /// Notifies listeners unless the page is already gone.
  void _notify() {
    if (!_isDisposed) notifyListeners();
  }

  /// The system prompt that explains the dashboard and the operator's rules.
  static const String _systemPrompt =
      'You are the AI assistant built into the Binghamton University Rover Team '
      'dashboard. You can operate the rover and change what the dashboard shows '
      'by calling the tools provided to you. Use view_show_page to put a page or '
      'camera feed in a dashboard pane, view_set_layout to change how many panes '
      'are shown, and view_clear_pane to empty a pane. Actions that move hardware '
      'are confirmed by the operator before they run. Be concise, explain what you '
      'are about to do, and never invent telemetry you cannot read. Do not claim '
      'that an action happened yourself; the dashboard reports what actually ran.';

  /// Matches tool schemas that a model occasionally echoes as chat text.
  static final RegExp _toolSchemaPattern = RegExp(r'"(type|parameters)"\s*:');

  /// The first message shown when the assistant opens.
  static const String _greeting =
      'Hi! I can change what the dashboard shows and operate the rover. Try '
      '"show the arm page" or "split the dashboard into four panes".';

  /// Creates the AI assistant model.
  ///
  /// Pass an [OllamaService] to replace the local Ollama connection, such as in
  /// tests.
  AiAssistantModel({OllamaService? ollama}) {
    _ollama = ollama ?? OllamaService();
    _initializeBindings();
  }

  /// Initializes the bindings for all rover operations.
  /// Each binding maps to a unique ID that the AI can use to perform operations.
  void _initializeBindings() {
    // ============================================================
    // ARM OPERATIONS (CubeMars Arm - AKH70-48 and AK45-36 motors)
    // ============================================================
    
    // Emergency and safety
    _bindings['arm_emergency_stop'] = 1000;          // Stop all arm motors immediately
    _bindings['arm_calibrate'] = 1001;               // Calibrate all arm motors
    
    // Individual joint control (angle commands in radians)
    _bindings['arm_swivel_set_angle'] = 1002;        // Swivel base rotation (AKH70-48, 48:1 gear ratio, 21 pole pairs)
    _bindings['arm_swivel_jog'] = 1003;              // Jog swivel continuously
    _bindings['arm_shoulder_set_angle'] = 1004;      // Shoulder bar angle (AKH70-48, 48:1 gear ratio, 21 pole pairs)
    _bindings['arm_shoulder_jog'] = 1005;            // Jog shoulder continuously
    _bindings['arm_elbow_set_angle'] = 1006;         // Elbow lever angle (AKH70-48, 48:1 gear ratio, 21 pole pairs)
    _bindings['arm_elbow_jog'] = 1007;               // Jog elbow continuously
    _bindings['arm_forearm_roll_set_angle'] = 1008;  // Forearm roll (AK45-36, 36:1 gear ratio, 14 pole pairs)
    _bindings['arm_forearm_roll_jog'] = 1009;        // Jog forearm roll continuously
    _bindings['arm_wrist_pitch_set_angle'] = 1010;   // Wrist pitch (AK45-36, 36:1 gear ratio, 14 pole pairs)
    _bindings['arm_wrist_pitch_jog'] = 1011;         // Jog wrist pitch continuously
    _bindings['arm_wrist_roll_set_angle'] = 1012;    // Wrist roll (AK45-36, 36:1 gear ratio, 14 pole pairs)
    _bindings['arm_wrist_roll_jog'] = 1013;          // Jog wrist roll continuously
    _bindings['arm_gripper_set_position'] = 1014;    // Gripper pinch position (AK40-10, 10:1 gear ratio, 14 pole pairs)
    _bindings['arm_gripper_jog'] = 1015;             // Jog gripper continuously
    
    // Arm laser
    _bindings['arm_laser_turn_on'] = 1016;           // Turn arm laser on
    _bindings['arm_laser_turn_off'] = 1017;          // Turn arm laser off
    _bindings['arm_laser_toggle'] = 1018;            // Toggle arm laser
    
    // Inverse kinematics
    _bindings['arm_ik_move_to'] = 1019;              // Move end effector to target position using IK
    _bindings['arm_ik_stop'] = 1020;                 // Stop IK movement
    
    // Arm camera
    _bindings['arm_camera_set_tilt'] = 1021;         // Set arm camera tilt angle (0-180 degrees)
    
    // ============================================================
    // DRIVE OPERATIONS (Rover drive system)
    // ============================================================
    
    // Emergency and safety
    _bindings['drive_emergency_stop'] = 2000;        // Stop all drive motors immediately
    
    // Tank drive mode
    _bindings['drive_tank_set_left'] = 2001;         // Set left wheel speed (-1 to 1)
    _bindings['drive_tank_set_right'] = 2002;        // Set right wheel speed (-1 to 1)
    _bindings['drive_tank_jog_left'] = 2003;         // Jog left wheels
    _bindings['drive_tank_jog_right'] = 2004;        // Jog right wheels
    
    // Modern drive mode
    _bindings['drive_modern_forward'] = 2005;        // Drive forward (trigger-based)
    _bindings['drive_modern_reverse'] = 2006;        // Drive in reverse (trigger-based)
    _bindings['drive_modern_steer'] = 2007;          // Steer left/right (joystick-based)
    _bindings['drive_modern_stop'] = 2008;           // Stop modern drive movement
    
    // Throttle control
    _bindings['drive_throttle_increase'] = 2009;     // Increase throttle by 0.1
    _bindings['drive_throttle_decrease'] = 2010;     // Decrease throttle by 0.1
    _bindings['drive_throttle_set'] = 2011;          // Set throttle to specific value (0-1)
    
    // Camera control (via drive)
    _bindings['drive_camera_front_tilt'] = 2012;     // Tilt front camera
    _bindings['drive_camera_front_swivel'] = 2013;   // Swivel front camera
    _bindings['drive_camera_rear_tilt'] = 2014;       // Tilt rear camera
    _bindings['drive_camera_rear_swivel'] = 2015;     // Swivel rear camera
    
    // Drive lights/blinkies
    _bindings['drive_set_color'] = 2016;             // Set drive LED color
    _bindings['drive_blink_on'] = 2017;              // Turn on blinkies
    _bindings['drive_blink_off'] = 2018;             // Turn off blinkies
    
    // ============================================================
    // CAMERA OPERATIONS (Servo-controlled cameras)
    // ============================================================
    
    // Front camera
    _bindings['camera_front_tilt_up'] = 3000;        // Tilt front camera up
    _bindings['camera_front_tilt_down'] = 3001;      // Tilt front camera down
    _bindings['camera_front_pan_left'] = 3002;       // Pan front camera left
    _bindings['camera_front_pan_right'] = 3003;      // Pan front camera right
    _bindings['camera_front_set_tilt'] = 3004;       // Set front camera tilt angle (0-60 degrees)
    _bindings['camera_front_set_swivel'] = 3005;     // Set front camera swivel angle (0-180 degrees)
    
    // Rear camera
    _bindings['camera_rear_tilt_up'] = 3006;         // Tilt rear camera up
    _bindings['camera_rear_tilt_down'] = 3007;       // Tilt rear camera down
    _bindings['camera_rear_pan_left'] = 3008;        // Pan rear camera left
    _bindings['camera_rear_pan_right'] = 3009;       // Pan rear camera right
    _bindings['camera_rear_set_tilt'] = 3010;        // Set rear camera tilt angle (0-180 degrees)
    _bindings['camera_rear_set_swivel'] = 3011;      // Set rear camera swivel angle (0-180 degrees)
    
    // ============================================================
    // SCIENCE SUBSYSTEM OPERATIONS
    // ============================================================
    
    // Emergency and safety
    _bindings['science_emergency_stop'] = 4000;      // Stop all science operations immediately
    _bindings['science_calibrate'] = 4001;           // Calibrate science subsystems
    
    // Carousel control
    _bindings['science_carousel_next_tube'] = 4002;  // Move to next dirt tube
    _bindings['science_carousel_prev_tube'] = 4003;  // Move to previous dirt tube
    _bindings['science_carousel_jog'] = 4004;        // Jog carousel motor continuously
    _bindings['science_carousel_set_position'] = 4005; // Set carousel to specific position
    
    // Auger control
    _bindings['science_auger_start'] = 4006;         // Start auger motor
    _bindings['science_auger_stop'] = 4007;          // Stop auger motor
    _bindings['science_auger_set_speed'] = 4008;     // Set auger speed (RPM)
    _bindings['science_auger_set_servos'] = 4009;    // Open/close auger servos
    
    // Pump control
    _bindings['science_pumps_on'] = 4010;            // Turn pumps on
    _bindings['science_pumps_off'] = 4011;           // Turn pumps off
    
    // Linear slider control
    _bindings['science_slider_jog'] = 4012;          // Jog linear slider
    _bindings['science_slider_set_position'] = 4013; // Set linear slider position
    
    // Data collection
    _bindings['science_start_collection'] = 4014;    // Start collecting science data
    _bindings['science_stop_collection'] = 4015;     // Stop collecting science data
    
    // ============================================================
    // RELAY OPERATIONS (Power control)
    // ============================================================
    
    _bindings['relay_set_mechanical_override'] = 5000;   // Set mechanical override state
    _bindings['relay_front_left_on'] = 5001;              // Turn on front left motor power
    _bindings['relay_front_left_off'] = 5002;            // Turn off front left motor power
    _bindings['relay_front_right_on'] = 5003;            // Turn on front right motor power
    _bindings['relay_front_right_off'] = 5004;           // Turn off front right motor power
    _bindings['relay_middle_left_on'] = 5005;            // Turn on middle left motor power
    _bindings['relay_middle_left_off'] = 5006;           // Turn off middle left motor power
    _bindings['relay_middle_right_on'] = 5007;           // Turn on middle right motor power
    _bindings['relay_middle_right_off'] = 5008;          // Turn off middle right motor power
    _bindings['relay_back_left_on'] = 5009;              // Turn on back left motor power
    _bindings['relay_back_left_off'] = 5010;             // Turn off back left motor power
    _bindings['relay_back_right_on'] = 5011;             // Turn on back right motor power
    _bindings['relay_back_right_off'] = 5012;            // Turn off back right motor power
    _bindings['relay_arm_on'] = 5013;                     // Turn on arm power
    _bindings['relay_arm_off'] = 5014;                    // Turn off arm power
    _bindings['relay_science_on'] = 5015;                 // Turn on science power
    _bindings['relay_science_off'] = 5016;                // Turn off science power
    
    // ============================================================
    // ANTENNA / BASE STATION OPERATIONS
    // ============================================================
    
    // Control mode
    _bindings['antenna_set_track_rover'] = 6000;          // Set antenna to track rover mode
    _bindings['antenna_set_manual'] = 6001;               // Set antenna to manual control mode
    
    // Manual control
    _bindings['antenna_manual_swivel_jog'] = 6002;        // Jog antenna swivel manually
    _bindings['antenna_manual_pitch_jog'] = 6003;         // Jog antenna pitch manually
    _bindings['antenna_manual_swivel_set_angle'] = 6004;  // Set antenna swivel angle
    _bindings['antenna_manual_pitch_set_angle'] = 6005;   // Set antenna pitch angle
    
    // ============================================================
    // SUBSYSTEMS OPERATIONS
    // ============================================================
    
    _bindings['subsystems_get_status'] = 7000;            // Get subsystems status
    _bindings['subsystems_check_sensors'] = 7001;         // Check GPS and IMU connection
    
    // ============================================================
    // VISION OPERATIONS
    // ============================================================
    
    _bindings['vision_get_aruco_tags'] = 8000;            // Get detected ArUco tags
    _bindings['vision_get_object_detections'] = 8001;     // Get object detections
    _bindings['vision_focus_on_tag'] = 8002;              // Focus cameras on detected ArUco tag
    
    // ============================================================
    // POSITION / GPS OPERATIONS
    // ============================================================
    
    _bindings['position_get_gps'] = 9000;                 // Get current GPS coordinates
    _bindings['position_get_orientation'] = 9001;         // Get current orientation (pitch, roll, yaw)
    _bindings['position_get_distance_to_base'] = 9002;    // Get distance to base station
    
    // ============================================================
    // VITALS OPERATIONS
    // ============================================================
    
    _bindings['vitals_get_battery_voltage'] = 10000;      // Get battery voltage
    _bindings['vitals_get_battery_current'] = 10001;      // Get battery current
    _bindings['vitals_get_battery_temperature'] = 10002;  // Get battery temperature
    _bindings['vitals_get_battery_percentage'] = 10003;   // Get battery charge percentage
    
    // ============================================================
    // SYSTEM OPERATIONS
    // ============================================================
    
    _bindings['system_get_rover_status'] = 11000;         // Get overall rover status
    _bindings['system_get_all_telemetry'] = 11001;        // Get all telemetry data
    _bindings['system_enter_safemode'] = 11002;           // Enter safe mode (stop all operations)
    _bindings['system_exit_safemode'] = 11003;            // Exit safe mode
    _bindings['system_home_all'] = 11004;                 // Home all subsystems
    _bindings['system_reset'] = 11005;                    // Reset rover systems

    // ============================================================
    // DASHBOARD VIEW OPERATIONS
    // ============================================================

    _bindings['view_show_page'] = 12000;                  // Show a page or camera in a pane
    _bindings['view_set_layout'] = 12001;                 // Change the number of panes
    _bindings['view_clear_pane'] = 12002;                 // Replace a pane with the blank view
    _bindings['view_add_page'] = 12003;                   // Open a page in a new or blank pane
  }

  /// Gets the bindings for the AI.
  Map<String, int> get bindings => Map.from(_bindings);

  /// Initializes the model.
  Future<void> init() async {
    if (_messages.isEmpty) {
      _messages.add(AiMessage.assistant(_greeting));
    }
    _availabilityTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _checkOllamaAvailability(),
    );
    await _checkOllamaAvailability();
  }

  /// Checks if Ollama is available.
  Future<void> _checkOllamaAvailability() async {
    _ollamaAvailable = await _ollama.isAvailable();
    _isCheckingAvailability = false;
    _notify();
  }

  /// Disposes the model.
  @override
  void dispose() {
    _isDisposed = true;
    _availabilityTimer?.cancel();
    _ollama.dispose();
    chatController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  /// Toggles unrestricted mode.
  void toggleUnrestrictedMode() {
    _unrestrictedMode = !_unrestrictedMode;
    _notify();
  }

  /// Sets unrestricted mode.
  void setUnrestrictedMode(bool value) {
    _unrestrictedMode = value;
    _notify();
  }

  /// Sends a message to the AI and gets a response.
  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty || _isGenerating) return;

    // Add user message
    final userMessage = AiMessage.user(content);
    _messages.add(userMessage);
    _notify();
    chatController.clear();

    // Scroll to bottom
    await _scrollToBottom();

    // Generate response
    _isGenerating = true;
    _notify();

    try {
      final response = await _ollama.chat(
        messages: [AiMessage.system(_systemPrompt), ..._messages],
        tools: _availableTools,
        temperature: _unrestrictedMode ? 0.3 : 0.7,
      );

      final reply = response.message;
      final toolCalls = reply.toolCalls.isEmpty
          ? _parseToolCallsFromContent(reply.content)
          : reply.toolCalls;
      if (toolCalls.isEmpty) {
        // Small models sometimes answer a clear view command with prose. Run
        // the command locally so an explicit request still takes effect.
        final intents = _parseViewIntent(content);
        if (intents.isNotEmpty) {
          final results = await _processToolCalls(intents);
          _messages.add(AiMessage.assistant(
            results.map((result) => '• $result').join('\n'),
            toolCalls: intents,
          ));
        } else {
          // Small models sometimes repeat the tool definitions instead of
          // answering. Show a helpful prompt rather than a wall of schema.
          _messages.add(
            _toolSchemaPattern.hasMatch(reply.content)
                ? AiMessage.assistant(
                    'I could not turn that into a dashboard action. Try naming '
                    'the page, for example "show the Arm page".',
                  )
                : reply,
          );
        }
      } else {
        // Only report what actually ran. Small models often claim success in
        // their prose even when a call was invalid, and some echo the tool
        // schemas back, so the model's text is replaced by real results.
        final results = await _processToolCalls(toolCalls);
        _messages.add(AiMessage.assistant(
          results.isEmpty
              ? 'I could not run that operation.'
              : results.map((result) => '• $result').join('\n'),
          toolCalls: toolCalls,
        ));
      }
    } on AiServiceException {
      _messages.add(AiMessage.assistant(
          'Error: I could not connect to the AI service. '
              'Please make sure Ollama is running and the model "$modelName" is available. '
              'You can install it with: ollama pull $modelName'));
    } catch (e) {
      _messages.add(AiMessage.assistant(
          'Error: An unexpected error occurred: $e'));
    }

    _isGenerating = false;
    _notify();
    await _scrollToBottom();
  }

  /// The tools advertised to the model for operating the rover.
  ///
  /// Only the operations worth exposing to a small local model are listed
  /// here. Each one has an executor in [_performAction].
  static const Map<String, AiTool> _roverTools = {
    'arm_emergency_stop': AiTool(
      name: 'arm_emergency_stop',
      description: 'Immediately stop every arm motor.',
      parameters: {'type': 'object', 'properties': <String, dynamic>{}},
    ),
    'arm_calibrate': AiTool(
      name: 'arm_calibrate',
      description: 'Calibrate all of the arm joints.',
      parameters: {'type': 'object', 'properties': <String, dynamic>{}},
    ),
    'arm_swivel_set_angle': AiTool(
      name: 'arm_swivel_set_angle',
      description: 'Rotate the arm swivel base to an absolute angle.',
      parameters: {
        'type': 'object',
        'properties': {
          'angle': {
            'type': 'number',
            'description': 'Target angle in radians.',
          },
        },
        'required': ['angle'],
      },
    ),
    'arm_shoulder_set_angle': AiTool(
      name: 'arm_shoulder_set_angle',
      description: 'Move the arm shoulder to an absolute angle.',
      parameters: {
        'type': 'object',
        'properties': {
          'angle': {
            'type': 'number',
            'description': 'Target angle in radians.',
          },
        },
        'required': ['angle'],
      },
    ),
    'arm_elbow_set_angle': AiTool(
      name: 'arm_elbow_set_angle',
      description: 'Move the arm elbow to an absolute angle.',
      parameters: {
        'type': 'object',
        'properties': {
          'angle': {
            'type': 'number',
            'description': 'Target angle in radians.',
          },
        },
        'required': ['angle'],
      },
    ),
    'arm_forearm_roll_set_angle': AiTool(
      name: 'arm_forearm_roll_set_angle',
      description: 'Rotate the forearm to an absolute angle.',
      parameters: {
        'type': 'object',
        'properties': {
          'angle': {
            'type': 'number',
            'description': 'Target angle in radians.',
          },
        },
        'required': ['angle'],
      },
    ),
    'arm_wrist_pitch_set_angle': AiTool(
      name: 'arm_wrist_pitch_set_angle',
      description: 'Tilt the wrist to an absolute angle.',
      parameters: {
        'type': 'object',
        'properties': {
          'angle': {
            'type': 'number',
            'description': 'Target angle in radians.',
          },
        },
        'required': ['angle'],
      },
    ),
    'arm_wrist_roll_set_angle': AiTool(
      name: 'arm_wrist_roll_set_angle',
      description: 'Rotate the wrist to an absolute angle.',
      parameters: {
        'type': 'object',
        'properties': {
          'angle': {
            'type': 'number',
            'description': 'Target angle in radians.',
          },
        },
        'required': ['angle'],
      },
    ),
    'arm_gripper_set_position': AiTool(
      name: 'arm_gripper_set_position',
      description: 'Set how far the gripper is open.',
      parameters: {
        'type': 'object',
        'properties': {
          'position': {
            'type': 'number',
            'description': '0 is fully closed, 1 is fully open.',
          },
        },
        'required': ['position'],
      },
    ),
    'arm_ik_move_to': AiTool(
      name: 'arm_ik_move_to',
      description:
          'Move the end effector to a point using inverse kinematics. The '
          'point is in meters relative to the arm base.',
      parameters: {
        'type': 'object',
        'properties': {
          'x': {'type': 'number', 'description': 'Target X in meters.'},
          'y': {'type': 'number', 'description': 'Target Y in meters.'},
          'z': {'type': 'number', 'description': 'Target Z in meters.'},
        },
        'required': ['x', 'y', 'z'],
      },
    ),
    'arm_ik_stop': AiTool(
      name: 'arm_ik_stop',
      description: 'Stop moving the arm through inverse kinematics.',
      parameters: {'type': 'object', 'properties': <String, dynamic>{}},
    ),
    'arm_laser_turn_on': AiTool(
      name: 'arm_laser_turn_on',
      description: 'Turn the arm laser on.',
      parameters: {'type': 'object', 'properties': <String, dynamic>{}},
    ),
    'arm_laser_turn_off': AiTool(
      name: 'arm_laser_turn_off',
      description: 'Turn the arm laser off.',
      parameters: {'type': 'object', 'properties': <String, dynamic>{}},
    ),
    'arm_camera_set_tilt': AiTool(
      name: 'arm_camera_set_tilt',
      description: 'Tilt the camera mounted on the arm.',
      parameters: {
        'type': 'object',
        'properties': {
          'angle': {
            'type': 'integer',
            'description': 'Tilt in degrees from 0 to 180.',
          },
        },
        'required': ['angle'],
      },
    ),
    'drive_emergency_stop': AiTool(
      name: 'drive_emergency_stop',
      description: 'Immediately stop all drive motors.',
      parameters: {'type': 'object', 'properties': <String, dynamic>{}},
    ),
    'drive_tank_set_left': AiTool(
      name: 'drive_tank_set_left',
      description: 'Set the speed of the left wheels.',
      parameters: {
        'type': 'object',
        'properties': {
          'speed': {
            'type': 'number',
            'description': 'Speed from -1 (reverse) to 1 (forward).',
          },
        },
        'required': ['speed'],
      },
    ),
    'drive_tank_set_right': AiTool(
      name: 'drive_tank_set_right',
      description: 'Set the speed of the right wheels.',
      parameters: {
        'type': 'object',
        'properties': {
          'speed': {
            'type': 'number',
            'description': 'Speed from -1 (reverse) to 1 (forward).',
          },
        },
        'required': ['speed'],
      },
    ),
    'drive_modern_stop': AiTool(
      name: 'drive_modern_stop',
      description: 'Stop the rover without changing its heading.',
      parameters: {'type': 'object', 'properties': <String, dynamic>{}},
    ),
    'science_emergency_stop': AiTool(
      name: 'science_emergency_stop',
      description: 'Immediately stop every science operation.',
      parameters: {'type': 'object', 'properties': <String, dynamic>{}},
    ),
    'science_auger_start': AiTool(
      name: 'science_auger_start',
      description: 'Start the science auger.',
      parameters: {'type': 'object', 'properties': <String, dynamic>{}},
    ),
    'science_auger_stop': AiTool(
      name: 'science_auger_stop',
      description: 'Stop the science auger.',
      parameters: {'type': 'object', 'properties': <String, dynamic>{}},
    ),
    'science_pumps_on': AiTool(
      name: 'science_pumps_on',
      description: 'Turn the science pumps on.',
      parameters: {'type': 'object', 'properties': <String, dynamic>{}},
    ),
    'science_pumps_off': AiTool(
      name: 'science_pumps_off',
      description: 'Turn the science pumps off.',
      parameters: {'type': 'object', 'properties': <String, dynamic>{}},
    ),
    'relay_arm_on': AiTool(
      name: 'relay_arm_on',
      description: 'Turn on power to the arm.',
      parameters: {'type': 'object', 'properties': <String, dynamic>{}},
    ),
    'relay_arm_off': AiTool(
      name: 'relay_arm_off',
      description: 'Turn off power to the arm.',
      parameters: {'type': 'object', 'properties': <String, dynamic>{}},
    ),
    'relay_science_on': AiTool(
      name: 'relay_science_on',
      description: 'Turn on power to the science subsystem.',
      parameters: {'type': 'object', 'properties': <String, dynamic>{}},
    ),
    'relay_science_off': AiTool(
      name: 'relay_science_off',
      description: 'Turn off power to the science subsystem.',
      parameters: {'type': 'object', 'properties': <String, dynamic>{}},
    ),
    'antenna_set_track_rover': AiTool(
      name: 'antenna_set_track_rover',
      description: 'Make the base station antenna track the rover.',
      parameters: {'type': 'object', 'properties': <String, dynamic>{}},
    ),
    'antenna_set_manual': AiTool(
      name: 'antenna_set_manual',
      description: 'Put the base station antenna in manual control.',
      parameters: {'type': 'object', 'properties': <String, dynamic>{}},
    ),
    'system_enter_safemode': AiTool(
      name: 'system_enter_safemode',
      description: 'Stop every rover subsystem and enter safe mode.',
      parameters: {'type': 'object', 'properties': <String, dynamic>{}},
    ),
  };

  /// The tools in the format the model expects, including dashboard views.
  List<AiTool> get _availableTools {
    final pages = DashboardView.uiViews.map((view) => view.name).join(', ');
    final cameras = DashboardView.cameraViews
        .map((view) => view.name)
        .join(', ');
    return [
      AiTool(
        name: 'view_show_page',
        description:
            'Replace one pane of the dashboard with a page or camera feed. '
            'Pages: $pages. Cameras: $cameras.',
        parameters: const {
          'type': 'object',
          'properties': {
            'page': {
              'type': 'string',
              'description': 'The exact name of the page or camera feed.',
            },
            'index': {
              'type': 'integer',
              'description':
                  'Which pane to change, starting at 0. Defaults to the first '
                  'pane that is not the assistant.',
            },
          },
          'required': ['page'],
        },
      ),
      AiTool(
        name: 'view_set_layout',
        description:
            'Set how many panes the dashboard is split into. '
            'Allowed values are 1, 2, 3, 4, and 8.',
        parameters: const {
          'type': 'object',
          'properties': {
            'panes': {
              'type': 'integer',
              'enum': [1, 2, 3, 4, 8],
              'description': 'The number of panes to show.',
            },
          },
          'required': ['panes'],
        },
      ),
      AiTool(
        name: 'view_clear_pane',
        description:
            'Empty one pane of the dashboard without changing the layout.',
        parameters: const {
          'type': 'object',
          'properties': {
            'index': {
              'type': 'integer',
              'description':
                  'Which pane to clear, starting at 0. Defaults to the first '
                  'pane that is not the assistant.',
            },
          },
        },
      ),
      AiTool(
        name: 'view_add_page',
        description:
            'Open a page or camera feed in a blank pane, adding a pane when '
            'the dashboard still has room. Pages: $pages. Cameras: $cameras.',
        parameters: const {
          'type': 'object',
          'properties': {
            'page': {
              'type': 'string',
              'description': 'The exact name of the page or camera feed.',
            },
          },
          'required': ['page'],
        },
      ),
      ..._roverTools.values,
    ];
  }

  /// Processes tool calls and returns what each one actually did.
  Future<List<String>> _processToolCalls(List<AiToolCall> toolCalls) async {
    final results = <String>[];
    for (var i = 0; i < toolCalls.length; i++) {
      final toolCall = toolCalls[i];
      final id = toolCall.id.isEmpty
          ? '${toolCall.function.name}_$i'
          : toolCall.id;
      _lastActionResult = null;
      final action = await _executeBinding(
        toolCall.function.name,
        toolCall.function.arguments,
        id,
      );
      if (action != null) {
        _pendingActions.add(action);
        results.add('Waiting for your confirmation to ${action.description.toLowerCase()}.');
      } else if (_lastActionResult != null) {
        results.add(_lastActionResult!);
      } else {
        results.add('Ran ${toolCall.function.name}.');
      }
    }
    _notify();
    return results;
  }

  /// Parses tool calls that were serialized as a JSON string inside the
  /// assistant message content. This is a fallback for models that do not
  /// return structured `tool_calls`.
  List<AiToolCall> _parseToolCallsFromContent(String content) {
    final trimmed = content.trim();
    if (trimmed.startsWith('[') && trimmed.endsWith(']')) {
      try {
        final parsed = jsonDecode(trimmed);
        if (parsed is List) {
          final calls = <AiToolCall>[];
          for (final item in parsed) {
            if (item is Map<String, dynamic>) {
              final call = _parseSingleToolCall(item);
              if (call != null) calls.add(call);
            }
          }
          if (calls.isNotEmpty) return calls;
        }
      } on FormatException {
        return [];
      }
    } else if (trimmed.startsWith('{') && trimmed.endsWith('}')) {
      try {
        final single = jsonDecode(trimmed) as Map<String, dynamic>;
        final tc = _parseSingleToolCall(single);
        return tc != null ? [tc] : <AiToolCall>[];
      } on FormatException {
        return [];
      }
    }

    // Otherwise, try to find any JSON object anywhere in the text and parse the
    // first one that looks like a tool call. Some models return the tool call
    // JSON wrapped in markdown fences, prose, or extra commentary.
    final embedded = _extractEmbeddedJsonObjects(trimmed);
    if (embedded.isNotEmpty) {
      final result = <AiToolCall>[];
      for (final item in embedded) {
        final tc = _parseSingleToolCall(item);
        if (tc != null) result.add(tc);
      }
      if (result.isNotEmpty) return result;
    }

    return [];
  }

  /// Extracts candidate JSON objects from a string that may contain prose,
  /// markdown fences, or other non-JSON content around the JSON.
  List<Map<String, dynamic>> _extractEmbeddedJsonObjects(String text) {
    final result = <Map<String, dynamic>>[];
    final buffer = StringBuffer();
    int depth = 0;
    bool inString = false;
    bool escapeNext = false;

    for (final char in text.characters) {
      if (escapeNext) {
        escapeNext = false;
        buffer.write(char);
        continue;
      }
      if (char == '\\' && inString) {
        escapeNext = true;
        buffer.write(char);
        continue;
      }
      if (char == '"') {
        inString = !inString;
        if (depth > 0) buffer.write(char);
        continue;
      }
      if (inString) {
        if (depth > 0) buffer.write(char);
        continue;
      }
      if (char == '{') {
        // Start a fresh object; prose and array brackets before it are noise.
        if (depth == 0) buffer.clear();
        buffer.write(char);
        depth++;
        continue;
      }
      if (depth > 0) {
        buffer.write(char);
        if (char == '}') depth--;
        if (depth == 0) {
          final candidate = buffer.toString().trim();
          buffer.clear();
          if (!candidate.startsWith('{') || !candidate.endsWith('}')) {
            continue;
          }
          try {
            final parsed = jsonDecode(candidate);
            if (parsed is Map<String, dynamic>) result.add(parsed);
          } on FormatException {
            // Not valid JSON; skip.
          }
        }
        continue;
      }
    }

    return result;
  }

  AiToolCall? _parseSingleToolCall(Map<String, dynamic> json) {
    // Models wrap calls in a `function` object when they follow the OpenAI
    // schema. Smaller models tend to send `{"name": ..., "arguments": ...}`
    // directly, so both shapes are accepted.
    final wrapped = json['function'];
    final functionJson = wrapped is Map<String, dynamic> ? wrapped : json;
    final name = functionJson['name'] as String?;
    if (name == null || name.isEmpty) return null;
    // Tool definitions echoed from the prompt have a description and a
    // parameter schema but no arguments. They are not calls, so skip them.
    if (!functionJson.containsKey('arguments') &&
        (functionJson.containsKey('parameters') ||
            functionJson.containsKey('description'))) {
      return null;
    }
    final argumentsRaw = functionJson['arguments'];
    Map<String, dynamic> arguments;
    if (argumentsRaw is Map<String, dynamic>) {
      arguments = _coerceNumericValues(argumentsRaw);
    } else if (argumentsRaw is String) {
      arguments = _coerceNumericValues(_parseArgumentsJson(argumentsRaw));
    } else {
      arguments = <String, dynamic>{};
    }
    return AiToolCall(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? 'function',
      function: AiToolFunction(name: name, arguments: arguments),
    );
  }

  /// Parses a JSON string that may contain the arguments object.
  Map<String, dynamic> _parseArgumentsJson(String jsonString) {
    final trimmed = jsonString.trim();
    try {
      final parsed = jsonDecode(trimmed);
      if (parsed is Map<String, dynamic>) return parsed;
    } on FormatException {
      // fall through
    }
    return <String, dynamic>{};
  }

  /// Coerces JSON-primitive values that are represented as [String] back into
  /// [int] or [double] so binding handlers do not hit `as num` type errors at
  /// runtime.
  Map<String, dynamic> _coerceNumericValues(Map<String, dynamic> map) {
    final result = <String, dynamic>{};
    for (final entry in map.entries) {
      final value = entry.value;
      if (value is String) {
        final intValue = int.tryParse(value);
        if (intValue != null) {
          result[entry.key] = intValue;
          continue;
        }
        final doubleValue = double.tryParse(value);
        if (doubleValue != null) {
          result[entry.key] = doubleValue;
          continue;
        }
      }
      result[entry.key] = value;
    }
    return result;
  }

  /// Executes a binding and returns a pending action if user confirmation is needed.
  Future<PendingAction?> _executeBinding(String bindingName,
      Map<String, dynamic> args, String toolCallId) async {
    // Normalize any JSON-primitive values that came back as the wrong Dart type.
    args = _coerceNumericArguments(args);

    // Check if we need user permission
    if (!_unrestrictedMode &&
        !_isReadOnlyBinding(bindingName) &&
        !_isSafeBinding(bindingName)) {
      return PendingAction(
        id: toolCallId,
        bindingName: bindingName,
        arguments: args,
        description: _describeAction(bindingName, args),
        onConfirm: () => unawaited(
          _confirmAction(toolCallId, bindingName, args),
        ),
        onCancel: () => _cancelAction(toolCallId),
      );
    }

    // Execute the action directly
    return _performAction(bindingName, args, toolCallId);
  }

  /// Safely reads a numeric argument from the AI bindings map.
  ///
  /// Accepts [int], [double], numeric [String], or missing/other values.
  /// Returns [defaultValue] for anything that cannot be interpreted as a number.
  num _argNum(Map<String, dynamic> args, String key, {num defaultValue = 0}) {
    final value = args[key];
    if (value is num) return value;
    if (value is String) {
      return double.tryParse(value) ?? int.tryParse(value) ?? defaultValue;
    }
    return defaultValue;
  }

  /// Safely reads an integer argument from the AI bindings map.
  int _argInt(Map<String, dynamic> args, String key, {int defaultValue = 0}) {
    final value = args[key];
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) {
      return int.tryParse(value) ?? double.tryParse(value)?.round() ?? defaultValue;
    }
    return defaultValue;
  }

  /// Coerces argument values that are JSON primitives represented as [String]
  /// back into [int] or [double] so binding handlers can safely cast them to
  /// [num].
  Map<String, dynamic> _coerceNumericArguments(Map<String, dynamic> args) {
    final result = <String, dynamic>{};
    for (final entry in args.entries) {
      final value = entry.value;
      if (value is String) {
        final intValue = int.tryParse(value);
        if (intValue != null) {
          result[entry.key] = intValue;
          continue;
        }
        final doubleValue = double.tryParse(value);
        if (doubleValue != null) {
          result[entry.key] = doubleValue;
          continue;
        }
      }
      result[entry.key] = value;
    }
    return result;
  }

  /// Checks if a binding is read-only (safe to execute without permission).
  bool _isReadOnlyBinding(String bindingName) {
    // All get operations are read-only
    return bindingName.startsWith('position_get_') ||
        bindingName.startsWith('vitals_get_') ||
        bindingName.startsWith('vision_get_') ||
        bindingName.startsWith('subsystems_get_') ||
        bindingName.startsWith('system_get_') ||
        bindingName == 'antenna_set_track_rover';
  }

  /// Checks if a binding is considered immediately safe (no confirmation needed).
  bool _isSafeBinding(String bindingName) {
    // Emergency stops and calibration are safe
    if (bindingName == 'arm_emergency_stop' ||
        bindingName == 'drive_emergency_stop' ||
        bindingName == 'science_emergency_stop' ||
        bindingName == 'arm_calibrate' ||
        bindingName == 'science_calibrate' ||
        bindingName == 'system_enter_safemode' ||
        bindingName == 'arm_ik_stop' ||
        bindingName == 'drive_modern_stop' ||
        bindingName == 'science_stop_collection' ||
        bindingName == 'arm_laser_turn_off') {
      return true;
    }
    // Dashboard layout changes only affect the UI, so they are safe.
    if (bindingName.startsWith('view_')) return true;
    // Camera movements are safe
    if (bindingName.startsWith('camera_') || bindingName.startsWith('drive_camera_')) {
      return true;
    }
    // Turning relays off is safe
    if (bindingName.startsWith('relay_') && bindingName.endsWith('_off')) {
      return true;
    }
    return false;
  }

  /// Describes what an action will do in human-readable form.
  String _describeAction(String bindingName, Map<String, dynamic> args) {
    String radToDeg(num rad) => (rad * 180 / 3.14159).toStringAsFixed(1);
    String percent(num value) => (value * 100).toStringAsFixed(0);
    
    switch (bindingName) {
      // ARM OPERATIONS
      case 'arm_emergency_stop':
        return 'EMERGENCY: Stop all arm motors immediately';
      case 'arm_calibrate':
        return 'Calibrate all arm motors';
      case 'arm_swivel_set_angle':
        final angle = _argNum(args, 'angle');
        return 'Move swivel to ${angle.toStringAsFixed(2)} rad (${radToDeg(angle)}°)';
      case 'arm_swivel_jog':
        final speed = _argNum(args, 'speed');
        return 'Jog swivel at ${percent(speed.abs())}% ${speed > 0 ? "clockwise" : "counter-clockwise"}';
      case 'arm_shoulder_set_angle':
        final angle = _argNum(args, 'angle');
        return 'Move shoulder to ${angle.toStringAsFixed(2)} rad (${radToDeg(angle)}°)';
      case 'arm_shoulder_jog':
        final speed = _argNum(args, 'speed');
        return 'Jog shoulder at ${percent(speed.abs())}% ${speed > 0 ? "up" : "down"}';
      case 'arm_elbow_set_angle':
        final angle = _argNum(args, 'angle');
        return 'Move elbow to ${angle.toStringAsFixed(2)} rad (${radToDeg(angle)}°)';
      case 'arm_elbow_jog':
        final speed = _argNum(args, 'speed');
        return 'Jog elbow at ${percent(speed.abs())}% ${speed > 0 ? "up" : "down"}';
      case 'arm_forearm_roll_set_angle':
        final angle = _argNum(args, 'angle');
        return 'Rotate forearm to ${radToDeg(angle)}°';
      case 'arm_forearm_roll_jog':
        final speed = _argNum(args, 'speed');
        return 'Jog forearm roll at ${percent(speed.abs())}% ${speed > 0 ? "CW" : "CCW"}';
      case 'arm_wrist_pitch_set_angle':
        final angle = _argNum(args, 'angle');
        return 'Move wrist pitch to ${radToDeg(angle)}°';
      case 'arm_wrist_pitch_jog':
        final speed = _argNum(args, 'speed');
        return 'Jog wrist pitch at ${percent(speed.abs())}% ${speed > 0 ? "up" : "down"}';
      case 'arm_wrist_roll_set_angle':
        final angle = _argNum(args, 'angle');
        return 'Rotate wrist to ${radToDeg(angle)}°';
      case 'arm_wrist_roll_jog':
        final speed = _argNum(args, 'speed');
        return 'Jog wrist roll at ${percent(speed.abs())}% ${speed > 0 ? "CW" : "CCW"}';
      case 'arm_gripper_set_position':
        final position = _argNum(args, 'position');
        return 'Set gripper to ${percent(position)} open (${position > 0.5 ? "opening" : "closing"})';
      case 'arm_gripper_jog':
        final speed = _argNum(args, 'speed');
        return 'Jog gripper at ${percent(speed.abs())}% ${speed > 0 ? "open" : "close"}';
      case 'arm_laser_turn_on':
        return 'Turn ON the arm laser (WARNING: bright light)';
      case 'arm_laser_turn_off':
        return 'Turn OFF the arm laser';
      case 'arm_laser_toggle':
        return 'Toggle the arm laser state';
      case 'arm_ik_move_to':
        final x = _argNum(args, 'x');
        final y = _argNum(args, 'y');
        final z = _argNum(args, 'z');
        return 'Move end effector to (${x.toStringAsFixed(2)}, ${y.toStringAsFixed(2)}, ${z.toStringAsFixed(2)}) meters using IK';
      case 'arm_ik_stop':
        return 'Stop IK movement';
      case 'arm_camera_set_tilt':
        final angle = _argNum(args, 'angle', defaultValue: 90);
        return 'Set arm camera tilt to ${angle.toStringAsFixed(0)}°';
      
      // DRIVE OPERATIONS
      case 'drive_emergency_stop':
        return 'EMERGENCY: Stop all drive motors immediately';
      case 'drive_tank_set_left':
        final speed = _argNum(args, 'speed');
        return 'Set left wheels to ${percent(speed.abs())}% ${speed > 0 ? "forward" : "reverse"}';
      case 'drive_tank_set_right':
        final speed = _argNum(args, 'speed');
        return 'Set right wheels to ${percent(speed.abs())}% ${speed > 0 ? "forward" : "reverse"}';
      case 'drive_tank_jog_left':
        final speed = _argNum(args, 'speed');
        return 'Jog left wheels at ${percent(speed.abs())}% ${speed != 0 ? "forward" : ""}';
      case 'drive_tank_jog_right':
        final speed = _argNum(args, 'speed');
        return 'Jog right wheels at ${percent(speed.abs())}% ${speed != 0 ? "forward" : ""}';
      case 'drive_modern_forward':
        final speed = _argNum(args, 'speed');
        return 'Drive forward at ${percent(speed.abs())}% (modern drive)';
      case 'drive_modern_reverse':
        final speed = _argNum(args, 'speed');
        return 'Drive in reverse at ${percent(speed.abs())}% (modern drive)';
      case 'drive_modern_steer':
        final direction = _argNum(args, 'direction');
        return 'Steer ${direction > 0 ? "right" : "left"} at ${radToDeg(direction.abs())}° (modern drive)';
      case 'drive_modern_stop':
        return 'Stop modern drive movement';
      case 'drive_throttle_increase':
        return 'Increase throttle by 10%';
      case 'drive_throttle_decrease':
        return 'Decrease throttle by 10%';
      case 'drive_throttle_set':
        final throttle = _argNum(args, 'throttle');
        return 'Set throttle to ${percent(throttle)}';
      case 'drive_camera_front_tilt':
        return 'Tilt front camera';
      case 'drive_camera_front_swivel':
        return 'Swivel front camera';
      case 'drive_camera_rear_tilt':
        return 'Tilt rear camera';
      case 'drive_camera_rear_swivel':
        return 'Swivel rear camera';
      case 'drive_set_color':
        final color = args['color'] ?? 'white';
        return 'Set drive LED color to $color';
      case 'drive_blink_on':
        return 'Turn ON blinky lights';
      case 'drive_blink_off':
        return 'Turn OFF blinky lights';
      
      // CAMERA OPERATIONS
      case 'camera_front_tilt_up':
        return 'Tilt front camera up';
      case 'camera_front_tilt_down':
        return 'Tilt front camera down';
      case 'camera_front_pan_left':
        return 'Pan front camera left';
      case 'camera_front_pan_right':
        return 'Pan front camera right';
      case 'camera_front_set_tilt':
        final angle = _argNum(args, 'angle', defaultValue: 30);
        return 'Set front camera tilt to ${angle.toStringAsFixed(0)}° (0-60° range)';
      case 'camera_front_set_swivel':
        final angle = _argNum(args, 'angle', defaultValue: 90);
        return 'Set front camera swivel to ${angle.toStringAsFixed(0)}° (0-180° range)';
      case 'camera_rear_tilt_up':
        return 'Tilt rear camera up';
      case 'camera_rear_tilt_down':
        return 'Tilt rear camera down';
      case 'camera_rear_pan_left':
        return 'Pan rear camera left';
      case 'camera_rear_pan_right':
        return 'Pan rear camera right';
      case 'camera_rear_set_tilt':
        final angle = _argNum(args, 'angle', defaultValue: 90);
        return 'Set rear camera tilt to ${angle.toStringAsFixed(0)}° (0-180° range)';
      case 'camera_rear_set_swivel':
        final angle = _argNum(args, 'angle', defaultValue: 90);
        return 'Set rear camera swivel to ${angle.toStringAsFixed(0)}° (0-180° range)';
      
      // SCIENCE OPERATIONS
      case 'science_emergency_stop':
        return 'EMERGENCY: Stop all science operations immediately';
      case 'science_calibrate':
        return 'Calibrate science subsystems';
      case 'science_carousel_next_tube':
        return 'Move dirt carousel to NEXT tube';
      case 'science_carousel_prev_tube':
        return 'Move dirt carousel to PREVIOUS tube';
      case 'science_carousel_jog':
        final direction = _argNum(args, 'direction');
        return 'Jog carousel ${direction > 0 ? "forward" : "backward"}';
      case 'science_carousel_set_position':
        final pos = _argNum(args, 'position');
        return 'Set carousel to position $pos steps';
      case 'science_auger_start':
        return 'Start auger motor';
      case 'science_auger_stop':
        return 'Stop auger motor';
      case 'science_auger_set_speed':
        final speed = _argNum(args, 'speed');
        return 'Set auger speed to ${speed.toStringAsFixed(2)} RPM';
      case 'science_auger_set_servos':
        final open = args['open'] ?? true;
        return 'Set auger servos to ${open ? "OPEN" : "CLOSED"}';
      case 'science_pumps_on':
        return 'Turn SCIENCE PUMPS ON';
      case 'science_pumps_off':
        return 'Turn SCIENCE PUMPS OFF';
      case 'science_slider_jog':
        final direction = _argNum(args, 'direction');
        return 'Jog linear slider ${direction > 0 ? "forward" : "backward"}';
      case 'science_slider_set_position':
        final pos = _argNum(args, 'position');
        return 'Set linear slider to $pos steps';
      case 'science_start_collection':
        return 'Start science data collection (CO2, temp, humidity)';
      case 'science_stop_collection':
        return 'Stop science data collection';
      
      // RELAY OPERATIONS
      case 'relay_set_mechanical_override':
        final state = args['state'] == true ||
            (args['state'] is String && args['state'].toLowerCase() == 'true');
        return 'Set mechanical override to ${state ? "ON (enabled)" : "OFF (disabled)"}';
      case 'relay_front_left_on':
        return 'Turn ON power to front left motor';
      case 'relay_front_left_off':
        return 'Turn OFF power to front left motor';
      case 'relay_front_right_on':
        return 'Turn ON power to front right motor';
      case 'relay_front_right_off':
        return 'Turn OFF power to front right motor';
      case 'relay_middle_left_on':
        return 'Turn ON power to middle left motor';
      case 'relay_middle_left_off':
        return 'Turn OFF power to middle left motor';
      case 'relay_middle_right_on':
        return 'Turn ON power to middle right motor';
      case 'relay_middle_right_off':
        return 'Turn OFF power to middle right motor';
      case 'relay_back_left_on':
        return 'Turn ON power to back left motor';
      case 'relay_back_left_off':
        return 'Turn OFF power to back left motor';
      case 'relay_back_right_on':
        return 'Turn ON power to back right motor';
      case 'relay_back_right_off':
        return 'Turn OFF power to back right motor';
      case 'relay_arm_on':
        return 'Turn ON power to arm';
      case 'relay_arm_off':
        return 'Turn OFF power to arm (arm will lose power)';
      case 'relay_science_on':
        return 'Turn ON power to science subsystem';
      case 'relay_science_off':
        return 'Turn OFF power to science subsystem';
      
      // ANTENNA OPERATIONS
      case 'antenna_set_track_rover':
        return 'Set antenna to TRACK ROVER mode';
      case 'antenna_set_manual':
        return 'Set antenna to MANUAL control mode';
      case 'antenna_manual_swivel_jog':
        final direction = _argNum(args, 'direction');
        return 'Jog antenna swivel ${direction > 0 ? "clockwise" : "counter-clockwise"}';
      case 'antenna_manual_pitch_jog':
        final direction = _argNum(args, 'direction');
        return 'Jog antenna pitch ${direction > 0 ? "up" : "down"}';
      case 'antenna_manual_swivel_set_angle':
        final angle = _argNum(args, 'angle');
        return 'Set antenna swivel to ${radToDeg(angle)}°';
      case 'antenna_manual_pitch_set_angle':
        final angle = _argNum(args, 'angle');
        return 'Set antenna pitch to ${radToDeg(angle)}°';
      
      // SUBSYSTEMS
      case 'subsystems_get_status':
        return 'Get current subsystems status (GPS, IMU, connected devices)';
      case 'subsystems_check_sensors':
        return 'Check GPS and IMU sensor connections';
      
      // VISION
      case 'vision_get_aruco_tags':
        return 'Get list of detected ArUco tags with positions';
      case 'vision_get_object_detections':
        return 'Get current object detection results';
      case 'vision_focus_on_tag':
        final tagId = _argNum(args, 'tag_id').round();
        return 'Focus cameras on ArUco tag #$tagId';
      
      // POSITION
      case 'position_get_gps':
        return 'Get current GPS coordinates (latitude, longitude, altitude)';
      case 'position_get_orientation':
        return 'Get current orientation (pitch, roll, yaw angles)';
      case 'position_get_distance_to_base':
        return 'Get distance from rover to base station in meters';
      
      // VITALS
      case 'vitals_get_battery_voltage':
        return 'Get battery voltage in volts';
      case 'vitals_get_battery_current':
        return 'Get battery current in amps';
      case 'vitals_get_battery_temperature':
        return 'Get battery temperature in Celsius';
      case 'vitals_get_battery_percentage':
        return 'Get battery charge percentage (0-100%)';
      
      // SYSTEM
      case 'system_get_rover_status':
        return 'Get overall rover status (disconnected, idle, manual, autonomous, power off, restart)';
      case 'system_get_all_telemetry':
        return 'Get all telemetry data from all subsystems';
      case 'system_enter_safemode':
        return 'ENTER SAFE MODE: Stop all operations and disable motors';
      case 'system_exit_safemode':
        return 'EXIT SAFE MODE: Re-enable operations';
      case 'system_home_all':
        return 'Home all subsystems (return to starting positions)';
      case 'system_reset':
        return 'WARNING: Reset all rover systems';

      // DASHBOARD VIEWS
      case 'view_show_page':
        final page = args['page'] ?? 'unknown';
        final index = _argInt(args, 'index');
        return 'Show "$page" in dashboard pane ${index + 1}';
      case 'view_set_layout':
        return 'Split the dashboard into ${_argInt(args, 'panes')} panes';
      case 'view_clear_pane':
        return 'Clear dashboard pane ${_argInt(args, 'index') + 1}';
      case 'view_add_page':
        return 'Open "${args['page'] ?? 'unknown'}" in a new dashboard pane';
      
      default:
        return 'Execute operation: $bindingName';
    }
  }

  /// Picks the pane a view command should change.
  ///
  /// When the model does not name a pane, the first pane that is not the
  /// assistant is used so the conversation stays on screen.
  int _targetPane(Map<String, dynamic> args) {
    if (args['index'] != null) {
      return _argInt(args, 'index')
          .clamp(0, models.views.views.length - 1)
          .toInt();
    }
    final index = models.views.views.indexWhere(
      (view) => view.name != Routes.aiAssistant,
    );
    return index < 0 ? 0 : index;
  }

  /// Short names the model tends to use for longer dashboard titles.
  static const Map<String, String> _viewAliases = {
    'science': 'Science Analysis',
    'science page': 'Science Analysis',
    'autonomy': 'Map',
    'power': 'Electrical',
    'assistant': 'AI Assistant',
    'chat': 'AI Assistant',
    'antenna': 'Base Station',
    'front': 'Rover front',
    'front camera': 'Rover front',
    'rear': 'Rover rear',
    'rear camera': 'Rover rear',
    'depth camera': 'Depth',
  };

  /// Words the operator may use for each dashboard view.
  static const Map<String, String> _pageHints = {
    'science analysis': 'Science Analysis',
    'science': 'Science Analysis',
    'autonomy': 'Map',
    'map': 'Map',
    'electrical': 'Electrical',
    'power': 'Electrical',
    'subsystems': 'Subsystems',
    'lidar': 'Lidar',
    'arm': 'Arm',
    'drive': 'Drive',
    'rocks': 'Rocks',
    'controllers': 'Controllers',
    'controller': 'Controllers',
    'base station': 'Base Station',
    'antenna': 'Base Station',
    'ai assistant': 'AI Assistant',
    'assistant': 'AI Assistant',
    'front camera': 'Rover front',
    'front': 'Rover front',
    'rear camera': 'Rover rear',
    'rear': 'Rover rear',
    'depth': 'Depth',
    'subsystem 1': 'Subsystem 1',
    'subsystem 2': 'Subsystem 2',
    'subsystem 3': 'Subsystem 3',
    'bottom left': 'Bottom Left',
    'bottom right': 'Bottom Right',
  };

  /// Interprets simple dashboard commands locally.
  ///
  /// A small local model occasionally answers an explicit view command with
  /// prose instead of a tool call, so these patterns guarantee it still runs.
  List<AiToolCall> _parseViewIntent(String message) {
    final lower = message.toLowerCase();
    final calls = <AiToolCall>[];
    final panes = _paneCount(lower);
    if (panes != null) {
      calls.add(
        AiToolCall(
          id: 'intent_layout',
          type: 'function',
          function: AiToolFunction(
            name: 'view_set_layout',
            arguments: {'panes': panes},
          ),
        ),
      );
    }

    final clear = RegExp(r'\b(clear|empty|blank)\b').hasMatch(lower) &&
        RegExp(r'\b(pane|view)\b').hasMatch(lower);
    if (clear && panes == null) {
      calls.add(
        AiToolCall(
          id: 'intent_clear',
          type: 'function',
          function: AiToolFunction(
            name: 'view_clear_pane',
            arguments: {'index': _paneIndex(lower) ?? 0},
          ),
        ),
      );
      return calls;
    }

    final hasAction = RegExp(
      r'\b(show|open|display|switch|put|make|add|create|start)\b',
    ).hasMatch(lower);
    // Only treat this as a view command when the message actually talks about
    // the dashboard, so "show me how the arm works" stays a question.
    final hasViewContext = RegExp(
      r'\b(page|view|pane|dashboard|camera|screen|layout)\b',
    ).hasMatch(lower);
    final page = _pageHint(lower);
    if (page != null && hasAction && hasViewContext) {
      final isAdd = RegExp(r'\b(new|add|another)\b').hasMatch(lower);
      final index = _paneIndex(lower);
      calls.add(
        AiToolCall(
          id: 'intent_page',
          type: 'function',
          function: AiToolFunction(
            name: isAdd && panes == null ? 'view_add_page' : 'view_show_page',
            arguments: {
              'page': page,
              if (!isAdd && index != null) 'index': index,
            },
          ),
        ),
      );
    }
    return calls;
  }

  /// Reads a pane count from words like "four panes" or "2 views".
  int? _paneCount(String lower) {
    const words = {
      'one': 1,
      'two': 2,
      'three': 3,
      'four': 4,
      'five': 5,
      'six': 6,
      'seven': 7,
      'eight': 8,
    };
    final match = RegExp(
      r'\b(\d+|one|two|three|four|five|six|seven|eight)\s*(?:panes?|views?|splits?)\b',
    ).firstMatch(lower);
    if (match == null) return null;
    final raw = match.group(1)!;
    final count = int.tryParse(raw) ?? words[raw];
    if (count == null || !const {1, 2, 3, 4, 8}.contains(count)) return null;
    return count;
  }

  /// Reads a zero-based pane index from "first pane" or "pane 2".
  int? _paneIndex(String lower) {
    const words = {
      'first': 0,
      'second': 1,
      'third': 2,
      'fourth': 3,
      'fifth': 4,
      'sixth': 5,
      'seventh': 6,
      'eighth': 7,
    };
    final word = RegExp(
      r'\b(first|second|third|fourth|fifth|sixth|seventh|eighth)\b',
    ).firstMatch(lower);
    if (word != null) return words[word.group(1)];
    final number = RegExp(r'\b(?:pane|view)\s*(\d+)\b').firstMatch(lower);
    if (number != null) {
      final index = int.tryParse(number.group(1)!) ?? 1;
      return index < 1 ? 0 : index - 1;
    }
    return null;
  }

  /// Finds the page name mentioned in a message.
  String? _pageHint(String lower) {
    final keys = _pageHints.keys.toList()
      ..sort((a, b) => b.length.compareTo(a.length));
    for (final key in keys) {
      if (RegExp('\\b${RegExp.escape(key)}\\b').hasMatch(lower)) {
        return _pageHints[key];
      }
    }
    return null;
  }

  /// Finds the dashboard view the model named.
  ///
  /// Exact names win, then aliases, then partial names like "Science" for
  /// "Science Analysis". UI pages are preferred if a camera and a page ever
  /// share a name.
  DashboardView? _resolveView(String name) {
    final target = name.trim().toLowerCase();
    if (target.isEmpty) return null;
    final wanted = (_viewAliases[target] ?? name).trim().toLowerCase();
    final all = DashboardView.allViews
        .where((view) => view.name != Routes.blank)
        .toList();
    DashboardView pick(Iterable<DashboardView> matches) => matches.firstWhere(
      (view) => DashboardView.uiViews.contains(view),
      orElse: () => matches.first,
    );
    final exact = all.where((view) => view.name.toLowerCase() == wanted);
    if (exact.isNotEmpty) return pick(exact);
    final partial = all.where(
      (view) =>
          view.name.toLowerCase().contains(wanted) ||
          wanted.contains(view.name.toLowerCase()),
    );
    return partial.isEmpty ? null : pick(partial);
  }

  /// Performs an action and returns any pending action.
  Future<PendingAction?> _performAction(
      String bindingName, Map<String, dynamic> args, String toolCallId) async {
    // Execute the actual rover commands here
    switch (bindingName) {
      // ============================================================
      // ARM OPERATIONS
      // ============================================================
      case 'arm_emergency_stop':
        _sendArmCommand(ArmCommand(stop: true));
        break;
      case 'arm_calibrate':
        _sendArmCommand(ArmCommand(calibrate: true));
        break;
      case 'arm_swivel_set_angle':
        final angle = _argNum(args, 'angle');
        _sendArmCommand(ArmCommand(
          swivel: MotorCommand(angle: angle.toDouble()),
        ));
        break;
      case 'arm_swivel_jog':
        final speed = _argNum(args, 'speed');
        _sendArmCommand(ArmCommand(
          swivel: MotorCommand(moveRadians: speed.toDouble() * 0.01),
        ));
        break;
      case 'arm_shoulder_set_angle':
        final angle = _argNum(args, 'angle');
        _sendArmCommand(ArmCommand(
          shoulder: MotorCommand(angle: angle.toDouble()),
        ));
        break;
      case 'arm_shoulder_jog':
        final speed = _argNum(args, 'speed');
        _sendArmCommand(ArmCommand(
          shoulder: MotorCommand(moveRadians: speed.toDouble() * 0.01),
        ));
        break;
      case 'arm_elbow_set_angle':
        final angle = _argNum(args, 'angle');
        _sendArmCommand(ArmCommand(
          elbow: MotorCommand(angle: angle.toDouble()),
        ));
        break;
      case 'arm_elbow_jog':
        final speed = _argNum(args, 'speed');
        _sendArmCommand(ArmCommand(
          elbow: MotorCommand(moveRadians: speed.toDouble() * 0.01),
        ));
        break;
      case 'arm_forearm_roll_set_angle':
        final angle = _argNum(args, 'angle');
        _sendArmCommand(ArmCommand(
          roll: MotorCommand(angle: angle.toDouble()),
        ));
        break;
      case 'arm_forearm_roll_jog':
        final speed = _argNum(args, 'speed');
        _sendArmCommand(ArmCommand(
          roll: MotorCommand(moveRadians: speed.toDouble() * 0.01),
        ));
        break;
      case 'arm_wrist_pitch_set_angle':
        final angle = _argNum(args, 'angle');
        _sendArmCommand(ArmCommand(
          wrist: WristCommand(
            pitch: MotorCommand(angle: angle.toDouble()),
          ),
        ));
        break;
      case 'arm_wrist_pitch_jog':
        final speed = _argNum(args, 'speed');
        _sendArmCommand(ArmCommand(
          wrist: WristCommand(
            pitch: MotorCommand(moveRadians: speed.toDouble() * 0.01),
          ),
        ));
        break;
      case 'arm_wrist_roll_set_angle':
        final angle = _argNum(args, 'angle');
        _sendArmCommand(ArmCommand(
          wrist: WristCommand(
            roll: MotorCommand(angle: angle.toDouble()),
          ),
        ));
        break;
      case 'arm_wrist_roll_jog':
        final speed = _argNum(args, 'speed');
        _sendArmCommand(ArmCommand(
          wrist: WristCommand(
            roll: MotorCommand(moveRadians: speed.toDouble() * 0.01),
          ),
        ));
        break;
      case 'arm_gripper_set_position':
        final position = _argNum(args, 'position');
        // Convert 0-1 position to motor command (0 = closed, 1 = open)
        _sendArmCommand(ArmCommand(
          pinch: MotorCommand(angle: position.toDouble() * 0.5 - 0.25),
        ));
        break;
      case 'arm_gripper_jog':
        final speed = _argNum(args, 'speed');
        _sendArmCommand(ArmCommand(
          pinch: MotorCommand(moveRadians: speed.toDouble() * 0.005),
        ));
        break;
      case 'arm_laser_turn_on':
        _sendArmCommand(ArmCommand(
          laserState: BoolState.YES,
        ));
        break;
      case 'arm_laser_turn_off':
        _sendArmCommand(ArmCommand(
          laserState: BoolState.NO,
        ));
        break;
      case 'arm_laser_toggle':
        // Toggle would require reading current state first
        _sendArmCommand(ArmCommand(
          laserState: BoolState.YES, // Default to on if we can't read state
        ));
        break;
      case 'arm_ik_move_to':
        final x = _argNum(args, 'x');
        final y = _argNum(args, 'y');
        final z = _argNum(args, 'z');
        _sendArmCommand(ArmCommand(
          usingIk: BoolState.YES,
          ikPose: Pose3d(
            translation: Translation3d(x: x.toDouble(), y: y.toDouble(), z: z.toDouble()),
          ),
        ));
        break;
      case 'arm_ik_stop':
        _sendArmCommand(ArmCommand(
          usingIk: BoolState.NO,
        ));
        break;
      case 'arm_camera_set_tilt':
        final angle = _argInt(args, 'angle', defaultValue: 90);
        _sendArmCommand(ArmCommand(
          servoAngle: angle.clamp(0, 180),
        ));
        break;
      
      // ============================================================
      // DRIVE OPERATIONS
      // ============================================================
      case 'drive_emergency_stop':
        _sendDriveCommand(DriveCommand(setThrottle: true, throttle: 0));
        _sendDriveCommand(DriveCommand(setLeft: true, left: 0));
        _sendDriveCommand(DriveCommand(setRight: true, right: 0));
        break;
      case 'drive_tank_set_left':
        final speed = _argNum(args, 'speed');
        _sendDriveCommand(DriveCommand(setLeft: true, left: speed.toDouble().clamp(-1, 1)));
        break;
      case 'drive_tank_set_right':
        final speed = _argNum(args, 'speed');
        _sendDriveCommand(DriveCommand(setRight: true, right: speed.toDouble().clamp(-1, 1)));
        break;
      case 'drive_tank_jog_left':
        final speed = _argNum(args, 'speed');
        _sendDriveCommand(DriveCommand(setLeft: true, left: speed.toDouble().clamp(-1, 1)));
        break;
      case 'drive_tank_jog_right':
        final speed = _argNum(args, 'speed');
        _sendDriveCommand(DriveCommand(setRight: true, right: speed.toDouble().clamp(-1, 1)));
        break;
      case 'drive_modern_forward':
        final speed = _argNum(args, 'speed');
        _sendDriveCommand(DriveCommand(throttle: speed.toDouble().clamp(0, 1), setThrottle: true));
        break;
      case 'drive_modern_reverse':
        final speed = _argNum(args, 'speed');
        _sendDriveCommand(DriveCommand(throttle: (-speed.toDouble().abs()).clamp(-1, 0), setThrottle: true));
        break;
      case 'drive_modern_steer':
        final direction = _argNum(args, 'direction');
        // Steering in modern drive is handled via left joystick
        _sendDriveCommand(DriveCommand(setLeft: true, left: direction.toDouble() * 0.5));
        break;
      case 'drive_modern_stop':
        _sendDriveCommand(DriveCommand(setThrottle: true, throttle: 0));
        break;
      case 'drive_throttle_increase':
        // Would need to read current throttle first
        _sendDriveCommand(DriveCommand(throttle: 0.1, setThrottle: true));
        break;
      case 'drive_throttle_decrease':
        _sendDriveCommand(DriveCommand(throttle: -0.1, setThrottle: true, setLeft: true, left: 0, setRight: true, right: 0));
        break;
      case 'drive_throttle_set':
        final throttle = _argNum(args, 'throttle');
        _sendDriveCommand(DriveCommand(throttle: throttle.toDouble().clamp(0, 1), setThrottle: true));
        break;
      case 'drive_camera_front_tilt':
        _sendDriveCommand(DriveCommand(frontTilt: 45.0));
        break;
      case 'drive_camera_front_swivel':
        _sendDriveCommand(DriveCommand(frontSwivel: 90.0));
        break;
      case 'drive_camera_rear_tilt':
        _sendDriveCommand(DriveCommand(rearTilt: 90.0));
        break;
      case 'drive_camera_rear_swivel':
        _sendDriveCommand(DriveCommand(rearSwivel: 90.0));
        break;
      case 'drive_set_color':
        final color = args['color'] ?? 'white';
        // Map color name to ProtoColor (simplified)
        ProtoColor protoColor = ProtoColor.PROTO_COLOR_UNDEFINED;
        if (color == 'red') protoColor = ProtoColor.RED;
        else if (color == 'green') protoColor = ProtoColor.GREEN;
        else if (color == 'blue') protoColor = ProtoColor.BLUE;
        else if (color == 'yellow' || color == 'white') protoColor = ProtoColor.UNLIT;
        _sendDriveCommand(DriveCommand(color: protoColor, blink: BoolState.YES));
        break;
      case 'drive_blink_on':
        _sendDriveCommand(DriveCommand(blink: BoolState.YES));
        break;
      case 'drive_blink_off':
        _sendDriveCommand(DriveCommand(blink: BoolState.NO));
        break;
      
      // ============================================================
      // CAMERA OPERATIONS
      // ============================================================
      case 'camera_front_tilt_up':
        _sendDriveCommand(DriveCommand(frontTilt: 45));
        break;
      case 'camera_front_tilt_down':
        _sendDriveCommand(DriveCommand(frontTilt: 15));
        break;
      case 'camera_front_pan_left':
        _sendDriveCommand(DriveCommand(frontSwivel: 45));
        break;
      case 'camera_front_pan_right':
        _sendDriveCommand(DriveCommand(frontSwivel: 135));
        break;
      case 'camera_front_set_tilt':
        final angle = _argNum(args, 'angle', defaultValue: 30.0);
        _sendDriveCommand(DriveCommand(frontTilt: angle.toDouble().clamp(0.0, 60.0)));
        break;
      case 'camera_front_set_swivel':
        final angle = _argNum(args, 'angle', defaultValue: 90.0);
        _sendDriveCommand(DriveCommand(frontSwivel: angle.toDouble().clamp(0.0, 180.0)));
        break;
      case 'camera_rear_tilt_up':
        _sendDriveCommand(DriveCommand(rearTilt: 135.0));
        break;
      case 'camera_rear_tilt_down':
        _sendDriveCommand(DriveCommand(rearTilt: 45.0));
        break;
      case 'camera_rear_pan_left':
        _sendDriveCommand(DriveCommand(rearSwivel: 45.0));
        break;
      case 'camera_rear_pan_right':
        _sendDriveCommand(DriveCommand(rearSwivel: 135.0));
        break;
      case 'camera_rear_set_tilt':
        final angle = _argNum(args, 'angle', defaultValue: 90.0);
        _sendDriveCommand(DriveCommand(rearTilt: angle.toDouble().clamp(0.0, 180.0)));
        break;
      case 'camera_rear_set_swivel':
        final angle = _argNum(args, 'angle', defaultValue: 90.0);
        _sendDriveCommand(DriveCommand(rearSwivel: angle.toDouble().clamp(0.0, 180.0)));
        break;
      
      // ============================================================
      // SCIENCE OPERATIONS
      // ============================================================
      case 'science_emergency_stop':
        _sendScienceCommand(ScienceCommand(stop: true));
        break;
      case 'science_calibrate':
        _sendScienceCommand(ScienceCommand(calibrate: true));
        break;
      case 'science_carousel_next_tube':
        _sendScienceCommand(ScienceCommand(carousel: CarouselCommand.NEXT_TUBE));
        break;
      case 'science_carousel_prev_tube':
        _sendScienceCommand(ScienceCommand(carousel: CarouselCommand.PREV_TUBE));
        break;
      case 'science_carousel_jog':
        final direction = _argNum(args, 'direction');
        _sendScienceCommand(ScienceCommand(carouselMotor: direction.toDouble() * 1000));
        break;
      case 'science_carousel_set_position':
        final position = _argInt(args, 'position');
        // Position would be in steps
        _sendScienceCommand(ScienceCommand(carouselMotor: position.toDouble()));
        break;
      case 'science_auger_start':
        _sendScienceCommand(ScienceCommand(
          auger: AugerCommand(speedRpm: 0.4),
        ));
        break;
      case 'science_auger_stop':
        _sendScienceCommand(ScienceCommand(
          auger: AugerCommand(speedRpm: 0),
        ));
        break;
      case 'science_auger_set_speed':
        final speed = _argNum(args, 'speed');
        _sendScienceCommand(ScienceCommand(
          auger: AugerCommand(speedRpm: speed.toDouble().clamp(0, 0.4)),
        ));
        break;
      case 'science_auger_set_servos':
        final open = args['open'] ?? true;
        _sendScienceCommand(ScienceCommand(
          auger: AugerCommand(
            upperServo: open ? ServoState.SERVO_OPEN : ServoState.SERVO_CLOSE,
            lowerServo: open ? ServoState.SERVO_OPEN : ServoState.SERVO_CLOSE,
          ),
        ));
        break;
      case 'science_pumps_on':
        _sendScienceCommand(ScienceCommand(pumps: PumpState.PUMP_ON));
        break;
      case 'science_pumps_off':
        _sendScienceCommand(ScienceCommand(pumps: PumpState.PUMP_OFF));
        break;
      case 'science_slider_jog':
        final direction = _argNum(args, 'direction');
        _sendScienceCommand(ScienceCommand(linearSlider: direction.toDouble() * 1000));
        break;
      case 'science_slider_set_position':
        final position = _argInt(args, 'position');
        _sendScienceCommand(ScienceCommand(linearSlider: position.toDouble()));
        break;
      case 'science_start_collection':
        _sendScienceCommand(ScienceCommand(
          state: ScienceState.COLLECT_DATA,
        ));
        break;
      case 'science_stop_collection':
        _sendScienceCommand(ScienceCommand(
          state: ScienceState.STOP_COLLECTING,
        ));
        break;
      
      // ============================================================
      // RELAY OPERATIONS
      // ============================================================
      case 'relay_set_mechanical_override':
        final state = args['state'] == true ||
            (args['state'] is String && args['state'].toLowerCase() == 'true');
        _sendRelaysCommand(RelaysCommand(
          bypass: state ? BoolState.YES : BoolState.NO,
        ));
        break;
      case 'relay_front_left_on':
        _sendRelaysCommand(RelaysCommand(frontLeftMotor: BoolState.YES));
        break;
      case 'relay_front_left_off':
        _sendRelaysCommand(RelaysCommand(frontLeftMotor: BoolState.NO));
        break;
      case 'relay_front_right_on':
        _sendRelaysCommand(RelaysCommand(frontRightMotor: BoolState.YES));
        break;
      case 'relay_front_right_off':
        _sendRelaysCommand(RelaysCommand(frontRightMotor: BoolState.NO));
        break;
      case 'relay_middle_left_on':
        _sendRelaysCommand(RelaysCommand(middleLeftMotor: BoolState.YES));
        break;
      case 'relay_middle_left_off':
        _sendRelaysCommand(RelaysCommand(middleLeftMotor: BoolState.NO));
        break;
      case 'relay_middle_right_on':
        _sendRelaysCommand(RelaysCommand(middleRightMotor: BoolState.YES));
        break;
      case 'relay_middle_right_off':
        _sendRelaysCommand(RelaysCommand(middleRightMotor: BoolState.NO));
        break;
      case 'relay_back_left_on':
        _sendRelaysCommand(RelaysCommand(backLeftMotor: BoolState.YES));
        break;
      case 'relay_back_left_off':
        _sendRelaysCommand(RelaysCommand(backLeftMotor: BoolState.NO));
        break;
      case 'relay_back_right_on':
        _sendRelaysCommand(RelaysCommand(backRightMotor: BoolState.YES));
        break;
      case 'relay_back_right_off':
        _sendRelaysCommand(RelaysCommand(backRightMotor: BoolState.NO));
        break;
      case 'relay_arm_on':
        _sendRelaysCommand(RelaysCommand(arm: BoolState.YES));
        break;
      case 'relay_arm_off':
        _sendRelaysCommand(RelaysCommand(arm: BoolState.NO));
        break;
      case 'relay_science_on':
        _sendRelaysCommand(RelaysCommand(science: BoolState.YES));
        break;
      case 'relay_science_off':
        _sendRelaysCommand(RelaysCommand(science: BoolState.NO));
        break;
      
      // ============================================================
      // ANTENNA / BASE STATION OPERATIONS
      // ============================================================
      case 'antenna_set_track_rover':
        _sendBaseStationCommand(BaseStationCommand(
          mode: AntennaControlMode.TRACK_ROVER,
        ));
        break;
      case 'antenna_set_manual':
        _sendBaseStationCommand(BaseStationCommand(
          mode: AntennaControlMode.MANUAL_CONTROL,
        ));
        break;
      case 'antenna_manual_swivel_jog':
        final direction = _argNum(args, 'direction');
        _sendBaseStationCommand(BaseStationCommand(
          mode: AntennaControlMode.MANUAL_CONTROL,
          manualCommand: AntennaFirmwareCommand(
            swivel: MotorCommand(moveRadians: direction.toDouble() * 0.005),
          ),
        ));
        break;
      case 'antenna_manual_pitch_jog':
        final direction = _argNum(args, 'direction');
        _sendBaseStationCommand(BaseStationCommand(
          mode: AntennaControlMode.MANUAL_CONTROL,
          manualCommand: AntennaFirmwareCommand(
            pitch: MotorCommand(moveRadians: direction.toDouble() * 0.005),
          ),
        ));
        break;
      case 'antenna_manual_swivel_set_angle':
        final angle = _argNum(args, 'angle');
        _sendBaseStationCommand(BaseStationCommand(
          mode: AntennaControlMode.MANUAL_CONTROL,
          manualCommand: AntennaFirmwareCommand(
            swivel: MotorCommand(angle: angle.toDouble()),
          ),
        ));
        break;
      case 'antenna_manual_pitch_set_angle':
        final angle = _argNum(args, 'angle');
        _sendBaseStationCommand(BaseStationCommand(
          mode: AntennaControlMode.MANUAL_CONTROL,
          manualCommand: AntennaFirmwareCommand(
            pitch: MotorCommand(angle: angle.toDouble()),
          ),
        ));
        break;
      
      // ============================================================
      // SUBSYSTEMS
      // ============================================================
      case 'subsystems_get_status':
        // Read-only, handled by _isReadOnlyBinding
        break;
      case 'subsystems_check_sensors':
        // Read-only, would get status from metrics
        break;
      
      // ============================================================
      // VISION
      // ============================================================
      case 'vision_get_aruco_tags':
        // Read-only, handled by _isReadOnlyBinding
        break;
      case 'vision_get_object_detections':
        // Read-only, handled by _isReadOnlyBinding
        break;
      case 'vision_focus_on_tag':
        // Would need to calculate camera angles to focus on tag
        // This is complex and would require vision processing
        break;
      
      // ============================================================
      // POSITION
      // ============================================================
      case 'position_get_gps':
        // Read-only, handled by _isReadOnlyBinding
        break;
      case 'position_get_orientation':
        // Read-only, handled by _isReadOnlyBinding
        break;
      case 'position_get_distance_to_base':
        // Read-only, handled by _isReadOnlyBinding
        break;
      
      // ============================================================
      // VITALS
      // ============================================================
      case 'vitals_get_battery_voltage':
        // Read-only, handled by _isReadOnlyBinding
        break;
      case 'vitals_get_battery_current':
        // Read-only, handled by _isReadOnlyBinding
        break;
      case 'vitals_get_battery_temperature':
        // Read-only, handled by _isReadOnlyBinding
        break;
      case 'vitals_get_battery_percentage':
        // Read-only, handled by _isReadOnlyBinding
        break;
      
      // ============================================================
      // SYSTEM
      // ============================================================
      case 'system_get_rover_status':
        // Read-only, handled by _isReadOnlyBinding
        break;
      case 'system_get_all_telemetry':
        // Read-only, handled by _isReadOnlyBinding
        break;
      case 'system_enter_safemode':
        // Stop everything - emergency safe mode
        _sendArmCommand(ArmCommand(stop: true));
        _sendDriveCommand(DriveCommand(setThrottle: true, throttle: 0));
        _sendDriveCommand(DriveCommand(setLeft: true, left: 0));
        _sendDriveCommand(DriveCommand(setRight: true, right: 0));
        _sendScienceCommand(ScienceCommand(stop: true));
        break;
      case 'system_exit_safemode':
        // Re-enable operations (would need to restore previous state)
        break;
      case 'system_home_all':
        // Would need to move all subsystems to home positions
        // This is complex and requires coordination
        break;
      case 'system_reset':
        // Would send reset commands to all subsystems
        _sendArmCommand(ArmCommand(stop: true));
        _sendDriveCommand(DriveCommand(setThrottle: true, throttle: 0));
        _sendScienceCommand(ScienceCommand(stop: true));
        break;

      // ============================================================
      // DASHBOARD VIEW OPERATIONS
      // ============================================================
      case 'view_show_page':
        final name = args['page']?.toString() ?? '';
        final view = _resolveView(name);
        if (view == null) {
          models.home.setMessage(
            severity: Severity.error,
            text: 'The AI asked for "$name", which is not a dashboard view.',
          );
          _lastActionResult =
              'Could not find a dashboard view named "$name".';
          break;
        }
        final index = _targetPane(args);
        if (!models.views.replaceView(index, view)) {
          _lastActionResult = '"${view.name}" is already on the dashboard.';
          break;
        }
        _lastActionResult = 'Showing "${view.name}" in pane ${index + 1}.';
        break;
      case 'view_set_layout':
        final panes = _argInt(args, 'panes', defaultValue: 1);
        if (!const {1, 2, 3, 4, 8}.contains(panes)) {
          models.home.setMessage(
            severity: Severity.error,
            text: 'The AI asked for $panes panes, which the layout does not '
                'support. Use 1, 2, 3, 4, or 8.',
          );
          _lastActionResult =
              'The dashboard can only show 1, 2, 3, 4, or 8 panes.';
          break;
        }
        models.views.setNumViews(panes);
        _lastActionResult = 'The dashboard is split into $panes panes.';
        break;
      case 'view_clear_pane':
        final index = _targetPane(args);
        models.views.replaceView(
          index,
          DashboardView.blank,
          ignoreErrors: true,
        );
        _lastActionResult = 'Cleared pane ${index + 1}.';
        break;
      case 'view_add_page':
        final name = args['page']?.toString() ?? '';
        final view = _resolveView(name);
        if (view == null) {
          models.home.setMessage(
            severity: Severity.error,
            text: 'The AI asked for "$name", which is not a dashboard view.',
          );
          _lastActionResult =
              'Could not find a dashboard view named "$name".';
          break;
        }
        final blank = models.views.views.indexWhere(
          (existing) => existing.name == Routes.blank,
        );
        if (blank >= 0) {
          if (models.views.replaceView(blank, view, ignoreErrors: true)) {
            _lastActionResult = 'Opened "${view.name}" in pane ${blank + 1}.';
          } else {
            _lastActionResult = '"${view.name}" is already on the dashboard.';
          }
          break;
        }
        final count = models.views.views.length;
        if (count < 4) {
          final panes = count + 1;
          models.views.setNumViews(panes);
          models.views.replaceView(count, view, ignoreErrors: true);
          _lastActionResult =
              'Split the dashboard into $panes panes and opened "${view.name}".';
          break;
        }
        final index = _targetPane(const <String, dynamic>{});
        if (models.views.replaceView(index, view)) {
          _lastActionResult =
              'All panes were in use, so pane ${index + 1} now shows "${view.name}".';
        } else {
          _lastActionResult = '"${view.name}" is already on the dashboard.';
        }
        break;

      default:
        // Unknown binding - do nothing
        break;
    }

    return null;
  }

  /// Sends an arm command.
  void _sendArmCommand(ArmCommand command) {
    models.messages.sendMessage(command);
  }

  /// Sends a drive command.
  void _sendDriveCommand(DriveCommand command) {
    models.messages.sendMessage(command);
  }

  /// Sends a science command.
  void _sendScienceCommand(ScienceCommand command) {
    models.messages.sendMessage(command);
  }

  /// Sends a relays command.
  void _sendRelaysCommand(RelaysCommand command) {
    models.messages.sendMessage(command);
  }

  /// Sends a base station command.
  void _sendBaseStationCommand(BaseStationCommand command) {
    models.messages.sendMessage(command);
  }

  /// Confirms a pending action.
  Future<void> _confirmAction(String toolCallId, String bindingName,
      Map<String, dynamic> args) async {
    await _performAction(bindingName, args, toolCallId);
    _pendingActions.removeWhere((a) => a.id == toolCallId);
    _notify();
  }

  /// Cancels a pending action.
  void _cancelAction(String toolCallId) {
    _pendingActions.removeWhere((a) => a.id == toolCallId);
    _notify();
  }

  /// Confirms an action by ID.
  void confirmAction(String actionId) {
    final action =
        _pendingActions.where((a) => a.id == actionId).firstOrNull;
    if (action != null) {
      unawaited(
        _confirmAction(action.id, action.bindingName, action.arguments),
      );
    }
  }

  /// Cancels an action by ID.
  void cancelAction(String actionId) {
    final action =
        _pendingActions.where((a) => a.id == actionId).firstOrNull;
    if (action != null) {
      _cancelAction(action.id);
    }
  }

  /// Clears the conversation.
  void clearConversation() {
    _messages
      ..clear()
      ..add(AiMessage.assistant(_greeting));
    _notify();
  }

  /// Scrolls to the bottom of the message list.
  Future<void> _scrollToBottom() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  /// Sets the model name.
  void setModel(String modelName) {
    _modelName = modelName;
    _ollama.model = modelName;
    _notify();
  }

  /// Refreshes the Ollama availability status.
  Future<void> refreshAvailability() async {
    await _checkOllamaAvailability();
  }
}

/// A pending action that requires user confirmation.
class PendingAction {
  /// Creates a pending action.
  const PendingAction({
    required this.id,
    required this.bindingName,
    required this.arguments,
    required this.description,
    required this.onConfirm,
    required this.onCancel,
  });

  /// The unique ID of the action.
  final String id;

  /// The binding name being executed.
  final String bindingName;

  /// The arguments for the action.
  final Map<String, dynamic> arguments;

  /// A human-readable description of the action.
  final String description;

  /// Called when the user confirms the action.
  final VoidCallback onConfirm;

  /// Called when the user cancels the action.
  final VoidCallback onCancel;
}
