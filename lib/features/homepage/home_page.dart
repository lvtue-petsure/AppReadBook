import 'package:flutter/material.dart';
import 'package:my_app/features/auth/dbService/supabase_service.dart';
import 'package:my_app/features/homepage/bookDetail_page.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  // Dữ liệu demo
  final List<String> sachNoi = ["Sách nói 1", "Sách nói 2", "Sách nói 3"];
  final List<String> sachDoc = ["Sách đọc A", "Sách đọc B", "Sách đọc C"];
  final List<String> yeuThich = ["Yêu thích X", "Yêu thích Y"];
  final supabaseService = SupabaseService();
  Map<String, dynamic>? titlebook;
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
  }

  void fetchSupabaseData() async {
    final bookReadMost = await supabaseService.getBookReadMost();
     setState(() {
    titlebook = bookReadMost;
     });

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
              onPressed: () {
                print("Đăng xuất");
              },
              child: Icon(Icons.person, color: Colors.white),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                _buildtabButton("Audio Book", 0),
                SizedBox(width: 12),
                _buildtabButton("Thể loại sách", 1),
                SizedBox(width: 12),
                _buildtabButton("danh sách yêu thích", 2),
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
      items = sachNoi;
    } else if (_selectedIndex == 1) {
      items = sachDoc;
    } else {
      items = yeuThich;
    }

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
                      'assets/images/toeic.PNG',
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
                    'Slide ${index + 1}',
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
    onTap: () {
      // Khi bấm → chỉ truyền dữ liệu sang BookDetailPage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BookDetailPage(
            title: "Sách TOEIC",      // chỉ hiện ở AppBar
            content: "Nội dung sách ở đây…",  // hiển thị bên trong BookDetailPage
            coverImage: "/images/toeic.PNG"
          ),
        ),
      );
    },
          child: Row(
            children: [
              Container(
                width: 100, // width nhỏ, không full màn hình
                margin: EdgeInsets.only(left: 8), // cách lề trái
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage('assets/images/toeic.PNG'),
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
                  titlebook?['nametitle'].toString()??"",
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
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Container(
                width: 100,
                margin: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.blue[100 * ((index % 8) + 1)],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: Text(items[index])),
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
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 8,
            itemBuilder: (context, index) {
              return Container(
                width: 120,
                margin: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.green[100 * ((index % 8) + 1)],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: Text("Item $index")),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Chuyễn văn bản thành audio",
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
                print("Nhấn vào nút Convert PDF → Text");
                // Sau này bạn thêm code chọn PDF và convert ở đây
              },
              icon: Icon(Icons.picture_as_pdf),
              label: Text("Convert PDF → Text", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),),
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
