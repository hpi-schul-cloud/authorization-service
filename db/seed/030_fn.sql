-- FUNCTION: public.has_duplicates(anyarray)

-- DROP FUNCTION IF EXISTS public.has_duplicates(anyarray);

CREATE OR REPLACE FUNCTION public.has_duplicates(
	_arr anyarray)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    IMMUTABLE PARALLEL UNSAFE
AS $BODY$
DECLARE
    _count_all INT;
    _count_distinct INT;
BEGIN
    SELECT COUNT(*) INTO _count_all FROM UNNEST(_arr) AS elem;
    SELECT COUNT(*) INTO _count_distinct FROM (SELECT DISTINCT UNNEST(_arr) AS elem) AS subquery;
    RETURN _count_all = _count_distinct;
END;
$BODY$;

ALTER FUNCTION public.has_duplicates(anyarray)
    OWNER TO postgres;
