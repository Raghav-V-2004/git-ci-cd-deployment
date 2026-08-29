
  create or replace   view DCM_LEARNING.TEST.my_second_dbt_model
  
  
  
  
  as (
    -- Use the `ref` function to select from other models

select *
from DCM_LEARNING.TEST.my_first_dbt_model
where id = 1
  );

