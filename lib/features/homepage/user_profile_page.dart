import 'package:flutter/material.dart';
import 'package:my_app/features/auth/presentation/pages/Login_Page.dart';
import 'package:my_app/features/auth/dbService/supabase_service.dart';
class UserProfilePage extends StatefulWidget {

  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool isLoading = true;
  final supabaseService = SupabaseService();
  String? _userID;
  Map<String, dynamic>? user;
  @override
  void initState() {
    super.initState();
   _getUser();
  }
 void _getUser() async {
    var userId = await supabaseService.getUsername();
    setState(() {
      _userID = userId;
    });
    print(_userID);
    loadUser();
  }
  Future<void> loadUser() async {
    final fetchedUser = await supabaseService.getUser(_userID??"0");

    setState(() {
      user = fetchedUser;
      isLoading = false;
    });
  }

  Future<void> logOut() async {
    var userId = await supabaseService.logout();
                Navigator.push(context,MaterialPageRoute(
                  builder: (_) => LoginPage(),
                ),
              );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Người dùng không tồn tại')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Thông tin người dùng')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              child:const Icon(Icons.person, size: 50)
            ),
            const SizedBox(height: 16),
            Text(user!["userName"], style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            Text(user!["email"], style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              
              onPressed: logOut,
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
