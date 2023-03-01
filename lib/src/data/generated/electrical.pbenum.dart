///
//  Generated code. Do not modify.
//  source: electrical.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class LedButtonColor extends $pb.ProtobufEnum {
  static const LedButtonColor LED_COLOR_UNDEFINED = LedButtonColor._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'LED_COLOR_UNDEFINED');
  static const LedButtonColor RED = LedButtonColor._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'RED');
  static const LedButtonColor YELLOW = LedButtonColor._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'YELLOW');
  static const LedButtonColor GREEN = LedButtonColor._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'GREEN');

  static const $core.List<LedButtonColor> values = <LedButtonColor> [
    LED_COLOR_UNDEFINED,
    RED,
    YELLOW,
    GREEN,
  ];

  static final $core.Map<$core.int, LedButtonColor> _byValue = $pb.ProtobufEnum.initByValue(values);
  static LedButtonColor? valueOf($core.int value) => _byValue[value];

  const LedButtonColor._($core.int v, $core.String n) : super(v, n);
}

