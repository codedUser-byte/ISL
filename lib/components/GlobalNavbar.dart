import 'package:flutter/material.dart';
import '../screens/TranslateScreen.dart';

class GlobalNavbar extends StatelessWidget {
  final VoidCallback toggleTheme;
  final String activeRoute;

  const GlobalNavbar({super.key, required this.toggleTheme, required this.activeRoute});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).primaryColor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).popUntil((route) => route.isFirst),
            child: Text("VANI", 
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: primary, letterSpacing: 1.8)),
          ),
          Row(
            children: [
              if (MediaQuery.of(context).size.width > 750) ...[
                _NavLink(
                  label: "Home", 
                  isActive: activeRoute == 'home',
                  onTap: () => Navigator.of(context).popUntil((route) => route.isFirst),
                ),
                _NavLink(
                  label: "Translate", 
                  isActive: activeRoute == 'translate',
                  onTap: () {
                    if (activeRoute != 'translate') {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TranslateScreen(toggleTheme: toggleTheme)));
                    }
                  },
                ),
                const _NavLink(label: "Models"),
              ],
              const SizedBox(width: 20),
              IconButton(
                onPressed: toggleTheme, 
                icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded, size: 22, color: primary)
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        child: Text(
          label, 
          style: TextStyle(
            color: isActive ? Theme.of(context).primaryColor : (isDark ? Colors.white70 : Colors.grey[600]), 
            fontWeight: isActive ? FontWeight.w800 : FontWeight.w500, 
            fontSize: 15
          ),
        ),
      ),
    );
  }
}