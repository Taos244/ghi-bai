--buoi4
----Hàm tổng hợp (aggregate function)
Select
Max (amount) as max_amount,
min (amount) as min_amount,
Sum (amount) as total_amount,
AVG (amount) as average_amount,
count (*) as total_record -- tong so luong ban ghi bang payment
Count (customer_id) as total_record_customer -- = so ban ghi bang payment
Count (distinct customer_id) as total_record_customer --so luong KH khac nhau
FROM payment;
where payment_date between '2020-01-01' and '2020-02-01';
and amount >0
---group by :tinh toan tong hop tren truong thong tin sau khi da duoc gom nhom
---hay cho biết mỗi KH đã trả bnh tiền
select * from payment;
select customer_id, staff_id
sum (amount)as total amount,
avg (amount) as avg_amount,
max (amount) as max_amount
min (amount) as min_amount
count (*) as count_rent
from payment
group by customer_id, staff_id
  order by customer_id
--cú pháp
select  col1,col2, ---toi da 2 col
Sum,
avg,
min,
max
from table_name
group by col1,col2
---challange: viet truy van de xem cac thong so 
--toi da
--toi thieu
--trung binh
--tong
---ve chi phí thay the cac phim hien tai

select film_id
max (replacement_cost) as max_replacement
min (replacement_cost) as min_replacement
round(avg (replacement_cost),2) as avg_replacement --round(...,2) = lam tron 2 so tphan
sum (replacement_cost) as sum_replacement
from film
group by film_id
order by film_id ---de de nhin hon
