-- test_del_rel1.sql

-- 

-- name, alias, subsys, domain, [cnum], [id_name], [id_type]
select UI_new_class( 'Shaft', 'SHAFT', 'Main', 'App' );
select UI_new_class( 'Cabin', 'CAB', 'Main', 'App' );
select UI_new_class( 'Door', 'D', 'Main', 'App' );

begin;
set constraints all deferred;
-- Cabin(r) <----> Shaft
select UI_new_binary_assoc(
	'Shaft', 'Cabin', 'Main', 'App',
	NULL, NULL,
	'1', false, 'travels in',
	'1', false, 'is conduit for'
);
commit;

select UI_delete_attr( 'ID', 'Cabin', 'App' );
select UI_set_attr_name( 'SHAFT_ID', 'Cabin', 'App', 'ID' );

begin;
set constraints all deferred;
-- Door(r) <----> Cabin
select UI_new_binary_assoc(
	'Cabin', 'Door', 'Main', 'App',
	NULL, NULL,
	'1', false, 'provide access to',
	'1', false, 'is accessible by'
);
commit;

select UI_delete_attr( 'ID', 'Door', 'App' );
select UI_set_attr_name( 'CAB_ID', 'Door', 'App', 'ID' );


\i q1.sql
