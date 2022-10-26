///
//  Generated code. Do not modify.
//  source: video_control.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use qualityDescriptor instead')
const Quality$json = const {
  '1': 'Quality',
  '2': const [
    const {'1': 'jpeg_quality', '3': 1, '4': 1, '5': 13, '10': 'jpegQuality'},
    const {'1': 'grayscale', '3': 2, '4': 1, '5': 8, '10': 'grayscale'},
  ],
};

/// Descriptor for `Quality`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List qualityDescriptor = $convert.base64Decode('CgdRdWFsaXR5EiEKDGpwZWdfcXVhbGl0eRgBIAEoDVILanBlZ1F1YWxpdHkSHAoJZ3JheXNjYWxlGAIgASgIUglncmF5c2NhbGU=');
@$core.Deprecated('Use switchDescriptor instead')
const Switch$json = const {
  '1': 'Switch',
  '2': const [
    const {'1': 'stream', '3': 1, '4': 1, '5': 13, '10': 'stream'},
    const {'1': 'enabled', '3': 2, '4': 1, '5': 8, '10': 'enabled'},
  ],
};

/// Descriptor for `Switch`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List switchDescriptor = $convert.base64Decode('CgZTd2l0Y2gSFgoGc3RyZWFtGAEgASgNUgZzdHJlYW0SGAoHZW5hYmxlZBgCIAEoCFIHZW5hYmxlZA==');
