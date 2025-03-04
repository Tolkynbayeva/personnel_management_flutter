import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personnel_management_flutter/data/news.dart';

String formatNewsDate(DateTime date, int index) {
  if (index == 0) {
    return 'Сегодня ${DateFormat('HH:mm').format(date)}';
  }
  return DateFormat('d MMMM HH:mm', 'ru').format(date);
}

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      itemCount: news.length,
      itemBuilder: (ctx, index) {
        final item = news[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              item.imageUrl,
              width: 358,
              height: 232,
            ),
            SizedBox(height: 8),
            Text(
              item.title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                height: 1.1,
                color: Color(0xFF252525),
              ),
            ),
            SizedBox(height: 8),
            Text(
              item.description,
              style: TextStyle(
                fontSize: 13,
                height: 1.2,
                color: Color(0xFF252525),
              ),
            ),
            SizedBox(height: 8),
            Text(
              formatNewsDate(item.date, index),
              style: TextStyle(
                fontSize: 12,
                height: 1.3,
                color: Color(0xFF818181),
              ),
            ),
            SizedBox(height: 24),
          ],
        );
      },
    );
  }
}
