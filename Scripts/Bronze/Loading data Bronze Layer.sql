/* ==============================================================================
=================Truncating and loading files in bronze layer====================
=================================================================================*/

	TRUNCATE TABLE bronze.crm_prd_info;
		
	LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/prd_info.csv'
	INTO TABLE crm_prd_info
	FIELDS TERMINATED BY ','
	OPTIONALLY ENCLOSED BY '"'
	LINES TERMINATED BY '\r\n'
	IGNORE 1 ROWS
		(prd_id, prd_key, prd_nm, prd_cost, prd_line, @prd_start_dt, @prd_end_dt)
	SET
		prd_start_dt = NULLIF(@prd_start_dt,''),
		prd_end_dt   = NULLIF(@prd_end_dt,'');
		
    TRUNCATE TABLE datawarehouse.crm_sales_details;
		
    LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sales_details.csv'
	INTO TABLE datawarehouse.crm_sales_details
	FIELDS TERMINATED BY ','
	OPTIONALLY ENCLOSED BY '"'
	LINES TERMINATED BY '\r\n'
	IGNORE 1 ROWS
		(sls_ord_num, 
		 sls_prd_key,
		 sls_cst_id,
		 sls_ord_dt,
		 sls_ship_dt,
		 sls_due_dt,
		 @sls_sales,
		 @sls_quantity,
		 @sls_price
		)
	SET sls_sales    = NULLIF(@sls_sales, ''),
		sls_quantity = NULLIF(@sls_quantity, ''),
		sls_price    = NULLIF(@sls_price, '');

	TRUNCATE TABLE datawarehouse.erp_cust_az12;
    
    LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/CUST_AZ12.csv'
    INTO TABLE datawarehouse.erp_cust_az12
	FIELDS TERMINATED BY ','
	OPTIONALLY ENCLOSED BY '"'
	LINES TERMINATED BY '\r\n'
	IGNORE 1 ROWS
		(cid,
        bdate,
        gen
        );
        
	TRUNCATE TABLE datawarehouse.erp_loc_a101;
    
    LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/LOC_A101.csv'
    INTO TABLE datawarehouse.erp_loc_a101
	FIELDS TERMINATED BY ','
	OPTIONALLY ENCLOSED BY '"'
	LINES TERMINATED BY '\r\n'
	IGNORE 1 ROWS
		(cid,
        bdate,
        gen
        );
        
        
	TRUNCATE TABLE datawarehouse.erp_px_cat_g1v2;
    
    LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/PX_CAT_G1V1.csv'
    INTO TABLE datawarehouse.erp_px_cat
	FIELDS TERMINATED BY ','
	OPTIONALLY ENCLOSED BY '"'
	LINES TERMINATED BY '\r\n'
	IGNORE 1 ROWS
		(cid,
        bdate,
        gen
        );
        

