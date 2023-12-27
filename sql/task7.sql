select distinct pipe_no from unit_passes u 
join unit_passes u22 on u.matid  != u22.matid and u22.unitid=22 
join pipes p on p.matid = u.matid

