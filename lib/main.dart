import 'package:flutter/material.dart';
import 'screens/HomeScreen.dart';
import 'screens/TranslateScreen.dart'; 

void main() => runApp(const VaniApp());

class VaniApp extends StatefulWidget {
  const VaniApp({super.key});

  @override
  State<VaniApp> createState() => _VaniAppState();
}

class _VaniAppState extends State<VaniApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryIndigo = Color(0xFF6366F1);

    return MaterialApp(
      title: 'Vani ISL',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      
      // LIGHT THEME CONFIG
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: primaryIndigo,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        cardColor: Colors.white,
        colorScheme: const ColorScheme.light(
          primary: primaryIndigo,
          secondary: Color(0xFF0EA5E9),
        ),
        useMaterial3: true, // Modern Flutter look
      ),

      // DARK THEME CONFIG
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: primaryIndigo,
        scaffoldBackgroundColor: const Color(0xFF020617),
        cardColor: const Color(0xFF1E293B),
        colorScheme: const ColorScheme.dark(
          primary: primaryIndigo,
          secondary: Color(0xFF10B981),
        ),
        useMaterial3: true,
      ),
      
      // Set the Home Screen
      home: HomeScreen(toggleTheme: toggleTheme),
    );
  }
}

// --- SHARED UI COMPONENTS ---

class GlobalNavbar extends StatelessWidget {
  final VoidCallback toggleTheme;
  final String activeRoute;

  const GlobalNavbar({super.key, required this.toggleTheme, required this.activeRoute});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).primaryColor;
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth > 900 ? 60 : 20, 
        vertical: 25
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          GestureDetector(
            onTap: () {
              if (activeRoute != 'home') Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(toggleTheme: toggleTheme)));
            },
            child: Text(
              "VANI",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: primary,
                letterSpacing: 1.8,
              ),
            ),
          ),

          // Navigation Links
          Row(
            children: [
              if (screenWidth > 750) ...[
                _NavLink(
                  label: "Home",
                  isActive: activeRoute == 'home',
                  onTap: () {
                    if (activeRoute != 'home') {
                      Navigator.pushAndRemoveUntil(
                        context, 
                        MaterialPageRoute(builder: (context) => HomeScreen(toggleTheme: toggleTheme)),
                        (route) => false
                      );
                    }
                  },
                ),
                _NavLink(
                  label: "Translate",
                  isActive: activeRoute == 'translate',
                  onTap: () {
                    if (activeRoute != 'translate') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TranslateScreen(toggleTheme: toggleTheme))
                      );
                    }
                  },
                ),
                const _NavLink(label: "Models"),
              ],
              const SizedBox(width: 10),
              
              // Theme Toggle
              IconButton(
                onPressed: toggleTheme,
                icon: Icon(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  size: 22,
                  color: primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback? onTap;
  const _NavLink({required this.label, this.isActive = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).primaryColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? primary : (isDark ? Colors.white70 : Colors.grey[600]),
            fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}