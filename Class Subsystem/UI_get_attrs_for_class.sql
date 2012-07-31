create or replace function miclass.UI_get_attrs_for_class(
	-- IN
	p_class		mi.name,
	p_domain	mi.name,
	-- OUT
	o_name		OUT mi.name,
	o_attr_type	OUT text,
	o_data_type	OUT mi.compound_name
) returns setof record as  -- Attribute
$$
--
-- Returns all Attributes for the specified Class.
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
begin
	perform * from miclass.class where name = p_class and domain = p_domain;
		if not found then
			raise exception 'UI: Class [%:%] does not exist.', p_domain, p_class;
		end if;

return query
	select name, attr_type, type from attribute join(
		select
			-- Native Attribute subclass
			'native' as attr_type,	-- newly computed
			name,
			class,					
			domain,
			type
			from native_attribute
		union select
			-- Referential Attribute subclass
			'referential' as attr_type,	-- newly computed
			name,
			class,
			domain,
			type from referential_attribute
	) as aun using( name, class, domain )
	-- aun: Union of both Native and Referential Attribute subclasses	
		where class = p_class and domain = p_domain order by name;
end
$$
language plpgsql;
