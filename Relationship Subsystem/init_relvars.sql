-- init_relvars.sql
--
-- These are all of the relvars for the miUML Metamodel Relationship Subsystem
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
drop schema if exists mirel cascade;
create schema mirel;
set search_path to mirel, miclass, midom, mitype, miuml, mi;

-- Types (from class models)


-- Architectural, for optimization

-- create domain archid as serial; -- Architectural ID, for primary keys


-- Base Relvars (relation variables from class models)
-- Model comments to be filled in by Model->SQL generator
-- Model: Class Name (initial caps w/spaces) -> SQL: table name (lowercase w/underscores)
-- Model: {I<n>} = Identity Constraint  -> SQL: Primary Key component I and Unique for I2..n
-- Model: {R<n>} = Relationship -> SQL: Foreign Key

-- Relvars >>>

-- Active Perspective
create table active_perspective(
	rnum	mi.nominal,	-- I, R100->Relationship.Rnum
	domain	mi.name,	-- I, R100->Relationship.Domain
	side	miuml.binary_side not null check( side = 'A' ),
						-- R105->Asymmetric Perspective.Side

	primary key( rnum, domain )
);

-- Association
create table association(
	rnum	mi.nominal,	-- I, R100->Relationship.Rnum
	domain	mi.name,	-- I, R100->Relationship.Domain

	primary key( rnum, domain )
);

-- Association Class
create table association_class(
	rnum	mi.nominal,	-- I, R120->Association.Rnum
	class	mi.name,	-- I2, R120->Class.Name
	domain	mi.name,	-- I, I2, R120->Class.Domain, R120->Association.Domain

	primary key( rnum, domain ),
	unique( class, domain )
);

-- Asymmetric Perspective
create table asymmetric_perspective(
	side	miuml.binary_side,
						-- I, R121->Perspective.Side
	rnum	mi.nominal,	-- I, R100->Relationship.Rnum
	domain	mi.name,	-- I, R100->Relationship.Domain

	primary key( side, rnum, domain )
);

-- Binary Association
create table binary_association(
	rnum	mi.nominal,	-- I, R119->Association.Rnum
	domain	mi.name,	-- I, R119->Association.Domain

	primary key( rnum, domain )
);

-- Constrained Loop
create table constrained_loop(
	element	mi.nominal,	--I, R17->Spanning Element.Number
	domain	mi.name,	--I, R17->Spanning Element.Domain

	primary key( element, domain )
);

-- Facet
create table facet(
	lineage		mi.nominal,	-- I, R131->Lineage.Element
	class		mi.name,	-- I, R131->Specialized Class.Name
	domain		mi.name,	-- I, R131->Lineage.Domain, Specialized Class.Domain

	primary key( lineage, class, domain )
);

-- Generalization
create table generalization(
	rnum		mi.nominal,			-- I, R100->Relationship.Rnum
	domain		mi.name,			-- I, R100->Relationship.Domain
	superclass  mi.name not null,	-- R103->Superclass.Class

	primary key( rnum, domain )
);

-- Generalization Role
create table generalization_role(
	rnum		mi.nominal,	-- I, R101->Generalization.Rnum
	class		mi.name,	-- I, R101->Specialized Class.Name
	domain		mi.name,	-- I, R101->Generalization.Rnum, Specialized Class.Rnum

	primary key( rnum, class, domain )
);

-- Lineage
create table lineage(
	element		mi.nominal,	-- I, R17->Spanning Element.Number
	domain		mi.name,	-- I, R17->Spanning Element.Domain

	primary key( element, domain )
);

-- Loop Segment
create table loop_segment(
	cloop	mi.nominal,	-- I, R160->Constrained Loop.Element
	rnum	mi.nominal,	-- I, R160->Relationship.Rnum
	domain	mi.name,	-- I, R160->Relationship.Domain, R160->Constrained Loop.Domain

	primary key( cloop, rnum, domain )
);

-- Many Perspective
create table many_perspective(
	side		miuml.side,	-- I, R104->Perspective.Side
	rnum		mi.nominal,	-- I, R104->Perspective.Rnum
	domain		mi.name,	-- I, R104->Perspective.Domain

	primary key( side, rnum, domain )
);

