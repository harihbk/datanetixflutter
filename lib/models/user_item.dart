class UserItem {
  final String id;
  final String firstName;
  final String lastName;
  final String schoolId;

  const UserItem({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.schoolId,
  });

  factory UserItem.fromJson(Map<String, dynamic> json) {
    String _schoolId = '';

    if (json.containsKey('organization_uuid') &&
        json['organization_uuid'] != null) {
      _schoolId = json['organization_uuid'] as String;
    }
    return UserItem(
      id: json['uuid'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      schoolId: _schoolId,
    );
  }
}
