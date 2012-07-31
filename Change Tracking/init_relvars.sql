-- init_relvars.sql
--
-- These are all of the relvars for the Change Tracking Domain
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
drop schema if exists mitrack cascade;
create schema mitrack;
set search_path to mitrack;

-- Types (from class models)

-- Base Relvars (relation variables from class models)
-- Model comments to be filled in by Model->SQL generator
-- Model: Class Name (initial caps w/spaces) -> SQL: table name (lowercase w/underscores)
-- Model: {I<n>} = Identity Constraint  -> SQL: Primary Key component I and Unique for I2..n
-- Model: {R<n>} = Relationship -> SQL: Foreign Key

-- Relvars

-- Change
create table change( 
	object_id		mi.entity_id,
	operation		mi.name,		
	entity_type		mi.name,

	primary key( object_id, operation )
);

-- End Relvars: Domains Subsystem

-- Start Foreign Key constraints

-- End Foreign Key constriants

set client_min_messages=NOTICE;
