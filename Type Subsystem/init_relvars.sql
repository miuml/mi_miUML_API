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
drop schema if exists mitype cascade;
create schema mitype;
set search_path to mitype;

-- Types (from class models)

-- Base Relvars (relation variables from class models)
-- Model comments to be filled in by Model->SQL generator
-- Model: Class Name (initial caps w/spaces) -> SQL: table name (lowercase w/underscores)
-- Model: {I<n>} = Identity Constraint  -> SQL: Primary Key component I and Unique for I2..n
-- Model: {R<n>} = Relationship -> SQL: Foreign Key

-- Relvars

-- Constrained Type --
create table constrained_type( 
	name	mi.name,	-- I, R714->Type.Name
    -- actually, should be mi.compound_name, but we'll use mi.name for testing

	primary key( name )
);


/*
-- R16
alter table spanning_element add
	foreign key( number, domain ) references element( number, domain )
	on update cascade deferrable;

alter table subsystem_element add
	foreign key( number, domain ) references element( number, domain )
	on update cascade deferrable;
*/
set client_min_messages=NOTICE;
