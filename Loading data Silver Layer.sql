/*========================================================================================================
Data transformation of CRM files like 
	--removing duplicates
    --handing missing data
    --normalization and standardization
    --data filtering
    --handling invalid values
    --data type casting
 
=========================================================================================================*/

insert into Silver.crm_cust_info(
cst_id,
cst_key,
cst_firstname,
cst_lastname,
cst_marital,
cst_gender,
cst_create_date
)
select 
cst_id,
cst_key,
trim(cst_firstname) as cst_firstname,
trim(cst_lastname) as cst_lastname,
case 
	when upper(trim(cst_gender)) = 'F' then 'Female'
    when upper(trim(cst_gender)) = 'M' then 'Male'
    else 'N/A'							#----------------Normalize gender values to readable format
end as cst_gender,
case 
	when upper(trim(cst_marital)) = 'M' then 'Married'
    when upper(trim(cst_marital)) = 'S' then 'Single'
    else 'N/A'							#----------------Normalize marital status values to readable format
end as cst_marital,
cst_create_date from(
select *,
row_number() over (partition by cst_id order by cst_create_date desc) as updated 
from datawarehouse.crm_cust_info
)t
where updated=1; 						#----------------Select the most recent records per customer

/*========================================================================================================
									Cleaning product information table
=========================================================================================================*/


insert into Silver.crm_prd_info(
prd_id,
cat_id,
prd_key,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
)
select 
prd_id,
replace(substring(prd_key,1,5),'-', '_') as cat_id,  #----------------Extracting category ID
substring(prd_key,7, length(prd_key)) as prd_key,	 #----------------Extracting Product key
prd_nm,
coalesce(nullif(prd_cost, ''),0) as prd_cost,
case trim(prd_line) 
	when 'R' then 'Road'
    when 'S' then 'Other Sales'
	when 'M' then 'Mountain'
    when 'T' then 'touring'
    else 'N/A'
end as prd_line,									#----------------Mapping product line to descriptive values
prd_start_dt,
date_sub(lead(prd_start_dt) over(partition by prd_key order by prd_start_dt), interval 1 day)
		as prd_end_dt_test								#----------------Calculating end date as one day before the next start date
from 
crm_prd_info
;

/*========================================================================================================
									Cleaning Sales details table 
=========================================================================================================*/

insert into Silver.crm_sales_details(
sls_ord_num,
sls_prd_key,
sls_cst_id,
sls_ord_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price
)
select 
sls_ord_num,
sls_prd_key,
sls_cst_id,
case
	when sls_ord_dt=0 or length(sls_ord_dt) !=8 then null
	else cast(cast(sls_ord_dt as char) as date) 			
end as sls_ord_dt,
case 
	when sls_ship_dt =0 or length(sls_ship_dt) != 8 then null
    else cast(cast(sls_ship_dt as char) as date)
end as sls_ship_dt,
case 
	when sls_due_dt =0 or length(sls_due_dt) != 8 then null
    else cast(cast(sls_due_dt as char) as date)
end as sls_due_dt,
case when sls_sales<=0 or sls_sales is null or sls_sales != sls_quantity * abs(sls_price) 
	 then abs(sls_quantity * sls_price)
     else sls_sales
end as sls_sales,								#----------------Recalculating sales if the original value is missing or incorrect
sls_quantity,
case when sls_price<=0 or sls_price is null 
	then round(sls_sales/ nullif(sls_quantity,0))
	else sls_price							   #----------------Derive price values if original value is incorrect
end as sls_price
from datawarehouse.crm_sales_details;

/*========================================================================================================
Data transformation of ERP files 
=========================================================================================================*/

insert into Silver.erp_cust_az12(
cid,
bdate,
gen)
select
case 
	when cid like 'NAS%' then substring(cid, 4, length(cid))
    else cid
end as cid,											#------------Deriving category ID 
case
	when bdate >curdate() then null
	else bdate
end as bdate,
case 
	when upper(trim(gen)) in ('M', 'MALE') then 'Male'
    when upper(trim(gen)) in ('F', 'FEMALE') then 'Female'
	else 'N/A'
end as gen										#-----------------Normalize the gender as readable value
    from datawarehouse.erp_cust_az12;
    
/*========================================================================================================
Cleaning customer location table 
=========================================================================================================*/

insert into Silver.erp_loc(
cid,
cntry
)
select
replace(cid, '-','') cid,						
case 
	when trim(cntry) in ('US','USA') then 'United States'
    when trim(cntry) = 'DE' then 'Germany'
    when trim(cntry) = '' or null then 'N/A'
    else trim(cntry)
end as cntry									#---------------Normalize and handling missing values							
from datawarehouse.erp_loc_a101;

/*========================================================================================================
Cleaning product category table 
=========================================================================================================*/

insert into Silver.erp_px_cat(
id,
cat,
subcat,
maintenance
)
select
id,
cat,
subcat,
maintenance
from datawarehouse.erp_px_cat_g1v2;
/*========================================================================================================
												Completed
=========================================================================================================*/





