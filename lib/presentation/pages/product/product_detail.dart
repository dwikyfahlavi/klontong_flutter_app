import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klontong_flutter_app/core/utils/route_constants.dart';
import 'package:klontong_flutter_app/data/models/product/product_model.dart';
import 'package:klontong_flutter_app/logic/product/product_cubit.dart';
import 'package:klontong_flutter_app/presentation/widgets/custom_button.dart';
import 'package:klontong_flutter_app/presentation/widgets/loading_widget.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductCubit, ProductState>(listener: (context, state) {
      if (state is ProductError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message)),
        );
      }
    }, builder: (context, state) {
      if (state is ProductLoading) {
        return const Scaffold(body: Center(child: LoadingWidget()));
      } else if (state is ProductLoaded) {
        List<Product> listProduct = state.products;
        Product data =
            listProduct.firstWhere((element) => element.id == product.id);
        return Scaffold(
          appBar: AppBar(title: Text(data.name ?? '')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (data.image != null)
                  Center(
                    child: Image.network(
                      data.image!,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 16),
                Text(
                  data.name ?? '',
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  "\$${data.harga}",
                  style:
                      const TextStyle(fontSize: 18, color: Colors.blueAccent),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: "Delete Product",
                  onPressed: () {
                    context.read<ProductCubit>().deleteProduct(data.id!);
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: "Update Product",
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      RouteConstants.addProduct,
                      arguments: data,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      } else {
        return const Center(child: Text('Failed to load product details.'));
      }
    });
  }
}
