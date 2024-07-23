IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseParquetFormat') 
    CREATE EXTERNAL FILE FORMAT [SynapseParquetFormat] 
    WITH ( FORMAT_TYPE = PARQUET)
GO

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = '{storage_account_name}_dfs_core_windows_net') 
    CREATE EXTERNAL DATA SOURCE [{storage_account_name}_dfs_core_windows_net] 
    WITH (
        LOCATION   = 'abfss://{container_name}@{storage_account_name}.dfs.core.windows.net',
        CREDENTIAL = serverless_credentails
    )
GO

-- DROP EXTERNAL TABLE IF EXISTS dbo.{table_name};
-- GO

CREATE EXTERNAL TABLE dbo.{table_name} (
    [id_loan] nvarchar(4000),
	[period] nvarchar(4000),
	[curr_act_upb] nvarchar(4000),
	[delq_sts] nvarchar(4000),
	[loan_age] nvarchar(4000),
	[mths_remng] nvarchar(4000),
	[dt_dfct_setlmt] nvarchar(4000),
	[flag_mod] nvarchar(4000),
	[cd_zero_bal] nvarchar(4000),
	[dt_zero_bal] nvarchar(4000),
	[cur_int_rt] nvarchar(4000),
	[cur_dfrd_upb] nvarchar(4000),
	[dt_lst_pi] nvarchar(4000),
	[mi_recoveries] nvarchar(4000),
	[net_sale_proceeds] nvarchar(4000),
	[non_mi_recoveries] nvarchar(4000),
	[expenses] nvarchar(4000),
	[legal_costs] nvarchar(4000),
	[maint_pres_costs] nvarchar(4000),
	[taxes_ins_costs] nvarchar(4000),
	[misc_costs] nvarchar(4000),
	[actual_loss] nvarchar(4000),
	[modcost] nvarchar(4000),
	[stepmod_ind] nvarchar(4000),
	[dpm_ind] nvarchar(4000),
	[eltv] nvarchar(4000),
	[zb_removal_upb] nvarchar(4000),
	[dlq_acrd_int] nvarchar(4000),
	[disaster_area_flag] nvarchar(4000),
	[borr_assist_ind] nvarchar(4000),
	[monthly_modcost] nvarchar(4000),
	[amt_int_brng_upb] nvarchar(4000)
)
WITH (
    LOCATION = '{location}',
    DATA_SOURCE = [{storage_account_name}_dfs_core_windows_net],
    FILE_FORMAT = [SynapseParquetFormat]
)
GO