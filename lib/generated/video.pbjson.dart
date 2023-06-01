///
//  Generated code. Do not modify.
//  source: video.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use cameraStatusDescriptor instead')
const CameraStatus$json = const {
  '1': 'CameraStatus',
  '2': const [
    const {'1': 'CAMERA_STATUS_UNDEFINED', '2': 0},
    const {'1': 'CAMERA_DISCONNECTED', '2': 1},
    const {'1': 'CAMERA_ENABLED', '2': 2},
    const {'1': 'CAMERA_DISABLED', '2': 3},
    const {'1': 'CAMERA_NOT_RESPONDING', '2': 4},
    const {'1': 'CAMERA_LOADING', '2': 5},
    const {'1': 'FRAME_TOO_LARGE', '2': 6},
    const {'1': 'CAMERA_HAS_NO_NAME', '2': 7},
  ],
};

/// Descriptor for `CameraStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List cameraStatusDescriptor = $convert.base64Decode('CgxDYW1lcmFTdGF0dXMSGwoXQ0FNRVJBX1NUQVRVU19VTkRFRklORUQQABIXChNDQU1FUkFfRElTQ09OTkVDVEVEEAESEgoOQ0FNRVJBX0VOQUJMRUQQAhITCg9DQU1FUkFfRElTQUJMRUQQAxIZChVDQU1FUkFfTk9UX1JFU1BPTkRJTkcQBBISCg5DQU1FUkFfTE9BRElORxAFEhMKD0ZSQU1FX1RPT19MQVJHRRAGEhYKEkNBTUVSQV9IQVNfTk9fTkFNRRAH');
@$core.Deprecated('Use cameraNameDescriptor instead')
const CameraName$json = const {
  '1': 'CameraName',
  '2': const [
    const {'1': 'CAMERA_NAME_UNDEFINED', '2': 0},
    const {'1': 'ROVER_FRONT', '2': 1},
    const {'1': 'ROVER_REAR', '2': 2},
    const {'1': 'AUTONOMY_DEPTH', '2': 3},
    const {'1': 'SUBSYSTEM1', '2': 4},
    const {'1': 'SUBSYSTEM2', '2': 5},
    const {'1': 'SUBSYSTEM3', '2': 6},
  ],
};

/// Descriptor for `CameraName`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List cameraNameDescriptor = $convert.base64Decode('CgpDYW1lcmFOYW1lEhkKFUNBTUVSQV9OQU1FX1VOREVGSU5FRBAAEg8KC1JPVkVSX0ZST05UEAESDgoKUk9WRVJfUkVBUhACEhIKDkFVVE9OT01ZX0RFUFRIEAMSDgoKU1VCU1lTVEVNMRAEEg4KClNVQlNZU1RFTTIQBRIOCgpTVUJTWVNURU0zEAY=');
@$core.Deprecated('Use cameraDetailsDescriptor instead')
const CameraDetails$json = const {
  '1': 'CameraDetails',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 14, '6': '.CameraName', '10': 'name'},
    const {'1': 'resolution_width', '3': 2, '4': 1, '5': 5, '10': 'resolutionWidth'},
    const {'1': 'resolution_height', '3': 3, '4': 1, '5': 5, '10': 'resolutionHeight'},
    const {'1': 'quality', '3': 4, '4': 1, '5': 5, '10': 'quality'},
    const {'1': 'fps', '3': 5, '4': 1, '5': 5, '10': 'fps'},
    const {'1': 'status', '3': 6, '4': 1, '5': 14, '6': '.CameraStatus', '10': 'status'},
  ],
};

/// Descriptor for `CameraDetails`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cameraDetailsDescriptor = $convert.base64Decode('Cg1DYW1lcmFEZXRhaWxzEh8KBG5hbWUYASABKA4yCy5DYW1lcmFOYW1lUgRuYW1lEikKEHJlc29sdXRpb25fd2lkdGgYAiABKAVSD3Jlc29sdXRpb25XaWR0aBIrChFyZXNvbHV0aW9uX2hlaWdodBgDIAEoBVIQcmVzb2x1dGlvbkhlaWdodBIYCgdxdWFsaXR5GAQgASgFUgdxdWFsaXR5EhAKA2ZwcxgFIAEoBVIDZnBzEiUKBnN0YXR1cxgGIAEoDjINLkNhbWVyYVN0YXR1c1IGc3RhdHVz');
@$core.Deprecated('Use videoDataDescriptor instead')
const VideoData$json = const {
  '1': 'VideoData',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'details', '3': 2, '4': 1, '5': 11, '6': '.CameraDetails', '10': 'details'},
    const {'1': 'frame', '3': 3, '4': 1, '5': 12, '10': 'frame'},
  ],
};

/// Descriptor for `VideoData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoDataDescriptor = $convert.base64Decode('CglWaWRlb0RhdGESDgoCaWQYASABKAlSAmlkEigKB2RldGFpbHMYAiABKAsyDi5DYW1lcmFEZXRhaWxzUgdkZXRhaWxzEhQKBWZyYW1lGAMgASgMUgVmcmFtZQ==');
@$core.Deprecated('Use videoCommandDescriptor instead')
const VideoCommand$json = const {
  '1': 'VideoCommand',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'details', '3': 2, '4': 1, '5': 11, '6': '.CameraDetails', '10': 'details'},
  ],
};

/// Descriptor for `VideoCommand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoCommandDescriptor = $convert.base64Decode('CgxWaWRlb0NvbW1hbmQSDgoCaWQYASABKAlSAmlkEigKB2RldGFpbHMYAiABKAsyDi5DYW1lcmFEZXRhaWxzUgdkZXRhaWxz');
