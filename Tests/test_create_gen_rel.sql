-- Existing Superclass, new Subclasses

select UI_new_domain( 'Gas', 'GAS' );

-- name, alias, subsys, domain, [cnum], [id_name], [id_type]
select UI_new_class( 'Connector', 'CONN', 'Main', 'Gas' );

begin;
set constraints R103_Generalization__requires__Superclass deferred;
select UI_new_gen(
	p_superclass:='Connector',
    p_subclasses:=array[ 'Valve', 'Pump' ],
    p_sub_aliases:=array[ 'V', 'P' ],
    p_subsys:='Main',
    p_domain:='Gas'
);
commit;

-- All new classes
begin;
set constraints R103_Generalization__requires__Superclass deferred;
select UI_new_gen(
	p_superclass:='Tank',
    p_super_alias:='T',
    p_subclasses:=array[ 'Cylindrical', 'Spherical' ],
    p_sub_aliases:=array[ 'CYL', 'SPH' ],
    p_subsys:='Main',
    p_domain:='Gas'
);
commit;

/*


-- Two existing Subclasses, new Superclass
-- Subclasses
select UI_new_class( 'Valve', 'P', 'Main', 'App', NULL, 'Number', 'nominal' );
select UI_new_class( 'Pump', 'V', 'Main', 'App', NULL, 'Serial', 'nominal' );

begin;
set constraints all deferred;
select UI_new_gen(
	'Connector', 'CONN', array[ 'Valve', 'Pump' ], array[ NULL, NULL ], 'Main', 'App'
);
commit;


-- Normal case, Superclass existing, Subclasses new
select UI_new_class( 'Fruit', 'F', 'Main', 'App', NULL, 'Name', 'short name' );

begin;
set constraints all deferred;
select UI_new_gen(
	'Fruit', NULL, array[ 'Apple', 'Orange' ], array[ 'APL', 'ORG' ], 'Main', 'App'
);
commit;

-- Normal case, all Classes are new
begin;
set constraints all deferred;
select UI_new_gen(
	'Fruit', 'F', array[ 'Apple', 'Orange' ], array[ 'APL', 'ORG' ], 'Main', 'App'
);
commit;

-- Not enough subclasses
begin;
set constraints all deferred;
select UI_new_gen(
	'Fruit', 'F', array[ 'Apple' ], array[ 'APL' ], 'Main', 'App'
);
commit;

-- No subclasses
begin;
set constraints all deferred;
select UI_new_gen(
	'Fruit', 'F', array[ ]::text[], array[ ]::text[], 'Main', 'App'
);
commit;

-- Alias not specified for new super class
begin;
set constraints all deferred;
select UI_new_gen(
	'Fruit', NULL, array[ 'Apple', 'Orange' ], array[ 'APL', 'ORG' ], 'Main', 'App'
);
commit;

-- Subclass array sizes are different
begin;
set constraints all deferred;
select UI_new_gen(
	'Fruit', 'F', array[ 'Apple', 'Orange', 'Kiwi' ], array[ 'APL', 'ORG' ], 'Main', 'App'
);
commit;
*/
