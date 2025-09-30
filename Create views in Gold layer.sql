/*======================================================================================================
DDL script : creating view in gold layer
--------------------------------------------------------------------------------------------------------
These tables represents cleaned, enriched and business ready dataset.
=======================================================================================================*/


create database gold;

drop view if exists gold.dim_customer;
create view gold.dim_customer as
select
	row_number() over (order by cst_id) as customer_key,
	ci.cst_id as customer_id,
	ci.cst_key as customer_number,
	ci.cst_firstname as first_name,
	ci.cst_lastname as last_name,
	lo.cntry as country,
	ci.cst_marital as marital_status,
	case when ci.cst_gender != 'N/A' then ci.cst_gender
		else coalesce(ca.gen, 'N/A') 
	end as gender,
	ca.bdate as birthdate,
	ci.cst_create_date as created_date
from crm_cust_info ci, erp_cust ca, erp_loc lo
where ca.cid = ci.cst_key
and lo.cid = ci.cst_key;

drop view if exists gold.dim_product;
create view gold.dim_product as
select 
	 row_number() over (order by pi.prd_start_dt, pi.prd_key) as product_key,
	 pi.prd_id as product_id,
	 pi.prd_key as product_number,
	 pi.prd_nm as product_name,
	 pi.cat_id as category_id,
	 pc.cat as category,
	 pc.subcat as subcategory,
	 pc.maintenance as maintenance,
	 pi.prd_cost as product_cost,
     pi.prd_line as product_line,
	 pi.prd_start_dt as product_start_date
	from crm_prd_info pi, erp_px_cat pc
where pi.cat_id = pc.id
and
prd_end_dt is null;


drop view if exists gold.fact_sales;
create view gold.fact_sales as
select 
si.sls_ord_num as order_number,
ci.customer_key,
pi.product_key,
si.sls_ord_dt as order_date,
si.sls_ship_dt as shipping_date,
si.sls_due_dt as due_date,
si.sls_sales as sales_amount,
si.sls_quantity as quantity,
si.sls_price as price
from crm_sales_details si, gold.dim_customer ci, gold.dim_product pi
where si.sls_cst_id = ci.customer_id
and si.sls_prd_key = pi.product_number;


