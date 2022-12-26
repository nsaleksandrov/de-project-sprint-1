with closed_monetary_value AS
(
select user_id,
       ntile(5) over (order by SUM(cost)) as monetary_value 
from analysis."order" o  
WHERE o.status = 4 --closed
AND o.order_ts >= '2022-01-01'
group by user_id
)

insert into analysis.tmp_rfm_monetary_value
SELECT o.user_id as user_id,
       monetary_value
FROM analysis."order" o 
LEFT JOIN closed_monetary_value cmv
ON o.user_id = cmv.user_id
WHERE o.order_ts >= '2022-01-01'



