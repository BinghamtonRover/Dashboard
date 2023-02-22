///
//  Generated code. Do not modify.
//  source: arm.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use positionDescriptor instead')
const Position$json = const {
  '1': 'Position',
  '2': const [
    const {'1': 'x', '3': 1, '4': 1, '5': 5, '10': 'x'},
    const {'1': 'y', '3': 2, '4': 1, '5': 5, '10': 'y'},
    const {'1': 'z', '3': 3, '4': 1, '5': 5, '10': 'z'},
  ],
};

/// Descriptor for `Position`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List positionDescriptor = $convert.base64Decode('CghQb3NpdGlvbhIMCgF4GAEgASgFUgF4EgwKAXkYAiABKAVSAXkSDAoBehgDIAEoBVIBeg==');
@$core.Deprecated('Use armCommandDescriptor instead')
const ArmCommand$json = const {
  '1': 'ArmCommand',
  '2': const [
    const {'1': 'calibrate', '3': 2, '4': 1, '5': 8, '10': 'calibrate'},
    const {'1': 'swivel', '3': 3, '4': 1, '5': 2, '10': 'swivel'},
    const {'1': 'extend', '3': 4, '4': 1, '5': 2, '10': 'extend'},
    const {'1': 'lift', '3': 5, '4': 1, '5': 2, '10': 'lift'},
    const {'1': 'precise_swivel', '3': 6, '4': 1, '5': 2, '10': 'preciseSwivel'},
    const {'1': 'precise_lift', '3': 7, '4': 1, '5': 2, '10': 'preciseLift'},
    const {'1': 'precise_extend', '3': 8, '4': 1, '5': 2, '10': 'preciseExtend'},
    const {'1': 'move_x', '3': 9, '4': 1, '5': 2, '10': 'moveX'},
    const {'1': 'move_y', '3': 10, '4': 1, '5': 2, '10': 'moveY'},
    const {'1': 'move_z', '3': 11, '4': 1, '5': 2, '10': 'moveZ'},
    const {'1': 'move_swivel', '3': 12, '4': 1, '5': 2, '10': 'moveSwivel'},
    const {'1': 'move_shoulder', '3': 13, '4': 1, '5': 2, '10': 'moveShoulder'},
    const {'1': 'move_elbow', '3': 14, '4': 1, '5': 2, '10': 'moveElbow'},
  ],
};

/// Descriptor for `ArmCommand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List armCommandDescriptor = $convert.base64Decode('CgpBcm1Db21tYW5kEhwKCWNhbGlicmF0ZRgCIAEoCFIJY2FsaWJyYXRlEhYKBnN3aXZlbBgDIAEoAlIGc3dpdmVsEhYKBmV4dGVuZBgEIAEoAlIGZXh0ZW5kEhIKBGxpZnQYBSABKAJSBGxpZnQSJQoOcHJlY2lzZV9zd2l2ZWwYBiABKAJSDXByZWNpc2VTd2l2ZWwSIQoMcHJlY2lzZV9saWZ0GAcgASgCUgtwcmVjaXNlTGlmdBIlCg5wcmVjaXNlX2V4dGVuZBgIIAEoAlINcHJlY2lzZUV4dGVuZBIVCgZtb3ZlX3gYCSABKAJSBW1vdmVYEhUKBm1vdmVfeRgKIAEoAlIFbW92ZVkSFQoGbW92ZV96GAsgASgCUgVtb3ZlWhIfCgttb3ZlX3N3aXZlbBgMIAEoAlIKbW92ZVN3aXZlbBIjCg1tb3ZlX3Nob3VsZGVyGA0gASgCUgxtb3ZlU2hvdWxkZXISHQoKbW92ZV9lbGJvdxgOIAEoAlIJbW92ZUVsYm93');
@$core.Deprecated('Use motorStatusDescriptor instead')
const MotorStatus$json = const {
  '1': 'MotorStatus',
  '2': const [
    const {'1': 'is_moving', '3': 1, '4': 1, '5': 8, '10': 'isMoving'},
    const {'1': 'angle', '3': 2, '4': 1, '5': 2, '10': 'angle'},
    const {'1': 'temperature', '3': 3, '4': 1, '5': 2, '10': 'temperature'},
  ],
};

/// Descriptor for `MotorStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List motorStatusDescriptor = $convert.base64Decode('CgtNb3RvclN0YXR1cxIbCglpc19tb3ZpbmcYASABKAhSCGlzTW92aW5nEhQKBWFuZ2xlGAIgASgCUgVhbmdsZRIgCgt0ZW1wZXJhdHVyZRgDIAEoAlILdGVtcGVyYXR1cmU=');
@$core.Deprecated('Use armDataDescriptor instead')
const ArmData$json = const {
  '1': 'ArmData',
  '2': const [
    const {'1': 'currentPosition', '3': 1, '4': 1, '5': 11, '6': '.Position', '10': 'currentPosition'},
    const {'1': 'targetPosition', '3': 2, '4': 1, '5': 11, '6': '.Position', '10': 'targetPosition'},
    const {'1': 'base', '3': 3, '4': 1, '5': 11, '6': '.MotorStatus', '10': 'base'},
    const {'1': 'shoulder', '3': 4, '4': 1, '5': 11, '6': '.MotorStatus', '10': 'shoulder'},
    const {'1': 'elbow', '3': 5, '4': 1, '5': 11, '6': '.MotorStatus', '10': 'elbow'},
  ],
};

