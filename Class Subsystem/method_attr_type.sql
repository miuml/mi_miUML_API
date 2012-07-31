create or replace function miclass.method_attr_type(
	-- To
	p_name		attribute.name%type,
	p_class		attribute.class%type,
	p_domain	attribute.domain%type
) returns native_attribute.type%type as -- resolves to native ultimately
$$
--
-- Returns the data type of an Attribute.  This may be the Type defined for a Native
-- Attribute or it may be the derived Type determined for a Referential Attribute.
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
	my_type		native_attribute.type%type;
begin
	-- Returns assigned type if Native Attribute
	select type into my_type from native_attribute where
		name = p_name and class = p_class and domain = p_domain limit 1;
	if found then
		return my_type;
	end if;

	-- Must be Referential Attribute, returns derived type
	select type into my_type from referential_attribute where
		name = p_name and class = p_class and domain = p_domain limit 1;
	return my_type;
end
$$
language plpgsql;
