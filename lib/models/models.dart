import 'package:flutter/material.dart';

/// Static prototype data models for the FixIT customer app.
///
/// This is intentionally local/in-memory. Real data will later come from
/// a Neon (Postgres) backend — wiring is deferred to a later milestone.


class ServiceCategory {
  const ServiceCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  final String id;
  final String name;
  final IconData icon;
  final Color color;
}

class ServiceItem {
  const ServiceItem({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.durationMinutes,
    this.popular = false,
  });

  final String id;
  final String categoryId;
  final String name;
  final String description;
  final int price; // in IDR
  final double rating;
  final int durationMinutes;
  final bool popular;
}

class PaymentMethod {
  const PaymentMethod({
    required this.id,
    required this.name,
    required this.brandColor,
    required this.tag,
  });

  final String id;
  final String name;
  final Color brandColor;
  final String tag; // short label shown inside the pill (e.g. "GO")
}

class TimeSlot {
  const TimeSlot({required this.label, this.enabled = true});

  final String label;
  final bool enabled;
}

/// Worker profile used by the marketplace and assignment logic.
class Worker {
  const Worker({
    required this.id,
    required this.name,
    required this.trade,
    required this.serviceIds,
    required this.areas,
    required this.rating,
    required this.verified,
    required this.certifications,
    required this.priceMultiplier,
  });

  final String id;
  final String name;
  final String trade; // e.g. "AC Technician"
  final List<String> serviceIds; // service item ids this worker commonly performs
  final List<String> areas; // area names covered, e.g. "Depok / Bekasi"
  final double rating;
  final bool verified;
  final List<String> certifications;
  final double priceMultiplier; // 1.0 = base price, >1 premium
}
