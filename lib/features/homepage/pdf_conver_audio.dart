import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter_tts/flutter_tts.dart';

class PdfToSpeechPage extends StatefulWidget {
  const PdfToSpeechPage({super.key});

  @override
  State<PdfToSpeechPage> createState() => _PdfToSpeechPageState();
}

class _PdfToSpeechPageState extends State<PdfToSpeechPage> {
  final FlutterTts flutterTts = FlutterTts();
  String pdfText = "";
  bool isPlaying = false;
  Future<void> pickAndLoadPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true, 
    );

    if (result != null) {
      Uint8List? bytes = result.files.single.bytes;

      if (bytes != null) {
        final PdfDocument document = PdfDocument(inputBytes: bytes);
        String text = PdfTextExtractor(document).extractText();
        document.dispose();

        setState(() {
          pdfText = text;
        });
      } else {
        final path = result.files.single.path;
        if (path != null) {
          final bytesFromPath = await File(path).readAsBytes();
          final PdfDocument document = PdfDocument(inputBytes: bytesFromPath);
          String text = PdfTextExtractor(document).extractText();
          document.dispose();

          setState(() {
            pdfText = text;
          });
        }
      }
    }
  }
void _toggleAudio() async {
    if (isPlaying) {
      await flutterTts.stop();
      setState(() {
        isPlaying = false;
      });
    } else  {
    if (pdfText.isNotEmpty) {
    await flutterTts.setEngine("com.google.android.tts");
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.setLanguage("vi-VN");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1.0);
     speakText(pdfText);
     setState(() {
        isPlaying = true;
      });
    }
    }
}


Future<void> speakText(String text) async {
  text = text.replaceAll(RegExp(r'\s+'), " ").trim();

  const int chunkSize = 300; 
  for (int i = 0; i < text.length; i += chunkSize) {
    String chunk = text.substring(
      i,
      (i + chunkSize > text.length) ? text.length : i + chunkSize,
    );

    await flutterTts.speak(chunk);
    await Future.delayed(const Duration(seconds: 1));
    if(!isPlaying){
      await flutterTts.stop();
      break;
      }
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PDF to Audio")),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: pickAndLoadPdf, child: const Text("📂 Chọn file PDF")),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: Text(pdfText.isNotEmpty ? pdfText : "Chưa có nội dung PDF"),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed:()=> _toggleAudio(), child: const Text("▶️ Đọc")),
              const SizedBox(width: 10),
              ElevatedButton(
                  onPressed: () => _toggleAudio(),
                  child: const Text("⏹ Dừng")),
            ],
          )
        ],
      ),
    );
  }
}
