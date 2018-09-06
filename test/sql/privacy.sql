\c single :ROLE_SUPERUSER
CREATE OR REPLACE FUNCTION _timescaledb_internal.test_privacy() RETURNS VOID
    AS :MODULE_PATHNAME, 'test_privacy' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
\c single :ROLE_DEFAULT_PERM_USER

-- Should be off be default in tests
SHOW timescaledb.telemetry_level;
SET timescaledb.telemetry_level=off;
SHOW timescaledb.telemetry_level;
SELECT _timescaledb_internal.test_privacy();
-- To make sure nothing was sent, we check the UUID table to make sure no exported UUID row was created
SELECT COUNT(*) from _timescaledb_catalog.installation_metadata;

-- Do it again to make sure
SELECT _timescaledb_internal.test_privacy();
SELECT COUNT(*) from _timescaledb_catalog.installation_metadata;
