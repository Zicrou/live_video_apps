enum ContentType { live, video }

class FeedItem {
  ContentType type;
  String? channelName; // for live
  String? videoUrl; // for recorded video
  int? hostUserId;
  String? title;
  String? status; // live / ended
  String? liveToken;

  FeedItem({
    required this.type,
    this.channelName,
    this.videoUrl,
    this.hostUserId,
    this.title,
    this.status,
    this.liveToken,
  });

  factory FeedItem.fromJson(Map<String, dynamic> json) {
    return FeedItem(
      type: json['type'] == 'live' ? ContentType.live : ContentType.video,
      channelName: json['channel_name'],
      videoUrl: json['video_url'],
      hostUserId: json['host_user_id'],
      title: json['title'],
      status: json['status'],
      liveToken: json['liveToken'],
    );
  }
}
