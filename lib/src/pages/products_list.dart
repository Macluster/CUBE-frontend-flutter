import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magicstep/src/blocs/product/product_cubit.dart';
import 'package:magicstep/src/config/colors.dart';
import 'package:magicstep/src/pages/create_product.dart';
import 'package:magicstep/src/widgets/custom_text_field.dart';
import 'package:magicstep/src/widgets/product_card_horizontal.dart';

class ProductsListPage extends StatefulWidget {
  /// Will be used to check if user is
  /// selecting products instead of viewing them
  final bool isSelecting;
  const ProductsListPage({
    Key? key,
    required this.isSelecting,
  }) : super(key: key);

  ///
  static const routeName = '/products-list';

  @override
  State<ProductsListPage> createState() => _ProductsListPageState();
}

class _ProductsListPageState extends State<ProductsListPage> {
  late final ProductCubit _productCubit;

  ///
  @override
  void initState() {
    super.initState();
    _productCubit = ProductCubit()..getProducts();
  }

  @override
  void dispose() {
    _productCubit.close();
    super.dispose();
  }

  ///
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Products List')),
        floatingActionButton: Container(
          margin: const EdgeInsets.only(
            right: 10,
            bottom: 20,
          ),
          child: FloatingActionButton(
            onPressed: () async {
              await Navigator.pushNamed(context, '/create-product');
              _productCubit.getProducts();
            },
            backgroundColor: ColorsConst.primaryColor,
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          shrinkWrap: true,
          children: [
            const CustomTextField(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search',
            ),
            const Divider(color: Colors.transparent),
            BlocBuilder<ProductCubit, ProductState>(
              bloc: _productCubit,
              builder: (context, state) {
                if (state is ProductsListRender) {
                  return ListView.separated(
                    physics: const ClampingScrollPhysics(),
                    itemCount: state.products.length,
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 5);
                    },
                    itemBuilder: (context, index) {
                      return ProductCardHorizontal(
                        product: state.products[index],
                        onDelete: () {
                          _productCubit.deleteProduct(state.products[index]);
                        },
                        onEdit: () async {
                          await Navigator.pushNamed(
                            context,
                            CreateProduct.routeName,
                            arguments: state.products[index].id,
                          );
                          _productCubit.getProducts();
                        },
                      );
                    },
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
