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

--BUOI10
--JOIN & UNION
Join de ket hop 2 bang theo chieu ngang
Union de ket hop 2 ban theo chieu doc

JOIN
--1. Xac dinh khoa key join
--- inner join: join tra ve nhung truong trung nhau
Select t1.*,t2.*
from table1 as T1
INNER JOIN table2 as T2
ON t1.key1=t2.key2

select A.payment_id,A.customer_id,B.first_name,B.last_name
from payment as A
inner join customer as B
ON A.customer_id=B.customer_id

--challenge: hay liet ke co bao nhieu ng chon ghe ngoi theo loai
--business, economy, comfort
--fare_condition va count
select b.fare_conditions,
count(ticket_no) as soluong
from boarding_passes as a
INNER JOIN seats as b
ON a.seat_no=b.seat_no
group by b.fare_conditions

--LEFT JOIN - RIGHT JOIN: giong nhau, thuong chi dung left join
Select t1.*,t2.* --tuy nhu cau
from table1 as T1 ---table 1 sau from la bang goc - tra tat ca gia tri
LEFT JOIN table2 as T2 ---table 2 la bang tham chieu, se co N/A neu ko tim thay
ON t1.key1=t2.key2
--dịch: hiển thị thông tin bảng 1 và bảng 2 sau khi lấy bảng 1 left join bảng 2 thông qua khóa bảng 1 và bảng 2

Select t1.*,t2.* --tuy nhu cau
from table1 as T1 ---table 1 sau from bang tham chieu, se co N/A neu ko tim thay
RIGHT JOIN table2 as T2 ---table 2 la bang la bang goc - tra tat ca gia tri
ON t1.key1=t2.key2
--dịch: hiển thị thông tin bảng 1 và bảng 2 sau khi lấy bảng 1 left join bảng 2 thông qua khóa bảng 1 và bảng 2

---TÌM THÔNG TIN CÁC CHUYẾN BAY CỦA TỪNG MÁY BAY
--B1: xác định bảng
select * from bookings.aircrafts_data;
Select * from flights
--B2: xác định key join:
-> aircraft_code
--B3: chọn phương thức
Select T1.aircraft_code,T2.flight_no
from aircrafts_data as T1
LEFT JOIN flights as T2
ON T1.aircraft_code=T2.aircraft_code
where T2.flight_no is null --neu muon biet may bay nao ko co chuyen bay nao

--challenge
--tim hieu ghe nao duoc dat thuong xuyen nhat: 
--liet ke tat ca cac ghe du chua bao gio duoc dat
--cho ngoi nao chua bao gio duoc dat
--HANG ghe nao duoc dat thuong xuyen nhat

Select T1.seat_no,
count(flight_id) as count_ticket
from seats as t1
LEFT JOIN bookings.boarding_passes as t2
on t1.seat_no=t2.seat_no
Group by t1.seat_no
order by count(flight_id) desc -->1A

Select T1.seat_no
from seats as t1
LEFT JOIN bookings.boarding_passes as t2
on t1.seat_no=t2.seat_no
where T2.seat_no is null --> ko co ghe nao bi trong

Select right(T1.seat_no,1 as line),
count(flight_id) as count_ticket
from seats as t1
LEFT JOIN bookings.boarding_passes as t2
on t1.seat_no=t2.seat_no
Group by right(T1.seat_no,1)
order by count(flight_id) desc --> line A

--FULL JOIN: lay tat ca ban ghi o ca 2 ban, co the null o ca 2 bang
Select t1.*,t2.*
from table1 as T1
FULL JOIN table2 as T2
ON t1.key1=t2.key2

Select * from boarding_passes as a
full join tickets as b
on a.ticket_no=b.ticket_no
where a.ticket_no is null

--JOIN ON MULTIPLE CONDITIONS: CO >2 KEYS
---VD: Tinh gia trung binh cua tung so ghe may bay
--xdinh output, input
Số ghế; Giá trung bình -> input: 

Select a.seat_no,
avg(amount) as AVG
from bookings.boarding_passes as a
LEFT JOIN ticket_flights as b
on a.ticket_no=b.ticket_no and a.flight_id=b.flight_id
group by a.seat_no
order by avg(amount) desc

--JOIN ON MULTIPLE TABLES: join nhiều bảng
--số vé, tên kh, giá vé, giờ bay, giờ kthuc

