-- Setup to test the permission resolution
-- 2 user groups
--- kids: [tick, trick, track]
--- adults: [donald, daisy]
-- 2 roles
--- Board Editor: adults
--- Board Reader: kids
-- 1 board with one nested node where the kids are Board Editors

INSERT INTO public.user_groups (uid, name) VALUES
('00000000-0000-0000-0000-000000000001', 'kids'),
('00000000-0000-0000-0000-000000000002', 'adults');

INSERT INTO public.user_group_members (user_group_uid, user_oid) VALUES
('00000000-0000-0000-0000-000000000001'::UUID, 'oid-tick'),
('00000000-0000-0000-0000-000000000001'::UUID, 'oid-trick'),
('00000000-0000-0000-0000-000000000001'::UUID, 'oid-track'),
('00000000-0000-0000-0000-000000000002'::UUID, 'oid-donald'),
('00000000-0000-0000-0000-000000000002'::UUID, 'oid-daisy');

INSERT INTO public.entities (entity_oid, parent_oid, permission_type) VALUES
    ('oid-board', NULL, 'BOARD'),
    ('oid-column', 'oid-board', 'BOARD'),
    ('oid-card1', 'oid-column', 'BOARD'),
    ('oid-card2', 'oid-column', 'BOARD');

INSERT INTO public.rules (entity_oid, user_group_uid, role_uid) VALUES
    ('oid-board', '00000000-0000-0000-0000-000000000001'::UUID, (SELECT uid FROM roles WHERE name = 'Board Reader')),
    ('oid-board', '00000000-0000-0000-0000-000000000002'::UUID, (SELECT uid FROM roles WHERE name = 'Board Editor')),
    ('oid-card1', '00000000-0000-0000-0000-000000000001'::UUID, (SELECT uid FROM roles WHERE name = 'Board Editor'));


--------------------------------
-- example query to resolve permissions, given a user_oid and a entity_oid
-- not optimized
-- not tested
-- must change to support white/blacklisting of users

-- get list of entities, via search bottom up (datastructure: linked list)
-- provide starting point
WITH RECURSIVE q_search_parents (this_entity_oid, this_parent_oid) AS (
	select e1.entity_oid, e1.parent_oid from entities e1 where entity_oid = 'oid-card1'
	UNION
		select e2.entity_oid, e2.parent_oid
		from entities e2
		inner join q_search_parents sp
		on e2.entity_oid = sp.this_parent_oid
),
-- resolve user_group, provide user_oid
q_user_groups as (
	select ug.uid as user_group_uid from user_groups ug
	join user_group_members ugm on ug.uid = ugm.user_group_uid
	where ugm.user_oid = 'oid-trick'
),
q_resolved_roles as (
	select role_uid from rules r
	inner join q_search_parents
		on r.entity_oid =  q_search_parents.this_entity_oid
	inner join q_user_groups
		on r.user_group_uid = q_user_groups.user_group_uid
)
-- expand permissions
select distinct unnest(permissions) from q_resolved_roles
inner join roles on q_resolved_roles.role_uid = roles.uid

-- results
--- with oid-trick, oid-card1
---- "BOARD_NODE_CREATE_TASK"
---- "BOARD_NODE_DELETE"
---- "FILESTORAGE_READ"
---- "BOARD_NODE_READ"
---- "BOARD_NODE_CREATE"
---- "FILESTORAGE_DELETE"
---- "FILESTORAGE_UPDATE"
---- "FILESTORAGE_CREATE"
---- "BOARD_NODE_SUBMIT_TASK"
---- "BOARD_NODE_UPDATE"

--- with oid-trick, oid-board
---- "FILESTORAGE_READ"
---- "BOARD_NODE_READ"