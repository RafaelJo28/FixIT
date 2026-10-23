import 'package:flutter/material.dart';

import '../theme.dart';

/// PLACEHOLDER commission rate. The real rate is a business decision and will
/// be set on the server, not in the app.
const double kCommissionRate = 0.15;

enum JobStatus { newRequest, accepted, onTheWay, inProgress, completed }

extension JobStatusX on JobStatus {
  String get label => switch (this) {
    JobStatus.newRequest => 'Permintaan baru',
    JobStatus.accepted => 'Diterima',
    JobStatus.onTheWay => 'Dalam perjalanan',
    JobStatus.inProgress => 'Sedang dikerjakan',
    JobStatus.completed => 'Selesai',
  };

  Color get color => switch (this) {
    JobStatus.newRequest => const Color(0xFFB45309),
    JobStatus.accepted => AppColors.blue,
    JobStatus.onTheWay => const Color(0xFF7C3AED),
    JobStatus.inProgress => const Color(0xFF0369A1),
    JobStatus.completed => AppColors.success,
  };

  /// Label of the button that moves the job to the next status.
  String? get actionLabel => switch (this) {
    JobStatus.accepted => 'Mulai perjalanan',
    JobStatus.onTheWay => 'Mulai pekerjaan',
    JobStatus.inProgress => 'Selesaikan pekerjaan',
    _ => null,
  };

  bool get isActive =>
      this == JobStatus.accepted ||
      this == JobStatus.onTheWay ||
      this == JobStatus.inProgress;

  /// Position in the 4-step progress bar (-1 = not started).
  int get step => switch (this) {
    JobStatus.newRequest => -1,
    JobStatus.accepted => 0,
    JobStatus.onTheWay => 1,
    JobStatus.inProgress => 2,
    JobStatus.completed => 3,
  };
}

class Job {
  Job({
    required this.id,
    required this.serviceName,
    required this.categoryLabel,
    required this.icon,
    required this.color,
    required this.customerName,
    required this.area,
    required this.fullAddress,
    required this.distanceKm,
    required this.schedule,
    required this.price,
    required this.note,
    required this.status,
  });

  final String id;
  final String serviceName;
  final String categoryLabel;
  final IconData icon;
  final Color color;
  final String customerName;
  final String area;
  final String fullAddress;
  final double distanceKm;
  final String schedule;
  final int price;
  final String note;
  JobStatus status;

  int get commission => (price * kCommissionRate).round();
  int get net => price - commission;
}

/// Positive amount = income, negative amount = withdrawal.
class EarningEntry {
  const EarningEntry({
    required this.title,
    required this.date,
    required this.amount,
  });

  final String title;
  final String date;
  final int amount;
}
