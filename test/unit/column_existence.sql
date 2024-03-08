BEGIN;

SELECT
    plan(2);

SELECT
    has_column(
        'roles',
        'name',
        'Column name exists in roles table'
    );

SELECT
    has_column(
        'user_groups',
        'created_at',
        'Column created_at exists in user_groups table'
    );

ROLLBACK;