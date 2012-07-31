create or replace function mirrid.method_rr_to_one_uncond_identifier_new(
	p_from_class	rr_to_one_uncond_identifier.from_class%type,
	p_to_class		miform.reference.to_class%type,
	p_rnum			rr_to_one_uncond_identifier.rnum%type,
	p_domain		rr_to_one_uncond_identifier.domain%type
) returns void as 
$$
--
-- Creates a Required Referential To One Unconditional Identifier (called by subclass only)
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
	my_id_num		rr_to_one_uncond_identifier.number%type;
begin
	-- Get the next ID Number
	my_id_num := method_rr_identifier_new(
		p_to_class, p_from_class, 'O', p_rnum, p_domain
	);

	insert into rr_to_one_uncond_identifier( number, from_class, rnum, domain ) values(
		my_id_num, p_from_class, p_rnum, p_domain
	);
end
$$
language plpgsql;
