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
  static const AutonomyState PATHING = AutonomyState._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PATHING');
  static const AutonomyState APPROACHING = AutonomyState._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'APPROACHING');
  static const AutonomyState AT_DESTINATION = AutonomyState._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'AT_DESTINATION');
  static const AutonomyState DRIVING = AutonomyState._(5, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'DRIVING');
  static const AutonomyState SEARCHING = AutonomyState._(6, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SEARCHING');
  static const AutonomyState NO_SOLUTION = AutonomyState._(7, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'NO_SOLUTION');
  static const AutonomyState ABORTING = AutonomyState._(8, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ABORTING');

  static const $core.List<AutonomyState> values = <AutonomyState> [
    AUTONOMY_STATE_UNDEFINED,
    PATHING,
    APPROACHING,
    AT_DESTINATION,
    DRIVING,
    SEARCHING,
    NO_SOLUTION,
    ABORTING,
  ];

  static final $core.Map<$core.int, AutonomyState> _byValue = $pb.ProtobufEnum.initByValue(values);
  static AutonomyState? valueOf($core.int value) => _byValue[value];

  const AutonomyState._($core.int v, $core.String n) : super(v, n);
}

class AutonomyTask extends $pb.ProtobufEnum {
  static const AutonomyTask AUTONOMY_TASK_UNDEFINED = AutonomyTask._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'AUTONOMY_TASK_UNDEFINED');
  static const AutonomyTask GPS_ONLY = AutonomyTask._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'GPS_ONLY');
  static const AutonomyTask VISUAL_MARKER = AutonomyTask._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'VISUAL_MARKER');
  static const AutonomyTask BETWEEN_GATES = AutonomyTask._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'BETWEEN_GATES');

  static const $core.List<AutonomyTask> values = <AutonomyTask> [
    AUTONOMY_TASK_UNDEFINED,
    GPS_ONLY,
    VISUAL_MARKER,
    BETWEEN_GATES,
  ];

  static final $core.Map<$core.int, AutonomyTask> _byValue = $pb.ProtobufEnum.initByValue(values);
  static AutonomyTask? valueOf($core.int value) => _byValue[value];

  const AutonomyTask._($core.int v, $core.String n) : super(v, n);
}

