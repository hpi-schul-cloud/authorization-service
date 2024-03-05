BEGIN;

SELECT plan(3);

SELECT ok(
    1 = 1,
    '1 equals 1'
);

SELECT ok(
    'hello' || ' ' || 'world' = 'hello world',
    'Concatenating strings works'
);

SELECT ok(
    5 + 5 = 10,
    'Adding numbers produces the correct result'
);

ROLLBACK;