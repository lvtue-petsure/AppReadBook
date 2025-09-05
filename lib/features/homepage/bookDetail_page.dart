import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class BookDetailPage extends StatefulWidget {
  final String title;
  final String content;
  final String coverImage;

  const BookDetailPage({
    Key? key,
    required this.title,
    required this.content,
    required this.coverImage,
  }) : super(key: key);

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  final FlutterTts flutterTts = FlutterTts();
  bool isPlaying = false;

  late PageController _pageController;
  late List<String> _pages;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Tự động chia content thành nhiều trang
    _pages = _splitContent(widget.content, 900); // 900 ký tự mỗi trang
  }

  List<String> _splitContent(String text, int chunkSize) {
    List<String> chunks = [];
    for (var i = 0; i < text.length; i += chunkSize) {
      chunks.add(
        text.substring(i, i + chunkSize > text.length ? text.length : i + chunkSize),
      );
    }
    return chunks;
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
      await flutterTts.speak(widget.content);
      setState(() {
        isPlaying = true;
      });
    }
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
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
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(widget.coverImage), // ảnh từ assets
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.4), // làm mờ để chữ dễ đọc
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
              itemCount: _pages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Text(
                      _pages[index],
                      style: TextStyle(
                        fontSize: 18,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // thanh điều hướng trang
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
                  "${_currentPage + 1} / ${_pages.length}",
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

          // nút đọc sách
          SizedBox(
            width: double.infinity,
            height: 55,
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
        ],
      ),
    );
  }
}