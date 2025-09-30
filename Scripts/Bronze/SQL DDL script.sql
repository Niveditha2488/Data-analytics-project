/* 
======================================================================================
DDL Script : Create tables in bronze layer
======================================================================================
*/

drop table if exists crm_cust_info ;
create table crm_cust_info(
cst_id int,
cst_key varchar(50),
cst_firstname varchar(50),
cst_lastname varchar(50),
cst_marital varchar(50),
cst_gender varchar(50),
cst_create_date date
);

drop table if exists crm_prd_info ;
create table crm_prd_info(
prd_id int,
prd_key varchar(50),
prd_nm varchar(50),
prs_cost int,
prd_line varchar(50),
prd_start_dt date,
prd_end_dt date
);

drop table if exists crm_sales_details ;
create table crm_sales_details(
sls_ord0_num varchar(50),
sls_prd_key varchar(50),
sls_cst_id int,
sls_ord_dt date,
sls_ship_dt date,
sls_due_dt date,
sls_sales int,
sls_quantity int,
sls_price int
);

drop table if exists erp_cust_az12;
create table Silver.erp_cust_az12(
cid varchar(50),
bdate date,
gen varchar(50));

drop table if exists erp_loc;
create table Silver.erp_loc(
cid varchar(50),
cntry varchar(50)
);

drop table if exists erp_px_cat;
create table Silver.erp_px_cat(
id varchar(50),
cat varchar(50),
subcat varchar(50),
maintenance varchar(50));




