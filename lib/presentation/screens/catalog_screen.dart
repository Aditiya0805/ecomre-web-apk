import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/datasources/cart_manager.dart';
import '../../data/datasources/database_helper.dart';
import '../../data/datasources/dummy_snack.dart';
import '../../data/models/snack_model.dart';
import '../widgets/snack_card.dart';
import 'admin_login_screen.dart';
import 'cart_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  List<SnackModel> _snacks = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadSnacks();
  }

  Future<void> _loadSnacks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final list = await DatabaseHelper.instance.getSnacks();
      setState(() {
        _snacks = list.isNotEmpty ? list : dummySnacks;
      });
    } catch (_) {
      setState(() {
        _snacks = dummySnacks;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  List<SnackModel> get _filteredSnacks {
    if (_searchQuery.trim().isEmpty) {
      return _snacks;
    }
    return _snacks.where((s) {
      return s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.description.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.vibrantGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'SnackDistro',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Tombol Login Admin
                    IconButton(
                      icon: const Icon(
                        Icons.admin_panel_settings_outlined,
                        color: Colors.white,
                      ),
                      tooltip: 'Login Admin',
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AdminLoginScreen(),
                          ),
                        );
                        // Refresh data setelah kembali dari panel admin
                        _loadSnacks();
                      },
                    ),
                    const SizedBox(width: 4),
                    // Tombol Keranjang Belanja
                    ListenableBuilder(
                      listenable: CartManager.instance,
                      builder: (context, _) {
                        final totalItems = CartManager.instance.totalItems;
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white24,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.shopping_cart,
                                  color: Colors.white,
                                ),
                                tooltip: 'Keranjang Belanja',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const CartScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),
                            if (totalItems > 0)
                              Positioned(
                                right: -2,
                                top: -2,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.redAccent,
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 18,
                                    minHeight: 18,
                                  ),
                                  child: Text(
                                    '$totalItems',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Search Box
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [AppColors.softShadow],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.black45),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          onChanged: (val) {
                            setState(() {
                              _searchQuery = val;
                            });
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Cari jajanan, misal "Keripik"',
                            isDense: true,
                          ),
                        ),
                      ),
                      if (_searchQuery.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Daftar Produk Grid
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _filteredSnacks.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.search_off,
                                      size: 56, color: Colors.grey),
                                  SizedBox(height: 10),
                                  Text(
                                    'Jajanan tidak ditemukan',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _loadSnacks,
                              child: GridView.builder(
                                itemCount: _filteredSnacks.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      MediaQuery.of(context).size.width > 900
                                          ? 4
                                          : MediaQuery.of(context).size.width >
                                                  600
                                              ? 3
                                              : 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 0.68,
                                ),
                                itemBuilder: (context, index) {
                                  final snack = _filteredSnacks[index];
                                  return SnackCard(snack: snack);
                                },
                              ),
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
