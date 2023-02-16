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
    const {'1': 'set_throttle', '3': 4, '4': 1, '5': 8, '10': 'setThrottle'},
    const {'1': 'set_left', '3': 5, '4': 1, '5': 8, '10': 'setLeft'},
    const {'1': 'set_right', '3': 6, '4': 1, '5': 8, '10': 'setRight'},
  ],
};

/// Descriptor for `DriveCommand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List driveCommandDescriptor = $convert.base64Decode('CgxEcml2ZUNvbW1hbmQSGgoIdGhyb3R0bGUYASABKAJSCHRocm90dGxlEhIKBGxlZnQYAiABKAJSBGxlZnQSFAoFcmlnaHQYAyABKAJSBXJpZ2h0EiEKDHNldF90aHJvdHRsZRgEIAEoCFILc2V0VGhyb3R0bGUSGQoIc2V0X2xlZnQYBSABKAhSB3NldExlZnQSGwoJc2V0X3JpZ2h0GAYgASgIUghzZXRSaWdodA==');
@$core.Deprecated('Use driveDataDescriptor instead')
const DriveData$json = const {
  '1': 'DriveData',
  '2': const [
    const {'1': 'throttle', '3': 1, '4': 1, '5': 2, '9': 0, '10': 'throttle', '17': true},
    const {'1': 'left', '3': 2, '4': 1, '5': 2, '9': 1, '10': 'left', '17': true},
    const {'1': 'right', '3': 3, '4': 1, '5': 2, '9': 2, '10': 'right', '17': true},
  ],
  '8': const [
    const {'1': '_throttle'},
    const {'1': '_left'},
    const {'1': '_right'},
  ],
};

/// Descriptor for `DriveData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List driveDataDescriptor = $convert.base64Decode('CglEcml2ZURhdGESHwoIdGhyb3R0bGUYASABKAJIAFIIdGhyb3R0bGWIAQESFwoEbGVmdBgCIAEoAkgBUgRsZWZ0iAEBEhkKBXJpZ2h0GAMgASgCSAJSBXJpZ2h0iAEBQgsKCV90aHJvdHRsZUIHCgVfbGVmdEIICgZfcmlnaHQ=');
