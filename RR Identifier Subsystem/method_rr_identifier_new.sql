create or replace function mirrid.method_rr_identifier_new(
	p_to_class		miform.reference.to_class%type,
	p_from_class	rr_identifier.class%type,
	p_ref_type		miform.reference.type%type,
	p_rnum			miform.reference.rnum%type,
	p_domain		rr_identifier.domain%type
) returns rr_identifier.number%type as 
$$
--
-- Creates a Required Referential Identifier (called by subclass only)
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
	my_id_num		rr_identifier.number%type;
	this_ref_role	miclass.referential_role%rowtype;
begin
	-- Get the next ID Number
	my_id_num := method_id_new( p_from_class, p_domain );

	insert into rr_identifier( number, class, domain ) values(
		my_id_num, p_from_class, p_domain
	);

	-- Create all Identifier Attributes for my Reference
	for this_ref_role in
		select * from referential_role where
			from_class = p_from_class and
			reference_type = p_ref_type and
			to_class = p_to_class and
			rnum = p_rnum and
			domain = p_domain
	loop
		perform miclass.method_id_attr_new(
			this_ref_role.from_attribute, this_ref_role.from_class, this_ref_role.domain,
			my_id_num
		);
	end loop;

	return my_id_num;
end
$$
language plpgsql;

