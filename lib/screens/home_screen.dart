import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final api = ApiService();
  Map<String, dynamic>? user;
  bool loading = true;

  // ✅ Liste des matières avec émojis
  final List<Map<String, String>> subjects = const [
    {"title": "Anglais", "emoji": "🇬🇧"},
    {"title": "Mathématique", "emoji": "➕"},
    {"title": "Orthographe", "emoji": "✏️"},
    {"title": "Histoire", "emoji": "📜"},
    {"title": "Grammaire", "emoji": "📖"},
    {"title": "Sc. Physique", "emoji": "⚛️"},
    {"title": "Géographie", "emoji": "🌍"},
    {"title": "SVT", "emoji": "🌱"},
  ];

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final data = await api.getProfile();
      setState(() {
        user = data;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> logout() async {
    await api.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Accueil")),

      // ✅ Drawer avec profil utilisateur
      drawer: Drawer(
        child: user == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  UserAccountsDrawerHeader(
                    decoration: const BoxDecoration(color: Colors.blue),
                    accountName: Text(user!['name']),
                    accountEmail: Text(user!['email']),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text(
                        user!['name'][0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text("Profil"),
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Naviguer vers l’écran Profil
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.group),
                    title: const Text("Utilisateurs"),
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Naviguer vers liste des utilisateurs
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.subscriptions),
                    title: const Text("Gérer mon abonnement"),
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Naviguer vers abonnement
                    },
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton.icon(
                      onPressed: logout,
                      icon: const Icon(Icons.logout),
                      label: const Text("Déconnexion"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                  ),
                ],
              ),
      ),

      // ✅ Contenu principal
      body: Column(
        children: [
          // Partie supérieure (fond bleu + logo + titre)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 30),
            color: Colors.blue,
            child: Column(
              children: [
                Image.asset("images/logo-lasco.jpg", height: 80),
                const SizedBox(height: 10),
                const Text(
                  "LASCO PRIVAT",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Partie inférieure (grid avec cartes animées)
          Expanded(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 cartes par ligne
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  final subject = subjects[index];
                  return GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Ouvrir ${subject['title']}")),
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 6,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // ✅ Emoji animé avec flutter_animate
                          Text(
                                subject['emoji']!,
                                style: const TextStyle(fontSize: 50),
                              )
                              .animate(
                                onPlay: (controller) => controller.repeat(),
                              )
                              .scale(
                                duration: 1000.ms,
                                begin: const Offset(1, 1),
                                end: const Offset(1.2, 1.2),
                              )
                              .then()
                              .scale(
                                duration: 1000.ms,
                                begin: const Offset(1.2, 1.2),
                                end: const Offset(1, 1),
                              ),
                          const SizedBox(height: 10),
                          Text(
                            subject['title']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
