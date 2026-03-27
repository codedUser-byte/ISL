// lib/components/GlobalNavbar.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '../screens/TranslateScreen.dart';
import '../screens/SignsPage.dart';
import '../screens/EmergencyScreen.dart';
import '../screens/TwoWayScreen.dart';
import '../l10n/AppLocalizations.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const _kViolet      = Color(0xFF7C3AED);
const _kVioletLight = Color(0xFFA78BFA);

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

  void _openAssistant(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'assistant',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (ctx, anim, _, __) {
        final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(1.0, 0), end: Offset.zero).animate(curved),
          child: FadeTransition(
            opacity: curved,
            child: Align(
              alignment: Alignment.centerRight,
              child: _AssistantPanel(toggleTheme: toggleTheme, setLocale: setLocale),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark        = Theme.of(context).brightness == Brightness.dark;
    final primary       = Theme.of(context).primaryColor;
    final l             = AppLocalizations.of(context);
    final screenWidth   = MediaQuery.of(context).size.width;
    final currentLocale = Localizations.localeOf(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth > 900 ? 48 : 16, vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D0D1F).withOpacity(0.7) : Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.05)),
        boxShadow: [BoxShadow(color: primary.withOpacity(isDark ? 0.08 : 0.04), blurRadius: 40, offset: const Offset(0, 8))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).popUntil((r) => r.isFirst),
            child: Row(children: [
              Container(
                width: 5, height: 26,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [primary, primary.withOpacity(0.4)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 14),
              ShaderMask(
                shaderCallback: (b) => LinearGradient(colors: [primary, const Color(0xFF9D8FFF)]).createShader(b),
                child: const Text('VANI', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 4.0)),
              ),
            ]),
          ),
          Row(children: [
            if (screenWidth > 750) ...[
              _NavLink(label: l.t('nav_home'), isActive: activeRoute == 'home',
                onTap: () => Navigator.of(context).popUntil((r) => r.isFirst)),
              _NavLink(label: l.t('nav_terminal'), isActive: activeRoute == 'translate',
                onTap: () { if (activeRoute != 'translate') Navigator.push(context, MaterialPageRoute(builder: (_) => TranslateScreen(toggleTheme: toggleTheme, setLocale: setLocale))); }),
              _NavLink(label: l.t('nav_signs'), isActive: activeRoute == 'signs',
                onTap: () { if (activeRoute != 'signs') Navigator.push(context, PageRouteBuilder(pageBuilder: (_, a, __) => SignsPage(toggleTheme: toggleTheme, setLocale: setLocale), transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child), transitionDuration: const Duration(milliseconds: 350))); }),
              _NavLink(label: l.t('nav_bridge'), isActive: activeRoute == 'bridge',
                onTap: () { if (activeRoute != 'bridge') Navigator.push(context, PageRouteBuilder(pageBuilder: (_, a, __) => TwoWayScreen(toggleTheme: toggleTheme, setLocale: setLocale), transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child), transitionDuration: const Duration(milliseconds: 350))); }),
              _EmergencyNavLink(isActive: activeRoute == 'emergency',
                onTap: () { if (activeRoute != 'emergency') Navigator.push(context, PageRouteBuilder(pageBuilder: (_, a, __) => EmergencyScreen(toggleTheme: toggleTheme, setLocale: setLocale), transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child), transitionDuration: const Duration(milliseconds: 350))); }),
              _NavLink(label: l.t('nav_api')),
              const SizedBox(width: 8),
              _AssistantNavButton(onTap: () => _openAssistant(context)),
              const SizedBox(width: 6),
            ],
            if (screenWidth <= 750) ...[
              _NavLink(label: l.t('nav_bridge'), isActive: activeRoute == 'bridge',
                onTap: () { if (activeRoute != 'bridge') Navigator.push(context, PageRouteBuilder(pageBuilder: (_, a, __) => TwoWayScreen(toggleTheme: toggleTheme, setLocale: setLocale), transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child), transitionDuration: const Duration(milliseconds: 350))); }),
              _MobileEmergencyIcon(isActive: activeRoute == 'emergency',
                onTap: () { if (activeRoute != 'emergency') Navigator.push(context, PageRouteBuilder(pageBuilder: (_, a, __) => EmergencyScreen(toggleTheme: toggleTheme, setLocale: setLocale), transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child), transitionDuration: const Duration(milliseconds: 350))); }),
              _MobileAssistantIcon(onTap: () => _openAssistant(context)),
            ],
            _LanguageDropdown(currentLocale: currentLocale, setLocale: setLocale, l: l, isDark: isDark, primary: primary),
            const SizedBox(width: 4),
            Container(width: 1, height: 20, color: isDark ? Colors.white10 : Colors.black12),
            const SizedBox(width: 4),
            IconButton(
              onPressed: toggleTheme,
              tooltip: isDark ? 'Light Mode' : 'Dark Mode',
              icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined, size: 20, color: isDark ? Colors.white54 : Colors.black45),
            ),
          ]),
        ],
      ),
    );
  }
}

