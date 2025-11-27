import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = "";

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  void _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? "User";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hai, $username!"), // Requirement: AppBar menampilkan username [cite: 4]
        backgroundColor: const Color.fromARGB(255, 255, 240, 240),
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Menu News [cite: 8]
            _buildMenuCard(
              title: "News",
              description: "Get an overview of the latest SpaceFlight news.",
              icon: Icons.article,
              category: "articles", // Endpoint API
              color: Colors.grey[100]!,
            ),
            const SizedBox(height: 16),
            // Menu Blog [cite: 10]
            _buildMenuCard(
              title: "Blog",
              description: "Blogs often provide a more detailed overview.",
              icon: Icons.book,
              category: "blogs", // Endpoint API
              color: Colors.grey[100]!,
            ),
            const SizedBox(height: 16),
            // Menu Report [cite: 12]
            _buildMenuCard(
              title: "Report",
              description: "Space stations and other missions data.",
              icon: Icons.analytics,
              category: "reports", // Endpoint API
              color: Colors.grey[100]!,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required String title,
    required String description,
    required IconData icon,
    required String category,
    required Color color,
  }) {
    return InkWell(
      onTap: () {
        // Navigasi ke halaman List sesuai menu yang dipilih [cite: 4, 15]
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ListPage(category: category, title: title),
          ),
        );
      },
      child: Card(
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 50),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(description),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}