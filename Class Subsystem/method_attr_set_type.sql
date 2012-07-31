create or replace function miclass.method_native_attr_set_type(
	-- Existing
	p_attr		mi.name,	-- Attrbute name
	p_class		mi.name,	-- Its Class
	p_domain	mi.name,	-- Its Domain
	-- New
	p_type		mi.compound_name	-- The new, existing, Constrained Type
) returns void as 
$$
--
-- Changes the data type (Constrained Type) of a Native Attribute.
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
begin
	declare
		self	native_attribute%rowtype;
	begin
		update native_attribute set type = p_type where 
			name = p_attr and class = p_class and domain = p_domain
			returning * into strict self;
	exception
		when foreign_key_violation then
			raise exception 'UI: Constrained type [%] does not exist.', p_type;
		when no_data_found then
			raise exception 'UI: Native attribute [%::%.%] does not exist.',
				p_domain, p_class, p_attr;
	end;

	perform CL_edit(
		p_domain || ':' || p_class || ':' || p_attr,
		'change type',
		'attribute'
	);
end
$$
language plpgsql;
