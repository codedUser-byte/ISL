// lib/screens/objectives/OfflinePage.dart
import 'package:flutter/material.dart';
import '../../l10n/AppLocalizations.dart';
import 'objective_shared.dart';

class OfflinePage extends StatelessWidget {
  final VoidCallback toggleTheme;
  final Function(Locale) setLocale;
  const OfflinePage({super.key, required this.toggleTheme, required this.setLocale});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l = AppLocalizations.of(context);
    const accent = Color(0xFF6366F1);

    return ObjectivePageBase(
      toggleTheme: toggleTheme,
      setLocale: setLocale,
      accentColor: accent,
      heroIcon: Icons.wifi_off_rounded,
      tag: l.t('off_tag'),
      category: l.t('off_category'),
      title: l.t('off_title'),
      subtitle: l.t('off_subtitle'),
      stats: [
        ObjStatData(value: l.t('off_stat1_val'), label: l.t('off_stat1_label'), description: l.t('off_stat1_desc'), color: kCrimson),
        ObjStatData(value: l.t('off_stat2_val'), label: l.t('off_stat2_label'), description: l.t('off_stat2_desc')),
        ObjStatData(value: l.t('off_stat3_val'), label: l.t('off_stat3_label'), description: l.t('off_stat3_desc'), color: accent),
        ObjStatData(value: l.t('off_stat4_val'), label: l.t('off_stat4_label'), description: l.t('off_stat4_desc')),
      ],
      sections: [
        ObjSection(
          title: l.t('off_s1_title'), isDark: isDark,
          child: Column(children: [
            ObjInfoCard(title: l.t('off_s1_c1_title'), body: l.t('off_s1_c1_body'), icon: Icons.signal_cellular_alt_rounded, accent: accent, isDark: isDark),
            const SizedBox(height: 16),
            ObjInfoCard(title: l.t('off_s1_c2_title'), body: l.t('off_s1_c2_body'), icon: Icons.emergency_rounded, accent: accent, isDark: isDark),
            const SizedBox(height: 16),
            ObjInfoCard(title: l.t('off_s1_c3_title'), body: l.t('off_s1_c3_body'), icon: Icons.school_rounded, accent: accent, isDark: isDark),
          ]),
        ),
        ObjSection(
          title: l.t('off_s2_title'), isDark: isDark,
          child: ObjBarChart(isDark: isDark, data: [
            (l.t('off_bar1'), 0.95, kEmerald),
            (l.t('off_bar2'), 0.78, kEmerald),
            (l.t('off_bar3'), 0.55, kAmber),
            (l.t('off_bar4'), 0.38, kCrimson),
            (l.t('off_bar5'), 0.14, kCrimson),
            (l.t('off_bar6'), 0.62, accent),
          ]),
        ),
        ObjSection(
          title: l.t('off_s3_title'), isDark: isDark,
          child: Column(children: [
            ObjInfoCard(title: l.t('off_s3_c1_title'), body: l.t('off_s3_c1_body'), icon: Icons.install_mobile_rounded, accent: accent, isDark: isDark),
            const SizedBox(height: 16),
            ObjInfoCard(title: l.t('off_s3_c2_title'), body: l.t('off_s3_c2_body'), icon: Icons.battery_saver_rounded, accent: accent, isDark: isDark),
            const SizedBox(height: 16),
            ObjInfoCard(title: l.t('off_s3_c3_title'), body: l.t('off_s3_c3_body'), icon: Icons.phone_android_outlined, accent: accent, isDark: isDark),
            const SizedBox(height: 16),
            ObjQuoteBlock(quote: l.t('off_quote'), source: l.t('off_quote_src'), accent: accent, isDark: isDark),
          ]),
        ),
        ObjSection(
          title: l.t('off_s4_title'), isDark: isDark,
          child: Column(children: [
            ObjTimelineItem(year: l.t('off_t1_year'), event: l.t('off_t1_event'), accent: accent, isDark: isDark),
            ObjTimelineItem(year: l.t('off_t2_year'), event: l.t('off_t2_event'), accent: accent, isDark: isDark),
            ObjTimelineItem(year: l.t('off_t3_year'), event: l.t('off_t3_event'), accent: accent, isDark: isDark),
            ObjTimelineItem(year: l.t('off_t4_year'), event: l.t('off_t4_event'), accent: accent, isDark: isDark, isLast: true),
          ]),
        ),
      ],
    );
  }
}