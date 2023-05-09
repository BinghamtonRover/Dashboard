///
//  Generated code. Do not modify.
//  source: electrical.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use electricalCommandDescriptor instead')
const ElectricalCommand$json = const {
  '1': 'ElectricalCommand',
  '2': const [
    const {'1': 'status', '3': 10, '4': 1, '5': 14, '6': '.RoverStatus', '10': 'status'},
  ],
};

/// Descriptor for `ElectricalCommand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List electricalCommandDescriptor = $convert.base64Decode('ChFFbGVjdHJpY2FsQ29tbWFuZBIkCgZzdGF0dXMYCiABKA4yDC5Sb3ZlclN0YXR1c1IGc3RhdHVz');
@$core.Deprecated('Use powerSourceStatusDescriptor instead')
const PowerSourceStatus$json = const {
  '1': 'PowerSourceStatus',
  '2': const [
    const {'1': 'current', '3': 1, '4': 1, '5': 2, '10': 'current'},
    const {'1': 'voltage', '3': 2, '4': 1, '5': 2, '10': 'voltage'},
    const {'1': 'temperature', '3': 3, '4': 1, '5': 2, '10': 'temperature'},
  ],
};

/// Descriptor for `PowerSourceStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List powerSourceStatusDescriptor = $convert.base64Decode('ChFQb3dlclNvdXJjZVN0YXR1cxIYCgdjdXJyZW50GAEgASgCUgdjdXJyZW50EhgKB3ZvbHRhZ2UYAiABKAJSB3ZvbHRhZ2USIAoLdGVtcGVyYXR1cmUYAyABKAJSC3RlbXBlcmF0dXJl');
@$core.Deprecated('Use electricalDataDescriptor instead')
const ElectricalData$json = const {
  '1': 'ElectricalData',
  '2': const [
    const {'1': 'v5_current', '3': 1, '4': 1, '5': 2, '10': 'v5Current'},
    const {'1': 'v5_voltage', '3': 2, '4': 1, '5': 2, '10': 'v5Voltage'},
    const {'1': 'v5_temperature', '3': 3, '4': 1, '5': 2, '10': 'v5Temperature'},
    const {'1': 'v12_current', '3': 4, '4': 1, '5': 2, '10': 'v12Current'},
    const {'1': 'v12_voltage', '3': 5, '4': 1, '5': 2, '10': 'v12Voltage'},
    const {'1': 'v12_temperature', '3': 6, '4': 1, '5': 2, '10': 'v12Temperature'},
    const {'1': 'battery_current', '3': 7, '4': 1, '5': 2, '10': 'batteryCurrent'},
    const {'1': 'battery_voltage', '3': 8, '4': 1, '5': 2, '10': 'batteryVoltage'},
    const {'1': 'battery_temperature', '3': 9, '4': 1, '5': 2, '10': 'batteryTemperature'},
  ],
};

/// Descriptor for `ElectricalData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List electricalDataDescriptor = $convert.base64Decode('Cg5FbGVjdHJpY2FsRGF0YRIdCgp2NV9jdXJyZW50GAEgASgCUgl2NUN1cnJlbnQSHQoKdjVfdm9sdGFnZRgCIAEoAlIJdjVWb2x0YWdlEiUKDnY1X3RlbXBlcmF0dXJlGAMgASgCUg12NVRlbXBlcmF0dXJlEh8KC3YxMl9jdXJyZW50GAQgASgCUgp2MTJDdXJyZW50Eh8KC3YxMl92b2x0YWdlGAUgASgCUgp2MTJWb2x0YWdlEicKD3YxMl90ZW1wZXJhdHVyZRgGIAEoAlIOdjEyVGVtcGVyYXR1cmUSJwoPYmF0dGVyeV9jdXJyZW50GAcgASgCUg5iYXR0ZXJ5Q3VycmVudBInCg9iYXR0ZXJ5X3ZvbHRhZ2UYCCABKAJSDmJhdHRlcnlWb2x0YWdlEi8KE2JhdHRlcnlfdGVtcGVyYXR1cmUYCSABKAJSEmJhdHRlcnlUZW1wZXJhdHVyZQ==');
