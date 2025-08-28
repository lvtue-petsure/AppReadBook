import 'package:flutter/material.dart';

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
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
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
                _buildtabButton("Top thịnh hành", 1),
                SizedBox(width: 12),
                _buildtabButton("Yêu thích", 2),
              ],
              ),
            Expanded(
              child: _buildListContent(),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildtabButton(String text, int index){
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
          color: _selectedIndex == index ? Colors.brown : Colors.grey,
        ),
      ),
    );
}
Widget _buildListContent(){
  List<String> items;
  if (_selectedIndex==0){
      items = sachNoi;
    }else if(_selectedIndex==1){
      items = sachDoc;
    }else{
      items = yeuThich;
    }

  return ListView( 
      children: [
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("sách nghe nhiều nhất", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
         SizedBox(
           height: 120,
           child: Container(
             width: 100,
              margin: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: Text("sách A")),
           ),
         ),
          // List ngang 1
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("top sách nghe nhiều nhất", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 120, // cần fix chiều cao cho list ngang
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

          // List ngang 2
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("top sách nghe mới cập nhật", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
          )
      ]
  );
}


}


