-- Funnel position of a stage. Closed stages share the last position.
{% macro stage_order(column) -%}
    case {{ column }}
        when 'Prospecting'   then 1
        when 'Qualification' then 2
        when 'Proposal'      then 3
        when 'Negotiation'   then 4
        when 'Closed Won'    then 5
        when 'Closed Lost'   then 5
    end
{%- endmacro %}
