-- Test: Create new binary to one association

select UI_new_modeled_domain( 'Gas', 'G' );

-- name, alias, subsys, domain, [cnum], [id_name], [id_type]
select UI_new_class( 'Lab', 'LB', 'Main', 'Gas' );
select UI_new_class( 'Fixture', 'FIX', 'Main', 'Gas' );

begin;
set constraints all deferred;
-- Do only one of the following cases - up to next commit

-- Lab < --  --0>> Fixture(r)
select UI_new_binary_assoc(
	'Fixture', 'Lab', 'Main', 'Gas',
	NULL, NULL,
	'M', true, 'stores',
	'1', false, 'is stored in'
);
/*
-- X < 0--  --> Y(r)
select UI_new_binary_assoc(
	'X', 'Y', 'Main', 'App',
	NULL, NULL,
	'1', true, 'left',
	'1', false, 'right'
);

-- X(r) < 0--  --> Y
select UI_new_binary_assoc(
	'X', 'Y', 'Main', 'App',
	NULL, 'A',
	'1', true, 'left',
	'1', false, 'right'
);

-- X(r) <--  --0 > Y
select UI_new_binary_assoc(
	'X', 'Y', 'Main', 'App',
	NULL, 'A',
	'1', false, 'left',
	'1', true, 'right'
);
*/
commit;