-- Mininal Partition
create table minimal_partition(
	rnum		mi.nominal,	-- I, R116->Generalization.Rnum, R117,118->Subclass.Rnum
	domain		mi.name,	-- I, R116->Generalization.Domain, R117,118->Subclass.Domain
	a_subclass	mi.name not null,	-- R117->Subclass.Name
	b_subclass	mi.name not null check( b_subclass != a_subclass ),	-- R118->Subclass.Name

	primary key( rnum, domain )
);

-- One Perspective
create table one_perspective(
	side				miuml.side,	-- I, R104->Perspective.Side
	rnum				mi.nominal,	-- I, R104->Perspective.Rnum
	domain				mi.name,	-- I, R104->Perspective.Domain

	primary key( side, rnum, domain )
);

-- Passive Perspective
create table passive_perspective(
	rnum	mi.nominal,	-- I, R100->Relationship.Rnum
	domain	mi.name,	-- I, R100->Relationship.Domain
	side	miuml.binary_side not null check( side = 'P' ),
						-- R105->Asymmetric Perspective.Side

	primary key( rnum, domain )
);

-- Perspective
create table perspective(
	side				miuml.side,			-- I
	rnum				mi.nominal,			-- I
	domain				mi.name,			-- I, R110->Class.Domain
	viewed_class		mi.name not null,	-- R110->Class.Name
	phrase				mi.name not null,
	conditional			boolean not null,
	uml_multiplicity	miuml.uml_mult not null, -- derived

	primary key( side, rnum, domain )
);

-- Relationship
create table relationship(
	rnum	mi.nominal,				-- I
	domain	mi.name,				-- I, I2, R14->Subsystem Element.Domain
	element	mi.nominal not null,	-- I2, R14->Subsystem Element.Number

	primary key( rnum, domain ),
	unique( element, domain )		-- I2
);

-- Specialized Class
create table specialized_class(
	name	mi.name,	-- I, R25->Class.Name
	domain	mi.name,	-- I, R25->Class.Domain

	primary key( name, domain )
);

-- Subclass
create table subclass(
	rnum	mi.nominal,	-- I, R102->Generalization Role.Rnum, R151->Formalizing Class.Rnum
	class	mi.name,	-- I, R102->Generalization Role.Class, R151->Formalizing Class.Class
	domain	mi.name,	-- I, R102->Generalization Role.Domain, R151->Formalizing Class.Domain

	primary key( rnum, class, domain )
);

-- Superclass
create table superclass(
	rnum	mi.nominal,	-- I, R102->Generalization Role.Rnum
	class	mi.name,	-- I, R102->Generalization Role.Class
	domain	mi.name,	-- I, R102->Generalization Role.Domain

	primary key( rnum, class, domain )
);

-- Symmetric Perspective
create table symmetric_perspective(
	side	miuml.unary_side,	-- I, R121->Perspective.Side
	rnum	mi.nominal,			-- I, R121->Relationship.Rnum. R123->Unary Association.Rnum
	domain	mi.name,			-- I, R121->Relationship.Domain, R123->Unary Association.Domain

	primary key( rnum, domain ),
	unique( side, rnum, domain )	-- Superkey
);

-- Unary Association
create table unary_association(
	rnum	mi.nominal,	-- I, R119->Association.Rnum
	domain	mi.name,	-- I, R119->Association.Domain

	primary key( rnum, domain )
);

-- Relvars <<<

-- Constraints >>>

-- R14
alter table relationship add
	foreign key( element, domain ) references subsystem_element( number, domain ) 
	on update cascade on delete cascade deferrable;

-- R17
alter table constrained_loop add
	foreign key( element, domain ) references spanning_element( number, domain ) 
	on update cascade on delete cascade deferrable;

-- R25
alter table specialized_class add
	foreign key( name, domain ) references miclass.class( name, domain ) 
	on update cascade on delete cascade deferrable;

-- R100
alter table association add
	foreign key( rnum, domain ) references relationship( rnum, domain ) 
	on update cascade on delete cascade deferrable;

