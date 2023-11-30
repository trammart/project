import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:snackstore/ui/categories/categories_manager.dart';
import 'package:snackstore/ui/categories/explore_screen.dart';
import 'ui/screens.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthManager(),
        ),
        ChangeNotifierProxyProvider<AuthManager, ProductsManager>(
          create: (ctx) => ProductsManager(), 
          update: (ctx, authManager, productsManager) {
            productsManager!.authToken = authManager.authToken;
            return productsManager;
          },
        ),
        ChangeNotifierProxyProvider<AuthManager, CategoriesManager>(
          create: (ctx) => CategoriesManager(), 
          update: (ctx, authManager, categoriesManager) {
            categoriesManager!.authToken = authManager.authToken;
            return categoriesManager;
          },
        ),
        ChangeNotifierProvider(
          create: (ctx) => CartManager(),
        ),
        ChangeNotifierProxyProvider<AuthManager, OrdersManager>(
          create: (ctx) => OrdersManager(), 
          update: (ctx, authManager, ordersManager) {
            ordersManager!.authToken = authManager.authToken;
            return ordersManager;
          },
        ),
      ],
      child: Consumer<AuthManager>(builder: (ctx, authManager, child) {
        return MaterialApp(
          title: 'Snack Shop',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Lato',
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.amber,
            ).copyWith(
              secondary: Colors.deepOrange,
            ),
          ),
          home: authManager.isAuth
              ? const ProductsOverviewScreen()
              : FutureBuilder(
                  future: authManager.tryAutoLogin(),
                  builder: (ctx, snapshot) {
                    return snapshot.connectionState == ConnectionState.waiting
                        ? const SplashScreen()
                        : const AuthScreen();
                  },
                ),
          routes: {
            CartScreen.routeName: (ctx) => const CartScreen(),
            OrdersScreen.routeName: (ctx) => const OrdersScreen(),
            UserOrdersScreen.routeName: (ctx) => const UserOrdersScreen(),
            UserProductsScreen.routeName: (ctx) => const UserProductsScreen(),
            ExploreScreen.routeName: (ctx) => const ExploreScreen(),
            CategoryScreen.routeName: (ctx) => const CategoryScreen(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == EditProductScreen.routeName) {
              final productId = settings.arguments as String?;
              return MaterialPageRoute(
                builder: (ctx) {
                  return EditProductScreen(
                    productId != null
                        ? ctx.read<ProductsManager>().findById(productId)
                        : null,
                  );
                },
              );
            }
            if (settings.name == EditCategoryScreen.routeName) {
              final categoryId = settings.arguments as String?;
              return MaterialPageRoute(
                builder: (ctx) {
                  return EditCategoryScreen(
                    categoryId != null
                        ? ctx.read<CategoriesManager>().findById(categoryId)
                        : null,
                  );
                },
              );
            }
            if (settings.name == ProductDetailScreen.routeName) {
              final productId = settings.arguments as String;
              return MaterialPageRoute(
                builder: (ctx) {
                  return ProductDetailScreen(
                      ctx.read<ProductsManager>().findById(productId)!
                  );
                },
              );
            }
            return null;
          },
        );
      }),
    );
  }
}
