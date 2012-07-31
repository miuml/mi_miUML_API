-- init_relvars.sql
--
-- These are all of the relvars for the miUML Metamodel Formalization Subsystem
--
--
-- Copyright 2011, Model Integration, LLC
-- Developer: Leon Starr / leon_starr@modelint.com
-- 
-- This file is part of the miUML metamodel library.
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU Lesser General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.  The license text should be viewable at
-- http://www.gnu.org/licenses/
--
--
set client_min_messages=ERROR;
drop schema if exists miform cascade;
create schema miform;
set search_path to miform, mirel, miclass, midom, mitype, mi, miuml;

-- Types (from class models)


-- Architectural, for optimization

-- create domain archid as serial; -- Architectural ID, for primary keys


-- Base Relvars (relation variables from class models)
-- Model comments to be filled in by Model->SQL generator
-- Model: Class Name (initial caps w/spaces) -> SQL: table name (lowercase w/underscores)
-- Model: {I<n>} = Identity Constraint  -> SQL: Primary Key component I and Unique for I2..n
-- Model: {R<n>} = Relationship -> SQL: Foreign Key

-- Relvars >>>

-- Associative Reference
create table associative_reference(
	type		miuml.assoc_ref_type,	-- I, R152->Reference.Type
	rnum		mi.nominal,				-- I, R152->Reference.Rnum
	domain		mi.name,				-- I, R152->Reference.Domain
	assoc_class	mi.name,				-- R152->Reference.From_class
	part_class	mi.name,				-- R152->Reference.To_class

	primary key( type, rnum, domain ),
	unique( type, rnum, domain, assoc_class, part_class ) -- Superkey
);

-- Asymmetric Associative Reference
create table asymmetric_assoc_reference(
	type		miuml.assoc_ref_type,	-- I, R175->Association Reference.Type
	side		miuml.side,				-- I2, R174->Assymetric Perspective.Side
	rnum		mi.nominal,				-- I, I2, R175->Association Reference.Rnum
											-- R174->Asymmetric Perspective.Rnum
	domain		mi.name,				-- I, I2, R175->Association Reference.Domain
											-- R174->Asymmetric Perspective.Domain
	assoc_class	mi.name,				-- R175->Association Reference.Association class
	part_class	mi.name,				-- R175->Association Reference.Participating class

	primary key( type, rnum, domain ),
	unique( side, rnum, domain )		-- I2
);

-- Formalizing Class
create table formalizing_class(
	rnum	mi.nominal,	-- I, R150->Relationship.Rnum
	class	mi.name,	-- I, R150->Class.Name
	domain	mi.name,	-- I, R150->Class.Domain, R150->Relationship.Domain

	primary key( rnum, class, domain )
);

-- P Reference
create table p_reference(
	rnum		mi.nominal,				-- I, R153->Association Reference.Rnum
	domain		mi.name,				-- I, R153->Association Reference.Domain
	assoc_class	mi.name,				-- R153->Association Reference.Association class
	part_class	mi.name,				-- R153->Association Reference.Participating class
	type		miuml.p_ref_type,		-- R153->Association Reference.Type

	primary key( rnum, domain ),
	unique( rnum, domain, type )	-- Superkey
);

-- Reference
create table reference(
	type		miuml.ref_type,	-- I
	from_class	mi.name,		-- I, R160->Reference Path.From class
	to_class	mi.name,		-- I, R160->Reference Path.To class
	rnum		mi.nominal,		-- I, R160->Reference Path.Rnum
	domain		mi.name,		-- I, R160->Reference Path.Domain

	primary key( type, from_class, to_class, rnum, domain )
);

-- Reference Path
create table reference_path(
	from_class	mi.name,	-- I, R155->Formalizing Class.Name
	to_class	mi.name,	-- I, R155->Class.Name
	rnum		mi.nominal,	-- I, R155->Formalizing Class.Rnum
	domain		mi.name,	-- I, R155->Formalizing Class.Domain

	primary key( from_class, to_class, rnum, domain )
);

-- Referring Participant Class
create table referring_participant_class(
	rnum	mi.nominal,	-- I, R151->Formalizing Class.Rnum
	class	mi.name,	-- I, R151->Formalizing Class.Name
	domain	mi.name,	-- I, R151->Formalizing Class.Domain

	primary key( rnum, class, domain )
);

