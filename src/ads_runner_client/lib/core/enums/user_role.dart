enum UserRole {
  admin('Admin'),
  client('Client'),
  operator_('Operator'),
  viewer('Viewer');

  const UserRole(this.displayName);
  final String displayName;
}
