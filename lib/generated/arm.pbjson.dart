///
//  Generated code. Do not modify.
//  source: arm.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use motorDirectionDescriptor instead')
const MotorDirection$json = const {
  '1': 'MotorDirection',
  '2': const [
    const {'1': 'MOTOR_DIRECTION_UNDEFINED', '2': 0},
    const {'1': 'UP', '2': 1},
    const {'1': 'DOWN', '2': 2},
    const {'1': 'LEFT', '2': 3},
    const {'1': 'RIGHT', '2': 4},
    const {'1': 'CLOCKWISE', '2': 5},
    const {'1': 'COUNTER_CLOCKWISE', '2': 6},
    const {'1': 'OPENING', '2': 7},
    const {'1': 'CLOSING', '2': 8},
    const {'1': 'NOT_MOVING', '2': 9},
  ],
};

/// Descriptor for `MotorDirection`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List motorDirectionDescriptor = $convert.base64Decode('Cg5Nb3RvckRpcmVjdGlvbhIdChlNT1RPUl9ESVJFQ1RJT05fVU5ERUZJTkVEEAASBgoCVVAQARIICgRET1dOEAISCAoETEVGVBADEgkKBVJJR0hUEAQSDQoJQ0xPQ0tXSVNFEAUSFQoRQ09VTlRFUl9DTE9DS1dJU0UQBhILCgdPUEVOSU5HEAcSCwoHQ0xPU0lORxAIEg4KCk5PVF9NT1ZJTkcQCQ==');
@$core.Deprecated('Use coordinatesDescriptor instead')
const Coordinates$json = const {
  '1': 'Coordinates',
  '2': const [
    const {'1': 'x', '3': 1, '4': 1, '5': 2, '10': 'x'},
    const {'1': 'y', '3': 2, '4': 1, '5': 2, '10': 'y'},
    const {'1': 'z', '3': 3, '4': 1, '5': 2, '10': 'z'},
  ],
};

/// Descriptor for `Coordinates`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List coordinatesDescriptor = $convert.base64Decode('CgtDb29yZGluYXRlcxIMCgF4GAEgASgCUgF4EgwKAXkYAiABKAJSAXkSDAoBehgDIAEoAlIBeg==');
@$core.Deprecated('Use motorDataDescriptor instead')
const MotorData$json = const {
  '1': 'MotorData',
  '2': const [
    const {'1': 'is_moving', '3': 1, '4': 1, '5': 8, '10': 'isMoving'},
    const {'1': 'is_limit_switch_pressed', '3': 2, '4': 1, '5': 8, '10': 'isLimitSwitchPressed'},
    const {'1': 'direction', '3': 3, '4': 1, '5': 14, '6': '.MotorDirection', '10': 'direction'},
    const {'1': 'current_step', '3': 4, '4': 1, '5': 5, '10': 'currentStep'},
    const {'1': 'target_step', '3': 5, '4': 1, '5': 5, '10': 'targetStep'},
    const {'1': 'angle', '3': 6, '4': 1, '5': 2, '10': 'angle'},
  ],
};

/// Descriptor for `MotorData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List motorDataDescriptor = $convert.base64Decode('CglNb3RvckRhdGESGwoJaXNfbW92aW5nGAEgASgIUghpc01vdmluZxI1Chdpc19saW1pdF9zd2l0Y2hfcHJlc3NlZBgCIAEoCFIUaXNMaW1pdFN3aXRjaFByZXNzZWQSLQoJZGlyZWN0aW9uGAMgASgOMg8uTW90b3JEaXJlY3Rpb25SCWRpcmVjdGlvbhIhCgxjdXJyZW50X3N0ZXAYBCABKAVSC2N1cnJlbnRTdGVwEh8KC3RhcmdldF9zdGVwGAUgASgFUgp0YXJnZXRTdGVwEhQKBWFuZ2xlGAYgASgCUgVhbmdsZQ==');
@$core.Deprecated('Use motorCommandDescriptor instead')
const MotorCommand$json = const {
  '1': 'MotorCommand',
  '2': const [
    const {'1': 'move_steps', '3': 1, '4': 1, '5': 5, '10': 'moveSteps'},
    const {'1': 'move_radians', '3': 2, '4': 1, '5': 2, '10': 'moveRadians'},
  ],
};

