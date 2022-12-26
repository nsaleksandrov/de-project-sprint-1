WITH AS tmp_rfm_frequency (
select user_id,
      NTILE(5) over (order BY COUNT(order_id)) as frequency
     from  analysis."order" o
WHERE o.status = 4 --closed
AND   o.order_ts >= '2022-01-01'    
group by user_id)

INSERT INTO analysis.tmp_rfm_frequency
SEKECT o.user_id as user_id,
       frequency
FROM analysis."order" o 
LEFT JOIN tmp_rfm_frequency trf
ON o.user_id = trf.user_id
WHERE o.order_ts >= '2022-01-01'