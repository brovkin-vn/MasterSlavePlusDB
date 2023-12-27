-- Задание 5
with x as (
select l.name location_name, 
  sum(u.parameter_count) over(partition by l.id) location_parameter_count,
  min(u.parameter_count) over() min_location_parameter_count
from unit_dict u
inner join location_dict l on l.id = u.location_id

)
select distinct location_name from x 
where location_parameter_count = min_location_parameter_count
