// lib/screens/objectives/EducationPage.dart
import 'package:flutter/material.dart';
import 'objective_shared.dart';

class EducationPage extends StatelessWidget {
  final VoidCallback toggleTheme;
  final Function(Locale) setLocale;
  const EducationPage({
    super.key, required this.toggleTheme, required this.setLocale,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const accent = Color(0xFFDC2626);

    return ObjectivePageBase(
      toggleTheme: toggleTheme,
      setLocale: setLocale,
      accentColor: accent,
      heroIcon: Icons.school_rounded,
      tag: '06',
      category: 'EDUCATION',
      title: 'Learn ISL\nThrough Real-Time\nAI Feedback',
      subtitle:
          'With fewer than 1% of deaf children reaching college, India\'s DHH education crisis demands a new model. Vani turns every phone into an ISL learning tool — with instant feedback, no teacher required.',
      stats: const [
        ObjStatData(value: '<1%', label: 'DHH Reaching College',
            description: 'In entire India', color: kCrimson),
        ObjStatData(value: '5%', label: 'DHH Children in School',
            description: 'Of any type — a catastrophic gap', color: kCrimson),
        ObjStatData(value: '387', label: 'Deaf Schools in India',
            description: 'For 63 million — critically insufficient', color: kAmber),
        ObjStatData(value: '16K', label: 'Training Samples',
            description: 'Vani model trained dataset size', color: accent),
      ],
      sections: [
        ObjSection(
          title: 'India\'s DHH Education Crisis',
          isDark: isDark,
          child: Column(
            children: [
              ObjInfoCard(
                title: 'Only 5% of Deaf Children Are in School',
                body:
                    'The 2017 ForumIAS analysis found that only 5% of deaf children in India are enrolled in any form of school. With 19%+ out-of-school as per a 2014 government survey, and a near-total absence in higher education — the compounding disadvantage over a lifetime is severe.',
                icon: Icons.child_care_rounded,
                accent: accent, isDark: isDark,
              ),
              const SizedBox(height: 16),
              ObjInfoCard(
                title: 'The Oralism Trap',
                body:
                    'India\'s deaf schools predominantly use oralism — teaching children to speak and lip-read rather than sign. This approach denies deaf children their natural language (ISL), slows learning, and results in lower literacy rates compared to bilingual (sign + written) education models validated globally.',
                icon: Icons.mic_off_rounded,
                accent: accent, isDark: isDark,
              ),
              const SizedBox(height: 16),
              ObjInfoCard(
                title: 'Teacher Shortage is Acute',
                body:
                    'India does not have enough ISL-trained teachers for its 387 deaf schools, let alone for the inclusion in mainstream schools mandated by RPwD 2016. ISLRTC was established in 2015 to address this, but the training pipeline is decades behind the need.',
                icon: Icons.person_search_rounded,
                accent: accent, isDark: isDark,
              ),
            ],
          ),
        ),
        ObjSection(
          title: 'Education Outcome Data',
          isDark: isDark,
          child: ObjBarChart(
            isDark: isDark,
            data: [
              ('DHH below secondary education level', 0.67, kCrimson),
              ('DHH with speech disability below secondary', 0.67, kCrimson),
              ('Rural DHH children receiving no education', 0.70, kCrimson),
              ('DHH reaching higher secondary', 0.22, kAmber),
              ('DHH reaching college or above', 0.01, kCrimson),
            ],
          ),
        ),
        ObjSection(
          title: 'Vani as an Educational Tool',
          isDark: isDark,
          child: Column(
            children: [
              ObjInfoCard(
                title: 'Real-Time Sign Feedback for Learners',
                body:
                    'A hearing student learning ISL can sign in front of Vani\'s camera and instantly see whether their gesture was recognised correctly. This closed-loop feedback replaces the need for a constant teacher presence — making self-paced ISL learning possible for the first time.',
                icon: Icons.loop_rounded,
                accent: accent, isDark: isDark,
              ),
              const SizedBox(height: 16),
              ObjInfoCard(
                title: 'Classroom Communication Aid',
                body:
                    'A DHH student in a mainstream school can use Vani to express complex thoughts to a hearing teacher without writing. A hearing teacher learning to include DHH students can use Vani to confirm whether they understood a student\'s signs — democratising inclusion without full interpreter presence.',
                icon: Icons.class_outlined,
                accent: accent, isDark: isDark,
              ),
              const SizedBox(height: 16),
              ObjInfoCard(
                title: 'Vocabulary Builder via Repetition Recognition',
                body:
                    'Vani logs which signs were correctly recognised in a session (locally, never uploaded). Users can review their accuracy on specific signs — effectively practicing ISL vocabulary with AI-scored feedback. This gamified loop is proven in language acquisition research to accelerate retention.',
                icon: Icons.auto_stories_rounded,
                accent: accent, isDark: isDark,
              ),
              const SizedBox(height: 24),
              ObjQuoteBlock(
                quote:
                    'We cannot say with confidence that even 10% of deaf children are in schools of any type. We cannot say 5% get a high school education. The number in college could be below a quarter of one percent.',
                source: 'REHABILITATION COUNCIL OF INDIA — DISABILITY IDENTITY REPORT',
                accent: accent, isDark: isDark,
              ),
            ],
          ),
        ),
        ObjSection(
          title: 'Policy & Educational Milestones',
          isDark: isDark,
          child: Column(
            children: [
              ObjTimelineItem(year: '1964', isDark: isDark, accent: accent,
                  event: 'Kothari Commission — Shifted disability education from "humanitarian to utilitarian" framing'),
              ObjTimelineItem(year: '2001', isDark: isDark, accent: accent,
                  event: 'First formal ISL classes in India — No structured ISL teaching existed before this year'),
              ObjTimelineItem(year: '2009', isDark: isDark, accent: accent,
                  event: 'RTE Act — Right to free and compulsory education for every disabled child mandated'),
              ObjTimelineItem(year: '2015', isDark: isDark, accent: accent,
                  event: 'ISLRTC established — 5-year plan to train ISL teachers and develop curriculum materials'),
              ObjTimelineItem(year: '2020', isDark: isDark, accent: accent,
                  event: 'NEP 2020 — Recommends ISL teaching nationwide; recognises DHH children\'s right to sign-based education'),
              ObjTimelineItem(year: '2025', isDark: isDark, accent: accent,
                  event: 'Vani v1.0 — First accessible AI-powered ISL learning feedback tool available to every Indian smartphone user', isLast: true),
            ],
          ),
        ),
      ],
    );
  }
}