/// Descriptor for `MotorCommand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List motorCommandDescriptor = $convert.base64Decode('CgxNb3RvckNvbW1hbmQSHQoKbW92ZV9zdGVwcxgBIAEoBVIJbW92ZVN0ZXBzEiEKDG1vdmVfcmFkaWFucxgCIAEoAlILbW92ZVJhZGlhbnM=');
@$core.Deprecated('Use armDataDescriptor instead')
const ArmData$json = const {
  '1': 'ArmData',
  '2': const [
    const {'1': 'currentPosition', '3': 1, '4': 1, '5': 11, '6': '.Coordinates', '10': 'currentPosition'},
    const {'1': 'targetPosition', '3': 2, '4': 1, '5': 11, '6': '.Coordinates', '10': 'targetPosition'},
    const {'1': 'base', '3': 3, '4': 1, '5': 11, '6': '.MotorData', '10': 'base'},
    const {'1': 'shoulder', '3': 4, '4': 1, '5': 11, '6': '.MotorData', '10': 'shoulder'},
    const {'1': 'elbow', '3': 5, '4': 1, '5': 11, '6': '.MotorData', '10': 'elbow'},
  ],
};

/// Descriptor for `ArmData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List armDataDescriptor = $convert.base64Decode('CgdBcm1EYXRhEjYKD2N1cnJlbnRQb3NpdGlvbhgBIAEoCzIMLkNvb3JkaW5hdGVzUg9jdXJyZW50UG9zaXRpb24SNAoOdGFyZ2V0UG9zaXRpb24YAiABKAsyDC5Db29yZGluYXRlc1IOdGFyZ2V0UG9zaXRpb24SHgoEYmFzZRgDIAEoCzIKLk1vdG9yRGF0YVIEYmFzZRImCghzaG91bGRlchgEIAEoCzIKLk1vdG9yRGF0YVIIc2hvdWxkZXISIAoFZWxib3cYBSABKAsyCi5Nb3RvckRhdGFSBWVsYm93');
@$core.Deprecated('Use armCommandDescriptor instead')
const ArmCommand$json = const {
  '1': 'ArmCommand',
  '2': const [
    const {'1': 'stop', '3': 1, '4': 1, '5': 8, '10': 'stop'},
    const {'1': 'calibrate', '3': 2, '4': 1, '5': 8, '10': 'calibrate'},
    const {'1': 'swivel', '3': 3, '4': 1, '5': 11, '6': '.MotorCommand', '10': 'swivel'},
    const {'1': 'shoulder', '3': 4, '4': 1, '5': 11, '6': '.MotorCommand', '10': 'shoulder'},
    const {'1': 'elbow', '3': 5, '4': 1, '5': 11, '6': '.MotorCommand', '10': 'elbow'},
    const {'1': 'gripper_lift', '3': 6, '4': 1, '5': 11, '6': '.MotorCommand', '10': 'gripperLift'},
    const {'1': 'ik_x', '3': 7, '4': 1, '5': 2, '10': 'ikX'},
    const {'1': 'ik_y', '3': 8, '4': 1, '5': 2, '10': 'ikY'},
    const {'1': 'ik_z', '3': 9, '4': 1, '5': 2, '10': 'ikZ'},
    const {'1': 'jab', '3': 10, '4': 1, '5': 8, '10': 'jab'},
  ],
};

