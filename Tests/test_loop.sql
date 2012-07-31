-- Test: Loop contiguity validation

-- Case: Combination of Association and Generalization Relationships

select UI_new_modeled_domain( 'Loop', 'LOOP' );

-- name, alias, subsys, domain, [cnum], [id_name], [id_type]
select UI_new_class( 'A', 'A', 'Main', 'Loop' );
select UI_new_class( 'B', 'B', 'Main', 'Loop' );
select UI_new_class( 'C', 'C', 'Main', 'Loop' );
select UI_new_class( 'D', 'D', 'Main', 'Loop' );
select UI_new_class( 'E', 'E', 'Main', 'Loop' );
select UI_new_class( 'F', 'F', 'Main', 'Loop' );
select UI_new_class( 'G', 'G', 'Main', 'Loop' );
select UI_new_class( 'H', 'H', 'Main', 'Loop' );
select UI_new_class( 'I', 'I', 'Main', 'Loop' );

begin;
set constraints all deferred;
-- A <-- R1 --> D
select UI_new_binary_assoc(
	'A', 'D', 'Main', 'Loop',
	 1, NULL,
	'1', false, 'left',
	'1', false, 'right'
);
commit;

begin;
set constraints all deferred;
-- D <-- R5 --> E
select UI_new_binary_assoc(
	'D', 'E', 'Main', 'Loop',
	 5, NULL,
	'1', false, 'left',
	'1', false, 'right'
);
commit;

begin;
set constraints all deferred;
-- E <-- R3 --> C
select UI_new_binary_assoc(
	'E', 'C', 'Main', 'Loop',
	 3, NULL,
	'1', false, 'left',
	'1', false, 'right'
);
commit;

-- A+R2-[ F, G, B ] 
begin;
set constraints all deferred;
select UI_new_gen(
	'A', NULL, array[ 'F', 'G', 'B' ], array[ NULL, NULL, NULL ], 'Main', 'Loop', 2
);
commit;

-- B+R4-[ H, I, C ]
begin;
set constraints all deferred;
select UI_new_gen(
	'B', NULL, array[ 'H', 'I', 'C' ], array[ NULL, NULL, NULL ], 'Main', 'Loop', 4
);
commit;


