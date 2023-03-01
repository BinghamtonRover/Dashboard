///
//  Generated code. Do not modify.
//  source: science.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use scienceCommandDescriptor instead')
const ScienceCommand$json = const {
  '1': 'ScienceCommand',
  '2': const [
    const {'1': 'dig', '3': 1, '4': 1, '5': 8, '10': 'dig'},
    const {'1': 'spin_carousel_tube', '3': 2, '4': 1, '5': 8, '10': 'spinCarouselTube'},
    const {'1': 'spin_carousel_section', '3': 3, '4': 1, '5': 8, '10': 'spinCarouselSection'},
    const {'1': 'vacuum_suck', '3': 4, '4': 1, '5': 2, '10': 'vacuumSuck'},
    const {'1': 'carousel_angle', '3': 5, '4': 1, '5': 5, '10': 'carouselAngle'},
    const {'1': 'carousel_linear_position', '3': 6, '4': 1, '5': 5, '10': 'carouselLinearPosition'},
    const {'1': 'test_linear_position', '3': 7, '4': 1, '5': 5, '10': 'testLinearPosition'},
    const {'1': 'vacuum_linear_position', '3': 8, '4': 1, '5': 5, '10': 'vacuumLinearPosition'},
    const {'1': 'dirtRelease', '3': 13, '4': 1, '5': 5, '10': 'dirtRelease'},
    const {'1': 'pump1', '3': 9, '4': 1, '5': 8, '10': 'pump1'},
    const {'1': 'pump2', '3': 10, '4': 1, '5': 8, '10': 'pump2'},
    const {'1': 'pump3', '3': 11, '4': 1, '5': 8, '10': 'pump3'},
    const {'1': 'pump4', '3': 12, '4': 1, '5': 8, '10': 'pump4'},
  ],
};

/// Descriptor for `ScienceCommand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scienceCommandDescriptor = $convert.base64Decode('Cg5TY2llbmNlQ29tbWFuZBIQCgNkaWcYASABKAhSA2RpZxIsChJzcGluX2Nhcm91c2VsX3R1YmUYAiABKAhSEHNwaW5DYXJvdXNlbFR1YmUSMgoVc3Bpbl9jYXJvdXNlbF9zZWN0aW9uGAMgASgIUhNzcGluQ2Fyb3VzZWxTZWN0aW9uEh8KC3ZhY3V1bV9zdWNrGAQgASgCUgp2YWN1dW1TdWNrEiUKDmNhcm91c2VsX2FuZ2xlGAUgASgFUg1jYXJvdXNlbEFuZ2xlEjgKGGNhcm91c2VsX2xpbmVhcl9wb3NpdGlvbhgGIAEoBVIWY2Fyb3VzZWxMaW5lYXJQb3NpdGlvbhIwChR0ZXN0X2xpbmVhcl9wb3NpdGlvbhgHIAEoBVISdGVzdExpbmVhclBvc2l0aW9uEjQKFnZhY3V1bV9saW5lYXJfcG9zaXRpb24YCCABKAVSFHZhY3V1bUxpbmVhclBvc2l0aW9uEiAKC2RpcnRSZWxlYXNlGA0gASgFUgtkaXJ0UmVsZWFzZRIUCgVwdW1wMRgJIAEoCFIFcHVtcDESFAoFcHVtcDIYCiABKAhSBXB1bXAyEhQKBXB1bXAzGAsgASgIUgVwdW1wMxIUCgVwdW1wNBgMIAEoCFIFcHVtcDQ=');
@$core.Deprecated('Use scienceDataDescriptor instead')
const ScienceData$json = const {
  '1': 'ScienceData',
  '2': const [
    const {'1': 'co2', '3': 1, '4': 1, '5': 2, '10': 'co2'},
    const {'1': 'humidity', '3': 2, '4': 1, '5': 2, '10': 'humidity'},
    const {'1': 'methane', '3': 3, '4': 1, '5': 2, '10': 'methane'},
    const {'1': 'pH', '3': 4, '4': 1, '5': 2, '10': 'pH'},
    const {'1': 'temperature', '3': 5, '4': 1, '5': 2, '10': 'temperature'},
  ],
};

/// Descriptor for `ScienceData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scienceDataDescriptor = $convert.base64Decode('CgtTY2llbmNlRGF0YRIQCgNjbzIYASABKAJSA2NvMhIaCghodW1pZGl0eRgCIAEoAlIIaHVtaWRpdHkSGAoHbWV0aGFuZRgDIAEoAlIHbWV0aGFuZRIOCgJwSBgEIAEoAlICcEgSIAoLdGVtcGVyYXR1cmUYBSABKAJSC3RlbXBlcmF0dXJl');
