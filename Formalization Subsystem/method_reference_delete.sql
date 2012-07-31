create or replace function miform.method_reference_delete(
	p_ref_type		reference.type%type,
	p_from_class	reference.from_class%type,
	p_to_class		reference.to_class%type,
	p_rnum			reference.rnum%type,
	p_domain		reference.domain%type
) returns void as 
$$
--
-- Deletes a Reference
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
declare
	this_ref_role		referential_role%rowtype;
begin
	-- Delete each Referential Role in this Reference
	for this_ref_role in
		select * from referential_role where
			reference_type = p_ref_type and
			from_class = p_from_class and
			to_class = p_to_class and
			rnum = p_rnum and
			domain = p_domain
	loop
		perform miclass.method_ref_role_delete(
			this_ref_role.from_attribute, this_ref_role.from_class,
			this_ref_role.reference_type, this_ref_role.to_class,
			this_ref_role.rnum, this_ref_role.domain
		);
	end loop;

	-- Delete self
	delete from reference where
		type = p_ref_type and from_class = p_from_class and to_class = p_to_class and
		rnum = p_rnum and domain = p_domain;
	-- Deletion cascades to Superclass, To One, Assoc, T, P, Symm and
	-- Assym Reference subclass instances
end
$$
language plpgsql;
