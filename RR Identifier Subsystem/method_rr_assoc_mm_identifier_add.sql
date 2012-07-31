create or replace function mirrid.method_rr_assoc_mm_identifier_add(
	p_id_num		rr_assoc_mm_identifier.number%type,
	p_part_class	referential_role.to_class%type,
	p_assoc_class	rr_assoc_mm_identifier.assoc_class%type,
	p_domain		association_class.domain%type,
	p_ref_type		to_many_in_mx_mx_assoc_ref.type%type,
	p_rnum			association_class.rnum%type
) returns void as
$$
--
-- Adds Reference (t or p) to an existing RR MM identifier
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
	this_ref_role	referential_role%rowtype;
begin
	-- Create all Identifier Attributes for my Reference
	for this_ref_role in
		select * from referential_role where
			from_class = p_assoc_class and
			reference_type = p_ref_type and
			to_class = p_part_class and
			rnum = p_rnum and
			domain = p_domain
	loop
		perform miclass.method_id_attr_new(
			this_ref_role.from_attribute, this_ref_role.from_class, this_ref_role.domain,
			p_id_num
		);
	end loop;
end
$$
language plpgsql;
