with tmp_rfm_recency AS
(
select user_id,
       ntile(5) OVER (ORDER BY max(o.order_ts) NULLS FIRST) as recency 
from analysis."order" o  
WHERE o.status = 4 --closed
AND   o.order_ts >= '2022-01-01'
group by user_id
)

insert into analysis.tmp_rfm_recency
SELECT o.user_id as user_id,
       recency
FROM analysis."order" o 
LEFT JOIN tmp_rfm_recency trr
ON o.user_id = trr.user_id
WHERE o.order_ts >= '2022-01-01'
