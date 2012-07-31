create or replace function miclass.UI_add_attr_to_id(
	-- Existing
	p_name		mi.name,	-- Add this Attribute to an Identifier
	p_class		mi.name,	-- Class of both Attribute and Identifier
	p_domain	mi.name,	-- Domain of both Attribute and Identifier
	p_id_num	mi.nominal default NULL	-- An existing ID number
) returns mi.nominal as  -- The specified or assigned ID number
$$
--
-- Adds an Attribute to an Identifier in the same Class.  If the Identifier is
-- referenced by any other Class, a corresponding Referential Attribute is added
-- to each Reference.  If specified, the ID number must already exist.
-- If it is not specified, a new Identifier will be created with the next higher
-- sequence number.  ID numbers are always ordered, 1..n with no gaps in the sequence
-- and there must always be a primary ID (numbered 1).
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
begin
	return method_attr_add_to_id( p_name, p_class, p_domain, p_id_num );
end
$$
language plpgsql;
