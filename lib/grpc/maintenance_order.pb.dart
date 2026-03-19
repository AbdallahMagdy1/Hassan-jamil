// Manually written from maintenance_order.proto
// Re-generate with: protoc --dart_out=grpc:lib/grpc Protos/maintenance_order.proto
// ignore_for_file: annotate_overrides, camel_case_types, constant_identifier_names
// ignore_for_file: non_constant_identifier_names, prefer_final_fields, unnecessary_this

import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

/// Sent by the Flutter client to open the stream.
/// Set customerId to the logged-in user's CustID.
class StreamRequest extends $pb.GeneratedMessage {
  factory StreamRequest({$core.String? customerId}) {
    final $result = create();
    if (customerId != null) $result.customerId = customerId;
    return $result;
  }

  StreamRequest._() : super();

  factory StreamRequest.fromBuffer(
    $core.List<$core.int> i, [
    $pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY,
  ]) => create()..mergeFromBuffer(i, r);

  factory StreamRequest.fromJson(
    $core.String i, [
    $pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY,
  ]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'StreamRequest',
          package: const $pb.PackageName(
            const $core.bool.fromEnvironment('protobuf.omit_message_names')
                ? ''
                : 'maintenanceorder',
          ),
          createEmptyInstance: create,
        )
        ..aOS(
          1,
          const $core.bool.fromEnvironment('protobuf.omit_field_names')
              ? ''
              : 'customerId',
        )
        ..hasRequiredFields = false;

  StreamRequest copyWith(void Function(StreamRequest) updates) =>
      super.copyWith((m) => updates(m as StreamRequest)) as StreamRequest;

  @$core.override
  StreamRequest clone() => StreamRequest()..mergeFromMessage(this);

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StreamRequest create() => StreamRequest._();
  StreamRequest createEmptyInstance() => create();
  static $pb.PbList<StreamRequest> createRepeated() =>
      $pb.PbList<StreamRequest>();
  @$core.pragma('dart2js:noInline')
  static StreamRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StreamRequest>(create);
  static StreamRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get customerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set customerId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCustomerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCustomerId() => clearField(1);
}

/// Streamed to Flutter whenever a FleetMaintenanceOrder row is inserted or updated.
/// Fields 13 and 14 (isClosed / isCanceled) let Flutter know when tracking is over.
class MaintenanceOrderUpdate extends $pb.GeneratedMessage {
  factory MaintenanceOrderUpdate({
    $core.String? maintenanceOrderId,
    $core.String? dateIn,
    $core.String? dateCompleteInspection,
    $core.int? orderStatusId,
    $core.String? vehicleId,
    $core.String? plateNo,
    $core.String? descriptionAr,
    $core.String? descriptionEn,
    $core.String? custId,
    $core.String? defectIn,
    $core.String? placeOfRepair,
    $core.String? eventTime,
    $core.bool? isClosed,
    $core.bool? isCanceled,
  }) {
    final $result = create();
    if (maintenanceOrderId != null)
      $result.maintenanceOrderId = maintenanceOrderId;
    if (dateIn != null) $result.dateIn = dateIn;
    if (dateCompleteInspection != null)
      $result.dateCompleteInspection = dateCompleteInspection;
    if (orderStatusId != null) $result.orderStatusId = orderStatusId;
    if (vehicleId != null) $result.vehicleId = vehicleId;
    if (plateNo != null) $result.plateNo = plateNo;
    if (descriptionAr != null) $result.descriptionAr = descriptionAr;
    if (descriptionEn != null) $result.descriptionEn = descriptionEn;
    if (custId != null) $result.custId = custId;
    if (defectIn != null) $result.defectIn = defectIn;
    if (placeOfRepair != null) $result.placeOfRepair = placeOfRepair;
    if (eventTime != null) $result.eventTime = eventTime;
    if (isClosed != null) $result.isClosed = isClosed;
    if (isCanceled != null) $result.isCanceled = isCanceled;
    return $result;
  }

  MaintenanceOrderUpdate._() : super();

  factory MaintenanceOrderUpdate.fromBuffer(
    $core.List<$core.int> i, [
    $pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY,
  ]) => create()..mergeFromBuffer(i, r);

