import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class BookDetailPage extends StatefulWidget {
  final String title;
  final String content;

  const BookDetailPage({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  final FlutterTts flutterTts = FlutterTts();
  bool isPlaying = false;

  @override
  void dispose() {
    flutterTts.stop();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.brown[400],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  widget.content,
                  style: TextStyle(fontSize: 18, height: 1.5),
                ),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _toggleAudio,
                icon: Icon(isPlaying ? Icons.pause : Icons.volume_up),
                label: Text(isPlaying ? "Dừng đọc" : "Nghe sách"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
