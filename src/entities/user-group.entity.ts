import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity()
export class UserGroup {
  @PrimaryGeneratedColumn('uuid')
  uid: string;

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  created_at: Date;

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  updated_at: Date;

  @Column()
  name: string;
}
