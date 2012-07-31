create or replace function miclass.event_class_id_attr_removed(
	p_class		identifier.class%type,
	p_domain	identifier.domain%type
) returns void as 
$$
--
-- Event: Identifier Attribute Removed
--
-- An Attribute participating in an Identifier was deleted.  If this Class has no
-- Identifiers at this point, it must create a new default ID.
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
	perform * from identifier where class = p_class and domain = p_domain;
	if not found then
		perform method_class_new_default_id( p_class, p_domain );
	end if;
end
$$
language plpgsql;
