-- revenue per region. Hooks write an audit row before and after every build.

{{ config(
    pre_hook=[
        "create table if not exists {{ target.database }}.{{ target.schema }}.db_audit_log (model_name varchar, event varchar, event_at timestamp)",
        "insert into {{ target.database }}.{{ target.schema }}.db_audit_log values ('{{ this.name }}', 'started', current_timestamp)" 
    ],
    post_hook="insert into {{ target.database }}.{{ target.schema }}.db_audit_log values ('{{ this.name }}', 'finished', current_timestamp)"
) }}

select 
    region,
    count(*) as order_count,
    sum(net_revenue) as net_revenue
    from {{ ref('fct_orders_analytics') }}
    group by region
