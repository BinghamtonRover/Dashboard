///
//  Generated code. Do not modify.
//  source: science.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class PumpState extends $pb.ProtobufEnum {
  static const PumpState PUMP_STATE_UNDEFINED = PumpState._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PUMP_STATE_UNDEFINED');
  static const PumpState PUMP_ON = PumpState._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PUMP_ON');
  static const PumpState PUMP_OFF = PumpState._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PUMP_OFF');

  static const $core.List<PumpState> values = <PumpState> [
    PUMP_STATE_UNDEFINED,
    PUMP_ON,
    PUMP_OFF,
  ];

  static final $core.Map<$core.int, PumpState> _byValue = $pb.ProtobufEnum.initByValue(values);
  static PumpState? valueOf($core.int value) => _byValue[value];

  const PumpState._($core.int v, $core.String n) : super(v, n);
}

class DirtReleaseState extends $pb.ProtobufEnum {
  static const DirtReleaseState DIRT_RELEASE_STATE_UNDEFINED = DirtReleaseState._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'DIRT_RELEASE_STATE_UNDEFINED');
  static const DirtReleaseState OPEN_DIRT = DirtReleaseState._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'OPEN_DIRT');
  static const DirtReleaseState CLOSE_DIRT = DirtReleaseState._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CLOSE_DIRT');

  static const $core.List<DirtReleaseState> values = <DirtReleaseState> [
    DIRT_RELEASE_STATE_UNDEFINED,
    OPEN_DIRT,
    CLOSE_DIRT,
  ];

  static final $core.Map<$core.int, DirtReleaseState> _byValue = $pb.ProtobufEnum.initByValue(values);
  static DirtReleaseState? valueOf($core.int value) => _byValue[value];

  const DirtReleaseState._($core.int v, $core.String n) : super(v, n);
}

