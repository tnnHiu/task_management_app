import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  List<String> _searchHistory = [];

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();  // Tải lịch sử tìm kiếm khi ứng dụng khởi động
  }

  // Tải lịch sử tìm kiếm từ Firestore
  Future<void> _loadSearchHistory() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final historySnapshot = await FirebaseFirestore.instance
        .collection('search')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true) // Sắp xếp theo thời gian
        .get();

    List<String> history = [];
    for (var doc in historySnapshot.docs) {
      history.add(doc['query']);
    }

    setState(() {
      _searchHistory = history;
    });
  }

  // Lưu lịch sử tìm kiếm vào Firestore
  Future<void> _saveSearchHistory(String query) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    if (!_searchHistory.contains(query)) {
      setState(() {
        _searchHistory.insert(0, query);
      });

      await FirebaseFirestore.instance.collection('search').add({
        'userId': userId,
        'query': query,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  // Xóa lịch sử tìm kiếm
  Future<void> _clearSearchHistory() async {
    setState(() {
      _searchHistory.clear();
    });

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    // Xóa tất cả lịch sử tìm kiếm của người dùng
    final snapshot = await FirebaseFirestore.instance
        .collection('search')
        .where('userId', isEqualTo: userId)
        .get();

    for (var doc in snapshot.docs) {
      doc.reference.delete();
    }
  }

  Future<void> _searchTasksAndEvents(String query) async {
    query = query.toLowerCase(); 
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;
    
    final tasksSnapshot = await FirebaseFirestore.instance
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .get();

    final eventsSnapshot = await FirebaseFirestore.instance
        .collection('events')
        .where('userId', isEqualTo: userId)
        .get();

    List<Map<String, dynamic>> results = [];

    for (var doc in tasksSnapshot.docs) {
      if (doc['name'].toString().toLowerCase().contains(query)) {
        results.add({'type': 'Task', 'data': {'id': doc.id, ...doc.data()}});
      }
    }

    for (var doc in eventsSnapshot.docs) {
      if (doc['title'].toString().toLowerCase().contains(query)) {
        results.add({'type': 'Event', 'data': {'id': doc.id, ...doc.data()}});
      }
    }

    setState(() {
      _searchResults = results;
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
                controller: _searchController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[800],
                  hintText: 'Tìm kiếm',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(color: Colors.white),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    _searchTasksAndEvents(value);
                  }
                },
              ),
            ),
            Expanded(
              child: _searchController.text.isEmpty
                  ? Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: _searchHistory.length,
                            itemBuilder: (context, index) {
                              final historyItem = _searchHistory[index];
                              return ListTile(
                                title: Text(historyItem, style: TextStyle(color: Colors.white)),
                                onTap: () {
                                  _searchController.text = historyItem;
                                  _searchTasksAndEvents(historyItem);
                                },
                              );
                            },
                          ),
                        ),
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
                          title: Text(result['data']['name'] ?? result['data']['title'] ?? 'Không có tên', style: TextStyle(color: Colors.white)),
                          subtitle: Text(result['type'], style: TextStyle(color: Colors.grey)),
                          onTap: () async {
                            await _saveSearchHistory(_searchController.text);
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

