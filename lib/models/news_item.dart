class News {
  final String id;
  final String imageUrl;
  final String? imageUrlLarge;
  final String title;
  final String description;
  final DateTime date;
  final List<NewsSection>? sections;

  const News({
    required this.id,
    required this.imageUrl,
    this.imageUrlLarge,
    required this.title,
    required this.description,
    required this.date,
    this.sections,
  });
}

class NewsSection {
  final String heading;
  final String content;

  const NewsSection({
    required this.heading,
    required this.content,
  });
}