// ── Assistant Nav Button ─────────────────────────────────────────
class _AssistantNavButton extends StatefulWidget {
  final VoidCallback onTap;
  const _AssistantNavButton({required this.onTap});
  @override
  State<_AssistantNavButton> createState() => _AssistantNavButtonState();
}

class _AssistantNavButtonState extends State<_AssistantNavButton> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _pulse;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            AnimatedBuilder(
              animation: _pulse,
              builder: (_, __) => Container(
                width: 7, height: 7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle, color: _kVioletLight,
                  boxShadow: [BoxShadow(color: _kVioletLight.withOpacity(_pulse.value * 0.9), blurRadius: 8, spreadRadius: 1)],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text('ISL Assistant', style: TextStyle(
              color: _hovered ? _kVioletLight : (isDark ? Colors.white54 : Colors.grey[600]),
              fontWeight: _hovered ? FontWeight.w800 : FontWeight.w600,
              fontSize: 12, letterSpacing: 1.0,
            )),
          ]),
        ),
      ),
    );
  }
}

// ── Mobile Assistant Icon ────────────────────────────────────────
class _MobileAssistantIcon extends StatelessWidget {
  final VoidCallback onTap;
  const _MobileAssistantIcon({required this.onTap});

  @override
  Widget build(BuildContext context) => IconButton(
    onPressed: onTap,
    tooltip: 'ISL Assistant',
    style: IconButton.styleFrom(
      backgroundColor: _kViolet.withOpacity(0.12),
      side: BorderSide(color: _kViolet.withOpacity(0.35)),
    ),
    icon: const Icon(Icons.auto_awesome_rounded, color: _kVioletLight, size: 18),
  );
}

// ── Assistant Panel ──────────────────────────────────────────────
class _AssistantPanel extends StatefulWidget {
  final VoidCallback toggleTheme;
  final Function(Locale) setLocale;
  const _AssistantPanel({required this.toggleTheme, required this.setLocale});

  @override
  State<_AssistantPanel> createState() => _AssistantPanelState();
}

class _AssistantPanelState extends State<_AssistantPanel> {
  final TextEditingController _inputCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  String _chatLanguage = 'English';

  static const _systemPrompt = '''
You are Vani Assistant, an expert in Indian Sign Language (ISL).
Help users learn and understand ISL signs.
Keep answers short, simple, and beginner friendly.
When asked how to sign something, describe the hand movement clearly in 1-2 sentences.
Only answer questions related to ISL, sign language, deaf culture, or accessibility.
If asked something unrelated, politely redirect to ISL topics.
Use a warm, friendly tone. Use occasional emojis to feel approachable.
''';

  static const List<String> _suggestions = [
    '👋 How to sign Hello?',
    '🙏 Sign for Thank You',
    'ISL alphabets A-Z',
    '❤️ Sign for Love',
    '🆘 Emergency signs',
    '🇮🇳 Sign for India',
  ];

  static const List<String> _languages = [
    'English', 'Hindi', 'Marathi', 'Tamil', 'Telugu', 'Bengali',
  ];

 @override
void initState() {
  super.initState();
  _messages.add({
    'role': 'bot',
    'text': _getWelcomeMessage('English'),
  });
}

String _getWelcomeMessage(String language) {
  switch (language) {
    case 'Hindi':
      return '👋 नमस्ते! मैं वाणी हूं — आपका ISL मार्गदर्शक।\n\nमुझसे किसी भी शब्द को साइन करने का तरीका पूछें!';
    case 'Marathi':
      return '👋 नमस्कार! मी वाणी आहे — तुमचा ISL मार्गदर्शक.\n\nकोणत्याही शब्दाची साइन कशी करायची ते मला विचारा!';
    case 'Tamil':
      return '👋 வணக்கம்! நான் வாணி — உங்கள் ISL வழிகாட்டி.\n\nஎந்த வார்த்தையையும் எப்படி சைகை செய்வது என்று என்னிடம் கேளுங்கள்!';
    case 'Telugu':
      return '👋 నమస్కారం! నేను వాణి — మీ ISL గైడ్.\n\nఏదైనా పదాన్ని సైన్ చేయడం ఎలాగో నన్ను అడగండి!';
    case 'Bengali':
      return '👋 নমস্কার! আমি বাণী — আপনার ISL গাইড।\n\nযেকোনো শব্দ সাইন করার উপায় আমাকে জিজ্ঞেস করুন!';
    default:
      return '👋 Hi! I\'m Vani — your ISL guide.\n\nAsk me how to sign any word, what a sign means, or how to start learning Indian Sign Language!';
  }
}

