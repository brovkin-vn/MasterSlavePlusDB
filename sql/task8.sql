with x as (
	select pipe_no, dt, duration from pipes p
  	inner join unit_passes u on u.matid = p.matid 
	  where lower(pipe_no) like '���%'
)
select pipe_no, dt, duration, lag(duration) over(order by dt) lag_duration from x



