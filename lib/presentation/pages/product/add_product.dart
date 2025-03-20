import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klontong_flutter_app/data/models/product/product_model.dart';
import 'package:klontong_flutter_app/logic/product/product_cubit.dart';
import 'package:klontong_flutter_app/presentation/widgets/custom_button.dart';
import 'package:klontong_flutter_app/presentation/widgets/custom_text_field.dart';

class AddProductPage extends StatefulWidget {
  final Product? product;

  const AddProductPage({super.key, this.product});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _categoryIdController = TextEditingController();
  final TextEditingController _categoryNameController = TextEditingController();
  final TextEditingController _skuController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _categoryIdController.text = widget.product!.categoryId.toString();
      _categoryNameController.text = widget.product!.categoryName ?? '';
      _skuController.text = widget.product!.sku ?? '';
      _nameController.text = widget.product!.name ?? '';
      _descriptionController.text = widget.product!.description ?? '';
      _weightController.text = widget.product!.weight.toString();
      _widthController.text = widget.product!.width.toString();
      _lengthController.text = widget.product!.length.toString();
      _heightController.text = widget.product!.height.toString();
      _imageController.text = widget.product!.image ?? '';
      _hargaController.text = widget.product!.harga.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomTextField(
                    controller: _categoryIdController,
                    hintText: 'Category ID',
                    keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                CustomTextField(
                    controller: _categoryNameController,
                    hintText: 'Category Name'),
                const SizedBox(height: 16),
                CustomTextField(controller: _skuController, hintText: 'SKU'),
                const SizedBox(height: 16),
                CustomTextField(
                    controller: _nameController, hintText: 'Product Name'),
                const SizedBox(height: 16),
                CustomTextField(
                    controller: _descriptionController,
                    hintText: 'Description'),
                const SizedBox(height: 16),
                CustomTextField(
                    controller: _weightController,
                    hintText: 'Weight',
                    keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                CustomTextField(
                    controller: _widthController,
                    hintText: 'Width',
                    keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                CustomTextField(
                    controller: _lengthController,
                    hintText: 'Length',
                    keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                CustomTextField(
                    controller: _heightController,
                    hintText: 'Height',
                    keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                CustomTextField(
                    controller: _imageController, hintText: 'Image URL'),
                const SizedBox(height: 16),
                CustomTextField(
                    controller: _hargaController,
                    hintText: 'Price',
                    keyboardType: TextInputType.number),
                const SizedBox(height: 20),
                CustomButton(
                  text:
                      widget.product == null ? 'Add Product' : 'Update Product',
                  onPressed: _submit,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        id: widget.product?.id,
        categoryId: int.parse(_categoryIdController.text),
        categoryName: _categoryNameController.text,
        sku: _skuController.text,
        name: _nameController.text,
        description: _descriptionController.text,
        weight: int.parse(_weightController.text),
        width: int.parse(_widthController.text),
        length: int.parse(_lengthController.text),
        height: int.parse(_heightController.text),
        image: _imageController.text,
        harga: int.parse(_hargaController.text),
      );

      if (widget.product == null) {
        context.read<ProductCubit>().addProduct(product);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Add Product Success")),
        );
      } else {
        context.read<ProductCubit>().updateProduct(product.id!, product);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Update Product Success")),
        );
      }

      Navigator.pop(context);
    }
  }
}
