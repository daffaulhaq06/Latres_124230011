import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'detail_page.dart';

class ListPage extends StatefulWidget {
  final String title;
  final String category; // 'articles', 'blogs', atau 'reports'

  const ListPage({super.key, required this.title, required this.category});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<dynamic> listData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

 Future<void> fetchData() async {
  // 1. Cek URL di Console (Lihat bagian Run tab di bawah)
  final url = "https://api.spaceflightnewsapi.net/v4/${widget.category}/"; 
  print("Mencoba Request ke: $url");

  try {
    final response = await http.get(Uri.parse(url));

    // 2. Cek Status Code
    print("Status Code: ${response.statusCode}"); 

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        listData = data['results'];
      });
    } else {
      // Jika error dari server
      print("Gagal: ${response.body}");
      throw Exception("Gagal memuat data");
    }
  } catch (e) {
    // 3. Tangkap Error Lain (misal gak ada sinyal)
    print("ERROR TERJADI: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $e")),
    );
  } finally {
    // 4. INI KUNCINYA: Apapun yang terjadi, matikan loading!
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
          ? const Center(child: CircularProgressIndicator()) // Loading Spinner
          : ListView.builder(
              itemCount: listData.length,
              itemBuilder: (context, index) {
                final item = listData[index];
                return InkWell(
                  onTap: () {
                    // Kirim ID dan Category ke Detail Page 
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(
                          id: item['id'], 
                          category: widget.category
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(item['image_url'], height: 200, width: double.infinity, fit: BoxFit.cover),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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