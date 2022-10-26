///
//  Generated code. Do not modify.
//  source: drive_control.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use velocityDescriptor instead')
const Velocity$json = const {
  '1': 'Velocity',
  '2': const [
    const {'1': 'speed', '3': 1, '4': 1, '5': 2, '10': 'speed'},
    const {'1': 'angle', '3': 2, '4': 1, '5': 2, '10': 'angle'},
  ],
};

/// Descriptor for `Velocity`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List velocityDescriptor = $convert.base64Decode('CghWZWxvY2l0eRIUCgVzcGVlZBgBIAEoAlIFc3BlZWQSFAoFYW5nbGUYAiABKAJSBWFuZ2xl');
@$core.Deprecated('Use actualSpeedDescriptor instead')
const ActualSpeed$json = const {
  '1': 'ActualSpeed',
  '2': const [
    const {'1': 'left', '3': 1, '4': 1, '5': 2, '10': 'left'},
    const {'1': 'right', '3': 2, '4': 1, '5': 2, '10': 'right'},
  ],
};

/// Descriptor for `ActualSpeed`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List actualSpeedDescriptor = $convert.base64Decode('CgtBY3R1YWxTcGVlZBISCgRsZWZ0GAEgASgCUgRsZWZ0EhQKBXJpZ2h0GAIgASgCUgVyaWdodA==');
@$core.Deprecated('Use haltDescriptor instead')
const Halt$json = const {
  '1': 'Halt',
  '2': const [
    const {'1': 'halt', '3': 1, '4': 1, '5': 8, '10': 'halt'},
  ],
};

/// Descriptor for `Halt`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List haltDescriptor = $convert.base64Decode('CgRIYWx0EhIKBGhhbHQYASABKAhSBGhhbHQ=');
@$core.Deprecated('Use driveModeDescriptor instead')
const DriveMode$json = const {
  '1': 'DriveMode',
  '2': const [
    const {'1': 'mode', '3': 1, '4': 1, '5': 14, '6': '.drive.DriveMode.Mode', '10': 'mode'},
  ],
  '4': const [DriveMode_Mode$json],
};

@$core.Deprecated('Use driveModeDescriptor instead')
const DriveMode_Mode$json = const {
  '1': 'Mode',
  '2': const [
    const {'1': 'NEUTRAL', '2': 0},
    const {'1': 'DRIVE', '2': 1},
    const {'1': 'CALIBRATING', '2': 2},
    const {'1': 'COUNT', '2': 3},
  ],
};

/// Descriptor for `DriveMode`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List driveModeDescriptor = $convert.base64Decode('CglEcml2ZU1vZGUSKQoEbW9kZRgBIAEoDjIVLmRyaXZlLkRyaXZlTW9kZS5Nb2RlUgRtb2RlIjoKBE1vZGUSCwoHTkVVVFJBTBAAEgkKBURSSVZFEAESDwoLQ0FMSUJSQVRJTkcQAhIJCgVDT1VOVBAD');
