import { Entity, PrimaryColumn, Column, Check } from 'typeorm';

@Entity()
@Check(`parent_oid <> entity_oid`)
export class CustomEntity {
  @PrimaryColumn()
  entity_oid: string;

  @Column({ nullable: true })
  parent_oid: string;

  @Column({ enum: ['BOARD', 'FILESTORAGE'] })
  permission_type: 'BOARD' | 'FILESTORAGE';
}
