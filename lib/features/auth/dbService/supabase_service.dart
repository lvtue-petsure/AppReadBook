import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;
  Future<bool> queryUser(String email, String pass) async {
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

   Future<bool> addUser(String email, String pass) async {
    final response = await _client.from('users').insert({
      'userName': email,
      'password': pass,
    });

    if (response.error != null) {
      return false;
    } else {
      return true;
    }
  }

  Future<List<Map<String, dynamic>>> gettitlebook() async {
    try{
     final response = await _client
      .from('titlebook')        
      .select('*')          
      .order('id', ascending: true); 

    return List<Map<String, dynamic>>.from(response as List);

    }catch (e) {
      print("Lỗi query: $e");
      return [];
    }
  }
}
