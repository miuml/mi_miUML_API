-- test_id_deletion.sql

\set VERBOSITY terse

-- Create a test class
select UI_new_class( 'X', 'X', 'Main', 'App' );

-- Tests
\echo 'F: Trying to delete component of SAI, only ID in class.'
select UI_delete_attr( 'ID', 'X', 'App');

\echo 'F: Trying to remove component of SAI, only ID in class.'
select UI_remove_attr_from_id( 'ID', 'X', 'App', 1);

-- Change SAI to MAI
select UI_new_ind_attr( 'Code', 'X', 'App', 'short name' );
select UI_add_attr_to_id( 'Code', 'X', 'App', 1 );

-- Tests

\echo 'S: Deleting MAI component from ID 1'
select UI_delete_attr( 'Code', 'X', 'App');

-- Change SAI to MAI
select UI_new_ind_attr( 'Code2', 'X', 'App', 'short name' );
select UI_add_attr_to_id( 'Code2', 'X', 'App', 1 );

-- Tests
\echo 'S: Removing MAI component from ID 1 to leave SAI'
select UI_remove_attr_from_id( 'Code2', 'X', 'App', 1);
\echo 'S: Removing non_ID attribute';
select UI_delete_attr( 'Code2', 'X', 'App');

-- Tests - multiple identifiers

-- Change SAI to MAI
select UI_new_ind_attr( 'xid2', 'X', 'App', 'short name' );
select UI_new_ind_attr( 'xid3', 'X', 'App', 'short name' );
select UI_new_ind_attr( 'xid4', 'X', 'App', 'short name' );
select UI_add_attr_to_id( 'xid2', 'X', 'App' );
select UI_add_attr_to_id( 'xid3', 'X', 'App' );
select UI_add_attr_to_id( 'xid4', 'X', 'App' );

-- Test surplus ID deletion and attr removal
\echo 'S: Deleting identifier attribute used in surplus SAI';
select UI_delete_attr( 'xid2', 'X', 'App' );
\echo 'S: Removing identifier attribute from surplus SAI';
select UI_remove_attr_from_id( 'xid4', 'X', 'App', 3 );
-- Create a test class
--select UI_new_class( 'X', 'X', 'Main', 'App' );

/*
-- We might need this for a test later
begin;
set constraints all deferred;
commit;
*/
