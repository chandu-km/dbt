{% macro round_currency(col, precision=4) %}
    round({{ col }}, {{ precision }})
{% endmacro %}