-- init_relvars.sql
--
-- These are all of the relvars for the miUML Metamodel Domain Subsystem
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
drop schema if exists midom cascade;
create schema midom;
set search_path to midom;

-- Types (from class models)

-- Base Relvars (relation variables from class models)
-- Model comments to be filled in by Model->SQL generator
-- Model: Class Name (initial caps w/spaces) -> SQL: table name (lowercase w/underscores)
-- Model: {I<n>} = Identity Constraint  -> SQL: Primary Key component I and Unique for I2..n
-- Model: {R<n>} = Relationship -> SQL: Foreign Key

-- Relvars

-- Bridge --
create table bridge( 
	client	mi.name,	-- I, R7t->Domain.Name
	service	mi.name,	-- I, R7p->Domain.Name

	primary key( client, service ),

	constraint R7c__bridge_service__cycle check ( client != service )
);

-- Domain --
create table domain(
	name	mi.name,		-- I
	alias	mi.short_name,	-- I2

	primary key( name ),
	unique( alias )
);

-- Domain Build Specification --
create table domain_build_spec(
	name								mi.name, -- I
	domain_name_is_default_subsys_name	boolean not null,
	default_subsys_name					mi.name not null,
	default_subsys_range				mi.posint not null,
	default_id_name						mi.name not null,
	default_id_type						mi.name not null,	-- R2->Common Type.Name

	primary key( name )
);

-- Element --
create table element(
	number	serial,	-- I
	domain	mi.name,	-- I, R15->Modeled Domain.Name

	primary key( number, domain )
);

-- Modeled Domain --
create table modeled_domain(
	name	mi.name,	-- I, R4->Domain.Name

	primary key( name )
);

-- Realized Domain --
create table realized_domain(
	name	mi.name,	-- I, R4->Domain.Name

	primary key( name )
);

-- Spanning Element --
create table spanning_element(
	number	mi.nominal,-- I, R16->Element.Number
	domain	mi.name,	-- I, R16->Element.Domain

	primary key( number, domain )
);

-- Subsystem --
create table subsystem(
	name	mi.name,				-- I
	domain	mi.name,				-- I, I2, R1->Modeled Domain.Name
	alias	mi.short_name not null,	-- I2

	primary key( name, domain ),
	unique( alias, domain ),

	-- Database attributes (non-modeled)
	cnum_generator mi.name not null, -- name of this subsystem's cnum sequencer for convenience
	rnum_generator mi.name not null, -- name of this subsystem's rnum sequencer for convenience

	unique( cnum_generator, domain ), -- because gen name includes subsys name
	unique( rnum_generator, domain )
);

-- Subsystem Element --
create table subsystem_element(
	number		mi.nominal,	-- I, R16->Element.Number
	domain		mi.name,		-- I, R16->Element.Domain
	subsystem	mi.name,		-- R13->Subsystem.Name

	primary key( number, domain )
);

-- Subsystem Range --
create table subsystem_range(
	floor 		mi.posint not null,-- I
	ceiling 	mi.posint not null,-- I2
	subsystem	mi.name,			-- I, I2, R3->Subsystem.Name
	domain		mi.name,			-- I, I2, R3->Subsystem.Name

	constraint A__bad_subsys_number_range check( ceiling > floor ), -- If equal, failed seq generator
	-- Ranges may not overlap in same domain - enforce in method

	primary key( floor, subsystem, domain ),
	unique( ceiling, subsystem, domain )
);
-- End Relvars: Domains Subsystem

-- Start Foreign Key constraints: Domains Subsystem
-- Domain


-- R1
alter table subsystem add constraint
    R1_Subsystem__manages_content_of__Modeled_Domain
	foreign key( domain ) references modeled_domain( name )
	on update cascade on delete cascade deferrable;

-- R2
alter table domain_build_spec add
	foreign key( default_id_type ) references mitype.constrained_type( name ) 
	on update cascade deferrable;

-- R3
alter table subsystem_range add
    constraint R3_Subsystem_Range__establishes_numbers_for__Subsystem
	foreign key( subsystem, domain ) references subsystem( name, domain )
	on update cascade on delete cascade deferrable;

-- R4
alter table modeled_domain add constraint
    R4_Modeled_Domain__is_a__Domain
	foreign key( name ) references domain( name )
	on update cascade deferrable;

alter table realized_domain add constraint
    R4_Realized_Domain__is_a__Domain
	foreign key( name ) references domain( name )
	on update cascade on delete cascade deferrable;

-- R7t
alter table bridge add constraint
    R7_Domain__makes_assumptions_on__Domain
	foreign key( client ) references domain( name )
	on update cascade on delete cascade deferrable;
-- R7p
alter table bridge add constraint
    R7_Domain__satisfies_assumptions_of__Domain
	foreign key( service ) references domain( name )
	on update cascade on delete cascade deferrable;

-- R13
alter table subsystem_element add constraint
    R13_Subsystem_Element__is_an__Element
	foreign key( number, domain ) references element( number, domain )
	on update cascade on delete cascade deferrable;

-- R15
alter table element add constraint
    R15_Elemeent__is_modeleled_in__Modeled_Domain
	foreign key( domain ) references modeled_domain( name )
	on update cascade on delete cascade deferrable;

-- R16
alter table spanning_element add constraint
    R16_Spanning_Element__is_an__Element
	foreign key( number, domain ) references element( number, domain )
	on update cascade on delete cascade deferrable;

alter table subsystem_element add constraint
    R16_Subsystem_Elemenet__is_an__Element
	foreign key( number, domain ) references element( number, domain )
	on update cascade on delete cascade deferrable;


-- R14, R17 See Class and Relationship schemas

set client_min_messages=NOTICE;
