import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth_pages/auth_gate.dart';

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    print("user name ${user?.displayName}");
    String displayName = user?.displayName ?? 'Người dùng';


    return Drawer(
      backgroundColor: Color(0xFF242424),
      
      child: ListView(
        padding: EdgeInsets.zero, // Đảm bảo không có padding dư thừa
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF242424),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thêm ảnh đại diện nếu cần
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    displayName.isNotEmpty ? displayName[0] : '?',
                    style: TextStyle(fontSize: 30, color: Colors.blue),
                  ),
                  radius: 30,
                ),
                SizedBox(height: 10),
                Text(
                  displayName,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.calendar_today, color: Colors.orange),
            title: Text('Hôm nay', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Xử lý logic khi nhấn
            },
          ),
          ListTile(
            leading: Icon(Icons.mail, color: Colors.orange),
            title: Text('Hộp thư đến', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Xử lý logic khi nhấn
            },
          ),
          ListTile(
            leading: Icon(Icons.rss_feed, color: Colors.orange,),
            title: Text('Đã đăng ký Lịch', style: TextStyle(color: Colors.white),),
            trailing: Text('277'),
            onTap: () {
              // Xử lý logic khi nhấn
            },
          ),
          ListTile(
            title: Text('Study', style: TextStyle(color: Colors.white)),
            trailing: Text('4', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Xử lý logic khi nhấn
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.add, color: Colors.grey),
            title: Text('Thêm', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Xử lý logic khi nhấn
            },
          ),
          Spacer(), // Đẩy các mục bên trên lên
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Đăng xuất', style: TextStyle(color: Colors.red)),
            onTap: () async {
              try {
                await FirebaseAuth.instance.signOut();
                Navigator.push(context, MaterialPageRoute(builder: (context) => AuthGate()));
              } catch (e) {
                print('Lỗi đăng xuất: $e', );
              }
            },
          ),
        ],
      ),
    );
  }
}
