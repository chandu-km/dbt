-- {{ config(materialized='incremental', unique_key='order_id') }}

-- {{ config(materialized='incremental', unique_key='order_id', incremental_strategy='append') }}

{{ config(materialized='incremental', unique_key='order_id', incremental_strategy='delete+insert') }}

select order_id, customer_id, order_status, order_placed_at, updated_at
from {{ ref('stg_orders__orders') }}

{% if is_incremental() %}
    where updated_at > (select coalesce(max(updated_at), '1900-01-01') from {{ this }})
{% endif %}