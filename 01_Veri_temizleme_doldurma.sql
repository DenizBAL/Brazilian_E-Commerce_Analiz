--VERİ TEMİZLİĞİ (DATA CLEANING)

----Veri kalitesini SQL ile kontrol.
SELECT order_id, order_purchase_timestamp, order_delivered_customer_date
FROM olist_orders_dataset
WHERE order_delivered_customer_date < order_purchase_timestamp;
--Teslimat tarihi, sipariş tarihinden önce olan hatalı kayıtlar yoktur.

----Null değerler (Orders): Kargoların null değerleri olabilir silinmemesi gerekiyor çünkü kargolar onaylamada,kargoda veya teslimatta bekliyor olabilir. 
--Silmek yerine beklemede olarak dolduruldu.
SELECT 
    COUNT(*) AS Toplam_Satır,
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS boş_sipraiş_numarası,
    SUM(CASE WHEN order_status IS NULL THEN 1 ELSE 0 END) AS boş_sipariş_durumu,
	SUM(CASE WHEN order_approved_at IS NULL THEN 1 ELSE 0 END) AS sipariş_onaylanmayanlar,
	SUM(CASE WHEN order_delivered_carrier_date IS NULL THEN 1 ELSE 0 END) AS kargolanmayanlar,
    SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END) AS teslim_edilmeyenler
FROM olist_orders_dataset;



----Null değerler (Products): ürünlerin açıklamaları boş kalmıştır. Bu boş değerleri silinmesi ciro hesaplamasını yanlış yapar. Bunun yerine bilinmiyor olarak dolduruldu.
SELECT 
    COUNT(*) AS Toplam_Satır,
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS boş_ürün_numarası,
    SUM(CASE WHEN product_category_name IS NULL THEN 1 ELSE 0 END) AS boş_categori_isimi,
	SUM(CASE WHEN product_name_lenght IS NULL THEN 1 ELSE 0 END) AS boş_ürün_isim_uzunluğu,
	SUM(CASE WHEN product_description_lenght IS NULL THEN 1 ELSE 0 END) AS boş_ürün_açıklama_uzunluğu,
    SUM(CASE WHEN product_photos_qty IS NULL THEN 1 ELSE 0 END) AS boş_ürün_fotoğraf_adedi
FROM olist_products_dataset;


-- Müşterilerde (Customers) boş değerler yoktur.
-- Geolocation (konum) tablosundaki koordinat verilerinin (lat/lng) eksik olduğu tespit edilmiştir. 
-- Bu nedenle analizde koordinat bazlı haritalama yerine, customers ve sellers tablolarındaki city ve state kolonları kullanılarak 
-- bölge bazlı (Aggregated) coğrafi analiz yapılmasına karar verilmiştir.

-- Reviews (Yorumlar) tablosunda müşteriler yorum başlığı ve yorum mesajları yazmamışlar. Müşteriler kargoları aldıktan sonra yorum yazmak zorunda değiller.
-- Sellers (Satıcılar) boş değerler yoktur.

----- VERİ ATAMA (DATA IMPUTATION)

-- Kategori ismini doldurma
UPDATE olist_products_dataset
SET product_category_name = 'bilinmiyor'
WHERE product_category_name IS NULL;

-- Ürün açıklamasını doldurma
UPDATE olist_products_dataset
SET product_description_lenght = 0 -- Sayısal bir kolonsa 0, metinse 'bilinmiyor'
WHERE product_description_lenght IS NULL;

--Ürün isim uzunluğu doldurma
UPDATE olist_products_dataset
SET product_name_lenght = 0
WHERE product_name_lenght IS NULL;

--Ürün fotoğraf adedi doldurma
UPDATE olist_products_dataset
SET product_photos_qty = 0
WHERE product_photos_qty IS NULL;
SELECT * FROM olist_products_dataset

---- Orders içinde Kargoların ve siparişlerin 'beklemede' şeklinde doldurma işlemini analizde kullanmak için yapıldı. Datetime verileri UPDATE ile değiştirilemez.
SELECT 
    order_id,
    ISNULL(CAST(order_approved_at AS VARCHAR), 'Beklemede') AS onaylama_durumu
FROM olist_orders_dataset;
SELECT 
    order_id,
    ISNULL(CAST(order_delivered_carrier_date AS VARCHAR), 'Beklemede') AS kargolanma_durumu
FROM olist_orders_dataset;
SELECT 
    order_id,
    ISNULL(CAST(order_delivered_customer_date AS VARCHAR), 'Beklemede') AS teslimat_durumu
FROM olist_orders_dataset;