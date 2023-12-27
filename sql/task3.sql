-- Задание 3
with x as (
	select l.id location_id, count(*) over(partition by location_id) unit_count from unit_dict t
	left join location_dict l on l.id = t.location_id
)
select x.location_id from x where x.unit_count < 3

