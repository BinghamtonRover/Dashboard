///
//  Generated code. Do not modify.
//  source: video.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class CameraName extends $pb.ProtobufEnum {
  static const CameraName CAMERA_NAME_UNDEFINED = CameraName._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CAMERA_NAME_UNDEFINED');
  static const CameraName CAMERA_NAME_ROVER_FRONT = CameraName._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CAMERA_NAME_ROVER_FRONT');
  static const CameraName CAMERA_NAME_ROVER_REAR = CameraName._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CAMERA_NAME_ROVER_REAR');
  static const CameraName CAMERA_NAME_ARM_BASE = CameraName._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CAMERA_NAME_ARM_BASE');
  static const CameraName CAMERA_NAME_ARM_GRIPPER = CameraName._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CAMERA_NAME_ARM_GRIPPER');
  static const CameraName CAMERA_NAME_SCIENCE_CAROUSEL = CameraName._(5, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CAMERA_NAME_SCIENCE_CAROUSEL');
  static const CameraName CAMERA_NAME_SCIENCE_MICROSCOPE = CameraName._(6, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CAMERA_NAME_SCIENCE_MICROSCOPE');

  static const $core.List<CameraName> values = <CameraName> [
    CAMERA_NAME_UNDEFINED,
    CAMERA_NAME_ROVER_FRONT,
    CAMERA_NAME_ROVER_REAR,
    CAMERA_NAME_ARM_BASE,
    CAMERA_NAME_ARM_GRIPPER,
    CAMERA_NAME_SCIENCE_CAROUSEL,
    CAMERA_NAME_SCIENCE_MICROSCOPE,
  ];

  static final $core.Map<$core.int, CameraName> _byValue = $pb.ProtobufEnum.initByValue(values);
  static CameraName? valueOf($core.int value) => _byValue[value];

  const CameraName._($core.int v, $core.String n) : super(v, n);
}

