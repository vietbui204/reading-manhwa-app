import '../../domain/entities/explore_banner.dart';

class ExploreBannerModel extends ExploreBanner {
  ExploreBannerModel({
    required super.id,
    required super.imageUrl,
    super.link,
  });

  factory ExploreBannerModel.fromJson(Map<String, dynamic> json) {
    return ExploreBannerModel(
      id: json['id'],
      imageUrl: json['image_url'],
      link: json['link'],
    );
  }
}
