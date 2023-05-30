///
//  Generated code. Do not modify.
//  source: mars.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use marsStatusDescriptor instead')
const MarsStatus$json = const {
  '1': 'MarsStatus',
  '2': const [
    const {'1': 'MARS_STATUS_UNDEFINED', '2': 0},
    const {'1': 'PORT_NOT_FOUND', '2': 1},
    const {'1': 'TEENSY_UNRESPONSIVE', '2': 2},
    const {'1': 'FAILED_HANDSHAKE', '2': 3},
    const {'1': 'TEENSY_CONNECTED', '2': 4},
  ],
};

/// Descriptor for `MarsStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List marsStatusDescriptor = $convert.base64Decode('CgpNYXJzU3RhdHVzEhkKFU1BUlNfU1RBVFVTX1VOREVGSU5FRBAAEhIKDlBPUlRfTk9UX0ZPVU5EEAESFwoTVEVFTlNZX1VOUkVTUE9OU0lWRRACEhQKEEZBSUxFRF9IQU5EU0hBS0UQAxIUChBURUVOU1lfQ09OTkVDVEVEEAQ=');
@$core.Deprecated('Use marsCommandDescriptor instead')
const MarsCommand$json = const {
  '1': 'MarsCommand',
  '2': const [
    const {'1': 'swivel', '3': 1, '4': 1, '5': 2, '10': 'swivel'},
    const {'1': 'tilt', '3': 2, '4': 1, '5': 2, '10': 'tilt'},
    const {'1': 'rover', '3': 3, '4': 1, '5': 11, '6': '.GpsCoordinates', '10': 'rover'},
    const {'1': 'baseStationOverride', '3': 4, '4': 1, '5': 11, '6': '.GpsCoordinates', '10': 'baseStationOverride'},
  ],
};

/// Descriptor for `MarsCommand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List marsCommandDescriptor = $convert.base64Decode('CgtNYXJzQ29tbWFuZBIWCgZzd2l2ZWwYASABKAJSBnN3aXZlbBISCgR0aWx0GAIgASgCUgR0aWx0EiUKBXJvdmVyGAMgASgLMg8uR3BzQ29vcmRpbmF0ZXNSBXJvdmVyEkEKE2Jhc2VTdGF0aW9uT3ZlcnJpZGUYBCABKAsyDy5HcHNDb29yZGluYXRlc1ITYmFzZVN0YXRpb25PdmVycmlkZQ==');
@$core.Deprecated('Use marsDataDescriptor instead')
const MarsData$json = const {
  '1': 'MarsData',
  '2': const [
    const {'1': 'swivel', '3': 1, '4': 1, '5': 2, '10': 'swivel'},
    const {'1': 'tilt', '3': 2, '4': 1, '5': 2, '10': 'tilt'},
    const {'1': 'coordinates', '3': 3, '4': 1, '5': 11, '6': '.GpsCoordinates', '10': 'coordinates'},
    const {'1': 'status', '3': 4, '4': 1, '5': 14, '6': '.MarsStatus', '10': 'status'},
  ],
};

/// Descriptor for `MarsData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List marsDataDescriptor = $convert.base64Decode('CghNYXJzRGF0YRIWCgZzd2l2ZWwYASABKAJSBnN3aXZlbBISCgR0aWx0GAIgASgCUgR0aWx0EjEKC2Nvb3JkaW5hdGVzGAMgASgLMg8uR3BzQ29vcmRpbmF0ZXNSC2Nvb3JkaW5hdGVzEiMKBnN0YXR1cxgEIAEoDjILLk1hcnNTdGF0dXNSBnN0YXR1cw==');
