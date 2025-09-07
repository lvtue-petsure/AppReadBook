import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:my_app/features/model/chapter_model.dart';
import 'package:my_app/features/auth/dbService/supabase_service.dart';

class BookDetailPage extends StatefulWidget {
  final String title;
  final String bookId;
  final String coverImage;
  final List<Chapter> chapters;

  const BookDetailPage({
    Key? key,
    required this.bookId,
    required this.title,
    required this.coverImage,
    required this.chapters,
  }) : super(key: key);

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  final FlutterTts flutterTts = FlutterTts();
  final supabaseService = SupabaseService();
  bool isPlaying = false;
  bool isFavorite = false;
  late PageController _pageController;
  int _currentPage = 0;
  String? _userID;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _getUser();
  }
void _getUser() async {
    var userId = await supabaseService.getUsername();
  setState(() {
    _userID = userId;
  });
  _checkFavoriteStatus();
}

// Kiểm tra xem sách đã được yêu thích chưa
void _checkFavoriteStatus() async {
  bool fav = await supabaseService.checkFavorite(_userID??"0", widget.bookId);
  setState(() {
    isFavorite = fav;
  });
}

void _toggleFavorite() async {
  setState(() {
    isFavorite = !isFavorite;
  });

  if (isFavorite) {
    // thêm vào bảng favorites
    await supabaseService.addFavorite(_userID??"0", widget.bookId);
  } else {
    // xóa khỏi bảng favorites
    await supabaseService.removeFavorite(_userID??"0", widget.bookId);
  }
}


  @override
  void dispose() {
    flutterTts.stop();
    _pageController.dispose();
    super.dispose();
  }

  void _toggleAudio() async {
    if (isPlaying) {
      await flutterTts.stop();
      setState(() {
        isPlaying = false;
      });
    } else {
      // Thiết lập ngôn ngữ sang tiếng Việt
    await flutterTts.setEngine("com.google.android.tts");
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.setLanguage("vi-VN");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1.0);

      String allContent = widget.chapters.map((c) => c.content).join(" ");
     speakLongText(allContent);
      setState(() {
        isPlaying = true;
      });
    }
  }
  
  Future<void> speakLongText(String text) async {
  final chunks = text.split(RegExp(r'(?<=\.)')); // cắt theo dấu chấm
  for (var chunk in chunks) {
    final clean = chunk.trim();
    if (clean.isNotEmpty) {
      await flutterTts.speak(clean);
      await Future.delayed(const Duration(seconds: 1)); 
      if(!isPlaying){
      await flutterTts.stop();
      break;
      }
    }
  }
  }


  void _nextPage() {
    if (_currentPage < widget.chapters.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(widget.coverImage),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.4),
                BlendMode.darken,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.chapters.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final chapter = widget.chapters[index];
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chapter.chapterTitle,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          chapter.content,
                          style: TextStyle(
                            fontSize: 18,
                            height: 1.6,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _prevPage,
                  icon: Icon(Icons.arrow_back),
                  label: Text("Trang trước"),
                ),
                Text(
                  "${_currentPage + 1} / ${widget.chapters.length}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                ElevatedButton.icon(
                  onPressed: _nextPage,
                  icon: Icon(Icons.arrow_forward),
                  label: Text("Trang sau"),
                ),
              ],
            ),
          ),
          Container(
  padding: EdgeInsets.all(16),
  color: Colors.white,
  child: Row(
    children: [
      Expanded(
        child: ElevatedButton.icon(
          onPressed: _toggleAudio,
          icon: Icon(
            isPlaying ? Icons.pause_circle_filled : Icons.volume_up_rounded,
            size: 28,
          ),
          label: Text(
            isPlaying ? "Dừng đọc" : "Nghe sách",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 3,
          ),
        ),
      ),
      SizedBox(width: 12),
      Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        child: GestureDetector(
          onTap: _toggleFavorite,
          child: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: Colors.red,
            size: 28,
          ),
        ),
      ),
    ],
  ),
),
        ],
      ),
    );
  }
}