  @override
  void dispose() {
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _send(String text) async {
    text = text.trim();
    if (text.isEmpty || _isLoading) return;
    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _isLoading = true;
    });
    _inputCtrl.clear();
    _scrollToBottom();

    final prompt = _chatLanguage == 'English'
        ? '$_systemPrompt\n\nUser: $text'
        : '$_systemPrompt\n\nReply in $_chatLanguage language only.\n\nUser: $text';

    final String? reply = await _callBackend(prompt);

    setState(() {
      _messages.add({
        'role': 'bot',
        'text': reply ?? '⚠️ Could not connect to backend. Make sure your Python server is running on port 8000.',
      });
      _isLoading = false;
    });
    _scrollToBottom();
  }

  Future<String?> _callBackend(String prompt) async {
    try {
      final url = Uri.parse('http://127.0.0.1:8000/api/chat');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'prompt': prompt}),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['reply'];
        if (reply != null && (reply as String).isNotEmpty) return reply;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent,
            duration: const Duration(milliseconds: 350), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark  = Theme.of(context).brightness == Brightness.dark;
    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;
    final panelW  = screenW > 600 ? 420.0 : screenW * 0.92;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: panelW, height: screenH,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF08081A) : const Color(0xFFF8F7FF),
          border: Border(left: BorderSide(color: _kViolet.withOpacity(0.2), width: 1)),
          boxShadow: [BoxShadow(color: _kViolet.withOpacity(0.15), blurRadius: 40, offset: const Offset(-8, 0))],
        ),
        child: Column(children: [
          _buildHeader(isDark),
          _buildSuggestions(isDark),
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (_, i) {
                if (i == _messages.length) return _buildTyping(isDark);
                final msg = _messages[i];
                return _buildBubble(msg['text']!, msg['role'] == 'user', isDark);
              },
            ),
          ),
          _buildInput(isDark),
        ]),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 52, 16, 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D0D22) : Colors.white,
        border: Border(bottom: BorderSide(color: _kViolet.withOpacity(0.12))),
      ),
      child: Column(children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [_kViolet, Color(0xFF5B21B6)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: _kViolet.withOpacity(0.4), blurRadius: 12)],
            ),
            child: const Icon(Icons.sign_language_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Vani ISL Assistant', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15,
                color: isDark ? Colors.white : const Color(0xFF0A0A1F), letterSpacing: 0.2)),
            Row(children: [
              Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF4ADE80), shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Text('Online — Ready to help', style: TextStyle(fontSize: 11, color: isDark ? Colors.white38 : Colors.grey[500])),
            ]),
          ])),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.close_rounded, color: isDark ? Colors.white38 : Colors.grey[400], size: 20),
          ),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Icon(Icons.language_rounded, size: 14, color: isDark ? Colors.white38 : Colors.grey[500]),
          const SizedBox(width: 8),
          Text('Reply in:', style: TextStyle(fontSize: 11, color: isDark ? Colors.white38 : Colors.grey[500])),
          const SizedBox(width: 10),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _languages.map((lang) {
                  final isSelected = _chatLanguage == lang;
                  return GestureDetector(
                    onTap: () => setState(() {
  _chatLanguage = lang;
  _messages.clear();
  _messages.add({
    'role': 'bot',
    'text': _getWelcomeMessage(lang),
  });
}),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.only(right: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? _kViolet.withOpacity(0.2) : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isSelected ? _kViolet.withOpacity(0.6) : _kViolet.withOpacity(0.15)),
                      ),
                      child: Text(lang, style: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? _kVioletLight : (isDark ? Colors.white38 : Colors.grey[500]),
                      )),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ]),
      ]),
    );
  }

  Widget _buildSuggestions(bool isDark) {
    return Container(
      height: 44,
      color: isDark ? const Color(0xFF0A0A1C) : const Color(0xFFF4F2FF),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        itemCount: _suggestions.length,
        itemBuilder: (_, i) => GestureDetector(
          onTap: () => _send(_suggestions[i]),
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: _kViolet.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _kViolet.withOpacity(0.2)),
            ),
            child: Text(_suggestions[i], style: TextStyle(fontSize: 11, color: isDark ? _kVioletLight : _kViolet, fontWeight: FontWeight.w600)),
          ),
        ),
      ),
    );
  }

  Widget _buildBubble(String text, bool isUser, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 30, height: 30,
              decoration: const BoxDecoration(gradient: LinearGradient(colors: [_kViolet, Color(0xFF5B21B6)]), shape: BoxShape.circle),
              child: const Icon(Icons.sign_language_rounded, color: Colors.white, size: 14),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isUser ? _kViolet : (isDark ? const Color(0xFF13132A) : Colors.white),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16), topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4), bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                border: isUser ? null : Border.all(color: isDark ? _kViolet.withOpacity(0.15) : const Color(0xFFE8E0FF)),
                boxShadow: [BoxShadow(color: isUser ? _kViolet.withOpacity(0.3) : Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Text(text, style: TextStyle(fontSize: 13, height: 1.55,
                  color: isUser ? Colors.white : (isDark ? const Color(0xFFE8E0FF) : const Color(0xFF1A1A2E)))),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildTyping(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        Container(
          width: 30, height: 30,
          decoration: const BoxDecoration(gradient: LinearGradient(colors: [_kViolet, Color(0xFF5B21B6)]), shape: BoxShape.circle),
          child: const Icon(Icons.sign_language_rounded, color: Colors.white, size: 14),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF13132A) : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16),
              bottomLeft: Radius.circular(4), bottomRight: Radius.circular(16),
            ),
            border: Border.all(color: isDark ? _kViolet.withOpacity(0.15) : const Color(0xFFE8E0FF)),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: List.generate(3, (i) => _BouncingDot(delay: i * 180))),
        ),
      ]),
    );
  }

  Widget _buildInput(bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D0D22) : Colors.white,
        border: Border(top: BorderSide(color: _kViolet.withOpacity(0.1))),
      ),
      child: Row(children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF111126) : const Color(0xFFF4F2FF),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _kViolet.withOpacity(isDark ? 0.2 : 0.15)),
            ),
            child: TextField(
              controller: _inputCtrl,
              onSubmitted: _send,
              style: TextStyle(fontSize: 13, color: isDark ? Colors.white : const Color(0xFF1A1A2E)),
              decoration: InputDecoration(
                hintText: 'Ask about any ISL sign...',
                hintStyle: TextStyle(color: isDark ? Colors.white24 : Colors.grey[400], fontSize: 13),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () => _send(_inputCtrl.text),
          child: Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [_kViolet, Color(0xFF5B21B6)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: _kViolet.withOpacity(0.45), blurRadius: 12, offset: const Offset(0, 4))],
            ),
            child: _isLoading
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.send_rounded, color: Colors.white, size: 18),
          ),
        ),
      ]),
    );
  }
}

