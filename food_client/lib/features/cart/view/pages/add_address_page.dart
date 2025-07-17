import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_client/core/theme/textstyle.dart';
import 'package:food_client/core/utils/show_snackbar.dart';
import 'package:food_client/core/widgets/button.dart';
import 'package:food_client/core/widgets/input_field.dart';
import 'package:food_client/core/widgets/loader.dart';
import 'package:food_client/features/cart/models/address_model.dart';
import 'package:food_client/features/cart/viewmodel/cubit/address_cubit.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class AddAddressPage extends StatefulWidget {
  final AddressModel? address;
  const AddAddressPage({super.key, this.address});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressLine1Controller = TextEditingController();
  final addressLine2Controller = TextEditingController();
  final cityController = TextEditingController();
  final postalCodeController = TextEditingController();
  String countryCode = 'IN';

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      nameController.text = widget.address!.fullName;
      phoneController.text = widget.address!.phoneNumber.split(' ').last;
      countryCode = widget.address!.phoneNumber.split(' ').first;
      addressLine1Controller.text = widget.address!.addressLine1;
      addressLine2Controller.text = widget.address!.addressLine2 ?? '';
      cityController.text = widget.address!.city;
      postalCodeController.text = widget.address!.postalCode;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    cityController.dispose();
    postalCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.address != null ? 'Edit Address' : 'Add Address'),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
        child: BlocConsumer<AddressCubit, AddressState>(
          listener: (context, state) {
            if (state is AddressFailure) {
              showSnackBar(context, message: state.message, color: Colors.red);
            } else if (state is AddressAdded) {
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            return Button(
              onPressed:
                  state is AddressLoading
                      ? () {}
                      : () {
                        if (formKey.currentState!.validate()) {
                          final addressModel = AddressModel(
                            id: widget.address?.id,
                            fullName: nameController.text.trim(),
                            phoneNumber: phoneController.text.trim(),
                            addressLine1: addressLine1Controller.text.trim(),
                            addressLine2: addressLine2Controller.text.trim(),
                            city: cityController.text.trim(),
                            postalCode: postalCodeController.text.trim(),
                          );

                          if (widget.address != null) {
                            context.read<AddressCubit>().editUserAddress(
                              addressModel,
                            );
                          } else {
                            context.read<AddressCubit>().addressSaved(
                              addressModel,
                            );
                          }
                        }
                      },
              child:
                  state is AddressLoading
                      ? const Loader()
                      : Text(
                        widget.address != null
                            ? 'Edit Address'
                            : 'Save Address',
                        style: Style.text3,
                      ),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                InputField(
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  hintText: 'Full Name',
                  icon: Icons.person,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: width / 1.17,
                  child: IntlPhoneField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      hintText: 'Phone number',
                      counterText: '',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(),
                      ),
                    ),
                    initialCountryCode: 'IN',
                    onChanged: (phone) {
                      countryCode = phone.countryISOCode;
                    },
                  ),
                ),
                const SizedBox(height: 8),
                InputField(
                  controller: addressLine1Controller,
                  keyboardType: TextInputType.streetAddress,
                  hintText: 'Address Line 1',
                  icon: Icons.gps_fixed,
                ),
                const SizedBox(height: 8),
                InputField(
                  controller: addressLine2Controller,
                  keyboardType: TextInputType.streetAddress,
                  hintText: 'Address Line 2 (Optional)',
                  icon: Icons.gps_fixed,
                ),
                const SizedBox(height: 8),
                InputField(
                  controller: cityController,
                  keyboardType: TextInputType.streetAddress,
                  hintText: 'City',
                  icon: Icons.location_city,
                ),
                const SizedBox(height: 8),
                InputField(
                  controller: postalCodeController,
                  keyboardType: TextInputType.number,
                  hintText: 'Postal Code',
                  icon: Icons.pin_drop,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
