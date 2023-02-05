///
//  Generated code. Do not modify.
//  source: autonomy.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class AutonomyState extends $pb.ProtobufEnum {
  static const AutonomyState AUTONOMY_STATE_UNDEFINED = AutonomyState._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'AUTONOMY_STATE_UNDEFINED');
  static const AutonomyState OFF = AutonomyState._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'OFF');
  static const AutonomyState PATHING = AutonomyState._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PATHING');
  static const AutonomyState APPROACHING = AutonomyState._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'APPROACHING');
  static const AutonomyState AT_GATE = AutonomyState._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'AT_GATE');

  static const $core.List<AutonomyState> values = <AutonomyState> [
    AUTONOMY_STATE_UNDEFINED,
    OFF,
    PATHING,
    APPROACHING,
    AT_GATE,
  ];

  static final $core.Map<$core.int, AutonomyState> _byValue = $pb.ProtobufEnum.initByValue(values);
  static AutonomyState? valueOf($core.int value) => _byValue[value];

  const AutonomyState._($core.int v, $core.String n) : super(v, n);
}

