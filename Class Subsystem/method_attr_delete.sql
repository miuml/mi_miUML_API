create or replace function miclass.method_attr_delete(
	-- Existing
	p_attr		attribute.name%type,
	p_class		attribute.class%type,
	p_domain	attribute.domain%type
) returns void as 
$$
--
-- Removes an Attribute.
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
	this_id_attr		identifier_attribute%rowtype;
	id_attr_deleted		boolean := false;  -- Was an ID Attribute deleted?
begin
	-- First, remove this Attribute from each Identifier in which it participates
	for this_id_attr in
		select * from identifier_attribute where
			attribute = p_attr and class = p_class and domain = p_domain
	loop
		perform method_id_attr_delete(
			this_id_attr.attribute, this_id_attr.class, this_id_attr.domain,
			this_id_attr.identifier -- An Attribute may participate in more than one ID
		);
		-- Deletion may fail if it would eliminate the last Identifier of the Class
		-- or if any Relationships would be destroyed.
		id_attr_deleted := true;
	end loop;

	-- At this point, the Attribute is not part of any Identifier and,
	-- consequently, not referenced in any Relationship.  So it is okay to delete.
	delete from attribute where 
		name = p_attr and class = p_class and domain = p_domain;
	-- Cascade deletes all subclasses

	perform CL_edit(
		p_domain || ':' || p_class || ':' || p_attr,
		'delete',
		'attribute'
	);

	-- This Attribute participated in at least one Identifier
	-- The Class may need to create a new Identifier if none remain
	if id_attr_deleted then
		perform event_class_id_attr_removed( p_class, p_domain );
	end if;
end
$$
language plpgsql;
