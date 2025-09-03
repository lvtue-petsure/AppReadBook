import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;
  // Query bảng bất kỳ
  Future<bool> queryUser(String email, String pass) async {
    try {
      String encoded = base64Encode(utf8.encode(pass));
      final data = await _client.from('users')
                                .select()
                                .eq('userName', email)
                                .eq('password', pass);                          
      print(data);
      return data.isNotEmpty;
    } catch (e) {
      print("Lỗi query: $e");
      return false;
    }
  }
}
