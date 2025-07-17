import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_client/features/cart/models/address_model.dart';
import 'package:food_client/features/cart/repository/cart_remote_repository.dart';

part 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  final CartRemoteRepository _cartRemoteRepository;
  AddressCubit({required CartRemoteRepository cartRemoteRepository})
    : _cartRemoteRepository = cartRemoteRepository,
      super(AddressInitial());

  void addressSaved(AddressModel address) async {
    emit(AddressLoading());

    final res = await _cartRemoteRepository.saveAddress(address);

    res.fold((l) => emit(AddressFailure(l.message)), (isDuplicate) {
      if (isDuplicate) {
        emit(
          AddressFailure("This address already exists. Try different address!"),
        );
      } else {
        emit(AddressAdded());
        getUserAddresses();
      }
    });
  }

  void getUserAddresses() async {
    emit(AddressLoading());

    final res = await _cartRemoteRepository.getUserSavedAddresses();

    res.fold(
      (l) => emit(AddressFailure(l.message)),
      (r) => emit(AddressFetched(index: 0, addresses: r)),
    );
  }

  void changeAddressTileIndex(int index) {
    if (state is AddressFetched) {
      final addresses = (state as AddressFetched).addresses;
      emit(AddressFetched(index: index, addresses: addresses));
    }
  }

  void deleteUserAddress(String docId) async {
    final res = await _cartRemoteRepository.deleteUserAddress(docId);

    res.fold((l) => emit(AddressFailure(l.message)), (_) => getUserAddresses());
  }

  void editUserAddress(AddressModel address) async {
    emit(AddressLoading());

    final res = await _cartRemoteRepository.editUserAddress(address);

    res.fold((l) => emit(AddressFailure(l.message)), (isDuplicate) {
      if (isDuplicate) {
        emit(
          AddressFailure("This address already exists. Try different address!"),
        );
      } else {
        emit(AddressAdded());
        getUserAddresses();
      }
    });
  }
}
