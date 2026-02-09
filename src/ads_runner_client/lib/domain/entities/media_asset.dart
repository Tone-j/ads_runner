import 'package:equatable/equatable.dart';

class MediaAsset extends Equatable {
  final String id;
  final String fileName;
  final String fileUrl;
  final String fileType;
  final int fileSize;
  final DateTime uploadedAt;
  final String? thumbnailUrl;

  const MediaAsset({
    required this.id,
    required this.fileName,
    required this.fileUrl,
    required this.fileType,
    required this.fileSize,
    required this.uploadedAt,
    this.thumbnailUrl,
  });

  @override
  List<Object?> get props => [id, fileName, fileUrl];
}
