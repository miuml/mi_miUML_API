create or replace function miclass.method_attr_set_name(
	-- id
	p_old_name	miclass.attribute.name%type,
	p_class		miclass.attribute.class%type,
	p_domain	miclass.attribute.domain%type,
	-- args
	p_new_name	miclass.attribute.name%type
) returns void as 
$$
--
-- Changes the name of an Attribute.
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
begin
	declare
		self	miclass.attribute%rowtype;
	begin
		update attribute set name = p_new_name where 
			name = p_old_name and class = p_class and domain = p_domain
			returning * into strict self;
	exception
		when no_data_found then
			raise exception 'UI: Attribute [%::%.%] does not exist.',
				p_domain, p_class, p_old_name;
	end;

	perform CL_edit(
		p_domain || ':' || p_class || ':' || p_old_name || ':' || p_new_name,
		'rename',
		'attribute'
	);
end
$$
language plpgsql;
