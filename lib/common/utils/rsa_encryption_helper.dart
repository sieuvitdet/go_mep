import 'package:flutter/services.dart' show rootBundle;
import 'package:fast_rsa/fast_rsa.dart';

class RsaPem {
  static Future<String> encryptPassword({
    required String password,
    String label = '',
  }) async {
    try {
      final publicPem =
          await rootBundle.loadString('assets/keys/public.pem', cache: true);

      String passwordEncrypted = await RSA.encryptOAEP(
        password,
        label,
        Hash.SHA256,
        publicPem,
      );
      return passwordEncrypted;
    } catch (e) {
      return "";
    }
  }
}
