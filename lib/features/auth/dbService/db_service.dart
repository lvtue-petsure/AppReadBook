import 'package:postgres/postgres.dart';
import 'dart:convert';

class DbService {
   static Future<Connection> openConnection() async {
    return await Connection.open(
      Endpoint(
          host: "aws-1-ap-southeast-1.pooler.supabase.com",
          port: 6543,
          database: "postgres",
          username: "postgres.xbyabttdnhlfjbtjpvjq",
          password: "1234567x@X", 
        ),
      settings: const ConnectionSettings(sslMode: SslMode.disable),
    );
  }
  static Future<bool> queryUser(String email, String pass) async {
    try {
      final conn = await openConnection();
      String encoded = base64Encode(utf8.encode(pass));
      final result = await conn.execute(
        Sql.named("SELECT * FROM users WHERE userName=@e and password=@p"),
        parameters: {"e": email,"p": encoded},
      );

      await conn.close();

      return result.isNotEmpty;
    } catch (e) {
      print("Lỗi DB: $e");
      return false;
    }
  }
}