{% macro decimal_odds_to_prob(col) %}

    1/ {{col}}

{% endmacro %}