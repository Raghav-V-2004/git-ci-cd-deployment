-- 1. Schema — suffixed, since it's the top-level container that gets "owned" per project
DEFINE SCHEMA dcm_demo.rbac_lab{{env_suffix}}
    COMMENT = 'RBAC + DMF + Tagging hands-on lab';

-- 2. Table — safe automatically, since it lives inside the now-suffixed schema
DEFINE TABLE dcm_demo.rbac_lab{{env_suffix}}.project_data (
    project_id   NUMBER,
    project_name VARCHAR,
    budget       NUMBER(12,2)
)
    DATA_METRIC_SCHEDULE = TRIGGER_ON_CHANGES;

-- 3. Role — suffixed, account-level object, no container
DEFINE ROLE rbac_lab_reader{{env_suffix}}
    COMMENT = 'Read-only access to rbac_lab';

-- 4. Grant chain — references updated to match suffixed schema/role
GRANT USAGE ON DATABASE dcm_demo TO ROLE rbac_lab_reader{{env_suffix}};
GRANT USAGE ON SCHEMA dcm_demo.rbac_lab{{env_suffix}} TO ROLE rbac_lab_reader{{env_suffix}};
GRANT SELECT ON TABLE dcm_demo.rbac_lab{{env_suffix}}.project_data TO ROLE rbac_lab_reader{{env_suffix}};

-- 5. DMF attachment — safe automatically, references the now-suffixed table
ATTACH DATA METRIC FUNCTION SNOWFLAKE.CORE.MIN
    TO TABLE dcm_demo.rbac_lab{{env_suffix}}.project_data ON (budget)
    EXPECTATION BUDGET_NOT_NEGATIVE (VALUE >= 0);

-- 6. Tag — safe automatically, lives inside the now-suffixed schema
-- DEFINE TAG dcm_demo.rbac_lab{{env_suffix}}.cost_center_tag
--     COMMENT = 'Tracks which team owns the budget/cost for this data';

-- (tag attachment line, if present in your real file, also needs the suffixed schema/table)

-- 7. Warehouse — already correct from before
DEFINE WAREHOUSE dcm_lab_wh{{env_suffix}}
    WAREHOUSE_SIZE = '{{wh_size}}'
    COMMENT = 'Multi-environment promotion test warehouse';


