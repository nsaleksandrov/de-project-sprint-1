insert into analysis.tmp_rfm_monetary_value
select user_id,
       ntile(5) over (order by SUM(cost)) as monetary_value 
from analysis."order" o  
group by user_id