import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klontong_flutter_app/core/utils/route_constants.dart';
import 'package:klontong_flutter_app/logic/auth/auth_cubit.dart';
import 'package:klontong_flutter_app/logic/product/product_cubit.dart';
import 'package:klontong_flutter_app/presentation/widgets/loading_widget.dart';
import 'package:klontong_flutter_app/presentation/widgets/product_item.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: "Search Products...",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (query) {
            setState(() {
              _searchQuery = query.toLowerCase();
            });
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
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
            final filteredProducts = state.products
                .where((product) =>
                    product.name!.toLowerCase().contains(_searchQuery))
                .toList();

            if (filteredProducts.isEmpty) {
              return const Center(child: Text("No Products Found"));
            }
            return ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];

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
