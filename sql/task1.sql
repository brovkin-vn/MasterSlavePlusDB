with x as (
	select t.unit_id, t.parameter_count, p.parameter_count parent_parameter_count from unit_dict t
	left join unit_dict p on p.unit_id = t.parent_id
)
select x.unit_id from x where x.parameter_count > x.parent_parameter_count
