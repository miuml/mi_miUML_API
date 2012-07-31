create or replace function mitrack.method_change_new(
	p_object_id		change.object_id%type,
	p_operation		change.operation%type,
	p_entity_type	change.entity_type%type
) returns void as 
$$
--
-- Registers a new Change
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
	insert into change( object_id, operation, entity_type ) values(
		p_object_id, p_operation, p_entity_type
	);
exception
	when unique_violation then
		-- There is already a change registered for this object id + operation
		-- so skip the insert and do nothing
end
$$
language plpgsql;
