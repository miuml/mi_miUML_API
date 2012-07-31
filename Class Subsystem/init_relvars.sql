-- init_relvars.sql
--
-- These are all of the relvars for the miUML Metamodel Class and Attributes Subsystem
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
drop schema if exists miclass cascade;
create schema miclass;
set search_path to miclass, midom, mitype;

-- Types (from class models)


-- Architectural, for optimization

-- create domain archid as serial; -- Architectural ID, for primary keys


-- Base Relvars (relation variables from class models)
-- Model comments to be filled in by Model->SQL generator
-- Model: Class Name (initial caps w/spaces) -> SQL: table name (lowercase w/underscores)
-- Model: {I<n>} = Identity Constraint  -> SQL: Primary Key component I and Unique for I2..n
-- Model: {R<n>} = Relationship -> SQL: Foreign Key

-- In alphabetic order by Subsystem

-- Relvars >>>

-- Attribute --
create table attribute(
	name	mi.name, -- I
	class	mi.name, -- I, R20->Class.Name
	domain	mi.name, -- I, R20->Class.Domain

	primary key( name, class, domain )
);

-- Class --
create table class(
	name	mi.name,				-- I
	domain	mi.name,				-- I, I2, I3, I4, R14->Element.Domain
	element	mi.nominal not null,	-- I2, R14->Subsystem Element.Number
	cnum	mi.nominal not null,	-- I3
	alias	mi.short_name not null,	-- I4

	primary key( name, domain ),	-- I
	unique( element, domain ),		-- I2
	unique( cnum, domain ),			-- I3
	unique( alias, domain ) 		-- I4
);

-- Identifier --
create table identifier(
	number	mi.nominal,	-- I
	class	mi.name,	-- I, R27->Class.Name
	domain	mi.name,	-- I, R27->Class.Domain

	primary key( number, class, domain )
);

-- Identifier Attribute --
create table identifier_attribute(
	identifier	mi.nominal,	-- I, R22->Identifier.Number
	attribute	mi.name,	-- I, R22->Attribute.Name
	class		mi.name,	-- I, R22->Attribute.Class, R22->Identifier.Class
	domain		mi.name,	-- I, R22->Attribute.Domain, R22->Identifier.Domain

	primary key( identifier, attribute, class, domain )
);

-- Independent Attribute --
create table independent_attribute(
	name	mi.name,			-- I, R25->Native Attribute.Name
	class	mi.name,			-- I, R25->Native Attribute.Class
	domain	mi.name,			-- I, R25->Native Attribute.Domain

	primary key( name, class, domain )
);

-- Modeled Identifier --
create table modeled_identifier(
	number	mi.nominal,	-- I, R30->Identifier.Number
	class	mi.name,	-- I, R30->Identifier.Class
	domain	mi.name,	-- I, R30->Identifier.Domain

	primary key( number, class, domain )
);

-- Native Attribute --
create table native_attribute(
	name	mi.name,			-- I, R21->Attribute.Name
	class	mi.name,			-- I, R21->Attribute.Class
	domain	mi.name,			-- I, R21->Attribute.Domain
	type	mi.compound_name,	-- R24->Constrained Type.Name

	primary key( name, class, domain )
);

-- Non Specialized Class
create table non_specialized_class(
	name	mi.name, -- I, R25->Class.Name
	domain	mi.name, -- I, R25->Class.Name

	primary key( name, domain )
);

-- Referential Attribute --
create table referential_attribute(
	name	mi.name,	-- I, R21->Attribute
	class	mi.name,	-- I, R21->Attribute
	domain	mi.name,	-- I, R21->Attribute
	type	mi.compound_name,	-- derived

	primary key( name, class, domain )
);

-- Referential Role --
create table referential_role(

	from_attribute	mi.name,		-- I, R31->Referential Attribute->Name

	from_class		mi.name,		-- I, R31->Referential Attribute->Class,
									--	  R31->Reference.From class

	reference_type	miuml.ref_type,	-- I, R31->Reference.Type

	to_class		mi.name,		-- I, R31->Reference.To class,
									--    R32->Identifier Attribute.Class

	rnum			mi.nominal,		-- I, R31->Reference.Rnum

	domain			mi.name,		-- I, R31->Reference.Domain,
									--	  R31->Referential Attribute.Domain,
									--    R32->Identifier Attribute.Domain

	to_attribute	mi.name,		-- R32->Identifier Attribute.Attribute

	to_identifier	mi.nominal,		-- R32->Identifier Attribute.Identifier

	primary key( from_attribute, from_class, reference_type, to_class, rnum, domain )
);


-- Relvars <<<

-- Constraints >>>
-- R14
alter table class add
	foreign key( element, domain ) references subsystem_element( number, domain ) 
	on update cascade on delete cascade deferrable;

-- R20
alter table attribute add
	foreign key( class, domain ) references class( name, domain )
	on update cascade on delete cascade deferrable;

-- R21
alter table native_attribute add
	foreign key( name, class, domain ) references attribute( name, class, domain )
	on update cascade on delete cascade deferrable;
alter table referential_attribute add
	foreign key( name, class, domain ) references attribute( name, class, domain )
	on update cascade on delete cascade deferrable;

-- R22t
alter table identifier_attribute add
	foreign key( attribute, class, domain ) references attribute( name, class, domain )
	on update cascade on delete cascade deferrable;
-- R22p
alter table identifier_attribute add
	foreign key( identifier, class, domain ) references identifier( number, class, domain )
	on update cascade on delete cascade deferrable;

-- R23
alter table non_specialized_class add
	foreign key( name, domain ) references class( name, domain ) 
	on update cascade on delete cascade deferrable;

-- R24
alter table native_attribute add
	foreign key( type ) references mitype.constrained_type( name )
	on update cascade on delete cascade deferrable;

-- R25
alter table independent_attribute add
	foreign key( name, class, domain ) references native_attribute( name, class, domain ) 
	on update cascade on delete cascade deferrable;

-- R27
alter table identifier add
	foreign key( class, domain ) references class( name, domain )
	on update cascade on delete cascade deferrable;

-- R30
alter table modeled_identifier add
	foreign key( number, class, domain ) references identifier( number, class, domain )
	on update cascade on delete cascade deferrable;

-- R31 -- See Formalization Subsystem

-- R32
alter table referential_role add
	foreign key( to_identifier, to_attribute, to_class, domain )
		references identifier_attribute( identifier, attribute, class, domain )
	on update cascade on delete cascade deferrable;

-- Constraints <<<
set client_min_messages=NOTICE;
