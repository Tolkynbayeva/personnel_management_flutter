import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:personnel_management_flutter/widgets/custom_calendar_dialog.dart';

class FilterButton extends StatelessWidget {
  final ValueChanged<DateTime> onDatePicked;

  const FilterButton({
    super.key,
    required this.onDatePicked,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final selected = await showDialog<DateTime>(
          context: context,
          builder: (_) => CustomCalendarDialog(),
        );
        if (selected != null) {
          onDatePicked(selected);
        }
      },
      child: Container(
        height: 30,
        margin: EdgeInsets.only(right: 16),
        padding: EdgeInsets.symmetric(vertical: 7, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            end: Alignment(4, 0),
            colors: [
              const Color(0xFF2253F6),
              const Color(0xFF9DB4FF),
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/svg/filter-icon.svg'),
            SizedBox(width: 4),
            Text(
              'Фильтры',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: Color(0xFFF2F5F7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
