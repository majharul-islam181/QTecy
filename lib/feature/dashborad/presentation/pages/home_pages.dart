import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/injections/dependency_injection.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/entities/product.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/cubit/login_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';
import '../widgets/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user;
  TextEditingController searchController = TextEditingController();
  List<Product> allProducts = [];
  List<Product> filteredProducts = [];
  List<Product> displayedProducts = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    context.read<ProductBloc>().add(FetchProductsEvent());
  }

  Future<void> _loadUserData() async {
    final storageService = StorageService();
    User? storedUser = await storageService.getUserData();
    if (mounted) {
      setState(() {
        user = storedUser;
      });
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _sortProducts(String sortType) {
    setState(() {
      if (sortType == 'PriceHighToLow') {
        displayedProducts
            .sort((a, b) => b.currentPrice.compareTo(a.currentPrice));
      } else if (sortType == 'PriceLowToHigh') {
        displayedProducts
            .sort((a, b) => a.currentPrice.compareTo(b.currentPrice));
      } else if (sortType == 'Rating') {
        displayedProducts.sort((a, b) => b.rating.compareTo(a.rating));
      }
    });
  }

  void _filterProducts(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredProducts = allProducts;
        displayedProducts = filteredProducts;
      });
    } else {
      setState(() {
        filteredProducts = allProducts.where((product) {
          return product.name.toLowerCase().contains(query.toLowerCase());
        }).toList();
        displayedProducts = filteredProducts;
      });
    }
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("Price - High to Low"),
              onTap: () {
                Navigator.pop(context);
                _sortProducts('PriceHighToLow');
              },
            ),
            ListTile(
              title: const Text("Price - Low to High"),
              onTap: () {
                Navigator.pop(context);
                _sortProducts('PriceLowToHigh');
              },
            ),
            ListTile(
              title: const Text("Rating"),
              onTap: () {
                Navigator.pop(context);
                _sortProducts('Rating');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products".tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showSortBottomSheet,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<LoginCubit>().logoutUser(),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: searchController,
              onChanged: _filterProducts,
              decoration: InputDecoration(
                hintText: "Search products...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: BlocProvider(
        create: (_) => sl<ProductBloc>()..add(FetchProductsEvent()),
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductLoaded) {
              allProducts = state.products;
              filteredProducts =
                  filteredProducts.isEmpty && searchController.text.isEmpty
                      ? allProducts
                      : filteredProducts;
              displayedProducts = filteredProducts;

              return _buildProductGrid(displayedProducts);
            } else if (state is ProductError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildProductGrid(List<Product> products) {
    return GridView.builder(
      padding: const EdgeInsets.all(12.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, 
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.65,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(product: product);  
      },
    );
  }
}
