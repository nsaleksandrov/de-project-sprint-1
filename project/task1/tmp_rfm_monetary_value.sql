with closed_monetary_value AS   
(   
select user_id,
       SUM(cost) as sum_cost
from analysis."order" o     
WHERE o.status = 4 --closed   
AND o.order_ts >= '2022-01-01'   
group by user_id   
)   

insert into analysis.tmp_rfm_monetary_value   
SELECT u.id as user_id,   
       ntile(5) over (order by cmv.sum_cost) as monetary_value    
FROM analysis."users" u   
LEFT JOIN closed_monetary_value cmv   
ON u.id = cmv.user_id   