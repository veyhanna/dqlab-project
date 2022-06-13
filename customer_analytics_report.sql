#Memahami table
  select * from orders_1 limit 5;
  select * from orders_2 limit 5;
  select * from customer limit 5;

#Total Penjualan dan Revenue pada Quarter-1 (Jan, Feb, Mar) dan Quarter-2 (Apr,Mei,Jun)
	select sum(quantity) as total_penjualan,
		sum(quantity*priceeach) as revenue
	from orders_1
	where status = 'Shipped';

	select sum(quantity) as total_penjualan,
		sum(quantity*priceeach) as revenue
	from orders_2
	where status = 'Shipped';
  
#Menghitung persentasi keseluruhan penjualan
 Select quarter, 
		sum(quantity) as total_penjualan,
		sum(quantity*priceeach) as revenue
	from 
	(
		select orderNumber, 
			status, 
			quantity, 
			priceeach, 
			'1' as quarter
		from orders_1
		union 
		select orderNumber, 
			status, 
			quantity, 
			priceeach, 
			'2' as quarter
		from orders_2
	) as tabel_a
	where status = 'shipped'
	group by quarter;
  
#Apakah jumlah customers xyz.com semakin bertambah?
	select quarter, count(distinct customerID) as total_customers
	from
	(
		select customerID, createDate, quarter(createDate) as quarter
		from customer
		where createDate >= '2004-01-01' and createDate <= '2004-06-31'
	) as tabel_b
	group by quarter;
  
#Seberapa banyak customers tersebut yang sudah melakukan transaksi?
	select quarter, 
	count(distinct customerID) as total_customers
	from (
		select customerID, createDate, quarter(createDate) as quarter
		from customer
		where (createDate between '2004-01-01' and '2004-06-30')
		and (customerID in (
			select distinct customerID from orders_1
			union
			select distinct customerID from orders_2)))
	as tabel_b
	group by quarter;

#Category produk apa saja yang paling banyak di-order oleh customers di Quarter-2?
	select left(productCode,3) as categoryid,
		count(distinct orderNumber) as total_order,
		sum(quantity) as total_penjualan
	from (
		select productCode, 
			orderNumber, 
			quantity, 
			status
		from orders_2
		where status = 'Shipped') as tabel_c
	group by categoryid
	order by total_order desc;
  
#Seberapa banyak customers yang tetap aktif bertransaksi setelah transaksi pertamanya?
  #Menghitung total unik customers yang transaksi di quarter_1
	SELECT COUNT(DISTINCT customerID) as total_customers FROM orders_1;
	#output = 25

	select 1 as quarter,
		count(distinct customerID)*100/25 as Q2
	from orders_1
	where customerID in 
		(select distinct customerID
		from orders_2);
