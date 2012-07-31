-- Test: Loop contiguity

-- Case: Loop through an Association Class
-- 
select UI_new_modeled_domain( 'Loop', 'LOOP' );

-- name, alias, subsys, domain, [cnum], [id_name], [id_type]
select UI_new_class( 'A', 'A', 'Main', 'Loop' );
select UI_new_class( 'B', 'B', 'Main', 'Loop' );
select UI_new_class( 'C', 'C', 'Main', 'Loop' );
select UI_new_class( 'D', 'D', 'Main', 'Loop' );

begin;
set constraints all deferred;
-- A <<-- C - R1 -->> B
select UI_new_binary_assoc(
	'A', 'B', 'Main', 'Loop',
	 1, NULL,
	'M', false, 'left',
	'M', false, 'right',
	'C'
);
commit;

begin;
set constraints all deferred;
-- B <-- R2 --> D
select UI_new_binary_assoc(
	'B', 'D', 'Main', 'Loop',
	 2, NULL,
	'1', false, 'left',
	'1', false, 'right'
);
commit;

begin;
set constraints all deferred;
-- D <-- R3 --> C
select UI_new_binary_assoc(
	'D', 'C', 'Main', 'Loop',
	 3, NULL,
	'1', false, 'left',
	'1', false, 'right'
);
commit;
