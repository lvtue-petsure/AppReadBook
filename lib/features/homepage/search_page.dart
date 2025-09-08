import 'package:flutter/material.dart';
import 'package:my_app/features/auth/dbService/supabase_service.dart';
import 'package:my_app/features/model/chapter_model.dart';
import 'package:my_app/features/homepage/bookDetail_page.dart';
import 'dart:async';


class SearchPage extends StatefulWidget {
  final String searchQuery; 

  const SearchPage({super.key, required this.searchQuery});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final supabaseService = SupabaseService();
  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // gọi tìm kiếm ngay khi mở trang với từ khoá truyền vào
    _searchBooks(widget.searchQuery);
  }

  Future<void> _searchBooks(String query) async {
    setState(() {
      isLoading = true;
    });

    final results = await supabaseService.searchBooks(query);

    setState(() {
      searchResults = results;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Kết quả cho: \"${widget.searchQuery}\"")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : searchResults.isEmpty
              ? const Center(child: Text("Không tìm thấy sách nào"))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: searchResults!.length,
                  itemBuilder: (context, index) {
                  final book = searchResults[index];
                  List<Chapter> chapter = (book?["chapter"] as List)
                  .map((e) => Chapter.fromJson(e as Map<String, dynamic>))
                  .toList();
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookDetailPage(
                              bookId: book?["id"].toString()??"",
                              title: book?["nametitle"]??"",
                              coverImage: "assets/"+book?["fileimage"]??"",
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
                                  "assets/"+book?["fileimage"],
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
                                      book?["nametitle"]??"",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "${book?["chapter"]!.length} chương",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    if (book?["chapter"]!.isNotEmpty)
                                      Text(
                                        book?["chapter"]!.first["content"]
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
