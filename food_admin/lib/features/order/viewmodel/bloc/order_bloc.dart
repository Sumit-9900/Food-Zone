import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_admin/features/order/models/order_model.dart';
import 'package:food_admin/features/order/repository/order_remote_repository.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRemoteRepository _orderRemoteRepository;
  OrderBloc({required OrderRemoteRepository orderRemoteRepository})
    : _orderRemoteRepository = orderRemoteRepository,
      super(OrderInitial()) {
    on<OrderFetched>(_onOrdersFetched);
  }

  void _onOrdersFetched(OrderFetched event, Emitter<OrderState> emit) async {
    emit(OrderLoading());

    final res = await _orderRemoteRepository.fetchOrders();

    res.fold(
      (l) => emit(OrderFailure(l.message)),
      (r) => emit(OrderSuccess(r)),
    );
  }
}
