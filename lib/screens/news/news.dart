import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personnel_management_flutter/data/news.dart';
import 'package:personnel_management_flutter/screens/news/news_details.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      itemCount: news.length,
      itemBuilder: (ctx, index) {
        final item = news[index];
        final now = DateTime.now();
        final isToday = item.date.year == now.year &&
            item.date.month == now.month &&
            item.date.day == now.day;
        final dateString = isToday
            ? 'Сегодня ${DateFormat('HH:mm').format(item.date)}'
            : DateFormat('d MMMM HH:mm', 'ru').format(item.date);

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => NewsDetailsScreen(news: item),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: Image.asset(
                  item.imageUrl,
                  width: double.infinity,
                  height: 232,
                  fit: BoxFit.cover,
                ),
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
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.2,
                  color: Color(0xFF252525),
                ),
              ),
              SizedBox(height: 8),
              Text(
                dateString,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.3,
                  color: Color(0xFF818181),
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
