WITH tmp_rfm_frequency AS ( 
select user_id ,
       COUNT(order_id) as cnt_order
     from  analysis."order" o 
WHERE o.status = 4 --closed 
AND   o.order_ts >= '2022-01-01'     
group by user_id
) 
 

INSERT INTO analysis.tmp_rfm_frequency 
SELECT u.id as user_id, 
        NTILE(5) over (order BY cnt_orders) as frequency
FROM analysis."users" u  
LEFT JOIN tmp_rfm_frequency trf 
ON u.id = trf.user_id 