create or replace function miclass.UI_remove_attr_from_id(
	-- Existing
	p_attr		mi.name,	-- Add this Attribute to an Identifier
	p_class		mi.name,	-- Class of both Attribute and Identifier
	p_domain	mi.name,	-- Domain of both Attribute and Identifier
	p_id_num	mi.nominal	-- The Identifier number
) returns void as 
$$
--
-- Removes an Attribute from an Identifier and the Identifier as well if this was the
-- last component Attribute.  Fails on a single attribute identifier (SAI) when
-- there is no other Identifier in the Class.  When an Identifier is deleted, the
-- remaining Identifier numbers are resequenced.
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
	perform method_id_attr_delete( p_attr, p_class, p_domain, p_id_num );
end
$$
language plpgsql;
