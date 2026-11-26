with source as (
    select * from {{ source('raw_orders', 'order_items') }}
),

cleaned as (
    select
        order_item_id,
        order_id,
        product_id,
        quantity,
        round(unit_price, 2)    as unit_price,
        round(item_discount, 2)   as item_discount,
        created_at
    from source
)

select * from cleaned