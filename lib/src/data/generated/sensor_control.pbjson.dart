///
//  Generated code. Do not modify.
//  source: sensor_control.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use electricalDataDescriptor instead')
const ElectricalData$json = const {
  '1': 'ElectricalData',
  '2': const [
    const {'1': 'battery_voltage', '3': 1, '4': 1, '5': 2, '10': 'batteryVoltage'},
    const {'1': 'battery_current', '3': 2, '4': 1, '5': 2, '10': 'batteryCurrent'},
    const {'1': 'v12_supply_voltage', '3': 3, '4': 1, '5': 2, '10': 'v12SupplyVoltage'},
    const {'1': 'v12_supply_current', '3': 4, '4': 1, '5': 2, '10': 'v12SupplyCurrent'},
    const {'1': 'v12_supply_temperature', '3': 5, '4': 1, '5': 2, '10': 'v12SupplyTemperature'},
    const {'1': 'v5_supply_voltage', '3': 6, '4': 1, '5': 2, '10': 'v5SupplyVoltage'},
    const {'1': 'v5_supply_current', '3': 7, '4': 1, '5': 2, '10': 'v5SupplyCurrent'},
    const {'1': 'v5_supply_temperature', '3': 8, '4': 1, '5': 2, '10': 'v5SupplyTemperature'},
    const {'1': 'odrive0_current', '3': 9, '4': 1, '5': 2, '10': 'odrive0Current'},
    const {'1': 'odrive1_current', '3': 10, '4': 1, '5': 2, '10': 'odrive1Current'},
    const {'1': 'odrive2_current', '3': 11, '4': 1, '5': 2, '10': 'odrive2Current'},
  ],
};

/// Descriptor for `ElectricalData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List electricalDataDescriptor = $convert.base64Decode('Cg5FbGVjdHJpY2FsRGF0YRInCg9iYXR0ZXJ5X3ZvbHRhZ2UYASABKAJSDmJhdHRlcnlWb2x0YWdlEicKD2JhdHRlcnlfY3VycmVudBgCIAEoAlIOYmF0dGVyeUN1cnJlbnQSLAoSdjEyX3N1cHBseV92b2x0YWdlGAMgASgCUhB2MTJTdXBwbHlWb2x0YWdlEiwKEnYxMl9zdXBwbHlfY3VycmVudBgEIAEoAlIQdjEyU3VwcGx5Q3VycmVudBI0ChZ2MTJfc3VwcGx5X3RlbXBlcmF0dXJlGAUgASgCUhR2MTJTdXBwbHlUZW1wZXJhdHVyZRIqChF2NV9zdXBwbHlfdm9sdGFnZRgGIAEoAlIPdjVTdXBwbHlWb2x0YWdlEioKEXY1X3N1cHBseV9jdXJyZW50GAcgASgCUg92NVN1cHBseUN1cnJlbnQSMgoVdjVfc3VwcGx5X3RlbXBlcmF0dXJlGAggASgCUhN2NVN1cHBseVRlbXBlcmF0dXJlEicKD29kcml2ZTBfY3VycmVudBgJIAEoAlIOb2RyaXZlMEN1cnJlbnQSJwoPb2RyaXZlMV9jdXJyZW50GAogASgCUg5vZHJpdmUxQ3VycmVudBInCg9vZHJpdmUyX2N1cnJlbnQYCyABKAJSDm9kcml2ZTJDdXJyZW50');
