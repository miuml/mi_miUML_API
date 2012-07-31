create or replace function miclass.UI_new_class(
	-- New
	p_name		text,	-- mi.name: Full name of the class, spaces okay
	p_alias		text,	-- mi.short_name: Short name, no whitespace
	-- Existing
	p_subsys	mi.name,	-- mi.name: Subsystem
	p_domain	mi.name,	-- mi.name: Domain
	-- New
	p_cnum		integer default null,	-- mi.nominal: Desired cnum
	p_id_name	text default null,	-- mi.name: Optional ID Attr name
	p_id_type	text default null	-- mi.compound_name: Optional ID Attr type
) returns mi.nominal as 
$$
--
-- Creates a new Class.  Since a Class requires at least one Identifier, one
-- must be created with the Class.  If an Identifier Attribute name and Type
-- are supplied, they will be used.  If either or both values are not specified,
-- system defaults will be used.  Ordinarily, each new Class is automatically
-- numbered within its Subsystem's numbering range.  The user may optionally
-- supply a desired number.  If this number is not already in use, or outside
-- the Subsystem numbering range, it will be applied to the new Class.
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
declare
	v_name			miclass.class.name%type;
	v_alias			miclass.class.alias%type;
	v_cnum			miclass.class.cnum%type;
	v_id_name		attribute.name%type;
	v_id_type		native_attribute.type%type;
	not_formalizing	boolean	:= false;
begin
	
	-- Input validation
	begin
		v_name := rtrim( p_name );
	exception
		when check_violation then
			raise exception 'UI: Class name [%] violates format.', p_name;
	end;
	begin
		v_alias := rtrim( p_alias );
	exception
		when check_violation then
			raise exception 'UI: Class alias [%] violates format.', p_alias;
	end;
	-- These next two may be NULL, which should be passed along
	-- Check violations should fire only when values are provided
	begin
		v_id_name := rtrim( p_id_name );
	exception
		when check_violation then
			raise exception 'UI: ID attribute name [%] violates format.', p_id_name;
	end;
	begin
		if p_cnum is not null then
			v_cnum := p_cnum;
		end if;
	exception
		when check_violation then
			raise exception 'UI: Cnum [%] must be a positive integer.', p_cnum;
	end;
	begin
		v_id_type := rtrim( p_id_type );
	exception
		when check_violation then
			raise exception 'UI: ID attribute type name [%] violates format.', p_id_type;
	end;

	-- Invoke function
	perform CL_new_command();
	return method_class_new(
		v_name, v_alias, p_subsys, p_domain, v_cnum, not_formalizing, v_id_name, v_id_type
	);
end
$$
language plpgsql;
