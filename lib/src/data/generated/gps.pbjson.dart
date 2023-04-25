///
//  Generated code. Do not modify.
//  source: gps.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use gpsCoordinatesDescriptor instead')
const GpsCoordinates$json = const {
  '1': 'GpsCoordinates',
  '2': const [
    const {'1': 'latitude', '3': 1, '4': 1, '5': 2, '10': 'latitude'},
    const {'1': 'longitude', '3': 2, '4': 1, '5': 2, '10': 'longitude'},
    const {'1': 'altitude', '3': 3, '4': 1, '5': 2, '10': 'altitude'},
  ],
};

/// Descriptor for `GpsCoordinates`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gpsCoordinatesDescriptor = $convert.base64Decode('Cg5HcHNDb29yZGluYXRlcxIaCghsYXRpdHVkZRgBIAEoAlIIbGF0aXR1ZGUSHAoJbG9uZ2l0dWRlGAIgASgCUglsb25naXR1ZGUSGgoIYWx0aXR1ZGUYAyABKAJSCGFsdGl0dWRl');
@$core.Deprecated('Use orientationDescriptor instead')
const Orientation$json = const {
  '1': 'Orientation',
  '2': const [
    const {'1': 'x', '3': 1, '4': 1, '5': 2, '10': 'x'},
    const {'1': 'y', '3': 2, '4': 1, '5': 2, '10': 'y'},
    const {'1': 'z', '3': 3, '4': 1, '5': 2, '10': 'z'},
  ],
};

/// Descriptor for `Orientation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orientationDescriptor = $convert.base64Decode('CgtPcmllbnRhdGlvbhIMCgF4GAEgASgCUgF4EgwKAXkYAiABKAJSAXkSDAoBehgDIAEoAlIBeg==');
@$core.Deprecated('Use roverPositionDescriptor instead')
const RoverPosition$json = const {
  '1': 'RoverPosition',
  '2': const [
    const {'1': 'gps', '3': 1, '4': 1, '5': 11, '6': '.GpsCoordinates', '10': 'gps'},
    const {'1': 'orientation', '3': 2, '4': 1, '5': 11, '6': '.Orientation', '10': 'orientation'},
  ],
};

/// Descriptor for `RoverPosition`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roverPositionDescriptor = $convert.base64Decode('Cg1Sb3ZlclBvc2l0aW9uEiEKA2dwcxgBIAEoCzIPLkdwc0Nvb3JkaW5hdGVzUgNncHMSLgoLb3JpZW50YXRpb24YAiABKAsyDC5PcmllbnRhdGlvblILb3JpZW50YXRpb24=');