select a.ticket_no,a.passenger_name,b.amount, c.scheduled_departure, c.scheduled_arrival
from bookings.tickets as a
inner join bookings.ticket_flights as b ON a.ticket_no=b.ticket_no
inner join bookings.flights as c on b.flight_id=c.flight_id

--Challenge
--muon tuy chinh chien dich tuy theo noi khach hang den
--Truy van first_name, last_name, email, quoc gia cua cac khach hang tu Brazil

select a.first_name,a.last_name,a.email,d.country
from public.customer as a
inner join public.address as b on a.address_id=b.address_id
Inner join public.city as c on b.city_id=c.city_id
inner join public.country as d on c.country_id=d.country_id
where d.country='Brazil'

--SELF-JOIN
CREATE TABLE employee (
	employee_id INT,
	name VARCHAR (50),
	manager_id INT
);

INSERT INTO employee 
VALUES
	(1, 'Liam Smith', NULL),
	(2, 'Oliver Brown', 1),
	(3, 'Elijah Jones', 1),
	(4, 'William Miller', 1),
	(5, 'James Davis', 2),
	(6, 'Olivia Hernandez', 2),
	(7, 'Emma Lopez', 2),
	(8, 'Sophia Andersen', 2),
	(9, 'Mia Lee', 3),
	(10, 'Ava Robinson', 3);
	
select emp.employee_id, emp.name as emp_name, emp.manager_id, mng.name as mng_name
from employee as emp
LEFT JOIN employee as mng on emp.manager_id=mng.employee_id
--challenge: tim nhung bo phim co cung thoi luong phim
--title1, title 2, length

Select f1.Title as title1, f2.title as title2, f1.length
from film as f1
Join film as f2 on f1.length=f2.length

--UNION: ghép nối 2 bảng theo chiều dọc
--so luong cot phai giong nhau
--data type phai giong nhau
--UNION loai trung lap, UNION ALL thi ko

Select col1,col2,col3...coln
from table1
UNION/UNION ALL
select col1,col2,col3...coln
from table2
UNION/UNION ALL
select col1,col2,col3...coln
from table3

Select first_name, 'actor' as source from actor
UNION ALL
select first_name,  'customer' as source from customer
UNION ALL
select first_name,  'staff' as source from staff
order by first_name 

--BUOI 12
--SUBQUERIES & CTEs
---Hieu duoc cach dung Subqueries va CTEs de xu ly nhung truy van phuc tap

--SUBQUERIES: truy vaans con trong 1 truy van

--SUBQUERIES IN WHERE
--Tim cac hoa don co so tien lon hon so tien trung binh cac hoa don

Select * from payment
where amount > (Select  avg(amount) from payment)

--tim nhung hoa don cua KH co ten la Adam

Select * from payment
where customer_id=(select customer_id from customer
where first_name='MARY') --dung dau = thi subquery phai tra ra ket qua duy nhat
where customer_id in (select customer_id from customer) -- dung in khi subque=ry ra nhieu ket qua

-- tim nhung bo phim co do dai > trung inh do dai cac bo phim
select film_id, title from film
where length>(select avg(length) from film)

--tim nhung bo phim o store 2 it nhat 3 lan
select film_id, title from film
where film_id in(select film_id from inventory where store_id=2 group by film_id having count(store_id)>=3)

--tim nhung khach hang den tu Abu Dhabi va da chi tieu nhieu hon 100
--co the ket hop join cho nhanh o cac bai thuc te khac
select customer_id, first_name,last_name, email from customer
where customer_id in(select customer_id from payment
group by customer_id
having sum(amount)>100) and address_id in(select address_id from address
where city_id=(select city_id from city
where city='Abu Dhabi'))

--SUBQUERIES IN FROM
--Tim nhung khach hang co nhieu hon 30 hoa don
Select customer.first_name,customer.last_name,new_table.customer_id,new_table.so_luong from
(Select customer_id, count(payment_id) as so_luong from payment
group by customer_id) as NEW_TABLE
inner join customer on new_table.customer_id=customer.customer_id
where so_luong>30

--SUBQUERIES IN Select: ket qua chi duoc la 1 gia tri
Select * ,
(select (avg(amount)) from payment) as avg_amount, 
(select (avg(amount)) from payment) - amount as chenh_lech
from payment

--Tim so tien chenh lech cua 1 hoa don voi so tien thanh toan max cong ty da nhan duoc

