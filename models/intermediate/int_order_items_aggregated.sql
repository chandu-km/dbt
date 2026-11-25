-- One row per order: how many items, and their money total
with order_items as (
    select * from {{ ref('stg_orders__order_items') }}
),

aggregated as (
    select
        order_id,
        count(order_item_id)                                   as item_count,
        round(sum(quantity * unit_price - item_discount), 2)   as gross_item_revenue
    from order_items
    group by order_id
)

select * from aggregated