USE [dovetail]
GO
/****** Object:  UserDefinedFunction [dbo].[GetCaseClock]    Script Date: 10/06/2011 16:28:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID (N'dbo.GetCaseClock', N'TF') IS NOT NULL
DROP FUNCTION dbo.GetCaseClock;
GO

ALTER FUNCTION [dbo].[GetCaseClock](@case_objid int)
    RETURNS  @caseclocktable TABLE
     (
   	elapsed_time_in_seconds int, 
   	elapsed_time_in_minutes int, 
   	elapsed_time_display varchar(255),
   	case_objid int
   )
   
AS
BEGIN
	declare @elapsed_time_in_seconds int, @elapsed_time_in_minutes int, @elapsed_time_display varchar(255)

	select @elapsed_time_in_seconds = 
      	CASE 
         	WHEN is_running = 0 THEN 
		time_so_far
	ELSE
		time_so_far + ( dateDiff(s, last_started_at, getdate()) )	
	END
	from table_case_clock where case_clock2case = @case_objid;

	select @elapsed_time_in_minutes = @elapsed_time_in_seconds / 60;

	select @elapsed_time_display = 
    	convert(varchar(40), @elapsed_time_in_minutes/(24*60)) + 'd ' 
  	+ convert(varchar(40), @elapsed_time_in_minutes%(24*60)/60) + 'h '
  	+ convert(varchar(40), @elapsed_time_in_minutes%60) + 'm';

	insert into @caseclocktable select  @elapsed_time_in_seconds, @elapsed_time_in_minutes, @elapsed_time_display, @case_objid
	RETURN 
	
END
