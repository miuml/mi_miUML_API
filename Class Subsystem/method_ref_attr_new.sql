create or replace function miclass.method_ref_attr_new(
	-- From
	p_from_class	referential_attribute.class%type,
	-- To
	p_to_attr		referential_attribute.name%type,
	p_to_class		referential_role.to_class%type,
	p_to_id			referential_role.to_identifier%type,
	-- Ref Role
	p_ref_type		referential_role.reference_type%type,
	p_rnum			referential_role.rnum%type,
	p_domain		referential_attribute.domain%type
) returns void as 
$$
--
-- Creates a new Referential Attribute
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
declare
	ref_attr_name	referential_attribute.name%type;
	first_rename	boolean := true;
	to_class_alias	miclass.class.alias%type;
	my_type			referential_attribute.type%type;
begin
	ref_attr_name := p_to_attr;

	-- The chosen referential attribute name may already be taken.  For example,
	-- if we are given Pig_Name to refer to the Name attribute in a class Pig, but
	-- there is already another referential attribute in the referring class titled
	-- Pig_Name, we need to add a numeric suffix to create Pig_Name _1.  If that is
	-- taken, we will try Pig_Name _2, and so forth until we succeed.
	loop
		perform * from attribute where
			name = ref_attr_name and class = p_from_class and domain = p_domain;
		if found then
			if first_rename then
				select alias from miclass.class where name = p_to_class and domain = p_domain
					into to_class_alias;
				ref_attr_name := to_class_alias || '_' || ref_attr_name;
				first_rename := false;
			else
				-- Create (initially) or increment the existing numeric suffix
				ref_attr_name := mi.op_name_incr( ref_attr_name );
				-- And let's try that again
			end if;
		else
			-- Not found, so it's unique and we can use the name
			exit;
		end if;
	end loop;

	-- Create superclass instance
	perform method_attr_new( ref_attr_name, p_from_class, p_domain );

	-- Get type of referenced attribute
	my_type := method_attr_type( p_to_attr, p_to_class, p_domain );

	-- Create self instance
	insert into referential_attribute( name, class, domain, type ) values(
		ref_attr_name, p_from_class, p_domain, my_type
	);

	perform CL_edit(
		p_domain || ':' || p_from_class || ':' || ref_attr_name,
		'new',
		'attribute'
	);
	-- Create referential role
	insert into referential_role(
		from_attribute, from_class,
		to_attribute, to_class, to_identifier,
		reference_type, rnum, domain
	) values (
		ref_attr_name, p_from_class,
		p_to_attr, p_to_class, p_to_id,
		p_ref_type, p_rnum, p_domain
	);

	perform CL_edit(
		p_domain || ':' || p_from_class || ':' || ref_attr_name || ':' || p_rnum,
		'new',
		'ref role'
	);
end
$$
language plpgsql;
