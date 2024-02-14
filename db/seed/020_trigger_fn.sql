-- FUNCTION: public.set_updated_at()--------------------------------------------

    -- DROP FUNCTION IF EXISTS public.set_updated_at();

    CREATE OR REPLACE FUNCTION public.set_updated_at()
        RETURNS trigger
        LANGUAGE 'plpgsql'
        COST 100
        VOLATILE NOT LEAKPROOF SECURITY DEFINER
    AS $BODY$
    BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
    END;
    $BODY$;

    ALTER FUNCTION public.set_updated_at()
        OWNER TO postgres;

    COMMENT ON FUNCTION public.set_updated_at()
        IS 'Sets the updated_at column to the current timestamp.';
