drop table if exists graph;

create table graph (id bigint primary key,
point1 varchar not null,
point2 varchar not null,
cost integer not null);

insert
	into
	graph
values(1,
'a',
'b',
10);

insert
	into
	graph
values(2,
'b',
'a',
10);

insert
	into
	graph
values(3,
'b',
'c',
35);

insert
	into
	graph
values(4,
'c',
'b',
35);

insert
	into
	graph
values(5,
'a',
'c',
15);

insert
	into
	graph
values(6,
'c',
'a',
15);

insert
	into
	graph
values(7,
'c',
'd',
30);

insert
	into
	graph
values(8,
'd',
'c',
30);

insert
	into
	graph
values(9,
'd',
'a',
20);

insert
	into
	graph
values(10,
'a',
'd',
20);

insert
	into
	graph
values(11,
'b',
'd',
25);

insert
	into
	graph
values(12,
'd',
'b',
25);
--select * from graph

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
where cost = (select min(cost) from final_route)
order by
		total_cost,
		route;
	
