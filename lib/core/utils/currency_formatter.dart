import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String toIdr(num amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  static String toRupiah(num amount) => toIdr(amount);
}
