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
  static const Device ARM = Device._(6, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ARM');
  static const Device GRIPPER = Device._(7, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'GRIPPER');
  static const Device SCIENCE = Device._(8, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SCIENCE');
  static const Device ELECTRICAL = Device._(9, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ELECTRICAL');
  static const Device DRIVE = Device._(10, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'DRIVE');
  static const Device MARS = Device._(11, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MARS');
  static const Device MARS_SERVER = Device._(12, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MARS_SERVER');

  static const $core.List<Device> values = <Device> [
    DEVICE_UNDEFINED,
    DASHBOARD,
    SUBSYSTEMS,
    VIDEO,
    AUTONOMY,
    FIRMWARE,
    ARM,
    GRIPPER,
    SCIENCE,
    ELECTRICAL,
    DRIVE,
    MARS,
    MARS_SERVER,
  ];

  static final $core.Map<$core.int, Device> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Device? valueOf($core.int value) => _byValue[value];

  const Device._($core.int v, $core.String n) : super(v, n);
}

class RoverStatus extends $pb.ProtobufEnum {
  static const RoverStatus DISCONNECTED = RoverStatus._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'DISCONNECTED');
  static const RoverStatus IDLE = RoverStatus._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'IDLE');
  static const RoverStatus MANUAL = RoverStatus._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MANUAL');
  static const RoverStatus AUTONOMOUS = RoverStatus._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'AUTONOMOUS');
  static const RoverStatus POWER_OFF = RoverStatus._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'POWER_OFF');

  static const $core.List<RoverStatus> values = <RoverStatus> [
    DISCONNECTED,
    IDLE,
    MANUAL,
    AUTONOMOUS,
    POWER_OFF,
  ];

  static final $core.Map<$core.int, RoverStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static RoverStatus? valueOf($core.int value) => _byValue[value];

  const RoverStatus._($core.int v, $core.String n) : super(v, n);
}

