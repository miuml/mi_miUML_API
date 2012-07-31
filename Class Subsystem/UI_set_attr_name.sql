create or replace function miclass.UI_set_attr_name(
	-- Existing
	p_old_name	mi.name,	-- Old Attrbute name
	p_class		mi.name,	-- Its Class
	p_domain	mi.name,	-- Its Domain
	-- New
	p_new_name	text		-- mi.name: New Attribute name
) returns void as 
$$
--
-- Renames an Attribute.
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
	v_new_name		miclass.attribute.name%type;
begin
	-- Input validation
	begin
		v_new_name := rtrim( p_new_name );
	exception
		when check_violation then
			raise exception 'UI: New attribute name [%] violates format.', p_new_name;
	end;

	-- Invoke function
	perform method_attr_set_name( p_old_name, p_class, p_domain, v_new_name );
end
$$
language plpgsql;
