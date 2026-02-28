//lib/screens/TranslateScreen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import '../components/GlobalNavbar.dart';
import '../l10n/AppLocalizations.dart';

class TranslateScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final Function(Locale) setLocale;
  const TranslateScreen({super.key, required this.toggleTheme, required this.setLocale});

  @override
  State<TranslateScreen> createState() => _TranslateScreenState();
}

class _TranslateScreenState extends State<TranslateScreen> {
  bool isCameraOn = false;
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  int _selectedCameraIndex = 0;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setupCameras();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showInstructions());
  }

  Future<void> _setupCameras() async {
    try {
      _cameras = await availableCameras();
    } catch (e) {
      debugPrint("Camera setup error: $e");
    }
  }

  Future<void> _toggleCamera(bool value) async {
    if (value) {
      if (_cameras != null && _cameras!.isNotEmpty) {
        _controller = CameraController(
          _cameras![_selectedCameraIndex],
          ResolutionPreset.high,
          enableAudio: false,
          imageFormatGroup:
              kIsWeb ? ImageFormatGroup.unknown : ImageFormatGroup.jpeg,
        );
        try {
          await _controller!.initialize();
          if (!mounted) return;
          setState(() => isCameraOn = true);
        } catch (e) {
          debugPrint("Camera init error: $e");
        }
      }
    } else {
      await _controller?.dispose();
      if (!mounted) return;
      setState(() {
        isCameraOn = false;
        _controller = null;
      });
    }
  }

  void _switchCamera() async {
    if (_cameras == null || _cameras!.length < 2) return;
    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras!.length;
    if (isCameraOn) {
      await _toggleCamera(false);
      await _toggleCamera(true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _showInstructions() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const _InstructionDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isWeb = MediaQuery.of(context).size.width > 900;
    final primary = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF06060F) : const Color(0xFFF4F6FD),
      body: Stack(
        children: [
          Positioned(
            top: -100,
            left: -100,
            child: _BlurGlow(color: primary.withOpacity(isDark ? 0.14 : 0.08), size: 450),
          ),
          Positioned(
            bottom: -150,
            right: -60,
            child: _BlurGlow(
                color: const Color(0xFF3B82F6).withOpacity(isDark ? 0.10 : 0.06),
                size: 420),
          ),
          SafeArea(
            child: Column(
              children: [
                GlobalNavbar(
                  toggleTheme: widget.toggleTheme,
                  setLocale: widget.setLocale,
                  activeRoute: 'translate',
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    child: isWeb
                        ? _buildWebLayout(isDark, primary)
                        : _buildMobileLayout(isDark, primary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebLayout(bool isDark, Color primary) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 7, child: _videoCaptureSection(isDark, primary)),
        const SizedBox(width: 28),
        Expanded(
          flex: 4,
          child: Column(
            children: [
              _currentDetectionSection(isDark, primary),
              const SizedBox(height: 22),
              _translationPanel(isDark, primary),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(bool isDark, Color primary) {
    return Column(
      children: [
        _videoCaptureSection(isDark, primary),
        const SizedBox(height: 20),
        _currentDetectionSection(isDark, primary),
        const SizedBox(height: 20),
        _translationPanel(isDark, primary),
      ],
    );
  }

  Widget _videoCaptureSection(bool isDark, Color primary) {
    final l = AppLocalizations.of(context);
    return _GlassContainer(
      isDark: isDark,
      primary: primary,
      child: Column(
        children: [
          _buildSectionHeader(
            isDark: isDark,
            primary: primary,
            icon: Icons.sensors_rounded,
            title: l.t('translate_vision_title'),
            subtitle: l.t('translate_vision_sub'),
          ),
          const SizedBox(height: 18),
          Container(
            height: 440,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.04)),
              boxShadow: [
                BoxShadow(
                    color: primary.withOpacity(0.15),
                    blurRadius: 40,
                    spreadRadius: -10)
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Center(
                    child: isCameraOn &&
                            _controller != null &&
                            _controller!.value.isInitialized
                        ? CameraPreview(_controller!)
                        : _buildCameraPlaceholder(isDark, primary),
                  ),
                  if (isCameraOn)
                    Positioned(top: 18, right: 18, child: _buildLiveBadge()),
                  if (isCameraOn)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildOutlineButton(
                onPressed: _switchCamera,
                icon: Icons.flip_camera_android_rounded,
                label: l.t('translate_switch'),
                primary: primary,
              ),
              const SizedBox(width: 18),
              _buildCameraToggle(isDark, primary, l),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPlaceholder(bool isDark, Color primary) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.04),
            border: Border.all(color: Colors.white.withOpacity(0.06)),
          ),
          child: Icon(Icons.videocam_off_rounded,
              color: Colors.white.withOpacity(0.2), size: 56),
        ),
        const SizedBox(height: 18),
        Text(
          "Camera Stream Offline",
          style: TextStyle(
              color: Colors.white.withOpacity(0.3), fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildLiveBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFEF4444),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFFEF4444).withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, color: Colors.white, size: 7),
          SizedBox(width: 7),
          Text("LIVE",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                  letterSpacing: 1.5)),
        ],
      ),
    );
  }

  Widget _currentDetectionSection(bool isDark, Color primary) {
    final l = AppLocalizations.of(context);
    return _GlassContainer(
      isDark: isDark,
      primary: primary,
      gradient: LinearGradient(
          colors: [primary.withOpacity(0.08), Colors.transparent]),
      child: Column(
        children: [
          Text(
            l.t('translate_prediction'),
            style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white38 : Colors.grey,
                letterSpacing: 1.8),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 22),
            decoration: BoxDecoration(
              color: isDark ? Colors.black26 : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: primary.withOpacity(0.12)),
            ),
            child: Center(
              child: Text(
                l.t('translate_waiting'),
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: primary,
                    letterSpacing: -0.5),
              ),
            ),
          ),
          const SizedBox(height: 14),
          // Confidence bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Confidence",
                      style: TextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.white38 : Colors.grey,
                          fontWeight: FontWeight.w600)),
                  Text("—",
                      style: TextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.white38 : Colors.grey)),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: 0,
                  minHeight: 4,
                  backgroundColor: isDark ? Colors.white10 : Colors.black.withOpacity(0.08),
                  valueColor: AlwaysStoppedAnimation<Color>(primary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _translationPanel(bool isDark, Color primary) {
    final l = AppLocalizations.of(context);
    return _GlassContainer(
      isDark: isDark,
      primary: primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.t('translate_transcription'),
            style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white38 : Colors.grey,
                letterSpacing: 1.8),
          ),
          const SizedBox(height: 14),
          Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.black26 : const Color(0xFFF4F6FD),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.05)),
            ),
            child: TextField(
              controller: _textController,
              maxLines: 4,
              style: TextStyle(
                  fontSize: 15,
                  color: isDark ? Colors.white : Colors.black87,
                  height: 1.6),
              decoration: InputDecoration(
                hintText: l.t('translate_hint'),
                hintStyle: TextStyle(
                    color: isDark ? Colors.white24 : Colors.grey[400],
                    fontSize: 14),
                contentPadding: const EdgeInsets.all(18),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _buildGradientButton(l.t('translate_start'), Icons.play_arrow_rounded, primary),
              ),
              const SizedBox(width: 12),
              _buildIconAction(Icons.copy_outlined, primary.withOpacity(0.8),
                  () => {}),
              const SizedBox(width: 10),
              _buildIconAction(Icons.delete_outline_rounded,
                  const Color(0xFFEF4444), () => _textController.clear()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required bool isDark,
    required Color primary,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: primary, size: 20),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: isDark ? Colors.white : const Color(0xFF0A0A1F),
                    letterSpacing: 0.2)),
            Text(subtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildGradientButton(String label, IconData icon, Color primary) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [primary, const Color(0xFF4F46E5)]),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: primary.withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 6))
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(icon, color: Colors.white, size: 18),
        label: Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w700, color: Colors.white, fontSize: 14)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  Widget _buildOutlineButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color primary,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
      style: OutlinedButton.styleFrom(
        foregroundColor: primary,
        side: BorderSide(color: primary.withOpacity(0.5), width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildCameraToggle(bool isDark, Color primary, AppLocalizations l) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isCameraOn
            ? primary.withOpacity(0.1)
            : Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCameraOn
              ? primary.withOpacity(0.25)
              : Colors.white.withOpacity(0.06),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isCameraOn ? l.t('translate_cam_on') : l.t('translate_cam_off'),
            style: TextStyle(
                fontWeight: FontWeight.w900,
                color: isCameraOn ? primary : Colors.grey,
                fontSize: 12,
                letterSpacing: 0.5),
          ),
          Switch.adaptive(
            value: isCameraOn,
            activeColor: primary,
            onChanged: _toggleCamera,
          ),
        ],
      ),
    );
  }

  Widget _buildIconAction(IconData icon, Color color, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: color, size: 18),
        padding: const EdgeInsets.all(14),
      ),
    );
  }
}

