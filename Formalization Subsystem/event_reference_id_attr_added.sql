create or replace function miform.event_reference_id_attr_added(
	p_ref_type		reference.type%type,
	p_from_class	reference.from_class%type,
	p_to_class		reference.to_class%type,
	p_rnum			reference.rnum%type,
	p_domain		reference.domain%type,
	p_new_attr		miclass.referential_role.to_attribute%type,
	p_id_num		miclass.referential_role.to_identifier%type
) returns void as 
$$
--
-- Event:  Identifier Attributed Added
--
-- The referenced Identifier has a new component Attribute.  A corresponding
-- referential Attribute must be added.
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
	perform miclass.method_ref_attr_new(
		-- From
		p_from_class,
		-- To
		p_new_attr, p_to_class, p_id_num,
		-- Ref Role
		p_ref_type, p_rnum, p_domain
	);
end
$$
language plpgsql;
