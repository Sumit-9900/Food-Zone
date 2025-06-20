import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_admin/core/theme/text_style.dart';
import 'package:food_admin/core/utils/show_snackbar.dart';
import 'package:food_admin/core/viewmodel/cubit/image_picker_cubit.dart';
import 'package:food_admin/core/widgets/loader.dart';
import 'package:food_admin/features/food/view/widgets/add_food_button.dart';
import 'package:food_admin/features/food/view/widgets/dropdown.dart';
import 'package:food_admin/features/food/view/widgets/input_field.dart';
import 'package:food_admin/features/food/viewmodel/bloc/food_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class AddFoodPage extends StatefulWidget {
  const AddFoodPage({super.key});

  @override
  State<AddFoodPage> createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  TextEditingController detailcontroller = TextEditingController();

  @override
  void dispose() {
    namecontroller.dispose();
    pricecontroller.dispose();
    detailcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item', style: Style.text),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Upload the Item Picture', style: Style.text1),
                const SizedBox(height: 20),
                BlocConsumer<ImagePickerCubit, ImagePickerState>(
                  listener: (context, state) {
                    if (state is ImagePickerFailure) {
                      showSnackBar(
                        context,
                        message: state.message,
                        color: Colors.red,
                      );
                    }
                  },
                  builder: (context, state) {
                    Widget imageWidget;

                    if (state is ImagePickerSuccess) {
                      imageWidget = ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(state.file, fit: BoxFit.cover),
                      );
                    } else if (state is ImagePickerLoading) {
                      imageWidget = const Loader();
                    } else {
                      imageWidget = Icon(Icons.camera_alt);
                    }

                    return Center(
                      child: GestureDetector(
                        onTap: () {
                          context
                              .read<ImagePickerCubit>()
                              .pickImageFromGallery();
                        },
                        child: Material(
                          elevation: 3,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.black),
                            ),
                            child: imageWidget,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Text('Item Name', style: Style.text1),
                const SizedBox(height: 10),
                InputField(
                  controller: namecontroller,
                  hintText: 'Enter Item Name',
                ),
                const SizedBox(height: 20),
                Text('Item Price', style: Style.text1),
                const SizedBox(height: 10),
                InputField(
                  controller: pricecontroller,
                  hintText: 'Enter Item Price',
                  keyboardType: TextInputType.number,
                  prefixText: '\$ ',
                ),
                const SizedBox(height: 20),
                Text('Item Detail', style: Style.text1),
                const SizedBox(height: 10),
                InputField(
                  controller: detailcontroller,
                  hintText: 'Enter Item Detail',
                  maxLines: 6,
                ),
                const SizedBox(height: 20),
                Text('Select Category', style: Style.text1),
                DropDown(category: context.read<FoodBloc>().categories),
                const SizedBox(height: 20),
                BlocConsumer<FoodBloc, FoodState>(
                  listener: (context, state) {
                    if (state is FoodFailure) {
                      showSnackBar(
                        context,
                        message: state.message,
                        color: Colors.red,
                      );
                    } else if (state is FoodAddedSuccess) {
                      showSnackBar(
                        context,
                        message: 'Food is being added!',
                        color: Colors.green,
                      );

                      context.pop();
                    }
                  },
                  builder: (context, state) {
                    return AddFoodButton(
                      textWidget:
                          state is FoodLoading
                              ? const Loader()
                              : Text(
                                'Add Item',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          final imagePickerState =
                              context.read<ImagePickerCubit>().state;

                          if (imagePickerState is ImagePickerInitial) {
                            showSnackBar(
                              context,
                              message: 'Image can\'t be empty!',
                              color: Colors.red,
                            );

                            return;
                          }

                          if (imagePickerState is ImagePickerSuccess) {
                            final imageFile = imagePickerState.file;
                            debugPrint('Selected image file: $imageFile');

                            context.read<FoodBloc>().add(
                              FoodAdded(
                                selectedImage: imageFile,
                                productDetail: detailcontroller.text.trim(),
                                productName: namecontroller.text.trim(),
                                productPrice: pricecontroller.text.trim(),
                              ),
                            );
                          }

                          namecontroller.clear();
                          pricecontroller.clear();
                          detailcontroller.clear();
                          context.read<ImagePickerCubit>().clearImage();
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
