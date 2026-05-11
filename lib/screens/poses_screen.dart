import 'package:flutter/material.dart';
import '../theme.dart';
import '../data/yoga_data.dart';
import '../models/yoga_models.dart';
import 'pose_detail_screen.dart';

class PosesScreen extends StatefulWidget {
  const PosesScreen({super.key});

  @override
  State<PosesScreen> createState() => _PosesScreenState();
}

class _PosesScreenState extends State<PosesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Yoga Poses', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 4),
                Text('Explore body & face yoga poses',
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: AppTheme.divider,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: AppTheme.textMuted,
              dividerHeight: 0,
              tabs: const [
                Tab(text: '🧘 Body Yoga'),
                Tab(text: '😊 Face Yoga'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPoseGrid(YogaData.bodyPoses),
                _buildPoseGrid(YogaData.facePoses),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPoseGrid(List<YogaPose> poses) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      itemCount: poses.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final pose = poses[i];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => PoseDetailScreen(pose: pose)),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.divider),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(14)),
                  child: Image.network(
                    pose.imageUrl,
                    width: 100,
                    height: 90,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 100,
                      height: 90,
                      color: AppTheme.divider,
                      child: const Icon(Icons.self_improvement),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(pose.name,
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 2),
                        Text(pose.sanskritName,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 12,
                                )),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            _buildTag(pose.level),
                            const SizedBox(width: 6),
                            _buildTag(pose.category),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(Icons.chevron_right, color: AppTheme.textMuted),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 10, color: AppTheme.primary, fontWeight: FontWeight.w600),
      ),
    );
  }
}