  factory MaintenanceOrderUpdate.fromJson(
    $core.String i, [
    $pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY,
  ]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'MaintenanceOrderUpdate',
          package: const $pb.PackageName(
            const $core.bool.fromEnvironment('protobuf.omit_message_names')
                ? ''
                : 'maintenanceorder',
          ),
          createEmptyInstance: create,
        )
        ..aOS(
          1,
          const $core.bool.fromEnvironment('protobuf.omit_field_names')
              ? ''
              : 'maintenanceOrderId',
        )
        ..aOS(
          2,
          const $core.bool.fromEnvironment('protobuf.omit_field_names')
              ? ''
              : 'dateIn',
        )
        ..aOS(
          3,
          const $core.bool.fromEnvironment('protobuf.omit_field_names')
              ? ''
              : 'dateCompleteInspection',
        )
        ..a<$core.int>(
          4,
          const $core.bool.fromEnvironment('protobuf.omit_field_names')
              ? ''
              : 'orderStatusId',
          $pb.PbFieldType.O3,
        )
        ..aOS(
          5,
          const $core.bool.fromEnvironment('protobuf.omit_field_names')
              ? ''
              : 'vehicleId',
        )
        ..aOS(
          6,
          const $core.bool.fromEnvironment('protobuf.omit_field_names')
              ? ''
              : 'plateNo',
        )
        ..aOS(
          7,
          const $core.bool.fromEnvironment('protobuf.omit_field_names')
              ? ''
              : 'descriptionAr',
        )
        ..aOS(
          8,
          const $core.bool.fromEnvironment('protobuf.omit_field_names')
              ? ''
              : 'descriptionEn',
        )
        ..aOS(
          9,
          const $core.bool.fromEnvironment('protobuf.omit_field_names')
              ? ''
              : 'custId',
        )
        ..aOS(
          10,
          const $core.bool.fromEnvironment('protobuf.omit_field_names')
              ? ''
              : 'defectIn',
        )
        ..aOS(
          11,
          const $core.bool.fromEnvironment('protobuf.omit_field_names')
              ? ''
              : 'placeOfRepair',
        )
        ..aOS(
          12,
          const $core.bool.fromEnvironment('protobuf.omit_field_names')
              ? ''
              : 'eventTime',
        )
        ..aOB(
          13,
          const $core.bool.fromEnvironment('protobuf.omit_field_names')
              ? ''
              : 'isClosed',
        )
        ..aOB(
          14,
          const $core.bool.fromEnvironment('protobuf.omit_field_names')
              ? ''
              : 'isCanceled',
        )
        ..hasRequiredFields = false;

  MaintenanceOrderUpdate copyWith(
    void Function(MaintenanceOrderUpdate) updates,
  ) =>
      super.copyWith((m) => updates(m as MaintenanceOrderUpdate))
          as MaintenanceOrderUpdate;

