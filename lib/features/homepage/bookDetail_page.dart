import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:my_app/features/model/chapter_model.dart';

class BookDetailPage extends StatefulWidget {
  final String title;
  final String coverImage;
  final List<Chapter> chapters;

  const BookDetailPage({
    Key? key,
    required this.title,
    required this.coverImage,
    required this.chapters,
  }) : super(key: key);

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  final FlutterTts flutterTts = FlutterTts();
  bool isPlaying = false;

  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
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
    await flutterTts.setLanguage("vi-VN");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1.0);

    // Kiểm tra ngôn ngữ có khả dụng không
    List<dynamic> voices = await flutterTts.getVoices;
    print("Available voices: $voices");
      String allContent = widget.chapters.map((c) => c.content).join(" ");
      await flutterTts.speak(allContent);
      setState(() {
        isPlaying = true;
      });
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
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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