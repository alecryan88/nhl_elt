{% macro decimal_to_american_odds(col) %}

    round(
        case 
            when {{ col }} < 2.00 then -100 / ({{ col }} -1)
            when {{ col }} >= 2.00 then 100 * ({{ col }} -1)
        end, 0) 

{% endmacro %}