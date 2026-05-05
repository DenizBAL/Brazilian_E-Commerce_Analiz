/*
Proje: Netflix Veri Seti Analizi
Yazar: Deniz BAL
Açıklama: Brazilian E-Commerce: Operasyonel Performans & Lojistik Analizi
Tarih: 2026-05-05
*/

---- VERİ ANALİZİ (DATA ANALYSIS)

--Multi Join denemesi
SELECT TOP 10
	o.order_id,
	c.customer_city,
	p.product_category_name,
	pay.payment_type,
	rev.review_score
FROM olist_orders_dataset o
JOIN olist_customers_dataset c 
ON c.customer_id=o.customer_id
JOIN olist_order_items_dataset oi 
ON oi.order_id=o.order_id
JOIN olist_products_dataset p 
ON oi.product_id=p.product_id
JOIN olist_order_payments_dataset pay 
ON pay.order_id=o.order_id
JOIN olist_order_reviews_dataset rev 
ON rev.order_id=o.order_id

----Ençok sipariş alan şehirler ve toplam harcaması.
SELECT 
	COUNT(DISTINCT o.order_id ) AS 'Toplam Sipariş Sayısı',
	c.customer_city,
	SUM(oi.price) as 'Toplam Ciro'
FROM olist_orders_dataset o
JOIN olist_customers_dataset c 
ON o.customer_id=c.customer_id
JOIN olist_order_items_dataset oi 
ON oi.order_id=o.order_id
GROUP BY c.customer_city
ORDER BY 'Toplam Ciro' DESC;
--sao paulo ve rio de janeiro metropol şehirleri toplam cironun büyük kısmını oluşturuyor.

---- Müşterilerin süreklilik analizi.
SELECT 
    CASE 
    WHEN Siparis_Sayisi > 1 THEN 'Tekrar Sipariş Veren Müşteri' ELSE 'Tek Seferlik Sipariş Veren Müşteri' END AS Musteri_Tipi,
    COUNT(*) AS Musteri_Sayisi
FROM (
    SELECT c.customer_unique_id, COUNT(o.order_id) AS Siparis_Sayisi
    FROM olist_customers_dataset c
    JOIN olist_orders_dataset o 
    ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
) AS Musteri_Ozet
GROUP BY CASE 
         WHEN Siparis_Sayisi > 1 THEN 'Tekrar Sipariş Veren Müşteri' ELSE 'Tek Seferlik Sipariş Veren Müşteri' END;
-- Müşterilerin büyük çoğunluğu tek seferlik alışveriş yapmaktadır.

---- Şirketin Lojistik performansı (Gecikme günü)
SELECT 
    c.customer_state,
    COUNT(o.order_id) AS Toplam_Siparis,
    AVG(DATEDIFF(day, o.order_purchase_timestamp, order_delivered_customer_date)) AS 'Ort_Fiili_Teslimat_Suresi (Gün)',
    AVG(DATEDIFF(day, o.order_purchase_timestamp, order_estimated_delivery_date)) AS 'Ort_Tahmini_Teslimat_Suresi (Gün)',
    AVG(DATEDIFF(day, o.order_estimated_delivery_date, order_delivered_customer_date)) AS Sapma_Gunu
FROM olist_orders_dataset o
JOIN olist_customers_dataset c 
ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered' AND o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY Sapma_Gunu DESC;
-- Şirketin şipariş teslimatı 8-20 gün arasında geçikmeler oluyor. Bu şehirlerin lojistik partnerleri değiştirilmesi gerekmektedir. 

---- Kargoların gecikme ve puanlama kıyaslaması.
SELECT 
    CASE 
        WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 'Zamanında/Erken'
        WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 'Geç Teslimat'
        ELSE 'Teslim Edilmedi/İptal' 
    END AS Teslimat_Durumu,
    COUNT(*) AS Siparis_Sayisi,
    ROUND(AVG(CAST(r.review_score AS FLOAT)),2) AS Ortalama_Yorum_Puani
FROM olist_orders_dataset o
JOIN olist_order_reviews_dataset r 
ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
GROUP BY 
    CASE 
        WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 'Zamanında/Erken'
        WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 'Geç Teslimat'
        ELSE 'Teslim Edilmedi/İptal' 
    END;
-- 7700 Adet sipariş geç teslim edildi. Yorum puanı düşük 2.5 ortalama ile düşük kalmıştır. Siparişlerin ilgili olan lojistik partnerlerle sorunun giderilmesi gerekir.

----Kargo Ücreti analizi (Kargo yük oranına göre)
SELECT 
    p.product_category_name,
    ROUND(AVG(oi.price),2) AS Ort_Urun_Fiyatı,
    ROUND(AVG(oi.freight_value),2) AS Ort_Kargo_Ucreti,
    ROUND((AVG(oi.freight_value) / AVG(oi.price)) * 100,2) AS Kargo_Yuk_Oranı
FROM olist_order_items_dataset oi
JOIN olist_products_dataset p 
ON oi.product_id = p.product_id
GROUP BY p.product_category_name
HAVING AVG(oi.price) > 0
ORDER BY Kargo_Yuk_Oranı DESC;

----Şirket Büyüme raporu
SELECT 
    YEAR(o.order_purchase_timestamp) AS Yil,
    MONTH(o.order_purchase_timestamp) AS Ay,
    COUNT(o.order_id) AS Siparis_Sayisi,
    SUM(oi.price) AS Aylik_Ciro
FROM olist_orders_dataset o
JOIN olist_order_items_dataset oi 
ON o.order_id = oi.order_id
GROUP BY YEAR(o.order_purchase_timestamp), MONTH(o.order_purchase_timestamp)
ORDER BY Yil, Ay;
