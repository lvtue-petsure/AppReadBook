import 'package:flutter/material.dart';
import 'package:my_app/features/auth/dbService/supabase_service.dart';
import 'package:my_app/features/homepage/bookDetail_page.dart';
import 'package:my_app/features/homepage/category_book_view.dart';
import 'package:my_app/features/homepage/favorites_page.dart';
import 'package:my_app/features/homepage/pdf_conver_audio.dart';
import 'package:my_app/features/homepage/user_profile_page.dart';
import 'package:my_app/features/homepage/search_page.dart';
import 'package:my_app/features/model/chapter_model.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  // Dữ liệu demo
  final supabaseService = SupabaseService();
  Map<String, dynamic>? titlebook;
  List<Map<String, dynamic>>? topbook;
  List<Map<String, dynamic>>? slidebook;
  List<Map<String, dynamic>>? bookleast;
  List<Map<String, dynamic>>? bookOlest;
  bool isLoading = true; 
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 5; // số slide
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _totalPages - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
    fetchSupabaseData();
    fetchTopBooks();
  }

  void fetchSupabaseData() async {
    final bookReadMost = await supabaseService.getBookReadMost();
    setState(() {
      titlebook = bookReadMost;
    });
  }

  void fetchTopBooks() async {
    try {
      final bookReadMost = await supabaseService.fetchTopBooks();
      final slideReadMost = await supabaseService.fetchTopBooksSlide();
      final fiveBooksleast = await supabaseService.getFiveBookRead();
      final fiveBooksOldes = await supabaseService.getFiveBookReadMost();
      setState(() {
        topbook = bookReadMost;
        slidebook = slideReadMost;
        bookleast = fiveBooksleast;
        bookOlest = fiveBooksOldes;
        isLoading = false;
      });
    } catch (e) {
      print("Error TTS: $e");
    }
  }

  void openBookDetail(Map<String, dynamic>? titleBook) {
    if (titleBook == null) return;
    try {
      final firstChapter = (titleBook!['chapter'] as List<dynamic>?)?.first;
      List<Chapter> chapter = (titleBook!['chapter'] as List)
          .map((e) => Chapter.fromJson(e as Map<String, dynamic>))
          .toList();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BookDetailPage(
            bookId: titleBook?['id'].toString() ?? "",
            title: firstChapter?['chaptertitle'] ?? "",
            coverImage: "assets/"+titleBook?['fileimage'] ?? "images/loading.png",
            chapters: chapter,
          ),
        ),
      );
    } catch (e) {
      print("Error TTS: $e");
    }
  }

  void openfvieBookleast(Map<String, dynamic>? book) {
    if (bookleast == null) return;
    try {
      final chaptersJson = book!['chapter'] as List<dynamic>? ?? [];
      final chapters = chaptersJson
          .map((e) => Chapter.fromJson(e as Map<String, dynamic>))
          .toList();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BookDetailPage(
            bookId: book?['id']!.toString() ?? "",
            title: book?['nametitle'] ?? "",
            coverImage:"assets/"+ book?['fileimage'] ?? "images/loading.png",
            chapters: chapters,
          ),
        ),
      );
    } catch (e) {
      print("Error TTS: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Icon(Icons.book),
            SizedBox(width: 100),
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Tìm kiếm...",
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                textInputAction: TextInputAction.search, 
                onSubmitted: (value) {
                  Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SearchPage(searchQuery: value??""),
                                ),
                          );
                  },
                ),    
              ),
            ),
            SizedBox(width: 12), // khoảng cách giữa search và logout
            // Icon logout nằm ngoài
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(12),
                backgroundColor: Colors.grey,
              ),
              onPressed: () async  {
                Navigator.push(context,MaterialPageRoute(
                  builder: (_) => UserProfilePage(),
                ),
              );
              },
              child: Icon(Icons.person, color: Colors.white),
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(), 
            )
          :Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                _buildtabButton("Audio Book", 0),
                SizedBox(width: 12),
                _buildtabButton("Thể loại sách", 1),
                SizedBox(width: 12),
                _buildtabButton("Danh sách yêu thích", 2),
              ],
            ),
            Expanded(child: _buildListContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildtabButton(String text, int index) {
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: _selectedIndex == index
              ? FontWeight.bold
              : FontWeight.normal,
          color: _selectedIndex == index ? Colors.blue : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildListContent() {
    List<String> items;
    if (_selectedIndex == 0) {
        fetchSupabaseData();
        fetchTopBooks();
      return _buildhomePage();
    } else if (_selectedIndex == 1) {
        return const CategoryBookView();
    } else {
        return const FavoritesPage();
    }
  }
  Widget _buildhomePage(){
    return ListView(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _totalPages,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/"+slidebook?[index % 3]["fileimage"] ??
                          "images/loading.png",
                    ), // đổi ảnh theo slide
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.3),
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    (slidebook != null && slidebook!.isNotEmpty)
                        ? slidebook![index % 3]["nametitle"]! ?? ""
                        : "",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "sách nghe nhiều nhất",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 120, // chiều cao thẻ
          child: InkWell(
            onTap:() {
                  openBookDetail(titlebook);
                },
            child: Row(
              children: [
                Container(
                  width: 100, // width nhỏ, không full màn hình
                  margin: EdgeInsets.only(left: 8), // cách lề trái
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage(
                       "assets/"+ titlebook?['fileimage'] ?? "images/loading.png",
                      ),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.blue.withOpacity(0.5),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "${titlebook?['nametitle'] ?? ""}\n${titlebook?['watching'] ?? ""}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Top sách nghe nhiều nhất",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount:5, // dùng length của list data
            itemBuilder: (context, index) {
              final book = bookOlest![index]; // lấy 1 object sách

              return GestureDetector(
                onTap: () {
                  openfvieBookleast(book);
                },
                child: Container(
                  width: 120,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage(
                        (book != null && book!.isNotEmpty)
                            ? "assets/"+book!['fileimage'] ?? ""
                            : "",
                      ),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.3), // làm tối ảnh để chữ nổi
                        BlendMode.darken,
                      ),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        (book != null && book!.isNotEmpty)
                            ? book!['nametitle'] ?? ""
                            : "",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "top sách nghe mới cập nhật",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount:5, // dùng length của list data
            itemBuilder: (context, index) {
              final book = bookleast![index]; // lấy 1 object sách

              return GestureDetector(
                onTap: () {
                  openfvieBookleast(book);
                },
                child: Container(
                  width: 120,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage(
                        (book != null && book!.isNotEmpty)
                            ?"assets/"+ book!['fileimage'] ?? ""
                            : "",
                      ),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.3),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        (book != null && book!.isNotEmpty)
                            ? book!['nametitle'] ?? ""
                            : "",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Chuyễn văn bản thành Audio",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 200, // chiều ngang cố định
            height: 60, // chiều cao cố định
            child: ElevatedButton.icon(
              onPressed: () {
                
                Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PdfToSpeechPage(),
        ),
      );
              },
              icon: Icon(Icons.picture_as_pdf),
              label: Text(
                "Convert PDF → Audio",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
 
