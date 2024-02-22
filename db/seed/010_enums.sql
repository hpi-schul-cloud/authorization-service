-- Type: bkg_permission

-- DROP TYPE IF EXISTS public.PERMISSION;

CREATE TYPE public.PERMISSION AS ENUM
    (
        'BOARD_TREE_CREATE',
        'BOARD_TREE_DELETE',
        'BOARD_NODE_CREATE',
        'BOARD_NODE_READ',
        'BOARD_NODE_UPDATE',
        'BOARD_NODE_DELETE',
        'BOARD_NODE_CREATE_TASK',
        'BOARD_NODE_SUBMIT_TASK',

        'FILESTORAGE_CREATE',
        'FILESTORAGE_READ',
        'FILESTORAGE_UPDATE',
        'FILESTORAGE_DELETE'
    );

ALTER TYPE public.PERMISSION
    OWNER TO postgres;

COMMENT ON TYPE public.PERMISSION
    IS 'Every permission must be stored as a enum.
The roles table can apply additional constraints which PERMISSION enums are allowed for their use case.';
