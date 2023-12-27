with x as (
	select t.unit_id, t.parameter_count, max(t.parameter_count) over(partition by location_id) max_parameter_count from unit_dict t
	left join location_dict l on l.id = t.location_id
)
select x.unit_id from x where x.parameter_count = x.max_parameter_count
order by x.max_parameter_count desc