  @$core.override
  MaintenanceOrderUpdate clone() =>
      MaintenanceOrderUpdate()..mergeFromMessage(this);

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MaintenanceOrderUpdate create() => MaintenanceOrderUpdate._();
  MaintenanceOrderUpdate createEmptyInstance() => create();
  static $pb.PbList<MaintenanceOrderUpdate> createRepeated() =>
      $pb.PbList<MaintenanceOrderUpdate>();
  @$core.pragma('dart2js:noInline')
  static MaintenanceOrderUpdate getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MaintenanceOrderUpdate>(create);
  static MaintenanceOrderUpdate? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get maintenanceOrderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set maintenanceOrderId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasMaintenanceOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMaintenanceOrderId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get dateIn => $_getSZ(1);
  @$pb.TagNumber(2)
  set dateIn($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasDateIn() => $_has(1);
  @$pb.TagNumber(2)
  void clearDateIn() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get dateCompleteInspection => $_getSZ(2);
  @$pb.TagNumber(3)
  set dateCompleteInspection($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasDateCompleteInspection() => $_has(2);
  @$pb.TagNumber(3)
  void clearDateCompleteInspection() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get orderStatusId => $_getIZ(3);
  @$pb.TagNumber(4)
  set orderStatusId($core.int v) {
    $_setSignedInt32(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasOrderStatusId() => $_has(3);
  @$pb.TagNumber(4)
  void clearOrderStatusId() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get vehicleId => $_getSZ(4);
  @$pb.TagNumber(5)
  set vehicleId($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasVehicleId() => $_has(4);
  @$pb.TagNumber(5)
  void clearVehicleId() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get plateNo => $_getSZ(5);
  @$pb.TagNumber(6)
  set plateNo($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasPlateNo() => $_has(5);
  @$pb.TagNumber(6)
  void clearPlateNo() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get descriptionAr => $_getSZ(6);
  @$pb.TagNumber(7)
  set descriptionAr($core.String v) {
    $_setString(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasDescriptionAr() => $_has(6);
  @$pb.TagNumber(7)
  void clearDescriptionAr() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get descriptionEn => $_getSZ(7);
  @$pb.TagNumber(8)
  set descriptionEn($core.String v) {
    $_setString(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasDescriptionEn() => $_has(7);
  @$pb.TagNumber(8)
  void clearDescriptionEn() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get custId => $_getSZ(8);
  @$pb.TagNumber(9)
  set custId($core.String v) {
    $_setString(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasCustId() => $_has(8);
  @$pb.TagNumber(9)
  void clearCustId() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get defectIn => $_getSZ(9);
  @$pb.TagNumber(10)
  set defectIn($core.String v) {
    $_setString(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasDefectIn() => $_has(9);
  @$pb.TagNumber(10)
  void clearDefectIn() => clearField(10);

  @$pb.TagNumber(11)
  $core.String get placeOfRepair => $_getSZ(10);
  @$pb.TagNumber(11)
  set placeOfRepair($core.String v) {
    $_setString(10, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasPlaceOfRepair() => $_has(10);
  @$pb.TagNumber(11)
  void clearPlaceOfRepair() => clearField(11);

  @$pb.TagNumber(12)
  $core.String get eventTime => $_getSZ(11);
  @$pb.TagNumber(12)
  set eventTime($core.String v) {
    $_setString(11, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasEventTime() => $_has(11);
  @$pb.TagNumber(12)
  void clearEventTime() => clearField(12);

  /// True when the order is fully delivered/completed (not canceled).
  @$pb.TagNumber(13)
  $core.bool get isClosed => $_getBF(12);
  @$pb.TagNumber(13)
  set isClosed($core.bool v) {
    $_setBool(12, v);
  }

  @$pb.TagNumber(13)
  $core.bool hasIsClosed() => $_has(12);
  @$pb.TagNumber(13)
  void clearIsClosed() => clearField(13);

  /// True when the order was canceled (not completed).
  @$pb.TagNumber(14)
  $core.bool get isCanceled => $_getBF(13);
  @$pb.TagNumber(14)
  set isCanceled($core.bool v) {
    $_setBool(13, v);
  }

  @$pb.TagNumber(14)
  $core.bool hasIsCanceled() => $_has(13);
  @$pb.TagNumber(14)
  void clearIsCanceled() => clearField(14);

  /// Convenience getter: true if the order has reached a terminal state.
  $core.bool get isTerminal => isClosed || isCanceled || orderStatusId >= 6;
}

/// Client confirms receipt of a terminal or vital update.
class AckRequest extends $pb.GeneratedMessage {
  factory AckRequest({
    $core.String? customerId,
    $core.String? maintenanceOrderId,
    $core.int? orderStatusId,
  }) {
    final $result = create();
    if (customerId != null) $result.customerId = customerId;
    if (maintenanceOrderId != null)
      $result.maintenanceOrderId = maintenanceOrderId;
    if (orderStatusId != null) $result.orderStatusId = orderStatusId;
    return $result;
  }
  AckRequest._() : super();
  factory AckRequest.fromBuffer(
    $core.List<$core.int> i, [
    $pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY,
  ]) => create()..mergeFromBuffer(i, r);
  factory AckRequest.fromJson(
    $core.String i, [
    $pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY,
  ]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo(
          'AckRequest',
          package: const $pb.PackageName('maintenanceorder'),
          createEmptyInstance: create,
        )
        ..aOS(1, 'customerId')
        ..aOS(2, 'maintenanceOrderId')
        ..a<$core.int>(3, 'orderStatusId', $pb.PbFieldType.O3)
        ..hasRequiredFields = false;

  @$core.override
  AckRequest clone() => AckRequest()..mergeFromMessage(this);
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AckRequest create() => AckRequest._();
  AckRequest createEmptyInstance() => create();

  @$pb.TagNumber(1)
  $core.String get customerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set customerId($core.String v) => $_setString(0, v);

  @$pb.TagNumber(2)
  $core.String get maintenanceOrderId => $_getSZ(1);
  @$pb.TagNumber(2)
  set maintenanceOrderId($core.String v) => $_setString(1, v);

  @$pb.TagNumber(3)
  $core.int get orderStatusId => $_getIZ(2);
  @$pb.TagNumber(3)
  set orderStatusId($core.int v) => $_setSignedInt32(2, v);
}

class AckResponse extends $pb.GeneratedMessage {
  factory AckResponse({$core.bool? success}) {
    final $result = create();
    if (success != null) $result.success = success;
    return $result;
  }
  AckResponse._() : super();
  factory AckResponse.fromBuffer(
    $core.List<$core.int> i, [
    $pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY,
  ]) => create()..mergeFromBuffer(i, r);
  factory AckResponse.fromJson(
    $core.String i, [
    $pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY,
  ]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo(
          'AckResponse',
          package: const $pb.PackageName('maintenanceorder'),
          createEmptyInstance: create,
        )
        ..aOB(1, 'success')
        ..hasRequiredFields = false;

  @$core.override
  AckResponse clone() => AckResponse()..mergeFromMessage(this);
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AckResponse create() => AckResponse._();
  AckResponse createEmptyInstance() => create();

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool v) => $_setBool(0, v);
}
