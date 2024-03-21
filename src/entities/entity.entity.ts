enum PermissionType {
  BOARD = 'BOARD',
  FILESTORAGE = 'FILESTORAGE',
}
type CustomEntity = {
  entity_oid: string;
  parent_oid: string | null;
  permission_type: PermissionType;
};
