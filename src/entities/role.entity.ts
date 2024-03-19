import { Permission } from './permission.enum';

type Role = {
  uid: string;
  created_at: Date;
  updated_at: Date;
  name: string;
  permissions: Permission[];
};