-- R101
alter table generalization_role add
	foreign key( rnum, domain ) references generalization( rnum, domain ) 
	on update cascade on delete cascade deferrable;
alter table generalization_role add
	foreign key( class, domain ) references specialized_class( name, domain ) 
	on update cascade on delete cascade deferrable;

-- R102
alter table subclass add
	foreign key( rnum, class, domain ) references generalization_role( rnum, class, domain ) 
	on update cascade on delete cascade deferrable;
alter table superclass add
	foreign key( rnum, class, domain ) references generalization_role( rnum, class, domain ) 
	on update cascade on delete cascade deferrable;

-- R103
alter table generalization add constraint
    R103_Generalization__requires__Superclass
	foreign key( rnum, domain, superclass ) references superclass( rnum, domain, class ) 
	on update cascade on delete cascade deferrable;

-- R104
alter table one_perspective add
	foreign key( rnum, domain, side ) references perspective( rnum, domain, side ) 
	on update cascade on delete cascade deferrable;
-- R104
alter table many_perspective add
	foreign key( rnum, domain, side ) references perspective( rnum, domain, side ) 
	on update cascade on delete cascade deferrable;

-- R105
alter table active_perspective add
	foreign key( rnum, domain, side ) references asymmetric_perspective( rnum, domain, side ) 
	on update cascade on delete cascade deferrable;
-- R105
alter table passive_perspective add
	foreign key( rnum, domain, side ) references asymmetric_perspective( rnum, domain, side ) 
	on update cascade on delete cascade deferrable;

-- R110
alter table perspective add
	foreign key( viewed_class, domain ) references miclass.class( name, domain ) 
	on update cascade on delete cascade deferrable;

-- R116
alter table minimal_partition add
	foreign key( rnum, domain ) references generalization( rnum, domain ) 
	on update cascade on delete cascade deferrable;

-- R117
alter table minimal_partition add
	foreign key( rnum, domain, a_subclass ) references subclass( rnum, domain, class ) 
	on update cascade on delete cascade deferrable;

-- R118
alter table minimal_partition add
	foreign key( rnum, domain, b_subclass ) references subclass( rnum, domain, class ) 
	on update cascade on delete cascade deferrable;

-- R119
alter table binary_association add
	foreign key( rnum, domain ) references association( rnum, domain ) 
	on update cascade on delete cascade deferrable;

-- R120
alter table association_class add
	foreign key( rnum, domain ) references association( rnum, domain ) 
	on update cascade on delete cascade deferrable;
alter table association_class add
	foreign key( class, domain ) references miclass.class( name, domain ) 
	on update cascade on delete cascade deferrable;

-- R121
alter table asymmetric_perspective add
	foreign key( rnum, domain, side ) references perspective( rnum, domain, side ) 
	on update cascade on delete cascade deferrable;
alter table symmetric_perspective add
	foreign key( rnum, domain, side ) references perspective( rnum, domain, side ) 
	on update cascade on delete cascade deferrable;

-- R123
alter table symmetric_perspective add
	foreign key( rnum, domain ) references unary_association( rnum, domain ) 
	on update cascade on delete cascade deferrable;

-- R124
alter table active_perspective add
	foreign key( rnum, domain ) references binary_association( rnum, domain ) 
	on update cascade on delete cascade deferrable;

-- R125
alter table passive_perspective add
	foreign key( rnum, domain ) references binary_association( rnum, domain ) 
	on update cascade on delete cascade deferrable;

-- R131
alter table facet add
	foreign key( lineage, domain ) references lineage( element, domain ) 
	on update cascade on delete cascade deferrable;
alter table facet add
	foreign key( class, domain ) references specialized_class( name, domain ) 
	on update cascade on delete cascade deferrable;

-- R160
alter table loop_segment add
	foreign key( cloop, domain ) references constrained_loop( element, domain ) 
	on update cascade on delete cascade deferrable;
alter table loop_segment add
	foreign key( rnum, domain ) references relationship( rnum, domain ) 
	on update cascade on delete cascade deferrable;


-- Constraints <<<

set client_min_messages=NOTICE;
