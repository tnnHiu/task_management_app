import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // Bộ điều khiển cho TextField để xử lý giá trị nhập liệu
  final TextEditingController _searchController = TextEditingController();

  // Lưu trữ kết quả tìm kiếm
  List<Map<String, dynamic>> _searchResults = [];
  
  // Lưu trữ lịch sử tìm kiếm của người dùng
  List<String> _searchHistory = [];

  @override
  void initState() {
    super.initState();
    _loadSearchHistory(); // Gọi hàm tải lịch sử tìm kiếm khi widget được khởi tạo
  }

  // Tải lịch sử tìm kiếm từ Firestore
  Future<void> _loadSearchHistory() async {
    final userId = FirebaseAuth.instance.currentUser?.uid; // Lấy userId của người dùng hiện tại
    if (userId == null) return; // Nếu userId không tồn tại, thoát khỏi hàm

    // Lấy các tài liệu trong collection 'search' khớp với userId, sắp xếp theo timestamp
    final historySnapshot = await FirebaseFirestore.instance
        .collection('search')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .get();

    List<String> history = [];
    for (var doc in historySnapshot.docs) {
      history.add(doc['query']); // Lấy query từ từng tài liệu và thêm vào danh sách
    }

    setState(() {
      _searchHistory = history; // Cập nhật trạng thái lịch sử tìm kiếm
    });
  }

  // Lưu một truy vấn tìm kiếm vào Firestore
  Future<void> _saveSearchHistory(String query) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return; // Nếu userId không tồn tại, thoát khỏi hàm

    // Nếu query chưa tồn tại trong lịch sử, thêm nó vào đầu danh sách
    if (!_searchHistory.contains(query)) {
      setState(() {
        _searchHistory.insert(0, query);
      });

      // Thêm truy vấn mới vào Firestore với userId và timestamp
      await FirebaseFirestore.instance.collection('search').add({
        'userId': userId,
        'query': query,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  // Xóa toàn bộ lịch sử tìm kiếm của người dùng
  Future<void> _clearSearchHistory() async {
    setState(() {
      _searchHistory.clear(); // Xóa lịch sử tìm kiếm trong trạng thái cục bộ
    });

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    // Lấy tất cả các tài liệu lịch sử của người dùng trong Firestore và xóa từng tài liệu
    final snapshot = await FirebaseFirestore.instance
        .collection('search')
        .where('userId', isEqualTo: userId)
        .get();

    for (var doc in snapshot.docs) {
      doc.reference.delete();
    }
  }

  // Tìm kiếm nhiệm vụ và sự kiện dựa trên từ khóa
  Future<void> _searchTasksAndEvents(String query) async {
    query = query.toLowerCase(); // Chuyển từ khóa sang chữ thường để so sánh
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    // Lấy các tài liệu trong collection 'tasks' của người dùng
    final tasksSnapshot = await FirebaseFirestore.instance
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .get();

    // Lấy các tài liệu trong collection 'events' của người dùng
    final eventsSnapshot = await FirebaseFirestore.instance
        .collection('events')
        .where('userId', isEqualTo: userId)
        .get();

    List<Map<String, dynamic>> results = [];

    // Lọc kết quả từ 'tasks' dựa trên từ khóa
    for (var doc in tasksSnapshot.docs) {
      if (doc['name'].toString().toLowerCase().contains(query)) {
        results.add({'type': 'Task', 'data': {'id': doc.id, ...doc.data()}});
      }
    }

    // Lọc kết quả từ 'events' dựa trên từ khóa
    for (var doc in eventsSnapshot.docs) {
      if (doc['title'].toString().toLowerCase().contains(query)) {
        results.add({'type': 'Event', 'data': {'id': doc.id, ...doc.data()}});
      }
    }

    setState(() {
      _searchResults = results; // Cập nhật trạng thái danh sách kết quả tìm kiếm
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tìm kiếm', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: TextField(
                controller: _searchController, // Liên kết bộ điều khiển với TextField
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[800], // Nền ô nhập màu xám
                  hintText: 'Tìm kiếm',
                  hintStyle: TextStyle(color: Colors.grey), // Gợi ý màu xám
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none, // Không có viền
                  ),
                ),
                style: TextStyle(color: Colors.white), // Văn bản màu trắng
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    _searchTasksAndEvents(value); // Gọi hàm tìm kiếm khi có thay đổi
                  }
                },
              ),
            ),
            Expanded(
              child: _searchController.text.isEmpty
                  ? Column(
                      children: [
                        // Hiển thị lịch sử tìm kiếm
                        Expanded(
                          child: ListView.builder(
                            itemCount: _searchHistory.length,
                            itemBuilder: (context, index) {
                              final historyItem = _searchHistory[index];
                              return ListTile(
                                title: Text(historyItem, style: TextStyle(color: Colors.white)),
                                onTap: () {
                                  _searchController.text = historyItem; // Điền từ khóa vào ô nhập
                                  _searchTasksAndEvents(historyItem); // Tìm kiếm lại
                                },
                              );
                            },
                          ),
                        ),
                        // Nút xóa lịch sử
                        if (_searchHistory.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: _clearSearchHistory,
                              child: Text('Xóa lịch sử tìm kiếm'),
                            ),
                          ),
                      ],
                    )
                  : ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final result = _searchResults[index];
                        return ListTile(
                          // Hiển thị tên hoặc tiêu đề của kết quả
                          title: Text(result['data']['name'] ?? result['data']['title'] ?? 'Không có tên', style: TextStyle(color: Colors.white)),
                          subtitle: Text(result['type'], style: TextStyle(color: Colors.grey)), // Loại kết quả (Task hoặc Event)
                          onTap: () async {
                            await _saveSearchHistory(_searchController.text); // Lưu lịch sử
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
