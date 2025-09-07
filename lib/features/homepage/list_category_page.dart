import 'package:flutter/material.dart';
import 'package:my_app/features/auth/dbService/supabase_service.dart';
import 'package:my_app/features/homepage/bookDetail_page.dart';
import 'package:my_app/features/model/chapter_model.dart';

class BookListByCategory extends StatefulWidget {
  final String category; // category được chọn

  const BookListByCategory({super.key, required this.category});

  @override
  State<BookListByCategory> createState() => _BookListByCategoryState();
}

class _BookListByCategoryState extends State<BookListByCategory> {
  final supabaseService = SupabaseService();
  bool isLoading = true;
  List<Map<String, dynamic>> books = [];

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    final bookCategories = await supabaseService.getBooksByCategory(
      widget.category,
    );
    setState(() {
      books = bookCategories;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.book),
            const SizedBox(width: 100),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(color: Colors.white),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Tìm kiếm...",
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(12),
                backgroundColor: Colors.grey,
              ),
              onPressed: () {
                print("Đăng xuất");
              },
              child: const Icon(Icons.person, color: Colors.white),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : books.isEmpty
          ? Center(
              child: Text("Không có sách trong thể loại '${widget.category}'"),
            )
          : ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        "assets/"+book['fileimage'] ?? "images/loading.png",
                        width: 50,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      book['nametitle'] ?? "Không có tên",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text("👀 ${book['watching'] ?? 0} lượt xem"),
                    onTap: () {
                      final chaptersJson =
                          book!['chapter'] as List<dynamic>? ?? [];
                      final chapters = chaptersJson
                          .map(
                            (e) => Chapter.fromJson(e as Map<String, dynamic>),
                          )
                          .toList();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookDetailPage(
                            bookId: book?['id']?.toString() ?? "",
                            title: book?['nametitle'] ?? "",
                            coverImage:
                               "assets/"+ book?['fileimage'] ?? "images/loading.png",
                            chapters: chapters,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
