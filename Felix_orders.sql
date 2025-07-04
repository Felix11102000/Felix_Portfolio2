#PPIC_Project
use project3;
DESC orders;
SELECT * FROM orders LIMIT 100;

#Update Date
SELECT 
  STR_TO_DATE(OrderDate, '%d/%m/%Y') AS OrderDate_fixed,
  STR_TO_DATE(DeliveryDate, '%d/%m/%Y') AS DeliveryDate_fixed
FROM orders;
UPDATE orders
SET OrderDate = STR_TO_DATE(OrderDate, '%d/%m/%Y'),
    DeliveryDate = STR_TO_DATE(DeliveryDate, '%d/%m/%Y');

##1 On-Time Delivery (OTD) {menghitung berapa persen pesanan yang dikirim <=3 hari }
SELECT 
  OrderNumber,
  OrderDate,
  DeliveryDate,
  DATEDIFF(DeliveryDate, OrderDate) AS lead_time_days
FROM orders;

#1 Hitung OTD (On-Time Delivery) untuk target ≤14 hari
SELECT 
    ROUND(
        SUM(CASE WHEN DATEDIFF(DeliveryDate, OrderDate) <= 14 THEN 1 ELSE 0 END) 
        / COUNT(*) * 100, 2
    ) AS OTD_percent
FROM orders
WHERE 
    DeliveryDate >= OrderDate
    AND DATEDIFF(DeliveryDate, OrderDate) <= 90;

WITH cleaned_orders AS (
    SELECT 
        DATEDIFF(DeliveryDate, OrderDate) AS lead_time_days
    FROM orders
    WHERE DeliveryDate >= OrderDate
      AND DATEDIFF(DeliveryDate, OrderDate) <= 90
)
, categorized AS (
    SELECT 
        CASE 
            WHEN lead_time_days <= 3 THEN '≤3 hari'
            WHEN lead_time_days <= 7 THEN '4–7 hari'
            WHEN lead_time_days <= 14 THEN '8–14 hari'
            WHEN lead_time_days <= 30 THEN '15–30 hari'
            ELSE '31–90 hari'
        END AS kategori_lead_time
    FROM cleaned_orders
)
SELECT 
    kategori_lead_time,
    COUNT(*) AS jumlah_order,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS persentase
FROM categorized
GROUP BY kategori_lead_time
ORDER BY 
    CASE 
        WHEN kategori_lead_time = '≤3 hari' THEN 1
        WHEN kategori_lead_time = '4–7 hari' THEN 2
        WHEN kategori_lead_time = '8–14 hari' THEN 3
        WHEN kategori_lead_time = '15–30 hari' THEN 4
        ELSE 5
    END;
    
###
    CREATE TABLE IF NOT EXISTS kpi_otd_monthly (
    periode VARCHAR(7) PRIMARY KEY,       -- YYYY-MM
    total_order INT,
    on_time_order INT,
    OTD_percent DECIMAL(5,2)
);
###
CREATE TABLE IF NOT EXISTS kpi_lead_time_distribution (
    kategori VARCHAR(20) PRIMARY KEY,
    jumlah_order INT,
    persen DECIMAL(5,2)
);
###
TRUNCATE TABLE kpi_otd_monthly;

INSERT INTO kpi_otd_monthly (periode, total_order, on_time_order, OTD_percent)
SELECT
    DATE_FORMAT(OrderDate, '%Y-%m') AS periode,
    COUNT(*) AS total_order,
    SUM(CASE WHEN DATEDIFF(DeliveryDate, OrderDate) <= 7 THEN 1 ELSE 0 END) AS on_time_order,
    ROUND(SUM(CASE WHEN DATEDIFF(DeliveryDate, OrderDate) <= 7 THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS OTD_percent
FROM orders
WHERE DeliveryDate >= OrderDate AND DATEDIFF(DeliveryDate, OrderDate) <= 90
GROUP BY DATE_FORMAT(OrderDate, '%Y-%m')
ORDER BY periode;
###
TRUNCATE TABLE kpi_lead_time_distribution;

INSERT INTO kpi_lead_time_distribution (kategori, jumlah_order, persen)
SELECT 
    kategori,
    jumlah_order,
    ROUND(jumlah_order * 100.0 / total.total_order, 2) AS persen
FROM (
    SELECT 
        CASE 
            WHEN DATEDIFF(DeliveryDate, OrderDate) <= 3 THEN '≤3 hari'
            WHEN DATEDIFF(DeliveryDate, OrderDate) <= 7 THEN '4–7 hari'
            WHEN DATEDIFF(DeliveryDate, OrderDate) <= 14 THEN '8–14 hari'
            WHEN DATEDIFF(DeliveryDate, OrderDate) <= 30 THEN '15–30 hari'
            ELSE '31–90 hari'
        END AS kategori,
        COUNT(*) AS jumlah_order
    FROM orders
    WHERE DeliveryDate >= OrderDate AND DATEDIFF(DeliveryDate, OrderDate) <= 90
    GROUP BY kategori
) distribusi
CROSS JOIN (
    SELECT COUNT(*) AS total_order
    FROM orders
    WHERE DeliveryDate >= OrderDate AND DATEDIFF(DeliveryDate, OrderDate) <= 90
) total;

SELECT * FROM  kpi_otd_monthly LIMIT 100;
SELECT * FROM  kpi_lead_time_distribution;

CREATE TABLE IF NOT EXISTS late_orders AS
SELECT 
    OrderNumber,
    OrderDate,
    DeliveryDate,
    DATEDIFF(DeliveryDate, OrderDate) AS lead_time_days
FROM orders
WHERE DeliveryDate >= OrderDate
  AND DATEDIFF(DeliveryDate, OrderDate) > 14;
SELECT *FROM late_orders;



    
#Insight Utama
#OTD (≤7 hari) hanya ~5.5%
#Sangat jauh dari target yang ideal. Mayoritas order tidak terpenuhi tepat waktu.
#Sebagian besar order (~59.3%) berada di 15–30 hari.
#Ini menunjukkan lead time yang panjang & tidak efisien.
#Hanya ~21% order selesai dalam 8–14 hari.
#Masih lebih baik, tapi tetap tidak memenuhi SLA ≤7 hari.
#Ada ~14% order yang bahkan >30 hari.
#Sangat perlu perhatian untuk perbaikan.

##Rekomendasi
#Audit proses end-to-end untuk identifikasi bottleneck.
# Segmentasi data lebih detail (per gudang, per produk, per tim).
#Tentukan target SLA yang lebih realistis (misal ≤14 hari dulu).
#Tingkatkan stok safety & kapasitas distribusi.
#Bangun monitoring KPI secara rutin (contohnya dashboard).







