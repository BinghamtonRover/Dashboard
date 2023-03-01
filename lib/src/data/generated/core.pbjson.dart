///
//  Generated code. Do not modify.
//  source: core.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use deviceDescriptor instead')
const Device$json = const {
  '1': 'Device',
  '2': const [
    const {'1': 'DEVICE_UNDEFINED', '2': 0},
    const {'1': 'DASHBOARD', '2': 1},
    const {'1': 'SUBSYSTEMS', '2': 2},
    const {'1': 'VIDEO', '2': 3},
    const {'1': 'AUTONOMY', '2': 4},
    const {'1': 'FIRMWARE', '2': 5},
  ],
};

/// Descriptor for `Device`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List deviceDescriptor = $convert.base64Decode('CgZEZXZpY2USFAoQREVWSUNFX1VOREVGSU5FRBAAEg0KCURBU0hCT0FSRBABEg4KClNVQlNZU1RFTVMQAhIJCgVWSURFTxADEgwKCEFVVE9OT01ZEAQSDAoIRklSTVdBUkUQBQ==');
@$core.Deprecated('Use roverStatusDescriptor instead')
const RoverStatus$json = const {
  '1': 'RoverStatus',
  '2': const [
    const {'1': 'DISCONNECTED', '2': 0},
    const {'1': 'IDLE', '2': 1},
    const {'1': 'MANUAL', '2': 2},
    const {'1': 'AUTONOMOUS', '2': 3},
  ],
};

/// Descriptor for `RoverStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List roverStatusDescriptor = $convert.base64Decode('CgtSb3ZlclN0YXR1cxIQCgxESVNDT05ORUNURUQQABIICgRJRExFEAESCgoGTUFOVUFMEAISDgoKQVVUT05PTU9VUxAD');
@$core.Deprecated('Use connectDescriptor instead')
const Connect$json = const {
  '1': 'Connect',
  '2': const [
    const {'1': 'sender', '3': 1, '4': 1, '5': 14, '6': '.Device', '10': 'sender'},
    const {'1': 'receiver', '3': 2, '4': 1, '5': 14, '6': '.Device', '10': 'receiver'},
  ],
};

/// Descriptor for `Connect`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectDescriptor = $convert.base64Decode('CgdDb25uZWN0Eh8KBnNlbmRlchgBIAEoDjIHLkRldmljZVIGc2VuZGVyEiMKCHJlY2VpdmVyGAIgASgOMgcuRGV2aWNlUghyZWNlaXZlcg==');
@$core.Deprecated('Use disconnectDescriptor instead')
const Disconnect$json = const {
  '1': 'Disconnect',
  '2': const [
    const {'1': 'sender', '3': 1, '4': 1, '5': 14, '6': '.Device', '10': 'sender'},
  ],
};

/// Descriptor for `Disconnect`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List disconnectDescriptor = $convert.base64Decode('CgpEaXNjb25uZWN0Eh8KBnNlbmRlchgBIAEoDjIHLkRldmljZVIGc2VuZGVy');
@$core.Deprecated('Use updateSettingDescriptor instead')
const UpdateSetting$json = const {
  '1': 'UpdateSetting',
  '2': const [
    const {'1': 'status', '3': 1, '4': 1, '5': 14, '6': '.RoverStatus', '10': 'status'},
  ],
};

/// Descriptor for `UpdateSetting`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateSettingDescriptor = $convert.base64Decode('Cg1VcGRhdGVTZXR0aW5nEiQKBnN0YXR1cxgBIAEoDjIMLlJvdmVyU3RhdHVzUgZzdGF0dXM=');
