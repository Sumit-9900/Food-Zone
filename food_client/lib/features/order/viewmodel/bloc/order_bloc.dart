import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_client/features/order/models/order_model.dart';
import 'package:food_client/features/order/repository/order_remote_repository.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRemoteRepository _orderRemoteRepository;
  OrderBloc({required OrderRemoteRepository orderRemoteRepository})
    : _orderRemoteRepository = orderRemoteRepository,
      super(OrderInitial()) {
    on<OrderSent>(_onOrderSent);
    on<OrderFetched>(_onOrderFetched);
    on<OrderDeleted>(_onOrderDelete);
  }

  void _onOrderSent(OrderSent event, Emitter<OrderState> emit) async {
    if (event.isPaymentSuccessful) {
      emit(OrderLoading());

      final res = await _orderRemoteRepository.storeOrdersToFirestore(
        event.order,
      );

      res.fold((l) => emit(OrderFailure(l.message)), (r) {
        emit(OrderPlaced());
        add(OrderFetched());
      });
    } else {
      emit(OrderFailure("Payment was not successful"));
    }
  }

  void _onOrderFetched(OrderFetched event, Emitter<OrderState> emit) async {
    emit(OrderLoading());

    final res = await _orderRemoteRepository.fetchOrders();

    res.fold(
      (l) => emit(OrderFailure(l.message)),
      (r) => emit(OrderSuccess(r)),
    );
  }

  void _onOrderDelete(OrderDeleted event, Emitter<OrderState> emit) async {
    final res = await _orderRemoteRepository.deleteOrder(event.docId);

    res.fold((l) => emit(OrderFailure(l.message)), (r) {
      emit(OrderRemoved());
      add(OrderFetched());
    });
  }
}
