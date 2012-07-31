-- test_create_classes.sql

-- Test 1: Create a 1c:1c Binary Association with formalizing Assoc Class

-- name, alias, subsys, domain, [cnum], [id_name], [id_type]
select UI_new_class( 'X', 'X', 'Main', 'App' );
select UI_new_ind_attr( 'Code', 'X', 'App', 'short name' );
select UI_add_attr_to_id( 'Code', 'X', 'App', 1 );

select UI_new_class( 'Y', 'Y', 'Main', 'App' );

begin;
set constraints all deferred;
-- X(r) <---->> Y
select UI_new_binary_assoc(
	'X', 'Y', 'Main', 'App',
	NULL, NULL,
	'1', false, 'left',
	'M', false, 'right'
);
commit;

select UI_add_attr_to_id( 'X_ID', 'Y', 'App', 1 );
select UI_add_attr_to_id( 'Code', 'Y', 'App', 1 );

\i q1.sql
