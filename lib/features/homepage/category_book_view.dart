import 'package:flutter/material.dart';
import 'package:my_app/features/auth/dbService/supabase_service.dart';
import 'package:my_app/features/homepage/list_category_page.dart';
class CategoryBookView extends StatefulWidget {
  const CategoryBookView({super.key});

  @override
  State<CategoryBookView> createState() => _CategoryBookViewtate();
}


class _CategoryBookViewtate extends State<CategoryBookView> {
final supabaseService = SupabaseService();
bool isLoading = true; 
List<String>? categories;
  @override
  void initState() {
    super.initState();
    fetchCategory();
  }

    void fetchCategory() async {
    final bookCategories = await supabaseService.getCategoryBook();
    setState(() {
      categories = bookCategories;
      isLoading= false;
    });
  }

  @override
  
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (categories == null || categories!.isEmpty) {
      return const Center(
        child: Text(
          "Không có dữ liệu",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      );
    }
    return ListView.builder(
      itemCount: categories?.length,
      padding: const EdgeInsets.all(12),
      itemBuilder:   (context, index) {
        final category = categories?[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: ListTile(
            
            title: Text(
              category!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BookListByCategory(
            category: categories?[index]?? "",
          ),
        ),
      );
            },
          ),
        );
      },
    );
  }
}
