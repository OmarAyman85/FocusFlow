class AttachmentEntity {
  final String name;
  final String url;
  final String type;
  final String uploadedBy;
  final DateTime uploadedAt;

  const AttachmentEntity({
    required this.name,
    required this.url,
    required this.type,
    required this.uploadedBy,
    required this.uploadedAt,
  });
}
