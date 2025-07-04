# 📦 On Time Delivery (OTD) Dashboard

## 📊 Deskripsi
Dashboard ini dibuat untuk memantau performa *On Time Delivery* (OTD) dari order yang diproses di perusahaan.  
Tujuan utamanya adalah memberikan informasi cepat & mudah dipahami tentang:
- Persentase pengiriman tepat waktu (*OTD%*)
- Distribusi lead time (waktu dari order hingga pengiriman)
- Daftar order yang terlambat
- Tren OTD per bulan
- Rata-rata OTD keseluruhan

Dashboard ini membantu manajemen untuk mengambil keputusan berbasis data dalam meningkatkan performa OTD.

---

## 📄 Fitur Utama
✅ **Trend OTD Per Bulan** — melihat tren OTD sejak Juli 2018  
✅ **Distribusi Lead Time** — distribusi waktu kirim per kategori hari  
✅ **Daftar Order Terlambat** — detail order yang ≥14 hari  
✅ **Ringkasan KPI** — total order, OTD bulan terakhir, rata-rata OTD  
✅ **Filter Periode** — pilih tahun untuk fokus analisis  

---

## 🛠️ Tools & Teknologi
- 📂 **Database**: MySQL
- 📊 **Visualisasi**: Power BI
- 🔎 **Bahasa Query**: SQL

---

## 🚀 Cara Kerja
1️⃣ Data order diambil dari database MySQL dengan query SQL.  
2️⃣ Data dibersihkan & dihitung lead time serta OTD%.  
3️⃣ Data diimpor ke Power BI untuk divisualisasikan.  
4️⃣ Dashboard interaktif dengan filter & indikator KPI.

---

## 📈 Insights
- Tren OTD cenderung stabil, namun masih rendah (sekitar 2–6%).
- Mayoritas order dikirim ≤15 hari (59%), namun ada order dengan lead time >14 hari yang signifikan & butuh perhatian.

---

## 🎯 Rekomendasi untuk Perusahaan
Berdasarkan temuan, berikut 2 rekomendasi utama untuk meningkatkan performa OTD:
1️⃣ **Analisis Penyebab Keterlambatan**  
Identifikasi akar penyebab order terlambat (stok, produksi, logistik) & buat rencana perbaikan pada titik yang paling sering bermasalah.

2️⃣ **Implementasi Sistem Monitoring & Alert**  
Bangun sistem notifikasi untuk order yang mendekati batas SLA, agar tim dapat segera menindaklanjuti sebelum terlambat.

---

## 🔗 SQL Query
Query lengkap yang digunakan untuk membersihkan & menghitung data tersedia di file berikut:  
📄 [query.sql](./query.sql)

---

## 📂 File
- `OTD_Dashboard.pbix` — file Power BI dashboard
- `query.sql` — query SQL untuk membersihkan & menyiapkan data
- `README.md` — dokumentasi proyek

## 👨‍💻 Author
📝 Felix Usmany  
📧 [felixusmany1110@gmail.com]  
🌐 [https://www.linkedin.com/in/felix-usmany-346002351/]


