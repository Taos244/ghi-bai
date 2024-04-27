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

--buoi6
/*trich xuat ten tu dia chi emai va noi voi ho
Kết quả ỏ dạng "Họ, Tên"*/

Select
email, last_name,
last_name || ', ' || substring(email from 1 for (position('.' in email)-1))
From customer

---DATE/TIME FUNCTION
--EXTRACT:
SELECT EXTRACT ( FIELD FROM DATE/TIME/INTERVAL)
--VD:
SELECT
EXTRACT(MONTH FROM rental_date),
extract(year from rental_date),
extract(hour from rental_date)
from rental

--năm 2020, có bao nhiêu đơn hàng cho thuê trong mỗi tháng
Select
extract(month from rental_date) as rental_month_2020,
count(rental_id)
from rental
where extract(year from rental_date) = 2020
Group by extract(month from rental_date)

--challenge
/*Phan tich cac khoan thanh toan va tim hieu:
- tháng nao co tổng số tiền thanh toán cao nhất
- Ngày nào trong tuần có số tiên tt cao nhất (0 là chủ nhật)
- Số tiền cao nhất mà 1 KH đã chi tiêu trong 1 tuan la bnh*/

Select
extract(month from payment_date) as month_of_year,
Sum(amount)
from payment
group by extract(month from payment_date)
order by Sum(amount) desc

Select
extract(Dow from payment_date) as day_of_week,
Sum(amount)
from payment
group by extract(dow from payment_date)
order by Sum(amount) desc

Select customer_id, extract(week from payment_date)as week_of_year,
Sum(amount)
from payment
group by customer_id,extract(week from payment_date)
order by Sum(amount) desc

--TO_CHAR: customize theo duoc dang text
TO_CHAR(payment_date,format) -- tham khao tren trang web cac dang format vi co nhieu
Select
payment_date,
extract(day from payment_date),
TO_CHAR(payment_date,'dd-mm-yyyy hh:mm:ss'),
TO_CHAR(payment_date,'MONTH'),
TO_CHAR(payment_date,'yy.yy')
from payment

--interval: tinh khoang thoi gian giua 2 ngay bat ky:
interval 30 day
select current_date, current_timestamp
rental_date,
return_date,
customer_id,
extract(day from return_date - rental_date)*24 + 
extract(hour from return_date - rental_date) || ' giờ' as rental_hours
from rental

---challenge: tao danh sach thoi gian da thue cua KH id la 35
---tim hieu KH nao co thoi gian thue trung binh longest

select customer_id,
return_date - rental_date as time_rent
from rental
where customer_id=35

select customer_id,
avg(return_date - rental_date) as avg_rent
from rental
group by customer_id
order by avg(return_date - rental_date) desc