/// Descriptor for `ArmCommand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List armCommandDescriptor = $convert.base64Decode('CgpBcm1Db21tYW5kEhIKBHN0b3AYASABKAhSBHN0b3ASHAoJY2FsaWJyYXRlGAIgASgIUgljYWxpYnJhdGUSJQoGc3dpdmVsGAMgASgLMg0uTW90b3JDb21tYW5kUgZzd2l2ZWwSKQoIc2hvdWxkZXIYBCABKAsyDS5Nb3RvckNvbW1hbmRSCHNob3VsZGVyEiMKBWVsYm93GAUgASgLMg0uTW90b3JDb21tYW5kUgVlbGJvdxIwCgxncmlwcGVyX2xpZnQYBiABKAsyDS5Nb3RvckNvbW1hbmRSC2dyaXBwZXJMaWZ0EhEKBGlrX3gYByABKAJSA2lrWBIRCgRpa195GAggASgCUgNpa1kSEQoEaWtfehgJIAEoAlIDaWtaEhAKA2phYhgKIAEoCFIDamFi');
@$core.Deprecated('Use gripperDataDescriptor instead')
const GripperData$json = const {
  '1': 'GripperData',
  '2': const [
    const {'1': 'lift', '3': 1, '4': 1, '5': 11, '6': '.MotorData', '10': 'lift'},
    const {'1': 'rotate', '3': 2, '4': 1, '5': 11, '6': '.MotorData', '10': 'rotate'},
    const {'1': 'pinch', '3': 3, '4': 1, '5': 11, '6': '.MotorData', '10': 'pinch'},
  ],
};

/// Descriptor for `GripperData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gripperDataDescriptor = $convert.base64Decode('CgtHcmlwcGVyRGF0YRIeCgRsaWZ0GAEgASgLMgouTW90b3JEYXRhUgRsaWZ0EiIKBnJvdGF0ZRgCIAEoCzIKLk1vdG9yRGF0YVIGcm90YXRlEiAKBXBpbmNoGAMgASgLMgouTW90b3JEYXRhUgVwaW5jaA==');
@$core.Deprecated('Use gripperCommandDescriptor instead')
const GripperCommand$json = const {
  '1': 'GripperCommand',
  '2': const [
    const {'1': 'stop', '3': 1, '4': 1, '5': 8, '10': 'stop'},
    const {'1': 'calibrate', '3': 2, '4': 1, '5': 8, '10': 'calibrate'},
    const {'1': 'lift', '3': 3, '4': 1, '5': 11, '6': '.MotorCommand', '10': 'lift'},
    const {'1': 'rotate', '3': 4, '4': 1, '5': 11, '6': '.MotorCommand', '10': 'rotate'},
    const {'1': 'pinch', '3': 5, '4': 1, '5': 11, '6': '.MotorCommand', '10': 'pinch'},
    const {'1': 'open', '3': 6, '4': 1, '5': 8, '10': 'open'},
    const {'1': 'close', '3': 7, '4': 1, '5': 8, '10': 'close'},
    const {'1': 'spin', '3': 8, '4': 1, '5': 8, '10': 'spin'},
  ],
};

/// Descriptor for `GripperCommand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gripperCommandDescriptor = $convert.base64Decode('Cg5HcmlwcGVyQ29tbWFuZBISCgRzdG9wGAEgASgIUgRzdG9wEhwKCWNhbGlicmF0ZRgCIAEoCFIJY2FsaWJyYXRlEiEKBGxpZnQYAyABKAsyDS5Nb3RvckNvbW1hbmRSBGxpZnQSJQoGcm90YXRlGAQgASgLMg0uTW90b3JDb21tYW5kUgZyb3RhdGUSIwoFcGluY2gYBSABKAsyDS5Nb3RvckNvbW1hbmRSBXBpbmNoEhIKBG9wZW4YBiABKAhSBG9wZW4SFAoFY2xvc2UYByABKAhSBWNsb3NlEhIKBHNwaW4YCCABKAhSBHNwaW4=');
