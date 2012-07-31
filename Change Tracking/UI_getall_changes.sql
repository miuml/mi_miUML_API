create or replace function miuml.UI_getall_changes(
	-- OUT
	o_object_id		OUT mi.entity_id,
	o_operation		OUT mi.name,
	o_entity_type	OUT mi.name
) returns setof record as  -- Change
$$
--
-- Returns all entities changed in the previous command.

-- The UI should consult this list after each command is processed since a
-- small change to one entity may result in changes to other entities.  For
-- example, the deletion of one Attribute may result in the deletion of
-- Referential Attributes elsewhere.  The object_id is a semicolon delimited
-- series of one or more values interpreted according to the entity_type.
--
-- For example, an object_id 'Gas:Valve:Status'
-- corresponds to domain, class and attribute name if the entity_type is 'attribute'.
-- 'Gas:Valve:2' corresponds to domain, class, id number if the entity_type is
-- 'identifier'.  The operation refers to the type of edit that occurred such as
-- 'deleted', 'renamed', 'new', 'resequenced ids' and so forth.
--
-- Based on the returned change data, the UI should perform the corresponding
-- queries to refresh any displayed model data.
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

return query
	select * from change;
end
$$
language plpgsql;
