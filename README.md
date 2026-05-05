/*
Proje: Netflix Veri Seti Analizi
Yazar: Deniz BAL
Açıklama: Brazilian E-Commerce: Operasyonel Performans & Lojistik Analizi
Tarih: 2026-05-05
*/

## 📌 Proje Hakkında
Bu proje, Brezilya'nın en büyük pazar yeri olan Olist platformuna ait 2016-2018 yılları arasındaki gerçek verileri (100k sipariş) kapsamaktadır. Analizin temel amacı; 
ham veriyi işleyerek şirket büyümesi, lojistik darboğazlar ve müşteri memnuniyeti arasındaki bağları SQL kullanarak ortaya çıkarmaktır. 
Dokuz farklı tablonun birbiriyle ilişkilendirilmesini, karmaşık veri temizleme (data imputation) süreçlerini ve operasyonel verimlilik metriklerinin hesaplanmasını içerir.

## 🔍 Analiz Odak Noktaları
Data Cleaning: Eksik verilerin (NULL) iş mantığına göre doldurulması ve veri tutarlılığının sağlanması.
Business Growth: Yıllık ve aylık bazda ciro ve sipariş hacmi trendleri.
Logistics Performance: Tahmini vs. gerçekleşen teslimat sürelerinin eyalet bazlı karşılaştırılması.
Customer Satisfaction: Teslimat gecikmelerinin müşteri yorum puanlarına (Review Score) doğrudan etkisi.

## 📂 Veri Modeli (ER Diagram)
Analizde kullanılan tablolar arasındaki ilişkileri anlamak için aşağıdaki şema baz alınmıştır:
![Dıagram](assets/Dıagram.png)

Veri temizleme (Data Cleaning)
![bos_sıparısler](assets/bos_sıparısler.png)


## 📊 Öne Çıkan Bulgular
-Multi joın denemesi
![Multijoın_denemesi](assets/Multijoın_denemesi.png)
-sao paulo ve rio de janeiro metropol şehirleri toplam cironun büyük kısmını oluşturuyor.
![en_cok_harcama_yapan_sehirler](assets/en_cok_harcama_yapan_sehirler.png)
-Müşterilerin büyük çoğunluğu tek seferlik alışveriş yapmaktadır.
![Müsteri_süreklilik_analizi](assets/Müsteri_süreklilik_analizi.png)
-Şirketin şipariş teslimatı 8-20 gün arasında geçikmeler oluyor. Bu şehirlerin lojistik partnerleri değiştirilmesi gerekmektedir.
![Lojistik_performans](assets/Lojistik_performans.png)
-7700 Adet sipariş geç teslim edildi. Yorum puanı düşük 2.5 ortalama ile düşük kalmıştır. Siparişlerin ilgili olan lojistik partnerlerle sorunun giderilmesi gerekir.
![Kargo_gecikme_ve_puanlama](assets/Kargo_gecikme_ve_puanlama.png)
-Kargo Ücreti analizi (Kargo yük oranına göre)
![Kargo_yük_oranı_ve_kargo_ücreti](assets/Kargo_yük_oranı_ve_kargo_ücreti.png)
-Şirket Büyüme raporu
![Sirket_büyüme_ciro](assets/Sirket_büyüme_ciro.png)

-- 2017 yılında 1 yıl içinde ciro 9 kat büyüme göstermiştir. Reklam ve pazarlama stratejisi kazançlı çıkmıştır. Şirket 'Black friday' etkisine önem verip, yatırım yapmıştır. 
-- 2018 yılında olis şirketi sipariş sayısını 7000-8000 arasında tutmuştur. Şirket büyümek yerine elde olan müşterilere yatırımda bulunmuş gibi görünüyor.
-- 2018 9. ayında veri toplama sona erdiği görülmüştür.

## 📬 İletişim
Bu proje ile ilgili sorularınız veya önerileriniz için benimle [LinkedIn profilim](https://www.linkedin.com/in/deniz-bal-64838b225) üzerinden iletişime geçebilirsiniz.



