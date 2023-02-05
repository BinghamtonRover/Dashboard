///
//  Generated code. Do not modify.
//  source: science.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class ScienceCommand extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ScienceCommand', createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'dig')
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'spinCarouselTube')
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'spinCarouselSection')
    ..aOB(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'vacuumSuck')
    ..a<$core.double>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'carouselAngle', $pb.PbFieldType.OF)
    ..a<$core.double>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'carouselLinearPosition', $pb.PbFieldType.OF)
    ..a<$core.double>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'testLinearPosition', $pb.PbFieldType.OF)
    ..a<$core.double>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'vacuumLinearPosition', $pb.PbFieldType.OF)
    ..aOB(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pump1')
    ..aOB(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pump2')
    ..aOB(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pump3')
    ..aOB(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pump4')
    ..hasRequiredFields = false
  ;

  ScienceCommand._() : super();
  factory ScienceCommand({
    $core.bool? dig,
    $core.bool? spinCarouselTube,
    $core.bool? spinCarouselSection,
    $core.bool? vacuumSuck,
    $core.double? carouselAngle,
    $core.double? carouselLinearPosition,
    $core.double? testLinearPosition,
    $core.double? vacuumLinearPosition,
    $core.bool? pump1,
    $core.bool? pump2,
    $core.bool? pump3,
    $core.bool? pump4,
  }) {
    final _result = create();
    if (dig != null) {
      _result.dig = dig;
    }
    if (spinCarouselTube != null) {
      _result.spinCarouselTube = spinCarouselTube;
    }
    if (spinCarouselSection != null) {
      _result.spinCarouselSection = spinCarouselSection;
    }
    if (vacuumSuck != null) {
      _result.vacuumSuck = vacuumSuck;
    }
    if (carouselAngle != null) {
      _result.carouselAngle = carouselAngle;
    }
    if (carouselLinearPosition != null) {
      _result.carouselLinearPosition = carouselLinearPosition;
    }
    if (testLinearPosition != null) {
      _result.testLinearPosition = testLinearPosition;
    }
    if (vacuumLinearPosition != null) {
      _result.vacuumLinearPosition = vacuumLinearPosition;
    }
    if (pump1 != null) {
      _result.pump1 = pump1;
    }
    if (pump2 != null) {
      _result.pump2 = pump2;
    }
    if (pump3 != null) {
      _result.pump3 = pump3;
    }
    if (pump4 != null) {
      _result.pump4 = pump4;
    }
    return _result;
  }
  factory ScienceCommand.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ScienceCommand.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ScienceCommand clone() => ScienceCommand()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ScienceCommand copyWith(void Function(ScienceCommand) updates) => super.copyWith((message) => updates(message as ScienceCommand)) as ScienceCommand; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ScienceCommand create() => ScienceCommand._();
  ScienceCommand createEmptyInstance() => create();
  static $pb.PbList<ScienceCommand> createRepeated() => $pb.PbList<ScienceCommand>();
  @$core.pragma('dart2js:noInline')
  static ScienceCommand getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ScienceCommand>(create);
  static ScienceCommand? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get dig => $_getBF(0);
  @$pb.TagNumber(1)
  set dig($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDig() => $_has(0);
  @$pb.TagNumber(1)
  void clearDig() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get spinCarouselTube => $_getBF(1);
  @$pb.TagNumber(2)
  set spinCarouselTube($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSpinCarouselTube() => $_has(1);
  @$pb.TagNumber(2)
  void clearSpinCarouselTube() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get spinCarouselSection => $_getBF(2);
  @$pb.TagNumber(3)
  set spinCarouselSection($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSpinCarouselSection() => $_has(2);
  @$pb.TagNumber(3)
  void clearSpinCarouselSection() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get vacuumSuck => $_getBF(3);
  @$pb.TagNumber(4)
  set vacuumSuck($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasVacuumSuck() => $_has(3);
  @$pb.TagNumber(4)
  void clearVacuumSuck() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get carouselAngle => $_getN(4);
  @$pb.TagNumber(5)
  set carouselAngle($core.double v) { $_setFloat(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasCarouselAngle() => $_has(4);
  @$pb.TagNumber(5)
  void clearCarouselAngle() => clearField(5);

  @$pb.TagNumber(6)
  $core.double get carouselLinearPosition => $_getN(5);
  @$pb.TagNumber(6)
  set carouselLinearPosition($core.double v) { $_setFloat(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasCarouselLinearPosition() => $_has(5);
  @$pb.TagNumber(6)
  void clearCarouselLinearPosition() => clearField(6);

  @$pb.TagNumber(7)
  $core.double get testLinearPosition => $_getN(6);
  @$pb.TagNumber(7)
  set testLinearPosition($core.double v) { $_setFloat(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasTestLinearPosition() => $_has(6);
  @$pb.TagNumber(7)
  void clearTestLinearPosition() => clearField(7);

  @$pb.TagNumber(8)
  $core.double get vacuumLinearPosition => $_getN(7);
  @$pb.TagNumber(8)
  set vacuumLinearPosition($core.double v) { $_setFloat(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasVacuumLinearPosition() => $_has(7);
  @$pb.TagNumber(8)
  void clearVacuumLinearPosition() => clearField(8);

  @$pb.TagNumber(9)
  $core.bool get pump1 => $_getBF(8);
  @$pb.TagNumber(9)
  set pump1($core.bool v) { $_setBool(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasPump1() => $_has(8);
  @$pb.TagNumber(9)
  void clearPump1() => clearField(9);

  @$pb.TagNumber(10)
  $core.bool get pump2 => $_getBF(9);
  @$pb.TagNumber(10)
  set pump2($core.bool v) { $_setBool(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasPump2() => $_has(9);
  @$pb.TagNumber(10)
  void clearPump2() => clearField(10);

  @$pb.TagNumber(11)
  $core.bool get pump3 => $_getBF(10);
  @$pb.TagNumber(11)
  set pump3($core.bool v) { $_setBool(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasPump3() => $_has(10);
  @$pb.TagNumber(11)
  void clearPump3() => clearField(11);

  @$pb.TagNumber(12)
  $core.bool get pump4 => $_getBF(11);
  @$pb.TagNumber(12)
  set pump4($core.bool v) { $_setBool(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasPump4() => $_has(11);
  @$pb.TagNumber(12)
  void clearPump4() => clearField(12);
}

class ScienceData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ScienceData', createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'co2', $pb.PbFieldType.OF)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'humidity', $pb.PbFieldType.OF)
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'methane', $pb.PbFieldType.OF)
    ..a<$core.double>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pH', $pb.PbFieldType.OF, protoName: 'pH')
    ..a<$core.double>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'temperature', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  ScienceData._() : super();
  factory ScienceData({
    $core.double? co2,
    $core.double? humidity,
    $core.double? methane,
    $core.double? pH,
    $core.double? temperature,
  }) {
    final _result = create();
    if (co2 != null) {
      _result.co2 = co2;
    }
    if (humidity != null) {
      _result.humidity = humidity;
    }
    if (methane != null) {
      _result.methane = methane;
    }
    if (pH != null) {
      _result.pH = pH;
    }
    if (temperature != null) {
      _result.temperature = temperature;
    }
    return _result;
  }
  factory ScienceData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ScienceData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ScienceData clone() => ScienceData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ScienceData copyWith(void Function(ScienceData) updates) => super.copyWith((message) => updates(message as ScienceData)) as ScienceData; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ScienceData create() => ScienceData._();
  ScienceData createEmptyInstance() => create();
  static $pb.PbList<ScienceData> createRepeated() => $pb.PbList<ScienceData>();
  @$core.pragma('dart2js:noInline')
  static ScienceData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ScienceData>(create);
  static ScienceData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get co2 => $_getN(0);
  @$pb.TagNumber(1)
  set co2($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCo2() => $_has(0);
  @$pb.TagNumber(1)
  void clearCo2() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get humidity => $_getN(1);
  @$pb.TagNumber(2)
  set humidity($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasHumidity() => $_has(1);
  @$pb.TagNumber(2)
  void clearHumidity() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get methane => $_getN(2);
  @$pb.TagNumber(3)
  set methane($core.double v) { $_setFloat(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMethane() => $_has(2);
  @$pb.TagNumber(3)
  void clearMethane() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get pH => $_getN(3);
  @$pb.TagNumber(4)
  set pH($core.double v) { $_setFloat(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPH() => $_has(3);
  @$pb.TagNumber(4)
  void clearPH() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get temperature => $_getN(4);
  @$pb.TagNumber(5)
  set temperature($core.double v) { $_setFloat(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasTemperature() => $_has(4);
  @$pb.TagNumber(5)
  void clearTemperature() => clearField(5);
}

