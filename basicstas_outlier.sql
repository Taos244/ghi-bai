Select * from user_data;
--1. Sử dụng Boxplot tìm ra outlier
---Tìm Q1 Q3 IQR
---Xác định Min Max
with minmaxvalue as(
Select Q1-1.5*IQR as min, Q3+1.5*IQR as max
from
(Select 
percentile_cont(0.25) WITHIN GROUP (ORDER BY users) as Q1,
percentile_cont(0.75) WITHIN GROUP (ORDER BY users) as Q3,
percentile_cont(0.75) WITHIN GROUP (ORDER BY users)
-percentile_cont(0.25) WITHIN GROUP (ORDER BY users) as IQR
from user_data) as a)
--Xác định outlier <min hoặc >max
Select * from user_data
where users<(select min from minmaxvalue)
or users >(select max from minmaxvalue)

--2. Xác định outlier bằng Z score
---Z-score=(users-avg)/stddev

Select avg(users), stddev(users)
from user_data

with cte as(
select data_date,users,
(Select avg(users)
from user_data) as avg,
(Select stddev(users)
from user_data) as stddev
from user_data)

,Twt_outlier as(
Select data_date,users,
(users-avg)/stddev as Z_score
from cte
where abs((users-avg)/stddev)>2)

UPDATE user_data
SET users=(Select avg(users)
from user_data)
where users in(Select users from Twt_outlier)
--hoặc
DELETE from user_data
where users in(Select users from Twt_outlier)


--Xử lý dữ liệu trùng lặp
Select * from address; --dang ở data greencycle

Select count(address) from address;
Select count(distinct address) from address --han che dung de tim/xu ly trung lap
select * from
(Select *,
row_number() over(partition by address order by last_update desc) as stt
from address) as a
where stt>1

Select * from address
where address = '1074 Binzhou Manor' --loại cũ hơn
