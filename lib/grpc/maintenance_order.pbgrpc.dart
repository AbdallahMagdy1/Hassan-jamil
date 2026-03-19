// Manually written gRPC client stub from maintenance_order.proto
// ignore_for_file: annotate_overrides, camel_case_types, constant_identifier_names
// ignore_for_file: non_constant_identifier_names, unnecessary_this

import 'dart:async' as $async;
import 'dart:core' as $core;
import 'package:grpc/service_api.dart' as $grpc;
import 'maintenance_order.pb.dart' as $0;

export 'maintenance_order.pb.dart';

/// gRPC client for the MaintenanceOrderService.
class MaintenanceOrderServiceClient extends $grpc.Client {
  static final _$streamMaintenanceUpdates =
      $grpc.ClientMethod<$0.StreamRequest, $0.MaintenanceOrderUpdate>(
        '/maintenanceorder.MaintenanceOrderService/StreamMaintenanceUpdates',
        ($0.StreamRequest value) => value.writeToBuffer(),
        ($core.List<$core.int> value) =>
            $0.MaintenanceOrderUpdate.fromBuffer(value),
      );

  static final _$acknowledgeUpdate =
      $grpc.ClientMethod<$0.AckRequest, $0.AckResponse>(
        '/maintenanceorder.MaintenanceOrderService/AcknowledgeUpdate',
        ($0.AckRequest value) => value.writeToBuffer(),
        ($core.List<$core.int> value) => $0.AckResponse.fromBuffer(value),
      );

  MaintenanceOrderServiceClient(
    $grpc.ClientChannel channel, {
    $grpc.CallOptions? options,
    $core.Iterable<$grpc.ClientInterceptor>? interceptors,
  }) : super(channel, options: options, interceptors: interceptors);

  /// Opens a server-streaming RPC.
  $grpc.ResponseStream<$0.MaintenanceOrderUpdate> streamMaintenanceUpdates(
    $0.StreamRequest request, {
    $grpc.CallOptions? options,
  }) => $createStreamingCall(
    _$streamMaintenanceUpdates,
    $async.Stream.fromIterable([request]),
    options: options,
  );

  /// Confirms receipt of an update.
  $async.Future<$0.AckResponse> acknowledgeUpdate(
    $0.AckRequest request, {
    $grpc.CallOptions? options,
  }) => $createUnaryCall(_$acknowledgeUpdate, request, options: options);
}
