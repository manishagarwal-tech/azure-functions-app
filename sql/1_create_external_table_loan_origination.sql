IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseParquetFormat') 
    CREATE EXTERNAL FILE FORMAT [SynapseParquetFormat] 
    WITH ( FORMAT_TYPE = PARQUET)
GO

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = '{storage_account_name}_dfs_core_windows_net') 
    CREATE EXTERNAL DATA SOURCE [{storage_account_name}_dfs_core_windows_net] 
    WITH (
        LOCATION   = 'abfss://{container_name}@{storage_account_name}.dfs.core.windows.net',
        CREDENTIAL = gen2_credentails
    )
GO

DROP EXTERNAL TABLE IF EXISTS dbo.{table_name};
GO

CREATE EXTERNAL TABLE dbo.{table_name} (
    [fico] nvarchar(4000),
	[dt_first_p] nvarchar(4000),
	[flag_fthb] nvarchar(4000),
	[dt_matr] nvarchar(4000),
	[cd_msa] nvarchar(4000),
	[mi_pct] nvarchar(4000),
	[cnt_units] nvarchar(4000),
	[occpy_sts] nvarchar(4000),
	[cltv] nvarchar(4000),
	[dti] nvarchar(4000),
	[orig_upb] nvarchar(4000),
	[ltv] nvarchar(4000),
	[orig_int_r] nvarchar(4000),
	[channel] nvarchar(4000),
	[ppmt_pnlty] nvarchar(4000),
	[amrtzn_type] nvarchar(4000),
	[st] nvarchar(4000),
	[prop_type] nvarchar(4000),
	[zipcode] nvarchar(4000),
	[id_loan] nvarchar(4000),
	[loan_purpose] nvarchar(4000),
	[orig_loan_term] nvarchar(4000),
	[cnt_borr] nvarchar(4000),
	[seller_name] nvarchar(4000),
	[servicer_name] nvarchar(4000),
	[flag_sc] nvarchar(4000),
	[id_loan_p] nvarchar(4000),
	[ind_afdl] nvarchar(4000),
	[ind_harp] nvarchar(4000),
	[cd_ppty_v] nvarchar(4000),
	[flag_int_o] nvarchar(4000),
	[ind_mi_cncl] nvarchar(4000)
)
WITH (
    LOCATION = '{location}',
    DATA_SOURCE = [{storage_account_name}_dfs_core_windows_net],
    FILE_FORMAT = [SynapseParquetFormat]
)
GO