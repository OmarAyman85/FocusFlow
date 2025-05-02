class Project {
  final String id;
  final String workspaceId;
  final String name;
  final String description;
  final List<String> memberIds;
  final String createdBy;
  final String createdByName;

  Project({
    required this.id,
    required this.workspaceId,
    required this.name,
    required this.description,
    required this.memberIds,
    required this.createdBy,
    required this.createdByName,
  });
}
