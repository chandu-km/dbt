{{ config(materialized='table') }}

with orders as (
    select * from {{ ref('stg_orders__orders')}}
),
customers as (
    select * from {{ ref('stg_catalog__customers')}}
),
item_aggregates as (
    select * from {{ ref('int_order_items_aggregated')}}
),
city_regions as (
    select * from {{ ref('city_regions')}}
),

final as (
    select
        orders.order_id,
        orders.customer_id,
        customers.first_name || ' ' || customers.last_name as customer_name,
        customers.customer_segment,
        orders.delivery_city,
        orders.delivery_state,
        city_regions.region,
        orders.order_status,
        orders.order_channel,
        orders.payment_method,
        orders.order_placed_at,
        item_aggregates.item_count,
        item_aggregates.gross_item_revenue,
        orders.discount_amount,
        orders.delivery_fee,
        round(item_aggregates.gross_item_revenue - orders.discount_amount + orders.delivery_fee, 2) as net_revenue
    from orders
    left join customers on orders.customer_id = customers.customer_id
    left join item_aggregates on orders.order_id = item_aggregates.order_id
    left join city_regions on orders.delivery_city = city_regions.city
)

select * from final
