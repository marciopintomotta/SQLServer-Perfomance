select
	db_name(smf.database_id) database_name
	,smf.name logical_name
	, smf.file_id 
	, smf.physical_name
	, cast(cast(sfg.name as varbinary(256)) as sysname) file_group_name
	, convert(varchar(10), (smf.size *8)) + 'KB' as size
	, case 
		when smf.max_size = -1 then 'Unlimited' 
		else convert(varchar(10),convert(bigint,smf.max_size)*8) + ' KB'
	  end as max_size
	, case 
		smf.is_percent_growth when 1 then convert(varchar(10),smf.growth) + '%' 
		else convert(varchar(10),smf.growth*8) + ' KB'
	  end growth
	, case 
		when smf.type = 1 then 'Log Only'
		when smf.type = 2 then 'Filestream Only'
		when smf.type = 3 then 'informational purpose only'
		when smf.type = 4 then 'Full-text'
	  end usage
	,smf.type 
	

 from
	sys.master_files smf
	outer apply (
		select
			sfg.name
		 from
			sys.filegroups sfg
		 where
			smf.type in (0,2)
			and smf.drop_lsn is null
			and smf.data_space_id = sfg.data_space_id
			
	
	) sfg