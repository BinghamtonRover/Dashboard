///
//  Generated code. Do not modify.
//  source: core.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class Device extends $pb.ProtobufEnum {
  static const Device DEVICE_UNDEFINED = Device._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'DEVICE_UNDEFINED');
  static const Device DASHBOARD = Device._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'DASHBOARD');
  static const Device SUBSYSTEMS = Device._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SUBSYSTEMS');
  static const Device VIDEO = Device._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'VIDEO');
  static const Device AUTONOMY = Device._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'AUTONOMY');
  static const Device FIRMWARE = Device._(5, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'FIRMWARE');

  static const $core.List<Device> values = <Device> [
    DEVICE_UNDEFINED,
    DASHBOARD,
    SUBSYSTEMS,
    VIDEO,
    AUTONOMY,
    FIRMWARE,
  ];

  static final $core.Map<$core.int, Device> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Device? valueOf($core.int value) => _byValue[value];

  const Device._($core.int v, $core.String n) : super(v, n);
}

