import 'package:flutter/material.dart';
import '../theme.dart';
import '../data/yoga_data.dart';

class BenefitsScreen extends StatelessWidget {
  const BenefitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Why Yoga?', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 4),
            Text('Discover the transformative benefits',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            _buildIntroCard(context),
            const SizedBox(height: 24),
            ...YogaData.benefits.map((b) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _buildBenefitCard(context, b),
                )),
            const SizedBox(height: 16),
            _buildFaceYogaSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primary.withValues(alpha: 0.1), AppTheme.secondary.withValues(alpha: 0.08)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        children: [
          const Text('🕉️', style: TextStyle(fontSize: 36)),
          const SizedBox(height: 12),
          Text(
            'Yoga is a 5,000-year-old practice that unites body, mind, and spirit through physical postures, breathing techniques, and meditation.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitCard(BuildContext context, Map<String, String> benefit) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(benefit['icon']!, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(benefit['title']!,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(benefit['description']!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaceYogaSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accent.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('😊', style: TextStyle(fontSize: 28)),
              const SizedBox(width: 10),
              Text('Face Yoga Benefits', style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
          const SizedBox(height: 14),
          ...[
            'Natural facelift without surgery or injections',
            'Reduces wrinkles and fine lines',
            'Improves blood circulation to the face',
            'Tones and firms facial muscles',
            'Relieves tension in jaw and forehead',
            'Promotes a youthful, glowing complexion',
          ].map((t) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(color: AppTheme.accent, fontSize: 16)),
                    Expanded(
                      child: Text(t,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.4)),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
