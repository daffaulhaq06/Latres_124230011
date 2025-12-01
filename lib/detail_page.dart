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
  Map<String, dynamic>? detail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    // Request Detail by ID [cite: 55]
    final url = "https://api.spaceflightnewsapi.net/v4/${widget.category}/${widget.id}/";
    
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          detail = jsonDecode(response.body);
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() => isLoading = false);
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Berita")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Image.network(detail!['image_url']),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(detail!['title'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text(detail!['news_site'], style: const TextStyle(color: Colors.grey)),
                        const SizedBox(height: 20),
                        Text(detail!['summary']),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: !isLoading 
          ? FloatingActionButton.extended(
              onPressed: () => _launchURL(detail!['url']), // Buka Website [cite: 25]
              label: const Text("Lihat Aslinya"),
              icon: const Icon(Icons.open_in_new),
            )
          : null,
    );
  }
}