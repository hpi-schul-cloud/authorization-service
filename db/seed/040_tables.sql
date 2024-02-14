-- Table: public.roles----------------------------------------------------------

    -- DROP TABLE IF EXISTS public.roles;

    CREATE TABLE IF NOT EXISTS public.roles
    (
        uid uuid NOT NULL DEFAULT uuid_generate_v4(),
        created_at timestamp with time zone NOT NULL DEFAULT now(),
        updated_at timestamp with time zone NOT NULL DEFAULT now(),
        name text COLLATE pg_catalog."default" NOT NULL,
        permissions bkg_permission[] NOT NULL,
        CONSTRAINT roles_pkey PRIMARY KEY (uid),
        CONSTRAINT unique_role_names UNIQUE (name),
        CONSTRAINT no_duplicated_permissions CHECK (has_duplicates(permissions)) NOT VALID
    )

    TABLESPACE pg_default;

    ALTER TABLE IF EXISTS public.roles
        OWNER to postgres;

    COMMENT ON TABLE public.roles
        IS 'Every role defines a set of PERMISSIONS.
    The role name is unique.';

    COMMENT ON CONSTRAINT unique_role_names ON public.roles
        IS 'Every role name must be unique. The same role e.g. teacher must have the same set of permissions.';

-- Trigger: set_updated_at_for_roles--------------------------------------------

    -- DROP TRIGGER IF EXISTS set_updated_at_for_roles ON public.roles;

    CREATE OR REPLACE TRIGGER set_updated_at_for_roles
        BEFORE INSERT OR UPDATE 
        ON public.roles
        FOR EACH ROW
        EXECUTE FUNCTION public.set_updated_at();

    COMMENT ON TRIGGER set_updated_at_for_roles ON public.roles
        IS 'Automatically sets the updated_at column to the current timestamp on change.';

-- Table: public.user_groups----------------------------------------------------

    -- DROP TABLE IF EXISTS public.user_groups;

    CREATE TABLE IF NOT EXISTS public.user_groups
    (
        uid uuid NOT NULL DEFAULT uuid_generate_v4(),
        created_at timestamp with time zone NOT NULL DEFAULT now(),
        updated_at timestamp with time zone NOT NULL DEFAULT now(),
        name text COLLATE pg_catalog."default",
        CONSTRAINT user_groups_pkey PRIMARY KEY (uid)
    )

    TABLESPACE pg_default;

    ALTER TABLE IF EXISTS public.user_groups
        OWNER to postgres;

    COMMENT ON TABLE public.user_groups
        IS 'A collection of users used to attach roles/permissions to them.';

-- Table: public.user_group_members---------------------------------------------

    -- DROP TABLE IF EXISTS public.user_group_members;

    CREATE TABLE IF NOT EXISTS public.user_group_members
    (
        user_group_uid uuid NOT NULL,
        user_oid text COLLATE pg_catalog."default" NOT NULL,
        CONSTRAINT user_group_members_pkey PRIMARY KEY (user_group_uid, user_oid),
        CONSTRAINT user_group_reference FOREIGN KEY (user_group_uid)
            REFERENCES public.user_groups (uid) MATCH SIMPLE
            ON UPDATE CASCADE
            ON DELETE CASCADE
    )

    TABLESPACE pg_default;

    ALTER TABLE IF EXISTS public.user_group_members
        OWNER to postgres;

    COMMENT ON TABLE public.user_group_members
        IS 'Relation to add members to a user_group.';

-- Table: public.permission_context---------------------------------------------

    -- DROP TABLE IF EXISTS public.permission_context;

    CREATE TABLE IF NOT EXISTS public.permission_context
    (
        entity_oid text COLLATE pg_catalog."default" NOT NULL,
        parent_oid text COLLATE pg_catalog."default",
        permission_type text COLLATE pg_catalog."default" NOT NULL,
        CONSTRAINT permission_context_pkey PRIMARY KEY (entity_oid),
        CONSTRAINT valid_permission_type CHECK (permission_type = ANY (ARRAY['BOARD'::text, 'FILESTORAGE'::text])),
        CONSTRAINT no_self_reference CHECK (parent_oid <> entity_oid) NOT VALID
    )

    TABLESPACE pg_default;

    ALTER TABLE IF EXISTS public.permission_context
        OWNER to postgres;

    COMMENT ON TABLE public.permission_context
        IS 'Every resource which needs to be authorized will have one permission_context listed in this table.
    The parent_oid is set if permissions need to be inherited.';

-- Table: public.permission_context_mappings------------------------------------

    -- DROP TABLE IF EXISTS public.permission_context_mappings;

    CREATE TABLE IF NOT EXISTS public.permission_context_mappings
    (
        entity_oid text COLLATE pg_catalog."default" NOT NULL,
        user_group_uid uuid NOT NULL,
        role_uid uuid NOT NULL,
        CONSTRAINT permission_context_mappings_pkey PRIMARY KEY (entity_oid, user_group_uid, role_uid),
        CONSTRAINT entity_reference FOREIGN KEY (entity_oid)
            REFERENCES public.permission_context (entity_oid) MATCH SIMPLE
            ON UPDATE NO ACTION
            ON DELETE NO ACTION,
        CONSTRAINT role_reference FOREIGN KEY (role_uid)
            REFERENCES public.roles (uid) MATCH SIMPLE
            ON UPDATE NO ACTION
            ON DELETE NO ACTION,
        CONSTRAINT user_group_reference FOREIGN KEY (user_group_uid)
            REFERENCES public.user_groups (uid) MATCH SIMPLE
            ON UPDATE NO ACTION
            ON DELETE NO ACTION
    )

    TABLESPACE pg_default;

    ALTER TABLE IF EXISTS public.permission_context_mappings
        OWNER to postgres;

    COMMENT ON TABLE public.permission_context_mappings
        IS 'Maps every permission_context to a unique role & user_group';

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------