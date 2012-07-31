-- Test: Lifecycle operations on Multiple Assigners

-- Case: All Associations wtih fork at C to D and B
-- 
select UI_new_modeled_domain( 'Loop', 'LOOP' );

-- name, alias, subsys, domain, [cnum], [id_name], [id_type]
select UI_new_class( 'A', 'A', 'Main', 'Loop' );
select UI_new_class( 'B', 'B', 'Main', 'Loop' );
select UI_new_class( 'C', 'C', 'Main', 'Loop' );
select UI_new_class( 'D', 'D', 'Main', 'Loop' );

begin;
set constraints all deferred;
-- A <-- R4 --> B
select UI_new_binary_assoc(
	'A', 'B', 'Main', 'Loop',
	 4, NULL,
	'1', false, 'left',
	'1', false, 'right'
);
commit;

begin;
set constraints all deferred;
-- B <-- R2 --> C
select UI_new_binary_assoc(
	'B', 'C', 'Main', 'Loop',
	 2, NULL,
	'1', false, 'left',
	'1', false, 'right'
);
commit;

begin;
set constraints all deferred;
-- C <-- R3 --> A
select UI_new_binary_assoc(
	'C', 'A', 'Main', 'Loop',
	 3, NULL,
	'1', false, 'left',
	'1', false, 'right'
);
commit;

begin;
set constraints all deferred;
-- C <-- R1 --> D
select UI_new_binary_assoc(
	'C', 'D', 'Main', 'Loop',
	 1, NULL,
	'1', false, 'left',
	'1', false, 'right'
);
commit;
set client_min_messages=ERROR; -- Hide Notice when temp table is created in UI_new_loop
-- A - B - C in Loop on R3, R4, R2 with D connected to C by R1 outside loop
select UI_new_loop( array[3, 4, 2], 'Loop' );
set client_min_messages=NOTICE;
