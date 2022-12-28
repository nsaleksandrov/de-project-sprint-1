WITH tmp_rfm_frequency AS ( 

select user_id 

     from  production.orders o 

WHERE o.status = 4 --closed 

AND   o.order_ts >= '2022-01-01'     

group by user_id
) 
 

INSERT INTO analysis.tmp_rfm_frequency 

SELECT u.id as user_id, 
        NTILE(5) over (order BY COUNT(order_id)) as frequency

FROM analysis."users" u  

LEFT JOIN tmp_rfm_frequency trf 

ON u.id = trf.user_id 

left join analysis."orders" o

on u.id = o.user_id

where o.order_ts >='2022-01-01'

group by u.id