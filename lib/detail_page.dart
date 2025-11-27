import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatefulWidget {
  final int id;
  final String category;

  const DetailPage({super.key, required this.id, required this.category});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<String, dynamic>? detailData; // Variabel untuk menampung data
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDetail();
  }

  // Fungsi fetch data berdasarkan ID sesuai instruksi soal
  // URL: https://api.spaceflightnewsapi.net/v4/{menu}/{id}/
  Future<void> fetchDetail() async {
    final url = "https://api.spaceflightnewsapi.net/v4/${widget.category}/${widget.id}/";
    
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          detailData = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load detail');
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Page")),
      // Tampilkan Loading jika data belum siap
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : detailData == null
              ? const Center(child: Text("Gagal memuat data"))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Gambar
                      Image.network(detailData!['image_url']),
                      
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Judul
                            Text(
                              detailData!['title'],
                              style: const TextStyle(
                                fontSize: 22, 
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            const SizedBox(height: 10),
                            
                            // Sumber & Tanggal
                            Text(
                              "${detailData!['news_site']} • ${detailData!['published_at'].substring(0, 10)}",
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 20),
                            
                            // Isi / Summary
                            Text(
                              detailData!['summary'],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
      floatingActionButton: !isLoading && detailData != null
          ? FloatingActionButton.extended(
              onPressed: () {
                _launchUrl(detailData!['url']);
              },
              label: const Text("Lihat Selengkapnya"),
              icon: const Icon(Icons.open_in_browser),
            )
          : null, // Sembunyikan tombol jika masih loading
    );
  }
}