// lib/components/GlobalNavbar.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '../screens/TranslateScreen.dart';
import '../screens/SignsPage.dart';
import '../screens/EmergencyScreen.dart';
import '../screens/TwoWayScreen.dart';
import '../l10n/AppLocalizations.dart';

class GlobalNavbar extends StatelessWidget {
  final VoidCallback toggleTheme;
  final Function(Locale) setLocale;
  final String activeRoute;

  const GlobalNavbar({
    super.key,
    required this.toggleTheme,
    required this.setLocale,
    required this.activeRoute,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).primaryColor;
    final l = AppLocalizations.of(context);
    final w = MediaQuery.of(context).size.width;
    final currentLocale = Localizations.localeOf(context);

    const double _kDesktopBreak = 750;
    final isMobile = w <= _kDesktopBreak;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: w > 900 ? 48 : 16,
        vertical: 20,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF0D0D1F).withOpacity(0.7)
            : Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.06)
              : Colors.black.withOpacity(0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(isDark ? 0.08 : 0.04),
            blurRadius: 40,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
            child: Row(
              children: [
                Container(
                  width: 5,
                  height: 26,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primary, primary.withOpacity(0.4)],
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 14),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [primary, const Color(0xFF9D8FFF)],
                  ).createShader(bounds),
                  child: const Text(
                    "VANI",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 4.0,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Row(
            children: [
              if (w > _kDesktopBreak) ...[
                _NavLink(
                  label: l.t('nav_home'),
                  isActive: activeRoute == 'home',
                  onTap: () =>
                      Navigator.of(context).popUntil((r) => r.isFirst),
                ),
                _NavLink(
                  label: l.t('nav_terminal'),
                  isActive: activeRoute == 'translate',
                  onTap: () {
                    if (activeRoute != 'translate') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TranslateScreen(
                            toggleTheme: toggleTheme,
                            setLocale: setLocale,
                          ),
                        ),
                      );
                    }
                  },
                ),
                _NavLink(
                  label: l.t('nav_signs'),
                  isActive: activeRoute == 'signs',
                  onTap: () {
                    if (activeRoute != 'signs') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SignsPage(
                            toggleTheme: toggleTheme,
                            setLocale: setLocale,
                          ),
                        ),
                      );
                    }
                  },
                ),
                _NavLink(
                  label: l.t('nav_bridge'),
                  isActive: activeRoute == 'bridge',
                  onTap: () {
                    if (activeRoute != 'bridge') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TwoWayScreen(
                            toggleTheme: toggleTheme,
                            setLocale: setLocale,
                          ),
                        ),
                      );
                    }
                  },
                ),
                _EmergencyNavLink(
                  isActive: activeRoute == 'emergency',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EmergencyScreen(
                          toggleTheme: toggleTheme,
                          setLocale: setLocale,
                        ),
                      ),
                    );
                  },
                ),
              ],

              if (w <= _kDesktopBreak) ...[
                _MobileEmergencyIcon(
                  isActive: activeRoute == 'emergency',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EmergencyScreen(
                          toggleTheme: toggleTheme,
                          setLocale: setLocale,
                        ),
                      ),
                    );
                  },
                ),
              ],

              _LanguageDropdown(
                currentLocale: currentLocale,
                setLocale: setLocale,
                l: l,
                isDark: isDark,
                primary: primary,
              ),
              const SizedBox(width: 6),

              IconButton(
                onPressed: toggleTheme,
                icon: Icon(
                  isDark
                      ? Icons.light_mode_outlined
                      : Icons.dark_mode_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}