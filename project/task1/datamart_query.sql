insert into analysis.dm_rfm_segments
select r.user_id as user_id,
       recency,
       frequency,
       monetary_value
from analysis.tmp_rfm_recency r
inner join analysis.tmp_rfm_frequency f on r.user_id = f.user_id 
inner join analysis.tmp_rfm_monetary_value mv on r.user_id = mv.user_id
order by r.user_id 