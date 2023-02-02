///
//  Generated code. Do not modify.
//  source: autonomy.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'gps.pb.dart' as $0;

import 'autonomy.pbenum.dart';

export 'autonomy.pbenum.dart';

class AutonomyData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AutonomyData', createEmptyInstance: create)
    ..aOM<$0.GpsCoordinates>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coordinates', subBuilder: $0.GpsCoordinates.create)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'heading', $pb.PbFieldType.OF)
    ..e<AutonomyState>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'state', $pb.PbFieldType.OE, defaultOrMaker: AutonomyState.AUTONOMY_STATE_UNDEFINED, valueOf: AutonomyState.valueOf, enumValues: AutonomyState.values)
    ..a<$core.double>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rawXOrientation', $pb.PbFieldType.OF)
    ..a<$core.double>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rawYOrientation', $pb.PbFieldType.OF)
    ..a<$core.double>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rawZOrientation', $pb.PbFieldType.OF)
    ..aOM<Grid>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'grid', subBuilder: Grid.create)
    ..hasRequiredFields = false
  ;

  AutonomyData._() : super();
  factory AutonomyData({
    $0.GpsCoordinates? coordinates,
    $core.double? heading,
    AutonomyState? state,
    $core.double? rawXOrientation,
    $core.double? rawYOrientation,
    $core.double? rawZOrientation,
    Grid? grid,
  }) {
    final _result = create();
    if (coordinates != null) {
      _result.coordinates = coordinates;
    }
    if (heading != null) {
      _result.heading = heading;
    }
    if (state != null) {
      _result.state = state;
    }
    if (rawXOrientation != null) {
      _result.rawXOrientation = rawXOrientation;
    }
    if (rawYOrientation != null) {
      _result.rawYOrientation = rawYOrientation;
    }
    if (rawZOrientation != null) {
      _result.rawZOrientation = rawZOrientation;
    }
    if (grid != null) {
      _result.grid = grid;
    }
    return _result;
  }
  factory AutonomyData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AutonomyData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AutonomyData clone() => AutonomyData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AutonomyData copyWith(void Function(AutonomyData) updates) => super.copyWith((message) => updates(message as AutonomyData)) as AutonomyData; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AutonomyData create() => AutonomyData._();
  AutonomyData createEmptyInstance() => create();
  static $pb.PbList<AutonomyData> createRepeated() => $pb.PbList<AutonomyData>();
  @$core.pragma('dart2js:noInline')
  static AutonomyData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AutonomyData>(create);
  static AutonomyData? _defaultInstance;

  @$pb.TagNumber(1)
  $0.GpsCoordinates get coordinates => $_getN(0);
  @$pb.TagNumber(1)
  set coordinates($0.GpsCoordinates v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCoordinates() => $_has(0);
  @$pb.TagNumber(1)
  void clearCoordinates() => clearField(1);
  @$pb.TagNumber(1)
  $0.GpsCoordinates ensureCoordinates() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.double get heading => $_getN(1);
  @$pb.TagNumber(2)
  set heading($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasHeading() => $_has(1);
  @$pb.TagNumber(2)
  void clearHeading() => clearField(2);

  @$pb.TagNumber(3)
  AutonomyState get state => $_getN(2);
  @$pb.TagNumber(3)
  set state(AutonomyState v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasState() => $_has(2);
  @$pb.TagNumber(3)
  void clearState() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get rawXOrientation => $_getN(3);
  @$pb.TagNumber(4)
  set rawXOrientation($core.double v) { $_setFloat(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasRawXOrientation() => $_has(3);
  @$pb.TagNumber(4)
  void clearRawXOrientation() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get rawYOrientation => $_getN(4);
  @$pb.TagNumber(5)
  set rawYOrientation($core.double v) { $_setFloat(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasRawYOrientation() => $_has(4);
  @$pb.TagNumber(5)
  void clearRawYOrientation() => clearField(5);

  @$pb.TagNumber(6)
  $core.double get rawZOrientation => $_getN(5);
  @$pb.TagNumber(6)
  set rawZOrientation($core.double v) { $_setFloat(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasRawZOrientation() => $_has(5);
  @$pb.TagNumber(6)
  void clearRawZOrientation() => clearField(6);

  @$pb.TagNumber(7)
  Grid get grid => $_getN(6);
  @$pb.TagNumber(7)
  set grid(Grid v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasGrid() => $_has(6);
  @$pb.TagNumber(7)
  void clearGrid() => clearField(7);
  @$pb.TagNumber(7)
  Grid ensureGrid() => $_ensure(6);
}

class Grid extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Grid', createEmptyInstance: create)
    ..pc<Row>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rows', $pb.PbFieldType.PM, subBuilder: Row.create)
    ..hasRequiredFields = false
  ;

  Grid._() : super();
  factory Grid({
    $core.Iterable<Row>? rows,
  }) {
    final _result = create();
    if (rows != null) {
      _result.rows.addAll(rows);
    }
    return _result;
  }
  factory Grid.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Grid.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Grid clone() => Grid()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Grid copyWith(void Function(Grid) updates) => super.copyWith((message) => updates(message as Grid)) as Grid; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Grid create() => Grid._();
  Grid createEmptyInstance() => create();
  static $pb.PbList<Grid> createRepeated() => $pb.PbList<Grid>();
  @$core.pragma('dart2js:noInline')
  static Grid getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Grid>(create);
  static Grid? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Row> get rows => $_getList(0);
}

class Row extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Row', createEmptyInstance: create)
    ..p<$core.bool>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isCellOccupied', $pb.PbFieldType.KB)
    ..hasRequiredFields = false
  ;

  Row._() : super();
  factory Row({
    $core.Iterable<$core.bool>? isCellOccupied,
  }) {
    final _result = create();
    if (isCellOccupied != null) {
      _result.isCellOccupied.addAll(isCellOccupied);
    }
    return _result;
  }
  factory Row.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Row.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Row clone() => Row()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Row copyWith(void Function(Row) updates) => super.copyWith((message) => updates(message as Row)) as Row; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Row create() => Row._();
  Row createEmptyInstance() => create();
  static $pb.PbList<Row> createRepeated() => $pb.PbList<Row>();
  @$core.pragma('dart2js:noInline')
  static Row getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Row>(create);
  static Row? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.bool> get isCellOccupied => $_getList(0);
}

