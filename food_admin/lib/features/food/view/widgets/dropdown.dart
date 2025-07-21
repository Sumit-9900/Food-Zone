import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_admin/features/food/viewmodel/bloc/food_bloc.dart';

class DropDown extends StatelessWidget {
  final List<String> category;
  const DropDown({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: const Color(0xFFececf8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFececf8)),
      ),
      child: BlocSelector<FoodBloc, FoodState, String>(
        selector: (state) {
          if (state is FoodCategoryChanged) {
            return state.selectedCategory;
          }
          return context.read<FoodBloc>().selectedCategory;
        },
        builder: (context, selectedCategory) {
          return DropdownButton(
            underline: const Text(''),
            isExpanded: true,
            value: selectedCategory,
            hint: const Text('Select Category'),
            dropdownColor: const Color(0xFFececf8),
            items:
                category.map<DropdownMenuItem<String>>((String item) {
                  return DropdownMenuItem(value: item, child: Text(item));
                }).toList(),
            onChanged: (String? item) {
              if (item != null) {
                context.read<FoodBloc>().add(FoodDropdownChanged(item));
              } else {
                debugPrint('Dropdown item value is null!');
              }
            },
          );
        },
      ),
    );
  }
}
