insert into analysis.tmp_rfm_recency
select distinct on (user_id) user_id,
       ntile(5) over (order BY order_ts) as recency
from analysis."order" o 
order by user_id ,
         order_ts desc


