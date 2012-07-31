create or replace function miclass.UI_delete_id(
	p_id_num	mi.nominal,	-- The ID number to delete
	p_class		mi.name,	-- It's Class
	p_domain	mi.name		-- The Class's Domain
) returns void as 
$$
--
-- Deletes an Identifier (and all of its Identifier Attributes).  Fails if
-- this is the only Identifier in a Class.
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
	perform method_id_delete( p_id_num, p_class, p_domain );
end
$$
language plpgsql;

