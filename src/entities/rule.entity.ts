import { Entity, PrimaryColumn } from 'typeorm';

@Entity()
export class Rule {
    @PrimaryColumn()
    entity_oid: string;

    @PrimaryColumn()
    user_group_uid: string;

    @PrimaryColumn()
    role_uid: string;
}