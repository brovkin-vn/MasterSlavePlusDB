with xxx as (
	select parent_id, unit_id, parameter_count from unit_dict 
	connect by prior unit_id = parent_id start with parent_id is null
),
xx as (
   select xxx.*, sum(parameter_count) over(partition by parent_id) as parent_parameter_count from xxx
),
x as (
	select distinct r.*, nvl(l.parent_parameter_count, 0) child_parameter_count from xx r
	left join xx l on r.unit_id = l.parent_id
)
select unit_id from x where parameter_count >= child_parameter_count
and  child_parameter_count > 0
