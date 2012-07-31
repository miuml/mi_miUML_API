create or replace function miclass.UI_new_ind_attr(
	-- New
	p_name		text,		-- mi.name: Name of the new Attribute
	-- Existing
	p_class		mi.name,	-- Add it to this Class
	p_domain	mi.name,	-- In this Domain
	p_type		mi.name		-- Name of an existing Constrained Type
) returns void as 
$$
--
-- Create a new Attribute of the designated Constrained Type for a Class
--
-- Copyright 2011, 2012 Model Integration, LLC
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
	v_name		miclass.class.name%type;
begin
	
	-- Input validation
	begin
		v_name := trim( p_name );
	exception
		when check_violation then
			raise exception 'UI: Attribute name [%] violates format.', p_name;
	end;

	-- Invoke function
	perform method_ind_attr_new( v_name, p_class, p_domain, p_type );
end
$$
language plpgsql;
