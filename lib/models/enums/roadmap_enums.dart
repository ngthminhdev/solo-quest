/// Source of roadmap creation
/// Used to distinguish between different creation methods
enum RoadmapCreationSource {
  /// System-provided or pre-seeded roadmaps
  system,

  /// User selected from template library
  template,

  /// AI-generated roadmap (future implementation)
  /// TODO: Wire to AI API when backend is ready
  ai,

  /// User manually created custom roadmap
  custom,
}

extension RoadmapCreationSourceExtension on RoadmapCreationSource {
  String get value {
    switch (this) {
      case RoadmapCreationSource.system:
        return 'system';
      case RoadmapCreationSource.template:
        return 'template';
      case RoadmapCreationSource.ai:
        return 'ai';
      case RoadmapCreationSource.custom:
        return 'custom';
    }
  }

  static RoadmapCreationSource fromString(String value) {
    switch (value.toLowerCase()) {
      case 'system':
        return RoadmapCreationSource.system;
      case 'template':
        return RoadmapCreationSource.template;
      case 'ai':
        return RoadmapCreationSource.ai;
      case 'custom':
        return RoadmapCreationSource.custom;
      default:
        return RoadmapCreationSource.system;
    }
  }
}
