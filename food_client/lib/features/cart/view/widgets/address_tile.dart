import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_client/core/routes/route_constants.dart';
import 'package:food_client/core/theme/textstyle.dart';
import 'package:food_client/features/cart/models/address_model.dart';
import 'package:food_client/features/cart/viewmodel/cubit/address_cubit.dart';
import 'package:go_router/go_router.dart';

class AddressTile extends StatelessWidget {
  final AddressModel address;
  final bool isSelected;
  final int index;
  const AddressTile({
    super.key,
    required this.address,
    required this.isSelected,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final addressString =
        '${address.addressLine1}, '
        '${address.addressLine2 != null && address.addressLine2!.isNotEmpty ? '${address.addressLine2}, ' : ''}'
        '${address.city}, '
        '${address.postalCode}';

    return GestureDetector(
      onTap: () {
        context.read<AddressCubit>().changeAddressTileIndex(index);
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: isSelected ? Colors.black : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      isSelected
                          ? CupertinoIcons.checkmark_circle_fill
                          : CupertinoIcons.circle,
                      color: isSelected ? Colors.black : Colors.grey,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            address.fullName,
                            style: Style.text2.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            address.phoneNumber,
                            style: Style.text2.copyWith(fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            addressString,
                            style: Style.text2.copyWith(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.pushNamed(
                    RouteConstants.addAddressRoute,
                    extra: address,
                  );
                },
                child: Icon(Icons.edit),
              ),
              const SizedBox(width: 10.0),
              GestureDetector(
                onTap: () {
                  context.read<AddressCubit>().deleteUserAddress(address.id!);
                },
                child: Icon(Icons.delete, color: Colors.redAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
