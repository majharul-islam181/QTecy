import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qtechy/feature/dashborad/presentation/pages/setting_bottom_sheet.dart';
import '../../../../core/injections/dependency_injection.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/entities/product.dart';
import '../../../auth/domain/entities/user.dart';
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

  void _showSettingsBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SingleChildScrollView(child: SettingsBottomSheet(user: user!));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "title".tr(),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettingsBottomSheet,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
            child: TextField(
              controller: searchController,
              onChanged: _filterProducts,
              decoration: InputDecoration(
                hintText: "searching_product".tr(),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
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
