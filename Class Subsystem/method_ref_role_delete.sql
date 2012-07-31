create or replace function miclass.method_ref_role_delete(
	p_from_attr			referential_role.from_attribute%type,
	p_from_class		referential_role.from_class%type,
	p_reference_type	referential_role.reference_type%type,
	p_to_class			referential_role.to_class%type,
	p_rnum				referential_role.rnum%type,
	p_domain			referential_role.domain%type
) returns void as 
$$
--
-- Deletes a Referential Role and notifies its associated Referential Attribute
-- which may also need to delete itself.
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
	delete from referential_role where
		from_attribute = p_from_attr and
		from_class = p_from_class and
		reference_type = p_reference_type and
		to_class = p_to_class and
		rnum = p_rnum and
		domain = p_domain;
	
	perform CL_edit(
		p_domain || ':' || p_from_class || ':' || p_from_attr || ':' || p_rnum,
		'delete',
		'ref role'
	);
	
	-- Notfiy the Referential Attribute which may need to delete itself
	perform event_ref_attr_ref_role_deleted( p_from_attr, p_from_class, p_domain );
end
$$
language plpgsql;
