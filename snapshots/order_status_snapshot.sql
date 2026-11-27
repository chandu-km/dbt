{% snapshot order_status_snapshot %}

{{ config(schema='snapshots', unique_key='order_id', strategy='timestamp', updated_at='updated_at') }}

select * from {{ source('raw_orders', 'orders') }}

{% endsnapshot %}