create or replace function miuml.CL_edit(
	p_object_id		mi.entity_id,
	p_operation		mi.name,
	p_entity_type	mi.name
) returns void as 
$$
--
-- Bridge to Service Function
--
-- An edit has occured to the designated object.  It will be registered
-- so that the UI can see what changed as a result of a commnand.
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
	perform mitrack.method_change_new( p_object_id, p_operation, p_entity_type );
end
$$
language plpgsql;
