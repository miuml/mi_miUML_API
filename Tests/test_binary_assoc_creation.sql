-- Test: New Binary Associative Association

-- name, alias, subsys, domain, [cnum], [id_name], [id_type]
select UI_new_class( 'X', 'X', 'Main', 'Gas' );
select UI_new_class( 'Y', 'Y', 'Main', 'Gas' );

begin;
set constraints all deferred;
/*
-- X <<-- Z -->> Y
select UI_new_binary_assoc(
	'X', 'Y', 'Main', 'Gas',
	NULL, NULL,
	'M', false, 'left',
	'M', false, 'right',
	'Z', 'Z'
);

-- X <-- Z -->> Y
select UI_new_binary_assoc(
	'X', 'Y', 'Main', 'App',
	NULL, NULL,
	'1', false, 'left',
	'M', false, 'right',
	'Z', 'Z'
);

-- X <<-- Z --> Y
select UI_new_binary_assoc(
	'X', 'Y', 'Main', 'App',
	NULL, NULL,
	'M', false, 'left',
	'1', false, 'right',
	'Z', 'Z'
);
*/

-- X <-- Z --> Y
select UI_new_binary_assoc(
	'X', 'Y', 'Main', 'App',
	NULL, NULL,
	'1', false, 'left',
	'1', false, 'right',
	'Z', 'Z'
);
commit;
