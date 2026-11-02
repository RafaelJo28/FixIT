import 'package:flutter/material.dart';

import '../data/specialties.dart';
import '../models/worker_profile.dart';
import '../theme.dart';
import 'common.dart';

const _avatarColors = [
  AppColors.blue,
  Color(0xFF0369A1),
  Color(0xFF4F46E5),
  Color(0xFF0891B2),
  Color(0xFF7C3AED),
  AppColors.success,
];

Color avatarColorFor(String key) {
  final sum = key.codeUnits.fold<int>(0, (a, b) => a + b);
  return _avatarColors[sum % _avatarColors.length];
}

/// Circle with the worker's initials (real photos come later).
class WorkerAvatar extends StatelessWidget {
  const WorkerAvatar({super.key, required this.name, this.size = 48});

  final String name;
  final double size;

  @override
  Widget build(BuildContext context) {
    final words = name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
    final initials = words.take(2).map((w) => w[0].toUpperCase()).join();
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: avatarColorFor(name),
      ),
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontSize: size * 0.38,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

/// Five stars, filled according to [rating] (0-5, halves supported).
class StarRating extends StatelessWidget {
  const StarRating({super.key, required this.rating, this.size = 16});

  final double rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 1; i <= 5; i++)
          if (rating >= i - 0.25)
            Icon(Icons.star_rounded, size: size, color: AppColors.star)
          else if (rating >= i - 0.75)
            Icon(Icons.star_half_rounded, size: size, color: AppColors.star)
          else
            Icon(Icons.star_rounded, size: size, color: AppColors.line),
      ],
    );
  }
}

/// "4.8 (126)" with a star, or "Belum ada ulasan".
class RatingLabel extends StatelessWidget {
  const RatingLabel({super.key, required this.rating, required this.count});

  final double rating;
  final int count;

  @override
  Widget build(BuildContext context) {
    if (count == 0) {
      return const Text(
        'Belum ada ulasan',
        style: TextStyle(fontSize: 12.5, color: AppColors.muted),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star_rounded, size: 16, color: AppColors.star),
        const SizedBox(width: 2),
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
        ),
        Text(
          ' ($count)',
          style: const TextStyle(fontSize: 12.5, color: AppColors.muted),
        ),
      ],
    );
  }
}

/// Selectable chip used for specialties, areas and gender.
class SelectChip extends StatelessWidget {
  const SelectChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      backgroundColor: Colors.white,
      selectedColor: AppColors.blue.withValues(alpha: 0.14),
      checkmarkColor: AppColors.blue,
      side: BorderSide(color: selected ? AppColors.blue : AppColors.line),
      labelStyle: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: selected ? AppColors.blue : AppColors.body,
      ),
    );
  }
}

/// Read-only tinted pill (specialty or area on a profile).
class InfoPill extends StatelessWidget {
  const InfoPill({super.key, required this.label, this.icon});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.blue.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: AppColors.blue),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.blue,
            ),
          ),
        ],
      ),
    );
  }
}

/// Mock thumbnail for a portfolio photo or video.
class PortfolioTile extends StatelessWidget {
  const PortfolioTile({
    super.key,
    required this.item,
    this.onTap,
    this.onDelete,
  });

  final PortfolioItem item;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final spec = specialtyById(item.specialtyId);
    final dark = Color.lerp(
      spec.color,
      Colors.black,
      0.18 + 0.08 * item.shade,
    )!;

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [spec.color, dark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Center(
              child: Icon(
                item.isVideo ? Icons.play_circle_fill_rounded : spec.icon,
                color: Colors.white.withValues(alpha: 0.9),
                size: item.isVideo ? 38 : 32,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(8, 14, 8, 7),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.55),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Text(
                  item.caption,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10.5,
                    height: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            if (item.isVideo)
              Positioned(
                left: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.durationLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            if (onTap != null)
              Positioned(
                left: 4,
                top: 4,
                child: Material(
                  color: Colors.black.withValues(alpha: 0.45),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onTap,
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.edit_outlined,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            if (onDelete != null)
              Positioned(
                right: 4,
                top: 4,
                child: Material(
                  color: Colors.black.withValues(alpha: 0.45),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onDelete,
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.close_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Seven rows: day name and opening hours. Today is highlighted.
class WorkHoursList extends StatelessWidget {
  const WorkHoursList({super.key, required this.hours});

  final List<DayHours> hours;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now().weekday - 1;
    return Column(
      children: [
        for (var i = 0; i < hours.length; i++)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: i == today
                  ? AppColors.blue.withValues(alpha: 0.08)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    kDayNames[i],
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: i == today
                          ? FontWeight.w800
                          : FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  hours[i].label,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: i == today ? FontWeight.w800 : FontWeight.w600,
                    color: hours[i].isOpen ? AppColors.ink : AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// One customer review (stars, name, date, comment).
class ReviewTile extends StatelessWidget {
  const ReviewTile({super.key, required this.review});

  final Review review;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: cardDecoration(radius: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              WorkerAvatar(name: review.customerName, size: 32),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.customerName,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      review.dateLabel,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              StarRating(rating: review.rating.toDouble(), size: 15),
            ],
          ),
          if (review.comment.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              review.comment,
              style: const TextStyle(
                fontSize: 13,
                height: 1.4,
                color: AppColors.body,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
