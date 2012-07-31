create or replace function miclass.event_ref_attr_ref_role_deleted(
	p_attr		referential_attribute.name%type,
	p_class		referential_attribute.class%type,
	p_domain	referential_attribute.domain%type
) returns void as 
$$
--
-- Event: Referential Role Deleted
--
-- The Referential Attribute must see if it participates in any remaining Referential
-- Roles.  If not, it must either delete itself or become an Independent Attribute.
-- If the Referential Attribute is referenced in some other Relationship, it must
-- remain in place as an Independent Attribute.  Otherwise, it has no further purpose
-- and deletes itself.
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
	-- Does this Referential Attribute still formalize any Relationships?
	perform * from referential_role where
		from_attribute = p_attr and
		from_class = p_class and
		domain = p_domain;
	if found then
		return; -- Do nothing, this is still a Referential Attribute
	end if;

	-- This Referential Attribute is no longer formalizing any Relationships

	-- Is this Referential Attribute referenced in any other Relationship?
	perform * from referential_role where
		to_attribute = p_attr and
		to_class = p_class and
		domain = p_domain;
	if found then
		-- Cannot delete without breaking some other Relationship, just migrate
		perform method_ref_attr_migrate_ind( p_attr, p_class, p_domain );
	else
		-- Delete self (via cascade from Attribute)
		perform method_attr_delete( p_attr, p_class, p_domain );
	end if;
end
$$
language plpgsql;
