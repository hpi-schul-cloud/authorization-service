INSERT INTO roles (name, permissions) VALUES
    ('Board Reader', ARRAY['BOARD_NODE_READ', 'FILESTORAGE_READ']::bkg_permission[]),
    ('Board Owner', ARRAY[
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
    ]::bkg_permission[]),
    ('Board Editor', ARRAY[
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
    ]::bkg_permission[]);