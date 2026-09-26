import '../models/snack_model.dart';

// ==== Update Latihan 6: imageUrl diarahkan ke Asset Lokal ====
final List<SnackModel> dummySnacks = [
  SnackModel(
    id: 'snack_001',
    name: 'Keripik Kaca Pedas',
    price: 12000.0,
    description: 'Keripik renyah dengan bumbu cabai asli dan daun jeruk gurih.',
    imageUrl: 'assets/images/keripik_kaca_pedas.jpg',
    stock: 25,
  ),
  SnackModel(
    id: 'snack_002',
    name: 'Makaroni Ulir Balado',
    price: 10000.0,
    description: 'Makaroni goreng renyah bumbu balado spesial.',
    imageUrl: 'assets/images/makaroni_balado.jpg',
    stock: 40,
  ),
  SnackModel(
    id: 'snack_003',
    name: 'Basreng Extra Pedas',
    price: 15000.0,
    description: 'Bakso goreng irisan tipis dengan rempah pedas melimpah.',
    imageUrl: 'assets/images/basreng_pedas.jpg',
    stock: 12,
  ),
  SnackModel(
    id: 'snack_004',
    name: 'Cilok Crispy Keju',
    price: 18000.0,
    description: 'Aci dicolok balut tepung panir dengan isian keju leleh.',
    imageUrl: 'assets/images/cilok_crispy_keju.jpg',
    stock: 8,
  ),
];
