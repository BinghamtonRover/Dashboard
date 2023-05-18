///
//  Generated code. Do not modify.
//  source: autonomy.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use autonomyStateDescriptor instead')
const AutonomyState$json = const {
  '1': 'AutonomyState',
  '2': const [
    const {'1': 'AUTONOMY_STATE_UNDEFINED', '2': 0},
    const {'1': 'PATHING', '2': 2},
    const {'1': 'APPROACHING', '2': 3},
    const {'1': 'AT_DESTINATION', '2': 4},
  ],
};

/// Descriptor for `AutonomyState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List autonomyStateDescriptor = $convert.base64Decode('Cg1BdXRvbm9teVN0YXRlEhwKGEFVVE9OT01ZX1NUQVRFX1VOREVGSU5FRBAAEgsKB1BBVEhJTkcQAhIPCgtBUFBST0FDSElORxADEhIKDkFUX0RFU1RJTkFUSU9OEAQ=');
@$core.Deprecated('Use autonomyTaskDescriptor instead')
const AutonomyTask$json = const {
  '1': 'AutonomyTask',
  '2': const [
    const {'1': 'AUTONOMY_TASK_UNDEFINED', '2': 0},
    const {'1': 'GPS_ONLY', '2': 1},
    const {'1': 'VISUAL_MARKER', '2': 2},
    const {'1': 'BETWEEN_GATES', '2': 3},
  ],
};

/// Descriptor for `AutonomyTask`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List autonomyTaskDescriptor = $convert.base64Decode('CgxBdXRvbm9teVRhc2sSGwoXQVVUT05PTVlfVEFTS19VTkRFRklORUQQABIMCghHUFNfT05MWRABEhEKDVZJU1VBTF9NQVJLRVIQAhIRCg1CRVRXRUVOX0dBVEVTEAM=');
@$core.Deprecated('Use autonomyDataDescriptor instead')
const AutonomyData$json = const {
  '1': 'AutonomyData',
  '2': const [
    const {'1': 'state', '3': 1, '4': 1, '5': 14, '6': '.AutonomyState', '10': 'state'},
    const {'1': 'destination', '3': 2, '4': 1, '5': 11, '6': '.GpsCoordinates', '10': 'destination'},
    const {'1': 'obstacles', '3': 3, '4': 3, '5': 11, '6': '.GpsCoordinates', '10': 'obstacles'},
    const {'1': 'path', '3': 4, '4': 3, '5': 11, '6': '.GpsCoordinates', '10': 'path'},
  ],
};

/// Descriptor for `AutonomyData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List autonomyDataDescriptor = $convert.base64Decode('CgxBdXRvbm9teURhdGESJAoFc3RhdGUYASABKA4yDi5BdXRvbm9teVN0YXRlUgVzdGF0ZRIxCgtkZXN0aW5hdGlvbhgCIAEoCzIPLkdwc0Nvb3JkaW5hdGVzUgtkZXN0aW5hdGlvbhItCglvYnN0YWNsZXMYAyADKAsyDy5HcHNDb29yZGluYXRlc1IJb2JzdGFjbGVzEiMKBHBhdGgYBCADKAsyDy5HcHNDb29yZGluYXRlc1IEcGF0aA==');
@$core.Deprecated('Use autonomyCommandDescriptor instead')
const AutonomyCommand$json = const {
  '1': 'AutonomyCommand',
  '2': const [
    const {'1': 'enable', '3': 1, '4': 1, '5': 8, '10': 'enable'},
    const {'1': 'destination', '3': 2, '4': 1, '5': 11, '6': '.GpsCoordinates', '10': 'destination'},
    const {'1': 'task', '3': 3, '4': 1, '5': 14, '6': '.AutonomyTask', '10': 'task'},
  ],
};

/// Descriptor for `AutonomyCommand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List autonomyCommandDescriptor = $convert.base64Decode('Cg9BdXRvbm9teUNvbW1hbmQSFgoGZW5hYmxlGAEgASgIUgZlbmFibGUSMQoLZGVzdGluYXRpb24YAiABKAsyDy5HcHNDb29yZGluYXRlc1ILZGVzdGluYXRpb24SIQoEdGFzaxgDIAEoDjINLkF1dG9ub215VGFza1IEdGFzaw==');
