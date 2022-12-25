insert into analysis.tmp_rfm_frequency
select user_id,
      NTILE(5) over (order BY COUNT(order_id)) as frequency
     from  analysis."order" o    
group by user_id