/// Descriptor for `ArmData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List armDataDescriptor = $convert.base64Decode('CgdBcm1EYXRhEjMKD2N1cnJlbnRQb3NpdGlvbhgBIAEoCzIJLlBvc2l0aW9uUg9jdXJyZW50UG9zaXRpb24SMQoOdGFyZ2V0UG9zaXRpb24YAiABKAsyCS5Qb3NpdGlvblIOdGFyZ2V0UG9zaXRpb24SIAoEYmFzZRgDIAEoCzIMLk1vdG9yU3RhdHVzUgRiYXNlEigKCHNob3VsZGVyGAQgASgLMgwuTW90b3JTdGF0dXNSCHNob3VsZGVyEiIKBWVsYm93GAUgASgLMgwuTW90b3JTdGF0dXNSBWVsYm93');
@$core.Deprecated('Use gripperDataDescriptor instead')
const GripperData$json = const {
  '1': 'GripperData',
  '2': const [
    const {'1': 'rotation', '3': 1, '4': 1, '5': 2, '10': 'rotation'},
    const {'1': 'swivel', '3': 2, '4': 1, '5': 2, '10': 'swivel'},
    const {'1': 'pinch', '3': 3, '4': 1, '5': 2, '10': 'pinch'},
    const {'1': 'motor_temperature', '3': 4, '4': 1, '5': 2, '10': 'motorTemperature'},
  ],
};

/// Descriptor for `GripperData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gripperDataDescriptor = $convert.base64Decode('CgtHcmlwcGVyRGF0YRIaCghyb3RhdGlvbhgBIAEoAlIIcm90YXRpb24SFgoGc3dpdmVsGAIgASgCUgZzd2l2ZWwSFAoFcGluY2gYAyABKAJSBXBpbmNoEisKEW1vdG9yX3RlbXBlcmF0dXJlGAQgASgCUhBtb3RvclRlbXBlcmF0dXJl');
@$core.Deprecated('Use gripperCommandDescriptor instead')
const GripperCommand$json = const {
  '1': 'GripperCommand',
  '2': const [
    const {'1': 'move_rotate', '3': 1, '4': 1, '5': 2, '10': 'moveRotate'},
    const {'1': 'move_lift', '3': 2, '4': 1, '5': 2, '10': 'moveLift'},
    const {'1': 'move_gripper', '3': 3, '4': 1, '5': 2, '10': 'moveGripper'},
  ],
};

/// Descriptor for `GripperCommand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gripperCommandDescriptor = $convert.base64Decode('Cg5HcmlwcGVyQ29tbWFuZBIfCgttb3ZlX3JvdGF0ZRgBIAEoAlIKbW92ZVJvdGF0ZRIbCgltb3ZlX2xpZnQYAiABKAJSCG1vdmVMaWZ0EiEKDG1vdmVfZ3JpcHBlchgDIAEoAlILbW92ZUdyaXBwZXI=');
@$core.Deprecated('Use hreiDataDescriptor instead')
const HreiData$json = const {
  '1': 'HreiData',
  '2': const [
    const {'1': 'arm_data', '3': 1, '4': 1, '5': 11, '6': '.ArmData', '10': 'armData'},
    const {'1': 'gripper_data', '3': 2, '4': 1, '5': 11, '6': '.GripperData', '10': 'gripperData'},
  ],
};

/// Descriptor for `HreiData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hreiDataDescriptor = $convert.base64Decode('CghIcmVpRGF0YRIjCghhcm1fZGF0YRgBIAEoCzIILkFybURhdGFSB2FybURhdGESLwoMZ3JpcHBlcl9kYXRhGAIgASgLMgwuR3JpcHBlckRhdGFSC2dyaXBwZXJEYXRh');
@$core.Deprecated('Use hreiCommandDescriptor instead')
const HreiCommand$json = const {
  '1': 'HreiCommand',
  '2': const [
    const {'1': 'arm_command', '3': 1, '4': 1, '5': 11, '6': '.ArmCommand', '10': 'armCommand'},
    const {'1': 'gripper_command', '3': 2, '4': 1, '5': 11, '6': '.GripperCommand', '10': 'gripperCommand'},
  ],
};

/// Descriptor for `HreiCommand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hreiCommandDescriptor = $convert.base64Decode('CgtIcmVpQ29tbWFuZBIsCgthcm1fY29tbWFuZBgBIAEoCzILLkFybUNvbW1hbmRSCmFybUNvbW1hbmQSOAoPZ3JpcHBlcl9jb21tYW5kGAIgASgLMg8uR3JpcHBlckNvbW1hbmRSDmdyaXBwZXJDb21tYW5k');
