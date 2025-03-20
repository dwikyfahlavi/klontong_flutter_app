import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klontong_flutter_app/core/utils/route_constants.dart';
import 'package:klontong_flutter_app/logic/auth/auth_cubit.dart';
import 'package:klontong_flutter_app/logic/product/product_cubit.dart';
import 'package:klontong_flutter_app/presentation/widgets/loading_widget.dart';
import 'package:klontong_flutter_app/presentation/widgets/product_item.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Add your logout logic here
              context.read<AuthCubit>().logout();
              Navigator.pushReplacementNamed(context, RouteConstants.login);
            },
          ),
        ],
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return LoadingWidget();
          } else if (state is ProductLoaded) {
            if (state.products.isEmpty) {
              return const Center(child: Text("No Products Available"));
            }
            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];

                return ProductItem(
                  product: product,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RouteConstants.productDetail,
                      arguments: product,
                    );
                  },
                );
              },
            );
          } else if (state is ProductError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text("No Products Available"));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(
          context,
          RouteConstants.addProduct,
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
