create or replace function miclass.UI_set_native_attr_type(
	-- Existing
	p_attr		mi.name,	-- Attrbute name
	p_class		mi.name,	-- Its Class
	p_domain	mi.name,	-- Its Domain
	-- New
	p_type		mi.compound_name	-- The new, existing, Constrained Type
) returns void as 
$$
--
-- Changes the data type (Constrained Type) of a Native (non referential) Attribute.
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
	perform method_native_attr_set_type( p_attr, p_class, p_domain, p_type );
end
$$
language plpgsql;
