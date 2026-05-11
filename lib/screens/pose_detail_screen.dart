import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/yoga_models.dart';
import 'video_player_screen.dart';

class PoseDetailScreen extends StatelessWidget {
  final YogaPose pose;
  const PoseDetailScreen({super.key, required this.pose});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                pose.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppTheme.divider,
                  child: const Center(child: Icon(Icons.self_improvement, size: 64)),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pose.name, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 4),
                  Text(pose.sanskritName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                            fontSize: 16,
                          )),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildChip(pose.level),
                      const SizedBox(width: 8),
                      _buildChip(pose.category),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSection(context, 'How to Practice', pose.description),
                  const SizedBox(height: 20),
                  _buildSection(context, 'Benefits', pose.benefits),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VideoPlayerScreen(
                            video: YogaVideo(
                              title: pose.name,
                              instructor: 'Tutorial',
                              duration: '',
                              level: pose.level,
                              youtubeId: pose.youtubeId,
                              thumbnail: pose.imageUrl,
                              category: pose.category,
                            ),
                          ),
                        ),
                      ),
                      icon: const Icon(Icons.play_circle_filled),
                      label: const Text('Watch Tutorial'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text,
          style: const TextStyle(
              color: AppTheme.secondary, fontSize: 13, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6)),
      ],
    );
  }
}
