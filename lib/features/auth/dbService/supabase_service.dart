import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;
  Future<bool> loginUser(String email, String pass) async {
    try {
      final data = await _client
          .from('users')
          .select()
          .eq('userName', email)
          .eq('password', pass)
          .eq('isActive', true);

      if (data.isNotEmpty) saveUsername(data![0]['id'].toString());
      return data.isNotEmpty;
    } catch (e) {
      print("Lỗi query: $e");
      return false;
    }
  }

  Future<Map<String, dynamic>?> getUser(String id) async {
    try {
      final data = await _client
          .from('users')
          .select()
          .eq('id', id)
          .single();
      return data;
    } catch (e) {
      print("Lỗi query: $e");
      return null;
    }
  }

  Future<bool> addUser(String email, String pass, int isActive) async {
    final response = await _client.from('users').insert({
      'userName': email,
      'password': pass,
      'isActive': isActive,
      'email': email+"@gmail.com",
    });
    print(response);
    if (response != null) {
      return false;
    } else {
      return true;
    }
  }

  Future<Map<String, dynamic>?> getBookReadMost() async {
    try {
      final response = await _client
          .from('titlebook')
          .select(
            'id, nametitle, watching,fileimage, chapter(id, chapternumber, chaptertitle, content)',
          )
          .order('watching', ascending: false)
          .limit(1)
          .maybeSingle();
      return response;
    } catch (e) {
      print("Lỗi query: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> getFiveBookReadMost() async {
    try {
      final response = await _client
          .from('titlebook')
          .select(
            'id, nametitle, watching,fileimage, chapter(id, chapternumber, chaptertitle, content)',
          )
          .order('watching', ascending: true)
          .limit(5)
          .maybeSingle();
      return response;
    } catch (e) {
      print("Lỗi query: $e");
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> fetchTopBooks() async {
    try {
      final response = await _client
          .from('top1_books_per_category')
          .select('*');
      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      print("Lỗi query: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchTopBooksSlide() async {
    try {
      final response = await _client.from('top_books_per_slide').select('*');
      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      print("Lỗi query: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchfiveBooksNew() async {
    try {
      final response = await _client
          .from('titlebook')
          .select(
            'id, nametitle, watching,fileimage,createdon, chapter(id, chapternumber, chaptertitle,content)',
          )
          .order('createdon', ascending: false)
          .limit(5);
      return response;
    } catch (e) {
      print("Lỗi query: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getFiveBookRead() async {
    try {
      final response = await _client
          .from('titlebook')
          .select(
            'id, nametitle, watching,fileimage, chapter(id, chapternumber, chaptertitle, content)',
          )
          .order('watching', ascending: true)
          .limit(5);
      return response;
    } catch (e) {
      print("Lỗi query: $e");
      return [];
    }
  }

  Future<List<String>> getCategoryBook() async {
    try {
      final response = await _client.from('titlebook').select('category');
      print(
        response.isNotEmpty
            ? response.map((row) => row['category'] as String).toSet().toList()
            : [],
      );
      return response.isNotEmpty
          ? response.map((row) => row['category'] as String).toSet().toList()
          : [];
    } catch (e) {
      print("Lỗi query: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getFavorites(String userId) async {
    try {
    final response = await _client
      .from('favorites')
      .select('''
        id,
        book_id,
        titlebook(
          watching,
          nametitle,
          fileimage,
          chapter(id,titlebookid,chapternumber, chaptertitle,content)
        )
      ''')
      .eq('user_id', int.parse(userId));
      return response;
    } catch (e) {
      print("Lỗi query: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getBooksByCategory(String category) async {
    final response = await _client
        .from('titlebook')
        .select('''
        id,
        nametitle,
        watching,
        fileimage,
        chapter (
          id,
          chapternumber,
          chaptertitle,
          content
        )
      ''')
        .eq('category', category)
        .order('watching', ascending: true)
        .limit(5);

    if (response.isEmpty) return [];
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> addFavorite(String userId, String bookId) async {
    await _client.from('favorites').insert({
      'user_id': userId,
      'book_id': bookId,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> removeFavorite(String userId, String bookId) async {
    await _client
        .from('favorites')
        .delete()
        .eq('user_id', userId)
        .eq('book_id', bookId);
  }

  Future<bool> checkFavorite(String userId, String bookId) async {
    final data = await _client
        .from('favorites')
        .select()
        .eq('user_id', userId)
        .eq('book_id', bookId);
    return data.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> searchBooks(String searchQuery) async {
    try{
    final response = await _client
        .from('titlebook')
        .select('''
        id,
        nametitle,
        watching,
        fileimage,
        chapter (
          id,
          chapternumber,
          chaptertitle,
          content
        )
      ''')
        .ilike('nametitle',  "%$searchQuery%");
        print(response);
    if (response.isEmpty) return [];
    return response;
    }catch(e){
      print("Lỗi query: $e");
      return [];
    }
  }

  // Lưu username
  Future<void> saveUsername(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', userId);
  }

  // Lấy username
  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('id');
  }

  // Xóa username khi logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('id');
  }
}
