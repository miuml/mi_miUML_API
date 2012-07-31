create or replace function mirrid.method_rr_assoc_identifier_new(
	p_ref_type		miform.associative_reference.type%type,
	p_part_class	miform.associative_reference.part_class%type,
	p_assoc_class	rr_assoc_identifier.assoc_class%type,
	p_rnum			miform.associative_reference.rnum%type,
	p_domain		rr_assoc_identifier.domain%type
) returns rr_identifier.number%type as 
$$
--
-- Creates a Required Referential Associative Identifier (called by subclass only)
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
	my_number	rr_assoc_identifier.number%type;
begin
	-- Get the next ID Number
	my_number := method_rr_identifier_new(
		p_part_class, p_assoc_class, p_ref_type, p_rnum, p_domain
	);

	insert into rr_assoc_identifier( number, assoc_class, domain ) values(
		my_number, p_assoc_class, p_domain
	);

	return my_number;
end
$$
language plpgsql;

