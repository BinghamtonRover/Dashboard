///
//  Generated code. Do not modify.
//  source: video.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use adjustCameraDescriptor instead')
const AdjustCamera$json = const {
  '1': 'AdjustCamera',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    const {'1': 'is_enabled', '3': 2, '4': 1, '5': 8, '10': 'isEnabled'},
    const {'1': 'resolution', '3': 3, '4': 1, '5': 5, '10': 'resolution'},
  ],
};

/// Descriptor for `AdjustCamera`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List adjustCameraDescriptor = $convert.base64Decode('CgxBZGp1c3RDYW1lcmESDgoCaWQYASABKAVSAmlkEh0KCmlzX2VuYWJsZWQYAiABKAhSCWlzRW5hYmxlZBIeCgpyZXNvbHV0aW9uGAMgASgFUgpyZXNvbHV0aW9u');
@$core.Deprecated('Use cameraStatusDescriptor instead')
const CameraStatus$json = const {
  '1': 'CameraStatus',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    const {'1': 'is_enabled', '3': 2, '4': 1, '5': 8, '10': 'isEnabled'},
    const {'1': 'resolution', '3': 3, '4': 1, '5': 5, '10': 'resolution'},
  ],
};

/// Descriptor for `CameraStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cameraStatusDescriptor = $convert.base64Decode('CgxDYW1lcmFTdGF0dXMSDgoCaWQYASABKAVSAmlkEh0KCmlzX2VuYWJsZWQYAiABKAhSCWlzRW5hYmxlZBIeCgpyZXNvbHV0aW9uGAMgASgFUgpyZXNvbHV0aW9u');
@$core.Deprecated('Use videoDataDescriptor instead')
const VideoData$json = const {
  '1': 'VideoData',
  '2': const [
    const {'1': 'cameras', '3': 1, '4': 3, '5': 11, '6': '.CameraStatus', '10': 'cameras'},
  ],
};

/// Descriptor for `VideoData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoDataDescriptor = $convert.base64Decode('CglWaWRlb0RhdGESJwoHY2FtZXJhcxgBIAMoCzINLkNhbWVyYVN0YXR1c1IHY2FtZXJhcw==');
