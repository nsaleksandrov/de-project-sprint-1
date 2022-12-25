create or replace view  analysis.orders_view as
select o.order_id ,
       o.order_ts,
       o.user_id ,
       o.bonus_payment,
       o.cost ,
       o.bonus_grant ,
       o3.key as sataus
from production.orders o 
join (select *, 
     row_number() over (partition by order_id order by dttm desc) rn
from production.orderstatuslog o2) o2
on o.order_id = o2.order_id and o.status = o2.status_id 
left join production.orderstatuses o3 on o2.status_id = o3.id 
where rn =1 
order by o.order_id 