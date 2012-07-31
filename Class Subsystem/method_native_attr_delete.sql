create or replace function miclass.method_native_attr_delete(
	p_attr		native_attribute.name%type,
	p_class		native_attribute.class%type,
	p_domain	native_attribute.domain%type
) returns void as 
$$
--
-- Deletes a Native Attribute, called by subclass only, so it is assumed that any subclass
-- instance has just been deleted.
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
	-- Delete superclass instance
	perform method_attr_delete( p_attr, p_class, p_domain );

	-- Cascade delete self subclass instance
end
$$
language plpgsql;