// ── Bouncing Dot ─────────────────────────────────────────────────
class _BouncingDot extends StatefulWidget {
  final int delay;
  const _BouncingDot({required this.delay});
  @override
  State<_BouncingDot> createState() => _BouncingDotState();
}

class _BouncingDotState extends State<_BouncingDot> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _anim = Tween<double>(begin: 0, end: -5).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    Future.delayed(Duration(milliseconds: widget.delay), () { if (mounted) _ctrl.repeat(reverse: true); });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _anim,
    builder: (_, __) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Transform.translate(
        offset: Offset(0, _anim.value),
        child: Container(width: 6, height: 6,
            decoration: BoxDecoration(color: _kVioletLight.withOpacity(0.7), shape: BoxShape.circle)),
      ),
    ),
  );
}

// ── Emergency Nav Link ───────────────────────────────────────────
class _EmergencyNavLink extends StatefulWidget {
  final bool isActive;
  final VoidCallback onTap;
  const _EmergencyNavLink({required this.isActive, required this.onTap});
  @override
  State<_EmergencyNavLink> createState() => _EmergencyNavLinkState();
}

class _EmergencyNavLinkState extends State<_EmergencyNavLink> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.4, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    const crimson = Color(0xFFDC2626);
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: widget.isActive ? crimson.withOpacity(0.18) : crimson.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: widget.isActive ? crimson.withOpacity(0.6) : crimson.withOpacity(0.25), width: widget.isActive ? 1.5 : 1.0),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          AnimatedBuilder(
            animation: _pulse,
            builder: (_, __) => Container(
              width: 6, height: 6,
              decoration: BoxDecoration(shape: BoxShape.circle, color: crimson,
                boxShadow: [BoxShadow(color: crimson.withOpacity(_pulse.value * 0.8), blurRadius: 6, spreadRadius: 1)]),
            ),
          ),
          const SizedBox(width: 7),
          const Text('SOS', style: TextStyle(color: crimson, fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1.5)),
        ]),
      ),
    );
  }
}

