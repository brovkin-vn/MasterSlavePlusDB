-- Задание 6
with x as (
select pipe_no, dt, duration, pass_id from pipes p
inner join unit_passes u on u.matid = p.matid 
)
select 
	pipe_no, 
	max(duration) keep(dense_rank last order by pass_id) over() last_duration
from x 
where 1=1 
 and dt between to_date('01.05.2016', 'DD.MM.YYYY') and to_date('20.05.2016', 'DD.MM.YYYY')
