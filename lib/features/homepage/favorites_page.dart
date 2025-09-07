import 'package:flutter/material.dart';
import 'package:my_app/features/homepage/bookDetail_page.dart';
import 'package:my_app/features/auth/dbService/supabase_service.dart';
import 'package:my_app/features/model/chapter_model.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final supabaseService = SupabaseService();
  List<Map<String, dynamic>> favorites = [];
  bool isLoading = true;
  String? _userID;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  void _getUser() async {
    var userId = await supabaseService.getUsername();
    setState(() {
      _userID = userId;
    });
    _loadFavorites(_userID);
  }

  void _loadFavorites(String? _userID) async {
    final favs = await supabaseService.getFavorites(_userID ?? "0");
    setState(() {
      favorites = favs;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : favorites.isEmpty
              ? const Center(
                  child: Text(
                    "Bạn chưa có sách yêu thích",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                  final fav = favorites[index];
                  List<Chapter> chapter = (fav?["titlebook"]!["chapter"] as List)
                  .map((e) => Chapter.fromJson(e as Map<String, dynamic>))
                  .toList();
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookDetailPage(
                              bookId: fav?["book_id"].toString()??"",
                              title: fav?["titlebook"]!["nametitle"]??"",
                              coverImage: "assets/"+fav?["titlebook"]!["fileimage"]??"",
                              chapters: chapter, // danh sách chương
                            ),
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  "assets/"+fav?["titlebook"]!["fileimage"],
                                  width: 70,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      fav?["titlebook"]!["nametitle"]??"",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "${fav?["titlebook"]!["chapter"].length} chương",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    if (fav?["titlebook"]!["chapter"].isNotEmpty)
                                      Text(
                                        fav?["titlebook"]!["chapter"].first["content"]
                                                ?.toString()
                                                .substring(0, 50) ??
                                            "",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[700],
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
