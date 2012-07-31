-- Test: New Binary Association (various types with and without Assoc Class)

-- name, alias, subsys, domain, [cnum], [id_name], [id_type]
select UI_new_class( 'Territory', 'TERR', 'Main', 'App' );

begin;
set constraints all deferred;

-- Territory <<-- Border -->> Territory 
select UI_new_binary_assoc(
	'Territory', 'Territory', 'Main', 'App',
	NULL, NULL,
	'M', false, 'borders',
	'M', false, 'is bordered by',
	'Border', 'BORD'
);

/*
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

-- X <-- Z --> Y
select UI_new_binary_assoc(
	'X', 'Y', 'Main', 'App',
	NULL, NULL,
	'1', false, 'left',
	'1', false, 'right',
	'Z', 'Z'
);

-- X < --  --> X(r)
select UI_new_binary_assoc(
	'X', 'X', 'Main', 'App',
	NULL, NULL,
	'1', false, 'left',
	'1', false, 'right'
);

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
