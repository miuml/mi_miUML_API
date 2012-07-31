-- test_create_classes.sql

-- name, alias, subsys, domain, [cnum], [id_name], [id_type]
select UI_new_modeled_domain( 'Air Traffic Control', 'ATC' );

-- Using default ID
select UI_new_class( 'Duty Station', 'DS', 'Main', 'Air Traffic Control' );

-- Using supplied ID
select UI_new_class(
	'Aircraft', 'AIR', 'Main', 'Air Traffic Control', NULL, 'Tail Number', 'short name'
);
