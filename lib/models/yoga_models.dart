class YogaPose {
  final String name;
  final String sanskritName;
  final String description;
  final String benefits;
  final String level;
  final String imageUrl;
  final String category;
  final String youtubeId;

  const YogaPose({
    required this.name,
    required this.sanskritName,
    required this.description,
    required this.benefits,
    required this.level,
    required this.imageUrl,
    required this.category,
    required this.youtubeId,
  });
}

class YogaCategory {
  final String title;
  final String subtitle;
  final String icon;
  final List<YogaPose> poses;

  const YogaCategory({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.poses,
  });
}

class YogaVideo {
  final String title;
  final String instructor;
  final String duration;
  final String level;
  final String youtubeId;
  final String thumbnail;
  final String category;

  const YogaVideo({
    required this.title,
    required this.instructor,
    required this.duration,
    required this.level,
    required this.youtubeId,
    required this.thumbnail,
    required this.category,
  });
}
