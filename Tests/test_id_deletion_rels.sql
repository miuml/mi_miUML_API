-- test_id_deletion.sql

\set VERBOSITY terse

-- Create test case
select UI_new_class( 'X', 'X', 'Main', 'App' );
select UI_new_ind_attr( 'Code', 'X', 'App', 'short name' );
select UI_add_attr_to_id( 'Code', 'X', 'App', 1 );

select UI_new_class( 'Y', 'Y', 'Main', 'App' );
select UI_new_class( 'Z', 'Z', 'Main', 'App' );

-- X <--  -->> Y
select UI_new_binary_assoc(
	'X', 'Y', 'Main', 'App',
	NULL, NULL,
	'1', false, 'left',
	'M', false, 'right'
);

select UI_add_attr_to_id( 'X_ID', 'Y', 'App', 1 );
select UI_add_attr_to_id( 'Code', 'Y', 'App', 1 );
select UI_delete_attr( 'ID', 'Y', 'App' );

-- Y <<--  --> Z
select UI_new_binary_assoc(
	'Y', 'Z', 'Main', 'App',
	NULL, NULL,
	'1', false, 'left',
	'M', false, 'right'
);

-- Adjust the Identifiers
select UI_add_attr_to_id( 'Code', 'Z', 'App', 1 );
select UI_delete_attr( 'ID', 'Z', 'App' );


-- Tests

\echo 'F: Deleting referenced MAI component from ID 1'
select UI_delete_attr( 'Code', 'X', 'App');
