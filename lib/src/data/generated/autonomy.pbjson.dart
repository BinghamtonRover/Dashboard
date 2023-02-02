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
    const {'1': 'OFF', '2': 1},
    const {'1': 'PATHING', '2': 2},
    const {'1': 'APPROACHING', '2': 3},
    const {'1': 'AT_GATE', '2': 4},
  ],
};

/// Descriptor for `AutonomyState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List autonomyStateDescriptor = $convert.base64Decode('Cg1BdXRvbm9teVN0YXRlEhwKGEFVVE9OT01ZX1NUQVRFX1VOREVGSU5FRBAAEgcKA09GRhABEgsKB1BBVEhJTkcQAhIPCgtBUFBST0FDSElORxADEgsKB0FUX0dBVEUQBA==');
@$core.Deprecated('Use autonomyDataDescriptor instead')
const AutonomyData$json = const {
  '1': 'AutonomyData',
  '2': const [
    const {'1': 'coordinates', '3': 1, '4': 1, '5': 11, '6': '.GpsCoordinates', '10': 'coordinates'},
    const {'1': 'heading', '3': 2, '4': 1, '5': 2, '10': 'heading'},
    const {'1': 'state', '3': 3, '4': 1, '5': 14, '6': '.AutonomyState', '10': 'state'},
    const {'1': 'raw_x_orientation', '3': 4, '4': 1, '5': 2, '10': 'rawXOrientation'},
    const {'1': 'raw_y_orientation', '3': 5, '4': 1, '5': 2, '10': 'rawYOrientation'},
    const {'1': 'raw_z_orientation', '3': 6, '4': 1, '5': 2, '10': 'rawZOrientation'},
    const {'1': 'grid', '3': 7, '4': 1, '5': 11, '6': '.Grid', '10': 'grid'},
  ],
};

/// Descriptor for `AutonomyData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List autonomyDataDescriptor = $convert.base64Decode('CgxBdXRvbm9teURhdGESMQoLY29vcmRpbmF0ZXMYASABKAsyDy5HcHNDb29yZGluYXRlc1ILY29vcmRpbmF0ZXMSGAoHaGVhZGluZxgCIAEoAlIHaGVhZGluZxIkCgVzdGF0ZRgDIAEoDjIOLkF1dG9ub215U3RhdGVSBXN0YXRlEioKEXJhd194X29yaWVudGF0aW9uGAQgASgCUg9yYXdYT3JpZW50YXRpb24SKgoRcmF3X3lfb3JpZW50YXRpb24YBSABKAJSD3Jhd1lPcmllbnRhdGlvbhIqChFyYXdfel9vcmllbnRhdGlvbhgGIAEoAlIPcmF3Wk9yaWVudGF0aW9uEhkKBGdyaWQYByABKAsyBS5HcmlkUgRncmlk');
@$core.Deprecated('Use gridDescriptor instead')
const Grid$json = const {
  '1': 'Grid',
  '2': const [
    const {'1': 'rows', '3': 1, '4': 3, '5': 11, '6': '.Row', '10': 'rows'},
  ],
};

/// Descriptor for `Grid`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gridDescriptor = $convert.base64Decode('CgRHcmlkEhgKBHJvd3MYASADKAsyBC5Sb3dSBHJvd3M=');
@$core.Deprecated('Use rowDescriptor instead')
const Row$json = const {
  '1': 'Row',
  '2': const [
    const {'1': 'is_cell_occupied', '3': 1, '4': 3, '5': 8, '10': 'isCellOccupied'},
  ],
};

/// Descriptor for `Row`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rowDescriptor = $convert.base64Decode('CgNSb3cSKAoQaXNfY2VsbF9vY2N1cGllZBgBIAMoCFIOaXNDZWxsT2NjdXBpZWQ=');