-- Superclass Reference
create table superclass_reference(
	subclass	mi.name,	-- I, R156->Subclass.Class, R152->Reference.From class
	superclass	mi.name,	-- I, R170->Superclass.Class, R152->Reference.To class
	rnum		mi.nominal,	-- I, R156->Subclass.Rnum, R170->Superclass.Rnum,
							-- 		R152->Reference.Rnum
	domain		mi.name,	-- I, R156->Subclass.Domain, R170->Superclass.Domain,
							-- 		R152->Reference.Domain
	type		miuml.super_ref_type not null,	-- R152->Reference.Type

	primary key( subclass, superclass, rnum, domain )
);

-- Symmetric Associative Reference
create table symmetric_assoc_reference(
	type		miuml.assoc_ref_type,	-- I, R175->Association Reference.Type
	rnum		mi.nominal,				-- I, R175->Association Reference.Rnum
											-- R173->Symmetric Perspective.Rnum
	domain		mi.name,				-- I, R175->Association Reference.Domain
											-- R174->Symmetric Perspective.Domain
	assoc_class	mi.name,				-- R175->Association Reference.Association class
	part_class	mi.name,				-- R175->Association Reference.Participating class

	primary key( type, rnum, domain )
);

/*
-- Superclass Reference
create table superclass_reference(

	subclass	mi.name,		-- I, R152->Reference.From class, R156->Subclass.Class

	superclass	mi.name,		-- I, R152->Reference.To class, R170->Superclass.Class

	rnum		mi.nominal,		-- I, R152->Reference.Rnum, R156->Subclass.Rnum,
									--  R170->Superclass.Rnum

	domain		mi.name,		-- I, R152->Reference.Domain, R156->Subclass.Domain,
									--	R170->Superclass.Domain

	type		miuml.super_ref_type,	-- R152->Reference.Type

	primary key( subclass, superclass, rnum, domain )
);
*/

-- T Reference
create table t_reference(
	assoc_class	mi.name,				-- I, R153->Association Reference.Association class
	part_class	mi.name,				-- I, R153->Association Reference.Participating class
	rnum		mi.nominal,				-- I, R153->Association Reference.Rnum
	domain		mi.name,				-- I, R153->Association Reference.Domain
	type		miuml.t_ref_type,		-- I, R153->Association Reference.Type

	primary key( rnum, domain ),
	unique( rnum, domain, type )	-- Superkey
);

-- To One Reference
create table to_one_reference(

	from_class	mi.name,		-- I, R152->Reference.From class,
									--	R157->Referring Participant Class.Class

	to_class	mi.name,		-- I2, R152->Reference.To class (loop constraint)

	to_side		miuml.side,		-- I3, R171->One Perspective.Side

	rnum		mi.nominal,		-- I, I2, I3, R152->Reference.Rnum,
									-- R171->One Perspective.Rnum,
									-- R157->One Perspective.Rnum,
									-- R170->Referring Participant Class.Rnum

	domain		mi.name,		-- I, I2, I3, R152->Reference.Domain,
									-- R171->One Perspective.Domain,
									-- R157->One Perspective.Domain,
									-- R170->Referring Participant Class.Domain
							
	type		miuml.to_one_ref_type, -- R152->Reference.Type

	primary key( from_class, rnum, domain ),
	unique( to_class, rnum, domain ),	-- I2
	unique( to_side, rnum, domain )		-- I3
);

-- Constraints >>>

-- R31 -- From Class nad Attributes Subsystem
alter table miclass.referential_role add
	foreign key( reference_type, from_class, to_class, rnum, domain )
		references reference( type, from_class, to_class, rnum, domain )
	on update cascade on delete cascade deferrable;

alter table miclass.referential_role add
	foreign key( from_attribute, from_class, domain )
		references miclass.referential_attribute( name, class, domain )
	on update cascade on delete cascade deferrable;

-- R150
alter table formalizing_class add
	foreign key( rnum, domain ) references mirel.relationship( rnum, domain ) 
	on update cascade on delete cascade deferrable;
