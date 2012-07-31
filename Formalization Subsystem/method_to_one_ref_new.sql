create or replace function miform.method_to_one_ref_new(
	p_from_mult		miuml.mult,
	p_from_class	to_one_reference.from_class%type,
	p_to_class		to_one_reference.to_class%type,
	p_to_side		to_one_reference.to_side%type,
	p_to_cond		boolean,
	p_rnum			to_one_reference.rnum%type,
	p_domain		to_one_reference.domain%type
) returns void as 
$$
--
-- Creates a new To One Reference
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
	to_id_attr		identifier_attribute%rowtype;
begin
	-- Create superclass instance
	perform method_reference_new( 'O', p_from_class, p_to_class, p_rnum, p_domain );

	-- Create self instance
	insert into to_one_reference( from_class, to_class, to_side, rnum, domain, type )
		values( p_from_class, p_to_class, p_to_side, p_rnum, p_domain, 'O' );

	-- Add referential attributes to this Reference
	for to_id_attr in
		select * from miclass.identifier_attribute where
			identifier = 1 and -- take reference to primary id
			class = p_to_class and domain = p_domain
	loop
		perform miclass.method_ref_attr_new(
			-- From
			p_from_class,
			-- To
			to_id_attr.attribute, p_to_class, 1,
			-- Ref Role
			'O', p_rnum, p_domain
		);
	end loop;
	
	-- Create RR identifier if referenced side is unconditional
	if p_from_mult = '1' and not p_to_cond then
		-- Create a new identifier in the assoc class
		perform mirrid.method_rr_to_one_uncond_identifier_new(
			p_from_class, p_to_class, p_rnum, p_domain
		);
	end if;
end
$$
language plpgsql;

