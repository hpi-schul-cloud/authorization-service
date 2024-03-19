import { Entity, PrimaryColumn } from 'typeorm';

@Entity()
export class UserGroupMember {
  @PrimaryColumn()
  user_group_uid: string;

  @PrimaryColumn()
  user_oid: string;
}