alter table formalizing_class add
	foreign key( class, domain ) references miclass.class( name, domain ) 
	on update cascade on delete cascade deferrable;

-- R151
alter table referring_participant_class add
	foreign key( rnum, class, domain ) references formalizing_class( rnum, class, domain ) 
	on update cascade on delete cascade deferrable;
alter table mirel.subclass add
	foreign key( rnum, class, domain ) references formalizing_class( rnum, class, domain ) 
	on update cascade on delete cascade deferrable;
alter table mirel.association_class add
	foreign key( rnum, class, domain ) references formalizing_class( rnum, class, domain ) 
	on update cascade on delete cascade deferrable;

-- R152
alter table superclass_reference add
	foreign key( subclass, superclass, rnum, domain, type ) references
		reference( from_class, to_class, rnum, domain, type ) 
	on update cascade on delete cascade deferrable;
alter table to_one_reference add
	foreign key( from_class, to_class, rnum, domain, type ) references
		reference( from_class, to_class, rnum, domain, type ) 
	on update cascade on delete cascade deferrable;
alter table associative_reference add
	foreign key( type, rnum, domain, assoc_class, part_class ) references
		reference( type, rnum, domain, from_class, to_class ) 
	on update cascade on delete cascade deferrable;

-- R153
alter table t_reference add
	foreign key( rnum, domain, assoc_class, part_class, type ) references
		associative_reference( rnum, domain, assoc_class, part_class, type )
	on update cascade on delete cascade deferrable;
alter table p_reference add
	foreign key( rnum, domain, assoc_class, part_class, type ) references
		associative_reference( rnum, domain, assoc_class, part_class, type )
	on update cascade on delete cascade deferrable;

-- R155
alter table reference_path add
	foreign key( from_class, rnum, domain ) references formalizing_class( class, rnum, domain ) 
	on update cascade on delete cascade deferrable;
alter table reference_path add
	foreign key( to_class, domain ) references miclass.class( name, domain ) 
	on update cascade on delete cascade deferrable;

-- R156
alter table superclass_reference add
	foreign key( subclass, rnum, domain ) references mirel.subclass( class, rnum, domain ) 
	on update cascade on delete cascade deferrable;

-- R157
alter table to_one_reference add
	foreign key( from_class, rnum, domain ) references
		referring_participant_class( class, rnum, domain )
	on update cascade on delete cascade deferrable;

-- R158
alter table t_reference add
	foreign key( rnum, domain ) references
		mirel.association_class( rnum, domain ) 
	on update cascade on delete cascade deferrable;

-- R159
alter table p_reference add
	foreign key( rnum, domain ) references
		mirel.association_class( rnum, domain ) 
	on update cascade on delete cascade deferrable;

-- R160
alter table reference add
	foreign key( from_class, to_class, rnum, domain ) references
		reference_path( from_class, to_class, rnum, domain )
	on update cascade on delete cascade deferrable;

-- R170
alter table superclass_reference add
	foreign key( superclass, rnum, domain ) references mirel.superclass( class, rnum, domain)
	on update cascade on delete cascade deferrable;

-- R171
alter table to_one_reference add
	foreign key( to_side, rnum, domain ) references mirel.one_perspective( side, rnum, domain)
	on update cascade on delete cascade deferrable;

-- R173
alter table symmetric_assoc_reference add
	foreign key( rnum, domain ) references mirel.symmetric_perspective( rnum, domain)
	on update cascade on delete cascade deferrable;

-- R174
alter table asymmetric_assoc_reference add
	foreign key( side, rnum, domain ) references
		mirel.asymmetric_perspective( side, rnum, domain )
	on update cascade on delete cascade deferrable;

-- R175
alter table symmetric_assoc_reference add
	foreign key( type, rnum, domain, assoc_class, part_class ) references
		associative_reference( type, rnum, domain, assoc_class, part_class )
	on update cascade on delete cascade deferrable;
alter table asymmetric_assoc_reference add
	foreign key( type, rnum, domain, assoc_class, part_class ) references
		associative_reference( type, rnum, domain, assoc_class, part_class )
	on update cascade on delete cascade deferrable;

-- Constraints <<<

set client_min_messages=NOTICE;
