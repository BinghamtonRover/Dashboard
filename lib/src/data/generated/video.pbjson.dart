///
//  Generated code. Do not modify.
//  source: video.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use cameraNameDescriptor instead')
const CameraName$json = const {
  '1': 'CameraName',
  '2': const [
    const {'1': 'CAMERA_NAME_UNDEFINED', '2': 0},
    const {'1': 'CAMERA_NAME_ROVER_FRONT', '2': 1},
    const {'1': 'CAMERA_NAME_ROVER_REAR', '2': 2},
    const {'1': 'CAMERA_NAME_ARM_BASE', '2': 3},
    const {'1': 'CAMERA_NAME_ARM_GRIPPER', '2': 4},
    const {'1': 'CAMERA_NAME_SCIENCE_CAROUSEL', '2': 5},
    const {'1': 'CAMERA_NAME_SCIENCE_MICROSCOPE', '2': 6},
  ],
};

/// Descriptor for `CameraName`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List cameraNameDescriptor = $convert.base64Decode('CgpDYW1lcmFOYW1lEhkKFUNBTUVSQV9OQU1FX1VOREVGSU5FRBAAEhsKF0NBTUVSQV9OQU1FX1JPVkVSX0ZST05UEAESGgoWQ0FNRVJBX05BTUVfUk9WRVJfUkVBUhACEhgKFENBTUVSQV9OQU1FX0FSTV9CQVNFEAMSGwoXQ0FNRVJBX05BTUVfQVJNX0dSSVBQRVIQBBIgChxDQU1FUkFfTkFNRV9TQ0lFTkNFX0NBUk9VU0VMEAUSIgoeQ0FNRVJBX05BTUVfU0NJRU5DRV9NSUNST1NDT1BFEAY=');
@$core.Deprecated('Use adjustCameraDescriptor instead')
const AdjustCamera$json = const {
  '1': 'AdjustCamera',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 14, '6': '.CameraName', '10': 'name'},
    const {'1': 'is_enabled', '3': 2, '4': 1, '5': 8, '10': 'isEnabled'},
    const {'1': 'resolution', '3': 3, '4': 1, '5': 5, '10': 'resolution'},
  ],
};

/// Descriptor for `AdjustCamera`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List adjustCameraDescriptor = $convert.base64Decode('CgxBZGp1c3RDYW1lcmESHwoEbmFtZRgBIAEoDjILLkNhbWVyYU5hbWVSBG5hbWUSHQoKaXNfZW5hYmxlZBgCIAEoCFIJaXNFbmFibGVkEh4KCnJlc29sdXRpb24YAyABKAVSCnJlc29sdXRpb24=');
@$core.Deprecated('Use cameraStatusDescriptor instead')
const CameraStatus$json = const {
  '1': 'CameraStatus',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 14, '6': '.CameraName', '10': 'name'},
    const {'1': 'is_enabled', '3': 2, '4': 1, '5': 8, '10': 'isEnabled'},
    const {'1': 'resolution', '3': 3, '4': 1, '5': 5, '10': 'resolution'},
  ],
};

/// Descriptor for `CameraStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cameraStatusDescriptor = $convert.base64Decode('CgxDYW1lcmFTdGF0dXMSHwoEbmFtZRgBIAEoDjILLkNhbWVyYU5hbWVSBG5hbWUSHQoKaXNfZW5hYmxlZBgCIAEoCFIJaXNFbmFibGVkEh4KCnJlc29sdXRpb24YAyABKAVSCnJlc29sdXRpb24=');
@$core.Deprecated('Use videoDataDescriptor instead')
const VideoData$json = const {
  '1': 'VideoData',
  '2': const [
    const {'1': 'cameras', '3': 1, '4': 3, '5': 11, '6': '.CameraStatus', '10': 'cameras'},
  ],
};

/// Descriptor for `VideoData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoDataDescriptor = $convert.base64Decode('CglWaWRlb0RhdGESJwoHY2FtZXJhcxgBIAMoCzINLkNhbWVyYVN0YXR1c1IHY2FtZXJhcw==');
@$core.Deprecated('Use videoFrameDescriptor instead')
const VideoFrame$json = const {
  '1': 'VideoFrame',
  '2': const [
    const {'1': 'name', '3': 4, '4': 1, '5': 14, '6': '.CameraName', '10': 'name'},
    const {'1': 'frame', '3': 5, '4': 1, '5': 12, '10': 'frame'},
  ],
};

/// Descriptor for `VideoFrame`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoFrameDescriptor = $convert.base64Decode('CgpWaWRlb0ZyYW1lEh8KBG5hbWUYBCABKA4yCy5DYW1lcmFOYW1lUgRuYW1lEhQKBWZyYW1lGAUgASgMUgVmcmFtZQ==');
