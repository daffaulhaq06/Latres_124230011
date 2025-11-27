import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'detail_page.dart';

class ListPage extends StatefulWidget {
  final String category; // 'articles', 'blogs', atau 'reports'
  final String title;

  const ListPage({super.key, required this.category, required this.title});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<dynamic> dataList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    // URL API dinamis berdasarkan kategori [cite: 54, 55]
    final url = "https://api.spaceflightnewsapi.net/v4/${widget.category}/"; 
    
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          dataList = data['results']; // Data ada di dalam object 'results'
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                final item = dataList[index];
                return InkWell(
                  onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(
                                id: item['id'],           // KITA HANYA KIRIM ID
                                category: widget.category // DAN KATEGORI (articles/blogs/reports)
                              ),
                            ),
                          );
                        },
                  child: Card(
                    margin: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Gambar Item
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(item['image_url']),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['title'],
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              Text(item['news_site'] ?? "Source unknown"),
                              Text(item['published_at'].substring(0, 10)), // Format tanggal sederhana
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}