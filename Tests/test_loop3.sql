-- Test: Loop contiguity validation

-- Case: Multiple paths between Generalizations

select UI_new_modeled_domain( 'Loop', 'LOOP' );

-- name, alias, subsys, domain, [cnum], [id_name], [id_type]
select UI_new_class( 'A', 'A', 'Main', 'Loop' );
select UI_new_class( 'B', 'B', 'Main', 'Loop' );
select UI_new_class( 'C', 'C', 'Main', 'Loop' );
select UI_new_class( 'D', 'D', 'Main', 'Loop' );
select UI_new_class( 'E', 'E', 'Main', 'Loop' );

begin;
set constraints all deferred;
-- E <-- R2 --> D
select UI_new_binary_assoc(
	'E', 'D', 'Main', 'Loop',
	 2, NULL,
	'1', false, 'left',
	'1', false, 'right'
);
commit;

begin;
set constraints all deferred;
-- A <-- R1 --> E
select UI_new_binary_assoc(
	'A', 'E', 'Main', 'Loop',
	 1, NULL,
	'1', false, 'left',
	'1', false, 'right'
);
commit;

-- A+R4-[ B, C ] 
begin;
set constraints all deferred;
select UI_new_gen(
	'A', NULL, array[ 'B', 'C' ], array[ NULL, NULL ], 'Main', 'Loop', 4
);
commit;

-- D+R3-[ B, C ] 
begin;
set constraints all deferred;
select UI_new_gen(
	'D', NULL, array[ 'B', 'C' ], array[ NULL, NULL ], 'Main', 'Loop', 3
);
commit;
