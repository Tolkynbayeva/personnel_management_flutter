import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personnel_management_flutter/models/news_item.dart';

class NewsDetailsScreen extends StatelessWidget {
  final News news;
  const NewsDetailsScreen({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isToday = news.date.year == now.year &&
        news.date.month == now.month &&
        news.date.day == now.day;
    final dateString = isToday
        ? 'Сегодня ${DateFormat('HH:mm').format(news.date)}'
        : DateFormat('d MMMM HH:mm', 'ru').format(news.date);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 411,
                  width: double.infinity,
                  child: Image.asset(
                    news.imageUrlLarge ?? news.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  left: 16,
                  top: 16,
                  child: SafeArea(
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            ),
            Transform.translate(
              offset: const Offset(0, -36),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
                decoration: const BoxDecoration(
                  color: Color(0xFFF2F5F7),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      news.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        height: 1.1,
                        color: Color(0xFF252525),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      dateString,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: Color(0xFF818181),
                      ),
                    ),
                    const SizedBox(height: 34),
                    Text(
                      news.description,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.4,
                        color: Color(0xFF252525),
                      ),
                    ),
                    const SizedBox(height: 34),
                    if (news.sections != null)
                      for (final section in news.sections!) ...[
                        Text(
                          section.heading,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            height: 1.1,
                            color: Color(0xFF252525),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          section.content,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.4,
                            color: Color(0xFF252525),
                          ),
                        ),
                        const SizedBox(height: 34),
                      ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
