import 'package:flutter/material.dart';

enum CampaignStatus {
  draft('Draft', Color(0xFF94A3B8)),
  active('Active', Color(0xFF10B981)),
  paused('Paused', Color(0xFFF59E0B)),
  completed('Completed', Color(0xFF3B82F6)),
  archived('Archived', Color(0xFF64748B));

  const CampaignStatus(this.label, this.color);
  final String label;
  final Color color;
}