// ── Mobile Emergency Icon ────────────────────────────────────────
class _MobileEmergencyIcon extends StatefulWidget {
  final bool isActive;
  final VoidCallback onTap;
  const _MobileEmergencyIcon({required this.isActive, required this.onTap});
  @override
  State<_MobileEmergencyIcon> createState() => _MobileEmergencyIconState();
}

class _MobileEmergencyIconState extends State<_MobileEmergencyIcon> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.3, end: 0.9).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    const crimson = Color(0xFFDC2626);
    return AnimatedBuilder(
      animation: _pulse,
      builder: (_, child) => Container(
        margin: const EdgeInsets.only(right: 4),
        decoration: BoxDecoration(shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: crimson.withOpacity(_pulse.value * 0.4), blurRadius: 10, spreadRadius: 1)]),
        child: child,
      ),
      child: IconButton(
        onPressed: widget.onTap,
        tooltip: AppLocalizations.of(context).t('nav_emergency'),
        style: IconButton.styleFrom(
          backgroundColor: crimson.withOpacity(widget.isActive ? 0.18 : 0.10),
          side: BorderSide(color: crimson.withOpacity(widget.isActive ? 0.6 : 0.3)),
        ),
        icon: const Icon(Icons.emergency_rounded, color: crimson, size: 18),
      ),
    );
  }
}

// ── Language Dropdown ────────────────────────────────────────────
class _LanguageDropdown extends StatelessWidget {
  final Locale currentLocale;
  final Function(Locale) setLocale;
  final AppLocalizations l;
  final bool isDark;
  final Color primary;

  const _LanguageDropdown({
    required this.currentLocale,
    required this.setLocale,
    required this.l,
    required this.isDark,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    final langs = [
      {'code': 'en', 'label': l.t('lang_en'), 'flag': '🇬🇧'},
      {'code': 'hi', 'label': l.t('lang_hi'), 'flag': '🇮🇳'},
      {'code': 'mr', 'label': l.t('lang_mr'), 'flag': '🇮🇳'},
    ];
    final current = langs.firstWhere((lang) => lang['code'] == currentLocale.languageCode, orElse: () => langs[0]);

    return PopupMenuButton<String>(
      tooltip: l.t('nav_language'),
      offset: const Offset(0, 46),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isDark ? const Color(0xFF1A1A3A) : Colors.white,
      elevation: 12,
      onSelected: (code) => setLocale(Locale(code)),
      itemBuilder: (context) => langs.map((lang) {
        final isSelected = lang['code'] == currentLocale.languageCode;
        return PopupMenuItem<String>(
          value: lang['code'],
          child: Row(children: [
            Text(lang['flag']!, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 12),
            Text(lang['label']!, style: TextStyle(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? primary : (isDark ? Colors.white70 : Colors.black87),
                fontSize: 14)),
            if (isSelected) ...[const Spacer(), Icon(Icons.check_rounded, color: primary, size: 16)],
          ]),
        );
      }).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: primary.withOpacity(0.08), borderRadius: BorderRadius.circular(10), border: Border.all(color: primary.withOpacity(0.15))),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(current['flag']!, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Text(current['label']!, style: TextStyle(color: primary, fontWeight: FontWeight.w700, fontSize: 12, letterSpacing: 0.5)),
          const SizedBox(width: 6),
          Icon(Icons.keyboard_arrow_down_rounded, color: primary, size: 16),
        ]),
      ),
    );
  }
}

// ── Nav Link ─────────────────────────────────────────────────────
class _NavLink extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback? onTap;
  const _NavLink({required this.label, this.isActive = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark  = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).primaryColor;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Text(label, style: TextStyle(
          color: isActive ? primary : (isDark ? Colors.white54 : Colors.grey[600]),
          fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
          fontSize: 12, letterSpacing: 1.0,
        )),
      ),
    );
  }
}