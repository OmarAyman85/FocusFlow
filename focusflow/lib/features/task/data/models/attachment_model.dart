import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/attachment_entity.dart';

class AttachmentModel extends AttachmentEntity {
  const AttachmentModel({
    required super.name,
    required super.url,
    required super.type,
    required super.uploadedBy,
    required super.uploadedAt,
  });

  factory AttachmentModel.fromMap(Map<String, dynamic> map) {
    return AttachmentModel(
      name: map['name'] ?? '',
      url: map['url'] ?? '',
      type: map['type'] ?? '',
      uploadedBy: map['uploadedBy'] ?? '',
      uploadedAt: (map['uploadedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'url': url,
      'type': type,
      'uploadedBy': uploadedBy,
      'uploadedAt': Timestamp.fromDate(uploadedAt),
    };
  }

  factory AttachmentModel.fromEntity(AttachmentEntity entity) =>
      AttachmentModel(
        name: entity.name,
        url: entity.url,
        type: entity.type,
        uploadedBy: entity.uploadedBy,
        uploadedAt: entity.uploadedAt,
      );

  AttachmentEntity toEntity() => this;
}
