import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klontong_flutter_app/core/utils/route_constants.dart';
import 'package:klontong_flutter_app/core/utils/service_locator.dart';
import 'package:klontong_flutter_app/data/models/product/product_model.dart';
import 'package:klontong_flutter_app/logic/auth/auth_cubit.dart';
import 'package:klontong_flutter_app/logic/product/product_cubit.dart';
import 'package:klontong_flutter_app/presentation/pages/login_gate.dart';
import 'package:klontong_flutter_app/presentation/pages/not_found_page.dart';
import 'package:klontong_flutter_app/presentation/pages/product/add_product.dart';
import 'package:klontong_flutter_app/presentation/pages/product/product_detail.dart';
import 'package:klontong_flutter_app/presentation/pages/product/product_list.dart';
import 'package:klontong_flutter_app/presentation/pages/register.dart';
import 'package:klontong_flutter_app/presentation/pages/splash_screen.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<AuthCubit>()..checkAuthStatus(),
        ),
        BlocProvider(
          create: (_) =>
              getIt<ProductCubit>()..fetchProducts(forceRefresh: true),
        ),
      ],
      child: MaterialApp(
        title: 'Klontong App',
        debugShowCheckedModeBanner: false,
        initialRoute: RouteConstants.splashScreen,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case RouteConstants.splashScreen:
              return MaterialPageRoute(builder: (_) => SplashScreen());

            case RouteConstants.login:
              return MaterialPageRoute(builder: (_) => const LoginScreen());

            case RouteConstants.register:
              return MaterialPageRoute(builder: (_) => RegisterPage());

            case RouteConstants.productList:
              return MaterialPageRoute(builder: (_) => const ProductListPage());

            case RouteConstants.productDetail:
              final product = settings.arguments as Product;
              return MaterialPageRoute(
                  builder: (_) => ProductDetailPage(product: product));

            case RouteConstants.addProduct:
              final product = settings.arguments as Product?;
              return MaterialPageRoute(
                  builder: (_) => AddProductPage(
                        product: product,
                      ));

            default:
              return MaterialPageRoute(builder: (_) => const NotFoundPage());
          }
        },
      ),
    );
  }
}
