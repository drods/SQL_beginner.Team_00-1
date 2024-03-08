with recursive pathway(last_point,
route) as (
select
 g.point1,
 array[point1]::char(1)[],
 0 as cost
from
 graph g
where
 point1 = 'a'
union
select
 g.point2 as last_point,
 (p.route || array[g.point2])::char(1)[] as route,
 p.cost + g.cost
from
 graph g,
 pathway p
where
 g.point1 = p.last_point
 and not g.point2 = any(p.route)),
final_route as (
select
 array_append(route,
 'a') as route,
 cost + (
 select
  g.cost
 from
  graph g
 where
  g.point1 = p.last_point
  and g.point2 = 'a') as cost
from
 pathway p
where
  (
 select
   array_length(p.route,
   1)) = 4
)
 select
  cost as total_cost,
  route
from
final_route
order by
  total_cost,
  route;
  
 --select * from graph g 