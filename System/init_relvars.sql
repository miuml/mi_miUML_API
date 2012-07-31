-- init_relvars.sql
--
-- Initializes content common across all miUML domains. 
-- (Not to be confused with a plpgsql domain!).
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
set client_min_messages=ERROR;

drop schema if exists mi cascade;
create schema mi;
set search_path to mi;

-- miUML Common Types, implemented as plpgsql domains
--

-- Constrained Types - >>>
--
-- These are Constrained Types available to all miUML Domains
--

-- posint - Positive integers.  Relevant math ops available.
create domain posint as integer
	constraint bad_posint_value check( value > 0 );

-- nominal - Positive integer values used only for naming.  No math ops defined.
create domain nominal as posint;

-- var_name - for platform variables (such as postgresql sequence names)
create domain var_name as text
	constraint bad_mi_var_name check( value ~'^[A-Za-z_]\w{1,139}$' );
	-- Regex says: No whitespace characters are permitted, 1-139 max length
	-- Must start with alpha or underscore char

 -- name - For Class, Attribute, Domain, and variable names in general
 -- Must start with alpha or underscore character, after which
 -- spaces are also allowed up to a maximum length, long enough for descriptive
 -- names.  No trailing whitespace allowed.
 -- A hyphen may be used anywhere between the first and last character.
create domain name as text
	constraint bad_mi_name check( value ~'(^[A-Za-z_][\-\w\s]{0,139}\w$|^\w$)' );
	-- Read this regex as:
		-- Either: One alpha char or underscore, 0-139 (hypen, word or space char) and
		--  	a final word char
		-- Or: Just one alpha or underscore char
	-- \w = word character (alnum with underscore)
	-- \s = space

-- compound_name - For names concatenated using '.' as a delimiter
-- For example, domain type names have the format <domain>.<type name>
create domain compound_name as text
	constraint bad_mi_compound_name check( value ~ '(^[A-Za-z_][\-\w\s.]*\w$|^\w$)' );
	-- \w = alnum with underscore
	-- \s = space

-- short_name - Used for abbreviations, aliases, keys, codes
-- No whitespace allowed anywhere, short length.  Underscores okay.
create domain short_name as text
	constraint bad_mi_short_name check( value ~ '^[A-Za-z_]{1,12}$' );
	-- \w = alnum with underscore

-- description - Unbounded text with no character restrictions.  May be empty.
-- Used for free form descriptions of variable and unpredictable length.
create domain description as text;

-- entity_id - Used to anonymize identifier values passed between miUML Domains
-- Represents the miUML concept of an External Entity
-- Values are typically recast to local types for the receiving miUML Domain
create domain entity_id as text;

-- utcdate - Use this for all date/time values
create domain utcdate as timestamp;
-- Constrained Types - <<<

set client_min_messages=NOTICE;
