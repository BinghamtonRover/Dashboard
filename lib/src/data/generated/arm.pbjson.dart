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
@$core.Deprecated('Use armCommandDescriptor instead')
const ArmCommand$json = const {
  '1': 'ArmCommand',
  '2': const [
    const {'1': 'stop', '3': 1, '4': 1, '5': 8, '10': 'stop'},
    const {'1': 'calibrate', '3': 2, '4': 1, '5': 8, '10': 'calibrate'},
    const {'1': 'move_swivel', '3': 3, '4': 1, '5': 2, '10': 'moveSwivel'},
    const {'1': 'move_shoulder', '3': 4, '4': 1, '5': 2, '10': 'moveShoulder'},
    const {'1': 'move_elbow', '3': 5, '4': 1, '5': 2, '10': 'moveElbow'},
    const {'1': 'move_x', '3': 6, '4': 1, '5': 2, '10': 'moveX'},
    const {'1': 'move_y', '3': 7, '4': 1, '5': 2, '10': 'moveY'},
    const {'1': 'move_z', '3': 8, '4': 1, '5': 2, '10': 'moveZ'},
    const {'1': 'has_x', '3': 9, '4': 1, '5': 8, '10': 'hasX'},
    const {'1': 'has_y', '3': 10, '4': 1, '5': 8, '10': 'hasY'},
    const {'1': 'has_z', '3': 11, '4': 1, '5': 8, '10': 'hasZ'},
  ],
};

/// Descriptor for `ArmCommand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List armCommandDescriptor = $convert.base64Decode('CgpBcm1Db21tYW5kEhIKBHN0b3AYASABKAhSBHN0b3ASHAoJY2FsaWJyYXRlGAIgASgIUgljYWxpYnJhdGUSHwoLbW92ZV9zd2l2ZWwYAyABKAJSCm1vdmVTd2l2ZWwSIwoNbW92ZV9zaG91bGRlchgEIAEoAlIMbW92ZVNob3VsZGVyEh0KCm1vdmVfZWxib3cYBSABKAJSCW1vdmVFbGJvdxIVCgZtb3ZlX3gYBiABKAJSBW1vdmVYEhUKBm1vdmVfeRgHIAEoAlIFbW92ZVkSFQoGbW92ZV96GAggASgCUgVtb3ZlWhITCgVoYXNfeBgJIAEoCFIEaGFzWBITCgVoYXNfeRgKIAEoCFIEaGFzWRITCgVoYXNfehgLIAEoCFIEaGFzWg==');
@$core.Deprecated('Use gripperDataDescriptor instead')
const GripperData$json = const {
  '1': 'GripperData',
  '2': const [
    const {'1': 'rotate', '3': 1, '4': 1, '5': 11, '6': '.MotorStatus', '10': 'rotate'},
    const {'1': 'lift', '3': 2, '4': 1, '5': 11, '6': '.MotorStatus', '10': 'lift'},
    const {'1': 'pinch', '3': 3, '4': 1, '5': 11, '6': '.MotorStatus', '10': 'pinch'},
  ],
};

/// Descriptor for `GripperData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gripperDataDescriptor = $convert.base64Decode('CgtHcmlwcGVyRGF0YRIkCgZyb3RhdGUYASABKAsyDC5Nb3RvclN0YXR1c1IGcm90YXRlEiAKBGxpZnQYAiABKAsyDC5Nb3RvclN0YXR1c1IEbGlmdBIiCgVwaW5jaBgDIAEoCzIMLk1vdG9yU3RhdHVzUgVwaW5jaA==');
@$core.Deprecated('Use gripperCommandDescriptor instead')
const GripperCommand$json = const {
  '1': 'GripperCommand',
  '2': const [
    const {'1': 'stop', '3': 1, '4': 1, '5': 8, '10': 'stop'},
    const {'1': 'calibrate', '3': 2, '4': 1, '5': 8, '10': 'calibrate'},
    const {'1': 'move_rotate', '3': 3, '4': 1, '5': 2, '10': 'moveRotate'},
    const {'1': 'move_lift', '3': 4, '4': 1, '5': 2, '10': 'moveLift'},
    const {'1': 'move_gripper', '3': 5, '4': 1, '5': 2, '10': 'moveGripper'},
  ],
};

/// Descriptor for `GripperCommand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gripperCommandDescriptor = $convert.base64Decode('Cg5HcmlwcGVyQ29tbWFuZBISCgRzdG9wGAEgASgIUgRzdG9wEhwKCWNhbGlicmF0ZRgCIAEoCFIJY2FsaWJyYXRlEh8KC21vdmVfcm90YXRlGAMgASgCUgptb3ZlUm90YXRlEhsKCW1vdmVfbGlmdBgEIAEoAlIIbW92ZUxpZnQSIQoMbW92ZV9ncmlwcGVyGAUgASgCUgttb3ZlR3JpcHBlcg==');
