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
    const {'1': 'ARM', '2': 6},
    const {'1': 'GRIPPER', '2': 7},
    const {'1': 'SCIENCE', '2': 8},
    const {'1': 'ELECTRICAL', '2': 9},
    const {'1': 'DRIVE', '2': 10},
    const {'1': 'MARS', '2': 11},
    const {'1': 'MARS_SERVER', '2': 12},
  ],
};

/// Descriptor for `Device`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List deviceDescriptor = $convert.base64Decode('CgZEZXZpY2USFAoQREVWSUNFX1VOREVGSU5FRBAAEg0KCURBU0hCT0FSRBABEg4KClNVQlNZU1RFTVMQAhIJCgVWSURFTxADEgwKCEFVVE9OT01ZEAQSDAoIRklSTVdBUkUQBRIHCgNBUk0QBhILCgdHUklQUEVSEAcSCwoHU0NJRU5DRRAIEg4KCkVMRUNUUklDQUwQCRIJCgVEUklWRRAKEggKBE1BUlMQCxIPCgtNQVJTX1NFUlZFUhAM');
@$core.Deprecated('Use roverStatusDescriptor instead')
const RoverStatus$json = const {
  '1': 'RoverStatus',
  '2': const [
    const {'1': 'DISCONNECTED', '2': 0},
    const {'1': 'IDLE', '2': 1},
    const {'1': 'MANUAL', '2': 2},
    const {'1': 'AUTONOMOUS', '2': 3},
    const {'1': 'POWER_OFF', '2': 4},
  ],
};

/// Descriptor for `RoverStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List roverStatusDescriptor = $convert.base64Decode('CgtSb3ZlclN0YXR1cxIQCgxESVNDT05ORUNURUQQABIICgRJRExFEAESCgoGTUFOVUFMEAISDgoKQVVUT05PTU9VUxADEg0KCVBPV0VSX09GRhAE');
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
    const {'1': 'color', '3': 2, '4': 1, '5': 11, '6': '.ProtoColor', '10': 'color'},
  ],
};

/// Descriptor for `UpdateSetting`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateSettingDescriptor = $convert.base64Decode('Cg1VcGRhdGVTZXR0aW5nEiQKBnN0YXR1cxgBIAEoDjIMLlJvdmVyU3RhdHVzUgZzdGF0dXMSIQoFY29sb3IYAiABKAsyCy5Qcm90b0NvbG9yUgVjb2xvcg==');
@$core.Deprecated('Use protoColorDescriptor instead')
const ProtoColor$json = const {
  '1': 'ProtoColor',
  '2': const [
    const {'1': 'red', '3': 1, '4': 1, '5': 2, '10': 'red'},
    const {'1': 'green', '3': 2, '4': 1, '5': 2, '10': 'green'},
    const {'1': 'blue', '3': 3, '4': 1, '5': 2, '10': 'blue'},
  ],
};

/// Descriptor for `ProtoColor`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List protoColorDescriptor = $convert.base64Decode('CgpQcm90b0NvbG9yEhAKA3JlZBgBIAEoAlIDcmVkEhQKBWdyZWVuGAIgASgCUgVncmVlbhISCgRibHVlGAMgASgCUgRibHVl');
