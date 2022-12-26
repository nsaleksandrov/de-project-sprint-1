WITH AS tmp_rfm_frequency (
select user_id,
      NTILE(5) over (order BY COUNT(order_id)) as frequency
     from  analysis."order" o
WHERE o.status = 4 --closed
AND   o.order_ts >= '2022-01-01'    
group by user_id)

INSERT INTO analysis.tmp_rfm_frequency
SELECT u.user_id as user_id,
       frequency
FROM analysis."users" u 
LEFT JOIN tmp_rfm_frequency trf
ON u.user_id = trf.user_id
WHERE u.user_id IN (SELECT DISTINCT user_id
                    FROM analysis."order" o
                    WHERE o.order_ts >='2022-01-01')