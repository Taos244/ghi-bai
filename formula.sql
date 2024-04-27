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
--5. JOIN & UNION
--6. WINDOW FUNCTION
--7. SUBQUERY & TEMPORARY TABLE
