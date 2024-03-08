BEGIN;

SELECT
    plan(2);

SELECT
    has_table('roles', 'Table roles exists');

SELECT
    has_table('user_groups', 'Table user_groups exists');

ROLLBACK;