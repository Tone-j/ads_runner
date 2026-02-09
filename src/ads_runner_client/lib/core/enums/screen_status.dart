import 'package:flutter/material.dart';

enum ScreenStatus {
  online('Online', Color(0xFF10B981)),
  offline('Offline', Color(0xFF64748B)),
  error('Error', Color(0xFFEF4444)),
  maintenance('Maintenance', Color(0xFFF59E0B));

  const ScreenStatus(this.label, this.color);
  final String label;
  final Color color;
}
