import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../models/models.dart';
import 'service_detail_screen.dart';
import '../theme.dart';

/// Shows all services within a chosen category.
class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key, required this.category});

  final ServiceCategory category;

  @override
  Widget build(BuildContext context) {
    final items = SampleData.servicesByCategory(category.id);

    return Scaffold(
      appBar: AppBar(title: Text(category.name)),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          itemCount: items.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, i) => _CategoryItem(
            item: items[i],
            color: category.color,
            icon: category.icon,
          ),
        ),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({
    required this.item,
    required this.color,
    required this.icon,
  });

  final ServiceItem item;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ServiceDetailScreen(item: item)),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: AppColors.star,
                        size: 15,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        item.rating.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.body,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${item.durationMinutes} mnt',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              formatIdr(item.price),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
