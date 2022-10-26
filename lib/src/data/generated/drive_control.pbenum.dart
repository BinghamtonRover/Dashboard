///
//  Generated code. Do not modify.
//  source: drive_control.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class DriveMode_Mode extends $pb.ProtobufEnum {
  static const DriveMode_Mode NEUTRAL = DriveMode_Mode._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'NEUTRAL');
  static const DriveMode_Mode DRIVE = DriveMode_Mode._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'DRIVE');
  static const DriveMode_Mode CALIBRATING = DriveMode_Mode._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CALIBRATING');
  static const DriveMode_Mode COUNT = DriveMode_Mode._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'COUNT');

  static const $core.List<DriveMode_Mode> values = <DriveMode_Mode> [
    NEUTRAL,
    DRIVE,
    CALIBRATING,
    COUNT,
  ];

  static final $core.Map<$core.int, DriveMode_Mode> _byValue = $pb.ProtobufEnum.initByValue(values);
  static DriveMode_Mode? valueOf($core.int value) => _byValue[value];

  const DriveMode_Mode._($core.int v, $core.String n) : super(v, n);
}

