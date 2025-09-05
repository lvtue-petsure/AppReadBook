import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;
  Future<bool> loginUser(String email, String pass) async {
    try {
      String encoded = base64Encode(utf8.encode(pass));
      final data = await _client.from('users')
                                .select()
                                .eq('userName', email)
                                .eq('password', pass);                          
      return data.isNotEmpty;
    } catch (e) {
      print("Lỗi query: $e");
      return false;
    }
  }

   Future<bool> addUser(String email, String pass,int isActive) async {
    final response = await _client.from('users').insert({
      'userName': email,
      'password': pass,
      'isActive': isActive,
    });

    if (response.error != null) {
      return false;
    } else {
      return true;
    }
  }

 Future<Map<String, dynamic>?> getBookReadMost() async {
      try {
      final response = await _client
                            .from('titlebook')
                            .select('*, chapter(*)') // select tất cả fields của titlebook + tất cả chapter liên quan
                            .order('watching', ascending: false)
                            .limit(1)
                            .single();
      return response;
      } catch (e) {
        print("Lỗi query: $e");
        return null;
    }
}
}
