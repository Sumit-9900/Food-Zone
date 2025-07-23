import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_admin/core/routes/app_route_constants.dart';
import 'package:food_admin/core/theme/text_style.dart';
import 'package:food_admin/core/utils/show_snackbar.dart';
import 'package:food_admin/core/widgets/loader.dart';
import 'package:food_admin/features/food/view/widgets/food_tile.dart';
import 'package:food_admin/features/food/view/widgets/my_drawer.dart';
import 'package:food_admin/features/food/viewmodel/bloc/food_bloc.dart';
import 'package:go_router/go_router.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  @override
  void initState() {
    super.initState();
    context.read<FoodBloc>().add(FoodFetched());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('List of Products', style: Style.text)),
      drawer: const MyDrawer(),
      body: BlocConsumer<FoodBloc, FoodState>(
        listener: (context, state) {
          if (state is FoodFailure) {
            showSnackBar(context, message: state.message, color: Colors.red);
          } else if (state is FoodDeletedSuccess) {
            showSnackBar(
              context,
              message: 'Food has been deleted successfully!',
              color: Colors.green,
            );
          }
        },
        builder: (context, state) {
          if (state is FoodLoading) {
            return const Loader();
          } else if (state is FoodSuccess) {
            return state.foods.isEmpty
                ? const Center(child: Text('No foods available'))
                : ListView.builder(
                  itemCount: state.foods.length,
                  itemBuilder: (context, index) {
                    return FoodTile(food: state.foods[index]);
                  },
                );
          } else if (state is FoodFailure) {
            return Center(child: Text(state.message));
          } else {
            // For any other state, fetch foods and show loading
            context.read<FoodBloc>().add(FoodFetched());
            return const Loader();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(AppRouteConstants.addNewFoodRouteName);
        },
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