Select payment_id, amount,
(select max(amount) from payment) as max_amount,
(select max(amount) from payment) - amount as diff
from payment

--CORRELATED SUBQUERY
--truy van con tuong quan
--CORRELATED SUBQUERY IN WHERE
--lay thong tin khach hang tu bang customer co tong hoa don>100$
---C1:
select a.customer_id, sum(b.amount) as total from customer as a
join payment as b on a.customer_id=b.customer_id
group by a.customer_id
having  sum(b.amount)>100
order by a.customer_id

---C2: tuong quan: where = Truy vấn trên bảng con với điều kiện phụ thuộc vào bảng chính.
Select *
from customer as a
where customer_id =(Select customer_id
					from payment as b
					where b.customer_id=a.customer_id ---neu muon dung = thay vi in, truy van tuong quan
group by customer_id
having sum(amount)>100)

--hoac dung in, truy van bthg
Select *
from customer as a
where customer_id in (Select customer_id
					from payment as b
group by customer_id
having sum(amount)>100)

--co the thay bang exists -> chi su dung trong subquery
Select *
from customer as a
where EXISTS(Select customer_id
					from payment as b
					where b.customer_id=a.customer_id ---neu muon dung = thay vi in
group by customer_id
having sum(amount)>100)

--CORRELATED SUBQUERY IN SELECT
---Liet ke ma KH, ten KH, ma thanh toan, so tien lon nhat cua tung KH
 select customer_id, payment_id,
 (Select max(amount) as max_amount from payment
  where customer_id=a.customer_id
 group by customer_id)
 from payment
 
 Select a.customer_id, a.first_name || a.last_name,b.payment_id,
 (Select max(amount) from payment 
  where customer_id=a.customer_id
 group by customer_id) 
 from customer as a
 join payment as b on a.customer_id=b.customer_id
 group by a.customer_id, a.first_name || a.last_name,b.payment_id
 order by a.customer_id
 
 --challenge
 --Liet ke cac khoan thanh toan voi tong so hoa don, tong so tien moi KH phai tra
 
 Select *,
 (select sum(amount) as sum_amount
 from payment
where customer_id=a.customer_id
 group by customer_id),
 (select count(payment_id) as count_payments
 from payment
 where customer_id=a.customer_id
 group by customer_id)
 from payment as a
 
 --lay danh sach cac phim co chi phi thay the lon nhat trong moi loai rating
 --film_id,title, rating,replacement_cost, avg_replacement_cost
 
 select a.film_id,a.title,a.rating,replacement_cost,
(select avg(replacement_cost) as avg_replacement_cost
from film
where rating=a.rating
group by a.rating)
 from film as a
 where replacement_cost=(select max(replacement_cost) as max_replacement
 from film
 where rating=a.rating
 group by a.rating
order by max(replacement_cost) desc)

--CTEs: Common Table Expression: Bang chua du lieu tam thoi, coi nhu 1 bang bthg
--bot phuc tap hon subquery

WITH ten_bang
AS (
Select *
FROM bang
WHERE...)
Select * from ten_bang

--vidu: liet ke cac khach hang co >30 hoa don
--ket qua can: ma KH, ten KH, so luong hoa don, tong so tien, thoi gian thue trung binh

WITH total_payment
AS (
Select customer_id, count(payment_id) as so_luong, sum(amount) as so_tien
from payment
group by customer_id),
avg_rentaltime
AS(
select customer_id, AVG(return_date - rental_date) as rental_time
from rental
group by customer_id)
Select a.customer_id, a.first_name,b.so_luong,b.so_tien, c.rental_time
from customer as a
join total_payment as b on a.customer_id=a.customer_id
join avg_rentaltime as c on b.customer_id=c.customer_id
where so_luong>30

--tim nhung hoa don co so tien > so tien trung binh kh do chi tieu/moi hoa don
--ket qua tra ra gom: ma KH,ten KH SL hoa don, so tien, so tien trung binh
with twt_soluong
as(
select customer_id,
count (payment_id) as so_luong
from payment group by customer_id),
twt_avgamount
as(
select customer_id,
avg (amount) as avg_amount
from payment group by customer_id)
select a.customer_id, a.first_name, d.amount, b.so_luong,c.avg_amount
from customer as a
join twt_soluong as b on a.customer_id=b.customer_id
join twt_avgamount as c on a.customer_id=c.customer_id
join payment as d on d.customer_id=a.customer_id
where d.amount>c.avg_amount
