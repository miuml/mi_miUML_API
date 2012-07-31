-- Test: New Binary Associative Association
select UI_new_modeled_domain( 'Publishing', 'PUB' );

-- name, alias, subsys, domain, [cnum], [id_name], [id_type]
select UI_new_class( 'Publisher', 'P', 'Main', 'Publishing' );
select UI_new_class( 'Book', 'B', 'Main', 'Publishing' );

begin;
set constraints all deferred;
-- Publisher <- is published by -- publishes -0->> Book
select UI_new_binary_assoc(
	'Book', 'Publisher', 'Main', 'Publishing',
	NULL, NULL,
	'M', true, 'publishes',
	'1', false, 'is published by'
);
commit;
