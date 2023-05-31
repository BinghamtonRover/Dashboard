///
//  Generated code. Do not modify.
//  source: drive.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use driveCommandDescriptor instead')
const DriveCommand$json = const {
  '1': 'DriveCommand',
  '2': const [
    const {'1': 'throttle', '3': 1, '4': 1, '5': 2, '10': 'throttle'},
    const {'1': 'left', '3': 2, '4': 1, '5': 2, '10': 'left'},
    const {'1': 'right', '3': 3, '4': 1, '5': 2, '10': 'right'},
    const {'1': 'set_left', '3': 4, '4': 1, '5': 8, '10': 'setLeft'},
    const {'1': 'set_right', '3': 5, '4': 1, '5': 8, '10': 'setRight'},
    const {'1': 'set_throttle', '3': 6, '4': 1, '5': 8, '10': 'setThrottle'},
    const {'1': 'front_swivel', '3': 7, '4': 1, '5': 2, '10': 'frontSwivel'},
    const {'1': 'front_tilt', '3': 8, '4': 1, '5': 2, '10': 'frontTilt'},
    const {'1': 'rear_swivel', '3': 9, '4': 1, '5': 2, '10': 'rearSwivel'},
    const {'1': 'rear_tilt', '3': 10, '4': 1, '5': 2, '10': 'rearTilt'},
  ],
};

/// Descriptor for `DriveCommand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List driveCommandDescriptor = $convert.base64Decode('CgxEcml2ZUNvbW1hbmQSGgoIdGhyb3R0bGUYASABKAJSCHRocm90dGxlEhIKBGxlZnQYAiABKAJSBGxlZnQSFAoFcmlnaHQYAyABKAJSBXJpZ2h0EhkKCHNldF9sZWZ0GAQgASgIUgdzZXRMZWZ0EhsKCXNldF9yaWdodBgFIAEoCFIIc2V0UmlnaHQSIQoMc2V0X3Rocm90dGxlGAYgASgIUgtzZXRUaHJvdHRsZRIhCgxmcm9udF9zd2l2ZWwYByABKAJSC2Zyb250U3dpdmVsEh0KCmZyb250X3RpbHQYCCABKAJSCWZyb250VGlsdBIfCgtyZWFyX3N3aXZlbBgJIAEoAlIKcmVhclN3aXZlbBIbCglyZWFyX3RpbHQYCiABKAJSCHJlYXJUaWx0');
@$core.Deprecated('Use driveDataDescriptor instead')
const DriveData$json = const {
  '1': 'DriveData',
  '2': const [
    const {'1': 'throttle', '3': 1, '4': 1, '5': 2, '10': 'throttle'},
    const {'1': 'left', '3': 2, '4': 1, '5': 2, '10': 'left'},
    const {'1': 'right', '3': 3, '4': 1, '5': 2, '10': 'right'},
    const {'1': 'set_left', '3': 4, '4': 1, '5': 8, '10': 'setLeft'},
    const {'1': 'set_right', '3': 5, '4': 1, '5': 8, '10': 'setRight'},
    const {'1': 'set_throttle', '3': 6, '4': 1, '5': 8, '10': 'setThrottle'},
    const {'1': 'front_swivel', '3': 7, '4': 1, '5': 2, '10': 'frontSwivel'},
    const {'1': 'front_tilt', '3': 8, '4': 1, '5': 2, '10': 'frontTilt'},
    const {'1': 'rear_swivel', '3': 9, '4': 1, '5': 2, '10': 'rearSwivel'},
    const {'1': 'rear_tilt', '3': 10, '4': 1, '5': 2, '10': 'rearTilt'},
    const {'1': 'leftSensorValue', '3': 11, '4': 1, '5': 2, '10': 'leftSensorValue'},
    const {'1': 'rightSensorValue', '3': 12, '4': 1, '5': 2, '10': 'rightSensorValue'},
  ],
};

/// Descriptor for `DriveData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List driveDataDescriptor = $convert.base64Decode('CglEcml2ZURhdGESGgoIdGhyb3R0bGUYASABKAJSCHRocm90dGxlEhIKBGxlZnQYAiABKAJSBGxlZnQSFAoFcmlnaHQYAyABKAJSBXJpZ2h0EhkKCHNldF9sZWZ0GAQgASgIUgdzZXRMZWZ0EhsKCXNldF9yaWdodBgFIAEoCFIIc2V0UmlnaHQSIQoMc2V0X3Rocm90dGxlGAYgASgIUgtzZXRUaHJvdHRsZRIhCgxmcm9udF9zd2l2ZWwYByABKAJSC2Zyb250U3dpdmVsEh0KCmZyb250X3RpbHQYCCABKAJSCWZyb250VGlsdBIfCgtyZWFyX3N3aXZlbBgJIAEoAlIKcmVhclN3aXZlbBIbCglyZWFyX3RpbHQYCiABKAJSCHJlYXJUaWx0EigKD2xlZnRTZW5zb3JWYWx1ZRgLIAEoAlIPbGVmdFNlbnNvclZhbHVlEioKEHJpZ2h0U2Vuc29yVmFsdWUYDCABKAJSEHJpZ2h0U2Vuc29yVmFsdWU=');
