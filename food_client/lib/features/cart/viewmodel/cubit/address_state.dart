part of 'address_cubit.dart';

@immutable
sealed class AddressState {}

final class AddressInitial extends AddressState {}

final class AddressLoading extends AddressState {}

final class AddressFailure extends AddressState {
  final String message;
  AddressFailure(this.message);
}

final class AddressAdded extends AddressState {}

final class AddressFetched extends AddressState {
  final int index;
  final List<AddressModel> addresses;
  AddressFetched({required this.index, required this.addresses});
}
