insert into analysis.analysis.dm_rfm_segments
select r.user_id as user_id,
       recency,
       frequency,
       monetary_value
from analysis.tmp_rfm_recency r
inner join analysis.tmp_rfm_frequency f on r.user_id = f.user_id 
inner join analysis.tmp_rfm_monetary_value mv on r.user_id = mv.user_id

0	5	5	5
1	5	4	4
2	5	3	3
3	5	3	2
4	5	4	2
5	5	5	5
6	4	2	2
7	5	1	2
8	5	1	2
9	5	3	2