# Витрина RFM

## 1.1. Выясните требования к целевой витрине.

Постановка задачи выглядит достаточно абстрактно - постройте витрину. Первым делом вам необходимо выяснить у заказчика детали. Запросите недостающую информацию у заказчика в чате.

Зафиксируйте выясненные требования. Составьте документацию готовящейся витрины на основе заданных вами вопросов, добавив все необходимые детали.

Витрина должна располагаться в той же базе в схеме analysis.
В Витрине нужны данные за 2022, должна состоять из таких полей:
user_id
recency (число от 1 до 5)
frequency (число от 1 до 5)
monetary_value (число от 1 до 5)
Название витрины - dm_rfm_segments. Обновление витрины не требуется.
Успешный заказ - это заказ со статусом closed



## 1.2. Изучите структуру исходных данных.

Полключитесь к базе данных и изучите структуру таблиц.
Если появились вопросы по устройству источника, задайте их в чате.
Зафиксируйте, какие поля вы будете использовать для расчета витрины.

Для расчета витрины нам понадобятся поле user_id(id пользователя) из таблицы orders
Для расчета метрики Recency нам понадобятся также order_ts для вычесления порядка заказов
Для расчета метрики Frequency понадобятся поля user_id и order_id для вычисления количетсва заказов.
Для расчета метрики Monetary Value понадобятся поля payment для оценки потреченной суммы
И поле status из таблицы orders для фильтрации успешных заказов


## 1.3. Проанализируйте качество данных

Изучите качество входных данных. Опишите, насколько качественные данные хранятся в источнике. Так же укажите, какие инструменты обеспечения качества данных были использованы в таблицах в схеме production.

-----------

Данные качественные, типы данных указаны корректно.
Из инструментов это ссылки и ограничения:
CONSTRAINT , CHECK, ADD CONSTAINT , REFERENCES

## 1.4. Подготовьте витрину данных

Теперь, когда требования понятны, а исходные данные изучены, можно приступить к реализации.

### 1.4.1. Сделайте VIEW для таблиц из базы production.**

Вас просят при расчете витрины обращаться только к объектам из схемы analysis. Чтобы не дублировать данные (данные находятся в этой же базе), вы решаете сделать view. Таким образом, View будут находиться в схеме analysis и вычитывать данные из схемы production. 

Напишите SQL-запросы для создания пяти VIEW (по одному на каждую таблицу) и выполните их. Для проверки предоставьте код создания VIEW.

```SQL
-- analysis."order" source

CREATE OR REPLACE VIEW analysis."order"
AS SELECT orders.order_id,
    orders.order_ts,
    orders.user_id,
    orders.bonus_payment,
    orders.payment,
    orders.cost,
    orders.bonus_grant,
    orders.status
   FROM production.orders;

 -- analysis.orderitems source

CREATE OR REPLACE VIEW analysis.orderitems
AS SELECT orderitems.id,
    orderitems.product_id,
    orderitems.order_id,
    orderitems.name,
    orderitems.price,
    orderitems.discount,
    orderitems.quantity
   FROM production.orderitems;

 -- analysis.orderstatuses source

CREATE OR REPLACE VIEW analysis.orderstatuses
AS SELECT orderstatuses.id,
    orderstatuses.key
   FROM production.orderstatuses;

-- analysis.orderstatuslog source

CREATE OR REPLACE VIEW analysis.orderstatuslog
AS SELECT orderstatuslog.id,
    orderstatuslog.order_id,
    orderstatuslog.status_id,
    orderstatuslog.dttm
   FROM production.orderstatuslog; 

 -- analysis.products source

CREATE OR REPLACE VIEW analysis.products
AS SELECT products.id,
    products.name,
    products.price
   FROM production.products;  


```

### 1.4.2. Напишите DDL-запрос для создания витрины.**

Далее вам необходимо создать витрину. Напишите CREATE TABLE запрос и выполните его на предоставленной базе данных в схеме analysis.

```SQL
-- analysis.datamart_ddl definition

-- Drop table

-- DROP TABLE analysis.datamart_ddl;

CREATE TABLE analysis.datamart_ddl (
	user_id int8 NULL,
	recency int8 NULL,
	frequency int8 NULL,
	monetary_value int8 NULL
);
```

### 1.4.3. Напишите SQL запрос для заполнения витрины

Наконец, реализуйте расчет витрины на языке SQL и заполните таблицу, созданную в предыдущем пункте.

Для решения предоставьте код запроса.

```SQL
insert into analysis.tmp_rfm_recency
select distinct on (user_id) user_id,
       ntile(5) over (order BY order_ts) as recency
from analysis."order" o 
order by user_id ,
         order_ts desc

insert into analysis.tmp_rfm_frequency
select user_id,
      NTILE(5) over (order BY COUNT(order_id)) as frequency
     from  analysis."order" o    
group by user_id

insert into analysis.tmp_rfm_monetary_value
select user_id,
       ntile(5) over (order by SUM(cost)) as monetary_value 
from analysis."order" o  
group by user_id

insert into analysis.dm_rfm_segments
select r.user_id as user_id,
       recency,
       frequency,
       monetary_value
from analysis.tmp_rfm_recency r
inner join analysis.tmp_rfm_frequency f on r.user_id = f.user_id 
inner join analysis.tmp_rfm_monetary_value mv on r.user_id = mv.user_id
order by r.user_id 
```



