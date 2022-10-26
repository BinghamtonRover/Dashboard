///
//  Generated code. Do not modify.
//  source: sensor_control.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class ElectricalData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ElectricalData', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sensor'), createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'batteryVoltage', $pb.PbFieldType.OF)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'batteryCurrent', $pb.PbFieldType.OF)
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'v12SupplyVoltage', $pb.PbFieldType.OF)
    ..a<$core.double>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'v12SupplyCurrent', $pb.PbFieldType.OF)
    ..a<$core.double>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'v12SupplyTemperature', $pb.PbFieldType.OF)
    ..a<$core.double>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'v5SupplyVoltage', $pb.PbFieldType.OF)
    ..a<$core.double>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'v5SupplyCurrent', $pb.PbFieldType.OF)
    ..a<$core.double>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'v5SupplyTemperature', $pb.PbFieldType.OF)
    ..a<$core.double>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'odrive0Current', $pb.PbFieldType.OF)
    ..a<$core.double>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'odrive1Current', $pb.PbFieldType.OF)
    ..a<$core.double>(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'odrive2Current', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  ElectricalData._() : super();
  factory ElectricalData({
    $core.double? batteryVoltage,
    $core.double? batteryCurrent,
    $core.double? v12SupplyVoltage,
    $core.double? v12SupplyCurrent,
    $core.double? v12SupplyTemperature,
    $core.double? v5SupplyVoltage,
    $core.double? v5SupplyCurrent,
    $core.double? v5SupplyTemperature,
    $core.double? odrive0Current,
    $core.double? odrive1Current,
    $core.double? odrive2Current,
  }) {
    final _result = create();
    if (batteryVoltage != null) {
      _result.batteryVoltage = batteryVoltage;
    }
    if (batteryCurrent != null) {
      _result.batteryCurrent = batteryCurrent;
    }
    if (v12SupplyVoltage != null) {
      _result.v12SupplyVoltage = v12SupplyVoltage;
    }
    if (v12SupplyCurrent != null) {
      _result.v12SupplyCurrent = v12SupplyCurrent;
    }
    if (v12SupplyTemperature != null) {
      _result.v12SupplyTemperature = v12SupplyTemperature;
    }
    if (v5SupplyVoltage != null) {
      _result.v5SupplyVoltage = v5SupplyVoltage;
    }
    if (v5SupplyCurrent != null) {
      _result.v5SupplyCurrent = v5SupplyCurrent;
    }
    if (v5SupplyTemperature != null) {
      _result.v5SupplyTemperature = v5SupplyTemperature;
    }
    if (odrive0Current != null) {
      _result.odrive0Current = odrive0Current;
    }
    if (odrive1Current != null) {
      _result.odrive1Current = odrive1Current;
    }
    if (odrive2Current != null) {
      _result.odrive2Current = odrive2Current;
    }
    return _result;
  }
  factory ElectricalData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ElectricalData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ElectricalData clone() => ElectricalData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ElectricalData copyWith(void Function(ElectricalData) updates) => super.copyWith((message) => updates(message as ElectricalData)) as ElectricalData; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ElectricalData create() => ElectricalData._();
  ElectricalData createEmptyInstance() => create();
  static $pb.PbList<ElectricalData> createRepeated() => $pb.PbList<ElectricalData>();
  @$core.pragma('dart2js:noInline')
  static ElectricalData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ElectricalData>(create);
  static ElectricalData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get batteryVoltage => $_getN(0);
  @$pb.TagNumber(1)
  set batteryVoltage($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBatteryVoltage() => $_has(0);
  @$pb.TagNumber(1)
  void clearBatteryVoltage() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get batteryCurrent => $_getN(1);
  @$pb.TagNumber(2)
  set batteryCurrent($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBatteryCurrent() => $_has(1);
  @$pb.TagNumber(2)
  void clearBatteryCurrent() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get v12SupplyVoltage => $_getN(2);
  @$pb.TagNumber(3)
  set v12SupplyVoltage($core.double v) { $_setFloat(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasV12SupplyVoltage() => $_has(2);
  @$pb.TagNumber(3)
  void clearV12SupplyVoltage() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get v12SupplyCurrent => $_getN(3);
  @$pb.TagNumber(4)
  set v12SupplyCurrent($core.double v) { $_setFloat(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasV12SupplyCurrent() => $_has(3);
  @$pb.TagNumber(4)
  void clearV12SupplyCurrent() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get v12SupplyTemperature => $_getN(4);
  @$pb.TagNumber(5)
  set v12SupplyTemperature($core.double v) { $_setFloat(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasV12SupplyTemperature() => $_has(4);
  @$pb.TagNumber(5)
  void clearV12SupplyTemperature() => clearField(5);

  @$pb.TagNumber(6)
  $core.double get v5SupplyVoltage => $_getN(5);
  @$pb.TagNumber(6)
  set v5SupplyVoltage($core.double v) { $_setFloat(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasV5SupplyVoltage() => $_has(5);
  @$pb.TagNumber(6)
  void clearV5SupplyVoltage() => clearField(6);

  @$pb.TagNumber(7)
  $core.double get v5SupplyCurrent => $_getN(6);
  @$pb.TagNumber(7)
  set v5SupplyCurrent($core.double v) { $_setFloat(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasV5SupplyCurrent() => $_has(6);
  @$pb.TagNumber(7)
  void clearV5SupplyCurrent() => clearField(7);

  @$pb.TagNumber(8)
  $core.double get v5SupplyTemperature => $_getN(7);
  @$pb.TagNumber(8)
  set v5SupplyTemperature($core.double v) { $_setFloat(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasV5SupplyTemperature() => $_has(7);
  @$pb.TagNumber(8)
  void clearV5SupplyTemperature() => clearField(8);

  @$pb.TagNumber(9)
  $core.double get odrive0Current => $_getN(8);
  @$pb.TagNumber(9)
  set odrive0Current($core.double v) { $_setFloat(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasOdrive0Current() => $_has(8);
  @$pb.TagNumber(9)
  void clearOdrive0Current() => clearField(9);

  @$pb.TagNumber(10)
  $core.double get odrive1Current => $_getN(9);
  @$pb.TagNumber(10)
  set odrive1Current($core.double v) { $_setFloat(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasOdrive1Current() => $_has(9);
  @$pb.TagNumber(10)
  void clearOdrive1Current() => clearField(10);

  @$pb.TagNumber(11)
  $core.double get odrive2Current => $_getN(10);
  @$pb.TagNumber(11)
  set odrive2Current($core.double v) { $_setFloat(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasOdrive2Current() => $_has(10);
  @$pb.TagNumber(11)
  void clearOdrive2Current() => clearField(11);
}

