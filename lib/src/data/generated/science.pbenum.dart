///
//  Generated code. Do not modify.
//  source: science.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class DirtReleasePosition extends $pb.ProtobufEnum {
  static const DirtReleasePosition TEMP_UNDEFINED = DirtReleasePosition._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'TEMP_UNDEFINED');
  static const DirtReleasePosition OPEN_DIRT = DirtReleasePosition._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'OPEN_DIRT');
  static const DirtReleasePosition CLOSE_DIRT = DirtReleasePosition._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CLOSE_DIRT');

  static const $core.List<DirtReleasePosition> values = <DirtReleasePosition> [
    TEMP_UNDEFINED,
    OPEN_DIRT,
    CLOSE_DIRT,
  ];

  static final $core.Map<$core.int, DirtReleasePosition> _byValue = $pb.ProtobufEnum.initByValue(values);
  static DirtReleasePosition? valueOf($core.int value) => _byValue[value];

  const DirtReleasePosition._($core.int v, $core.String n) : super(v, n);
}

class PumpState extends $pb.ProtobufEnum {
  static const PumpState P_U = PumpState._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'P_U');
  static const PumpState PUMP_ON = PumpState._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PUMP_ON');
  static const PumpState PUMP_OFF = PumpState._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PUMP_OFF');

  static const $core.List<PumpState> values = <PumpState> [
    P_U,
    PUMP_ON,
    PUMP_OFF,
  ];

  static final $core.Map<$core.int, PumpState> _byValue = $pb.ProtobufEnum.initByValue(values);
  static PumpState? valueOf($core.int value) => _byValue[value];

  const PumpState._($core.int v, $core.String n) : super(v, n);
}

