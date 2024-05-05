PROBLEM SOLVING:
  Hiểu vấn đề: outcome là gì? nguồn dữ liệu chứa outcome? ttin có sẵn và phái sinh
  Chia nhỏ vấn đề: Bảng chưa có lấy ở đâu? Các bước để có các trường phái sinh?
  KH hành động: Mỗi bước nhỏ cho vào CTEs
  Triển khai: Kiểm tra outcome ở mỗi CTEs, nên đặt tên mỗi CTEs theo step
  Review: Test & Fix bug
--1. BASIC QUERY
SELECT cột FROM bảng AS cot
SELECT DISTINCT cột FROM bảng AS "Cột" --dùng TV thêm ""

ORDER BY cột ASC/DESC -- mặc định là ASC: sắp xếp cột theo
LIMIT số: giới hạn số dòng -- luôn đặt ở cuối cùng

--2. FILTERING
WHERE cột is null: lọc các giá trị của cột trống
WHERE cột > 10 -- các dấu: >, <, > =, < =, < > / ! =

AND/OR: điều kiện cùng,và/hoặc
WHERE (customer_id = 322 OR customer_id=346 OR customer_id=354) AND (amount <2 OR amount >10)

BETWEEN 'giá trị 1' AND 'giá trị 2': trong khoảng từ giá trị 1 đến giá trị 2
BETWEEN 'yyyy-mm-dd' AND 'yyyy-mm-dd'

IN(a, b, c): giá trị thuộc trong nhóm a, b, c

LIKE: Các trường có chung đặc điểm
cột LIKE 'J%' -- bat dau bang J
cột LIKE '%N' -- ket thuc bang chu N
cột LIKE '%N%' -- co chua chu N
cột LIKE '__N%' -- co chu thu 3 la N

HAVING: lọc dữ liệu sau GROUP BY -- HAVING sau GROUP BY - WHERE sau FROM

--3. GROUPING
GROUP BY: tính toán tổng hợp trên trường thông tin sau khi đã được gom nhóm
SELECT  cột1,cột2,
SUM(),
AVG(),
MIN(),
MAX()
FROM bảng
GROUP BY cột1,cột2

--4. BUILT-IN FUNCTION
--4.1. AGGREGATE FUNCTIONS - HÀM TỔNG HỢP
SUM()
AVG()
MIN()
MAX()
COUNT()

--4.2. SCALAR FUNCTION
---STRING:
LENGTH(cột): đếm ký tự cột
LOWER(cột): viết thường
UPPER(cột): viết hoa

LEFT(cột,số): lấy số ký tự từ bên trái
RIGHT(cột, số): lấy số ký tự từ bên phải

CONCAT('cụm'/cột1,...n) - 'cụm'/cột1 || 'cụm'/cột2 || ...n: nối
POSITION('kí tự' in cột)
SUBSTRING(cột from vị trí for số lượng): trích xuất cụm ký tự theo vị trí và số lượng nhất định trong cột
REPLACE(cột/cụm kí tự,'kí tự cần thay thế','kí tự mới')

---MATHEMATICAL
ABS(): lấy giá trị tuyệt đối (-24 = 24)
ROUND(cột,số): làm tròn số số thập phân (24.444 = 24.44)
CEILING(): làm tròn lên số nguyên lớn hơn gần nhất (25)
FLOOR(): làm tròn xuống số nguyên bé hơn gần nhất (24)
--more: https://learn.microsoft.com/en-us/sql/t-sql/functions/mathematical-functions-transact-sql?view=sql-server-ver16

---DATE AND TIME
EXTRACT(FIELD FROM NGÀY/THÁNG/KHOẢNG THỜI GIAN(INTERVAL): trích xuất trường mong muốn từ cụm/khoảng thời gian
Field: DATE/TIME/MONTH/DOW...
--more: https://www.w3schools.com/sql/func_mysql_extract.asp
INTERVAL số FIELDS: tính khảong thời gian bất kỳ
INTERVAL 30 days

SELECT TIMESTAMP('2017-12-31 00:00:10', '10:20:40') => 2017-12-31 10:20:50

---CONVERSION
TO_CHAR(cột, định hạng): đổi định dạng cột (text)
  TO_CHAR(payment_date,'dd-mm-yyyy hh:mm:ss'),
  TO_CHAR(payment_date,'MONTH'),
  TO_CHAR(payment_date,'yy.yy')
--more: https://www.techonthenet.com/oracle/functions/to_char.php

--5. JOIN & UNION
---JOIN
Select t1.*,t2.*
from table1 as T1
INNER/LEFT/RIGHT/FULL JOIN table2 as T2
ON t1.key1=t2.key2

INNER JOIN: trả về những trường trùng nhau
LEFT JOIN(gốc sau from)/RIGHT JOIN(gốc sau right join): trả tất cả giá trị của bảng gốc, bảng quy chiếu sẽ có Null
FULL JOIN: trả về tất cả giá trị ở các bảng -> có thể có null
---UNION
--Nối n bảng theo chiều dọc
  --Cần trùng cột
Select col1,col2,col3...coln
from table1
UNION/UNION ALL
select col1,col2,col3...coln
from table2
UNION/UNION ALL
select col1,col2,col3...coln
from table3

--6. SUBQUERY & TEMPORARY TABLE
---Để xử lý các vấn đề phức tạp
  ---Thường dùng cte cho dễ đọc
---SUBQUERIES in WHERE
(tìm tất cả hóa đơn của KH tên là Adam)
->
Select * from payment
where customer_id=(select customer_id from customer
where first_name='MARY') --dùng dấu = khi sub trả 1 kết quả duy nhất
where customer_id in (select customer_id from customer) -- dùng IN khi sub trả nhiều kết quả
  
---SUBQUERIES in FROM
(Tim nhung khach hang co nhieu hon 30 hoa don)
->
Select customer.first_name,customer.last_name,new_table.customer_id,new_table.so_luong from
(Select customer_id, count(payment_id) as so_luong from payment
group by customer_id) as NEW_TABLE
inner join customer on new_table.customer_id=customer.customer_id
where so_luong>30

---SUBQUERIES in SELECT
----Kết quả sub chỉ được là 1 giá trị
(Tim so tien chenh lech cua 1 hoa don voi so tien thanh toan max cong ty da nhan duoc)
->
Select payment_id, amount,
(select max(amount) from payment) as max_amount,
(select max(amount) from payment) - amount as diff
from payment

---CORRELATED SUB: bảng con có điều kiện phụ thuộc vào bảng chính
Select *
from customer as a
where customer_id =(Select customer_id
					from payment as b
					where b.customer_id=a.customer_id ---Điều kiện phụ thuộc -> có thể dùng = thay vì dùng IN
group by customer_id
having sum(amount)>100)
HOẶC dùng EXISTS : chỉ sử dụng trong sub
Select *
from customer as a
where EXISTS(Select customer_id
					from payment as b
					where b.customer_id=a.customer_id ---neu muon dung = thay vi in
group by customer_id
having sum(amount)>100)
**SAME trong WHERE/FROM/SELECT

---CTE: Bảng chứa dữ liệu tạm thời, coi như bảng bthg
  --phải bôi khi chyaj lệnh
WITH ten_bang
AS (
Select *
FROM bang
WHERE...)
Select * from ten_bang

--7. WINDOW FUNCTION
