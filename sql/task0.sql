select lpad(name, length(name)+(level-1)*2, '-')name, parent_id, unit_id, location_id, parameter_count, level from unit_dict 
connect by prior unit_id = parent_id start with parent_id is null
