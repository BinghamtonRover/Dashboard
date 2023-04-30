///
//  Generated code. Do not modify.
//  source: arm.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class MotorDirection extends $pb.ProtobufEnum {
  static const MotorDirection MOTOR_DIRECTION_UNDEFINED = MotorDirection._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MOTOR_DIRECTION_UNDEFINED');
  static const MotorDirection UP = MotorDirection._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'UP');
  static const MotorDirection DOWN = MotorDirection._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'DOWN');
  static const MotorDirection LEFT = MotorDirection._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'LEFT');
  static const MotorDirection RIGHT = MotorDirection._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'RIGHT');
  static const MotorDirection CLOCKWISE = MotorDirection._(5, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CLOCKWISE');
  static const MotorDirection COUNTER_CLOCKWISE = MotorDirection._(6, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'COUNTER_CLOCKWISE');
  static const MotorDirection OPENING = MotorDirection._(7, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'OPENING');
  static const MotorDirection CLOSING = MotorDirection._(8, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CLOSING');
  static const MotorDirection NOT_MOVING = MotorDirection._(9, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'NOT_MOVING');

  static const $core.List<MotorDirection> values = <MotorDirection> [
    MOTOR_DIRECTION_UNDEFINED,
    UP,
    DOWN,
    LEFT,
    RIGHT,
    CLOCKWISE,
    COUNTER_CLOCKWISE,
    OPENING,
    CLOSING,
    NOT_MOVING,
  ];

  static final $core.Map<$core.int, MotorDirection> _byValue = $pb.ProtobufEnum.initByValue(values);
  static MotorDirection? valueOf($core.int value) => _byValue[value];

  const MotorDirection._($core.int v, $core.String n) : super(v, n);
}