// --- Shared Widgets ---

class _BlurGlow extends StatelessWidget {
  final Color color;
  final double size;
  const _BlurGlow({required this.color, this.size = 400});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 110, sigmaY: 110),
        child: Container(color: Colors.transparent),
      ),
    );
  }
}

class _GlassContainer extends StatelessWidget {
  final Widget child;
  final bool isDark;
  final Color primary;
  final Gradient? gradient;

  const _GlassContainer({
    required this.child,
    required this.isDark,
    required this.primary,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.04)
                : Colors.white.withOpacity(0.65),
            borderRadius: BorderRadius.circular(28),
            gradient: gradient,
            border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.07)
                    : Colors.white.withOpacity(0.5),
                width: 1.5),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.25 : 0.02),
                  blurRadius: 24)
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _InstructionDialog extends StatelessWidget {
  const _InstructionDialog();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).primaryColor;
    final l = AppLocalizations.of(context);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: AlertDialog(
        backgroundColor:
            isDark ? const Color(0xFF0D0D1F) : Colors.white.withOpacity(0.95),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        contentPadding: const EdgeInsets.fromLTRB(28, 0, 28, 24),
        titlePadding: const EdgeInsets.fromLTRB(28, 28, 28, 20),
        title: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.sign_language_rounded, color: primary, size: 36),
            ),
            const SizedBox(height: 16),
            Text(
              l.t('dialog_title'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 18,
                letterSpacing: 1.0,
                color: isDark ? Colors.white : const Color(0xFF0A0A1F),
              ),
            ),
          ],
        ),
        content: Text(
          l.t('dialog_body'),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isDark ? Colors.white54 : Colors.grey[600],
            fontSize: 14,
            height: 1.6,
          ),
        ),
        actions: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [primary, const Color(0xFF4F46E5)]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Text(
                    l.t('dialog_btn'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}