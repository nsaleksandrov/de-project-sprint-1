with tmp_rfm_recency AS 
( 
select user_id, 
       max(o.order_ts)  as max_ts
from analysis."order" o
WHERE o.status = 4 --closed 
AND   o.order_ts >= '2022-01-01' 
group by user_id 
)

insert into analysis.tmp_rfm_recency
SELECT u.id as user_id, 
       ntile(5) OVER (ORDER BY max_ts NULLS FIRST) AS recency 
FROM analysis."users" u 
LEFT JOIN tmp_rfm_recency trr 
ON u.id = trr.user_id 