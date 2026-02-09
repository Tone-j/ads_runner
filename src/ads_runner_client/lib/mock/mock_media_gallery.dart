import '../domain/entities/media_asset.dart';

class MockMediaGallery {
  static final List<MediaAsset> banners = [
    MediaAsset(
      id: 'mock_banner_001',
      fileName: 'summer_promo_banner.jpg',
      fileUrl: 'https://picsum.photos/seed/banner1/1920/1080',
      fileType: 'image/jpeg',
      fileSize: 2450000,
      uploadedAt: DateTime.now(),
      thumbnailUrl: 'https://picsum.photos/seed/banner1/480/270',
    ),
    MediaAsset(
      id: 'mock_banner_002',
      fileName: 'tech_launch_banner.jpg',
      fileUrl: 'https://picsum.photos/seed/banner2/1920/1080',
      fileType: 'image/jpeg',
      fileSize: 1980000,
      uploadedAt: DateTime.now(),
      thumbnailUrl: 'https://picsum.photos/seed/banner2/480/270',
    ),
    MediaAsset(
      id: 'mock_banner_003',
      fileName: 'fashion_week_banner.jpg',
      fileUrl: 'https://picsum.photos/seed/banner3/1920/1080',
      fileType: 'image/jpeg',
      fileSize: 3100000,
      uploadedAt: DateTime.now(),
      thumbnailUrl: 'https://picsum.photos/seed/banner3/480/270',
    ),
    MediaAsset(
      id: 'mock_banner_004',
      fileName: 'restaurant_opening_banner.jpg',
      fileUrl: 'https://picsum.photos/seed/banner4/1920/1080',
      fileType: 'image/jpeg',
      fileSize: 2700000,
      uploadedAt: DateTime.now(),
      thumbnailUrl: 'https://picsum.photos/seed/banner4/480/270',
    ),
  ];

  static final List<MediaAsset> videos = [
    MediaAsset(
      id: 'mock_video_001',
      fileName: 'promo_video_30s.mp4',
      fileUrl: 'https://example.com/mock_video_1.mp4',
      fileType: 'video/mp4',
      fileSize: 15000000,
      uploadedAt: DateTime.now(),
      thumbnailUrl: 'https://picsum.photos/seed/video1/1920/1080',
    ),
    MediaAsset(
      id: 'mock_video_002',
      fileName: 'brand_story_15s.mp4',
      fileUrl: 'https://example.com/mock_video_2.mp4',
      fileType: 'video/mp4',
      fileSize: 8500000,
      uploadedAt: DateTime.now(),
      thumbnailUrl: 'https://picsum.photos/seed/video2/1920/1080',
    ),
    MediaAsset(
      id: 'mock_video_003',
      fileName: 'product_showcase_45s.mp4',
      fileUrl: 'https://example.com/mock_video_3.mp4',
      fileType: 'video/mp4',
      fileSize: 22000000,
      uploadedAt: DateTime.now(),
      thumbnailUrl: 'https://picsum.photos/seed/video3/1920/1080',
    ),
  ];
}
