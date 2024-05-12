--SEGMENTTATION ANALYSIS USSING SQL
---Phân loại KH bằng mô hình RFM
--Áp dụng sql vào các bài toán RFM

--Concept phân loại KH
1. Nhân khẩu
2. Tâm lý
3. Hành vi -- nhiều insight nhất
4. Địa lý

RFM: Rencency - Frequency - Montery
- Nhận diện các đtg Kh khác nhau
-> Xây dựng ctrinh khác nhau
-> Định hướng nguồn lực mkt hiệu quả
-> Cơ sở xây dựng ctirnh
-> Dự đoán 

B1: Tính giá trị R F M
- Rencency: khoảng tg lần cuối giao dịch tới hiện tại = ngày phân tích - ngày giao dịch gần nhất
  --càng xa cho điểm càng thấp DESC
- Frequency : tần suất giao dịch = tổng số lần mua/(ngày giao dịch gần nhất - ngày giao dịch đầu tiên)
  --tần suất lớn cho điểm càng cao ASC
- Montery: Tổng số tiền Kh đã chi trả = Cộng gộp số tiền KH đã thanh toán
  -- ASC

B2: Chia các giá tị thành khoảng trên thang điểm từ 1-5 hoặc 1-4
B3: Phân nhóm theo 125 tổ hợp RFM - 11 nhóm (bảng quy ước) - https://blog.tomorrowmarketers.org/phan-tich-rfm-la-gi/
B4: Biểu đổ để trả lời câu hỏi
B5: Champion: giữ chân bằng mọi giá ntn, Kh thân thiết, cá nhân hóa cao
Loyal và potential lyoalits: làm thế nào để nâng giá trị giỏ hàng, Ctrinh ưu đãi gắn liền với ngưỡng chi tiêu/hoặc gthieu bạn bè
recent và promissing: Làm thế nào để hài lòng và quay lại mua nhiều lần hơn:quy trình chăm sóc bài bản cá nhân hóa đủ cao để bđ tạo mqh
Customer needing attention và at risk: điều gì khiến họ ko quay lại-> khảo sát tìm nguyên nhân, khắc phục và đề xuất các dvu giá trị hơn thay vì giảm giá để tránh lãng phí ngân khách
about to sleep, hibernating và lost: làm tnso để họ qlai và thường xuyên hơn: retarrgeting, xúc tiến ngắn hạn như voucher, discount giảm giá, ưu đãi độc quyền

 --USING SQL
--B1: Tìm giá trị R F M

Select * from customer;
Select * from sales;
Select * from segment_score;

With customer_rfm as(
Select 
a.Customer_id,
current_date-max(order_date) as R,
Count(distinct order_id) as F,
	--/(max(order_date) - min(order_date)) as F,
Sum(sales) as M
from customer as a
join sales as b on a.customer_id=b.customer_id
Group by a.customer_id)


--B2: chia theo thang điểm từ 1-5
,rfm_score as(Select 
customer_id,
ntile(5) OVER(order by R Desc) as R_score, --chia dataset thành 5 khoảng, order by r chia khoảng
ntile(5) over(order by F) as F_score,
ntile(5) over(order by M) as M_score
from customer_rfm)

--B3: chia theo 125 tổ hợp RFM
, rfm_final as (select customer_id,
cast(r_score as varchar) || cast(f_score as varchar) || cast(m_score as varchar) as RFM_SCORE
from rfm_score)
Select segment, count(*) from(Select a.customer_id, b.segment from rfm_final as a
join segment_score as b on a.rfm_score=b.scores) as a
group by segment
order by count(*)

--B4: trực quan bằng heatmap trên excel
--tự học power BI trên youtube
