import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth_pages/auth_gate.dart';
import '../Profile_pages/task_pa.dart';
import '../../pages/Profile_pages/event_pa.dart';

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    print("user name ${user?.displayName}");
    String displayName = user?.displayName ?? 'Người dùng';


    return Drawer(
      backgroundColor: Color(0xFF242424),
      
      child: ListView(
        padding: EdgeInsets.zero, 
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF242424),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
            title: Text('Thống kê nhiệm vụ', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StatisticsPage(
                    startDate: DateTime.now().subtract(Duration(days: 30)),
                    endDate: DateTime.now(),
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.mail, color: Colors.orange),
            title: Text('Thống kê sự kiện', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EventStatisticsScreen()),
            );
            },
          ),
          ListTile(
            leading: Icon(Icons.rss_feed, color: Colors.orange,),
            title: Text('Thống kê focus mode', style: TextStyle(color: Colors.white),),
            onTap: () {
            },
          ),
          Divider(),
          Spacer(), 
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
