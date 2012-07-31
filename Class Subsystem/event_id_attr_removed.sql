create or replace function miclass.event_id_attr_removed(
	p_id_num	identifier.number%type,	-- The ID number
	p_class		identifier.class%type,	-- It's Class
	p_domain	identifier.domain%type	-- The Class's Domain
) returns void as 
$$
--
-- Event: Identifier Attribute Removed
--
-- An Identifier Attribute was removed from this Identifier.  If there are no other
-- Identifier Attributes, and this is not the only Identifier of its Class, delete it.
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
	-- Are there any remaining Attributes in this Identifier?
	perform * from identifier_attribute where
		identifier = p_id_num and
		class = p_class and
		domain = p_domain;
	if found then
		-- The Identifier remains in place, no change
		return;
	end if;

	-- The Identifier has no more component Attributes.  Can we delete it?
	-- Check cases where we cannot:

	-- The Identifier is referenced by at least one Relationship
	perform * from referential_role where
		to_identifier = p_id_num and to_class = p_class and domain = p_domain;
	if found then
		raise exception 'UI: Identifier [%] in class [%::%] is still referenced.',
			p_id_num, p_domain, p_class;
	end if;

	-- Okay to delete self
	delete from identifier where
		number = p_id_num and class = p_class and domain = p_domain;
	
	perform CL_edit(
		p_domain || ':' || p_class || ':' || p_id_num,
		'delete',
		'identifier'
	);

	-- Resquence any remaining Identifiers
	perform * from identifier where
		class = p_class and domain = p_domain;
	if found then
		perform method_class_reseq_ids( p_class, p_domain );
	end if;
end
$$
language plpgsql;
