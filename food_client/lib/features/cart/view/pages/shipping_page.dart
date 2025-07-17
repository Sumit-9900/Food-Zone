import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_client/core/routes/route_constants.dart';
import 'package:food_client/core/theme/textstyle.dart';
import 'package:food_client/core/utils/show_snackbar.dart';
import 'package:food_client/core/widgets/button.dart';
import 'package:food_client/core/widgets/loader.dart';
import 'package:food_client/features/cart/view/widgets/address_tile.dart';
import 'package:food_client/features/cart/viewmodel/cubit/address_cubit.dart';
import 'package:go_router/go_router.dart';

class ShippingPage extends StatefulWidget {
  final double totalPrice;
  const ShippingPage({super.key, required this.totalPrice});

  @override
  State<ShippingPage> createState() => _ShippingPageState();
}

class _ShippingPageState extends State<ShippingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shipping Address')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: BlocConsumer<AddressCubit, AddressState>(
                      listener: (context, state) {
                        if (state is AddressFailure) {
                          showSnackBar(
                            context,
                            message: state.message,
                            color: Colors.red,
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is AddressLoading) {
                          return const Loader();
                        } else if (state is AddressFetched) {
                          final addresses = state.addresses;
                          final selectedIndex = state.index;

                          if (addresses.isEmpty) {
                            return Center(
                              child: Text(
                                'No address saved!',
                                style: Style.text2.copyWith(fontSize: 20),
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: addresses.length,
                            itemBuilder: (context, index) {
                              final address = addresses[index];

                              final isSelected = index == selectedIndex;

                              return AddressTile(
                                address: address,
                                isSelected: isSelected,
                                index: index,
                              );
                            },
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      context.pushNamed(RouteConstants.addAddressRoute);
                    },
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.grey.shade300, width: 2),
                      ),
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(Icons.add, color: Colors.black),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Add Address',
                                style: Style.text2.copyWith(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Button(
              label: 'Proceed to Payment',
              onPressed: () {
                context.pushNamed(
                  RouteConstants.paymentRoute,
                  extra: widget.totalPrice,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
