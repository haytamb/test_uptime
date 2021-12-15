-- 1. what are the 3 elevators with the most breakdowns?

select elevator_id, brand, model, "address", city,  count(elevator_id) as breakdown_count 
from breakdowns
join elevators on breakdowns.elevator_id=elevators.id
join buildings on elevators.building_id=buildings.id
group by elevator_id, brand, model, "address","city"
order by breakdown_count desc
limit 3; 


-- 2. for each elevator, when was the last visit done?

select elevator_id, brand, model, "address", city, max(closed_at)as latest_visit
from visits
join elevators on visits.elevator_id=elevators.id
join buildings on elevators.building_id=buildings.id
group by elevator_id, brand, model, "address", city
order by elevator_id;

-- 3. what is the elevator with the most "relapses"?
--    a "relapse" is a breakdown occuring on an elevator
--    that is 90 days away from the previous one at most


select elevator_id, elevator_id, brand, model, "address", city, count(elevator_id) 
from (select elevator_id, start_date-previous_start_date as relapse 
      from (select elevator_id, start_date, lag(start_date) over (partition by elevator_id order by elevator_id,start_date)
            as previous_start_date 
            from breakdowns) as date_diff) as t_relapse
join elevators on t_relapse.elevator_id=elevators.id
join buildings on elevators.building_id=buildings.id
where relapse>=90
group by elevator_id, elevator_id, brand, model, "address", city
order by count desc;