///
//  Generated code. Do not modify.
//  source: electrical.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class PowerMode extends $pb.ProtobufEnum {
  static const PowerMode POWER_MODE_UNDEFINED = PowerMode._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'POWER_MODE_UNDEFINED');
  static const PowerMode IDLE = PowerMode._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'IDLE');
  static const PowerMode ACTIVE = PowerMode._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ACTIVE');

  static const $core.List<PowerMode> values = <PowerMode> [
    POWER_MODE_UNDEFINED,
    IDLE,
    ACTIVE,
  ];

  static final $core.Map<$core.int, PowerMode> _byValue = $pb.ProtobufEnum.initByValue(values);
  static PowerMode? valueOf($core.int value) => _byValue[value];

  const PowerMode._($core.int v, $core.String n) : super(v, n);
}

class LedColor extends $pb.ProtobufEnum {
  static const LedColor LED_COLOR_UNDEFINED = LedColor._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'LED_COLOR_UNDEFINED');
  static const LedColor RED = LedColor._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'RED');
  static const LedColor YELLOW = LedColor._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'YELLOW');
  static const LedColor GREEN = LedColor._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'GREEN');

  static const $core.List<LedColor> values = <LedColor> [
    LED_COLOR_UNDEFINED,
    RED,
    YELLOW,
    GREEN,
  ];

  static final $core.Map<$core.int, LedColor> _byValue = $pb.ProtobufEnum.initByValue(values);
  static LedColor? valueOf($core.int value) => _byValue[value];

  const LedColor._($core.int v, $core.String n) : super(v, n);
}

