create or replace function miform.method_associative_ref_new(
	p_ref_type		associative_reference.type%type, -- T or P
	p_side			miuml.side, -- A, P, or S
	p_refd_mult		miuml.mult,	-- Referenced multiplicity
	p_opp_mult		miuml.mult,	-- Opposite multiplicity
	p_rnum			associative_reference.rnum%type,
	p_domain		associative_reference.domain%type,
	p_assoc_class	associative_reference.assoc_class%type,
	p_part_class	associative_reference.part_class%type
) returns void as 
$$
--
-- Creates a new Associative Reference
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
	part_id_attr		miclass.identifier_attribute%rowtype;
	mm_id_num			mi.nominal;
begin
	-- Create superclass instance
	perform method_reference_new(
		p_ref_type, p_assoc_class, p_part_class, p_rnum, p_domain 
	);

	-- Create self instance
	insert into associative_reference( type, rnum, domain, assoc_class, part_class )
		values( p_ref_type, p_rnum, p_domain, p_assoc_class, p_part_class );

	-- Create symmetry subclass
	if p_side = 'S' then
		insert into symmetric_assoc_reference( type, rnum, domain, assoc_class, part_class )
			values( p_ref_type, p_rnum, p_domain, p_assoc_class, p_part_class );
	else -- A or P
		insert into asymmetric_assoc_reference( type, side, rnum, domain, assoc_class, part_class )
			values( p_ref_type, p_side, p_rnum, p_domain, p_assoc_class, p_part_class );
	end if;
	
	-- Create T/P subclass instance
	if p_ref_type = 'T' then
		insert into t_reference( rnum, domain, assoc_class, part_class, type )
			values( p_rnum, p_domain, p_assoc_class, p_part_class, p_ref_type );
	else -- P
		insert into p_reference( rnum, domain, assoc_class, part_class, type )
			values( p_rnum, p_domain, p_assoc_class, p_part_class, p_ref_type );
	end if;

	-- Add referential attributes to this Reference
	for part_id_attr in
		select * from miclass.identifier_attribute where
			identifier = 1 and -- take reference to primary id
			class = p_part_class and domain = p_domain
	loop
		perform miclass.method_ref_attr_new(
			-- From
			p_assoc_class,
			-- To
			part_id_attr.attribute, p_part_class, 1,
			-- Ref Role
			p_ref_type, p_rnum, p_domain
		);
	end loop;
	

	-- Create multiplicity subclass for id subsystem
	if p_refd_mult = '1' then -- To one in ???
		if p_opp_mult = 'M' then -- To one in 1x:Mx
			insert into to_one_in_1x_mx_assoc_ref( type, rnum, domain ) values(
				p_ref_type, p_rnum, p_domain
			);
			-- This reference does not participate in an RR identifier
		else -- To one in 1x:1x
			insert into to_one_in_1x_1x_assoc_ref( type, rnum, domain ) values(
				p_ref_type, p_rnum, p_domain
			);
			-- Create a new identifier in the assoc class
			perform mirrid.method_rr_assoc_1_identifier_new(
				p_part_class, p_assoc_class, p_domain, p_ref_type, p_rnum
			);
		end if;
	else -- To many in 1x:Mx or Mx:Mx
		if p_opp_mult = '1' then -- To many in 1x:Mx
			insert into to_many_in_1x_mx_assoc_ref( type, rnum, domain ) values(
				p_ref_type, p_rnum, p_domain
			);
			-- Create a new identifier in the assoc class
			perform mirrid.method_rr_assoc_m_identifier_new(
				p_part_class, p_assoc_class, p_domain, p_ref_type, p_rnum
			);
		else -- To many in Mx:Mx
			insert into to_many_in_mx_mx_assoc_ref( type, rnum, domain ) values(
				p_ref_type, p_rnum, p_domain
			);
			if p_ref_type = 'T' then
				insert into to_many_in_mx_mx_assoc_tref( type, rnum, domain ) values(
					p_ref_type, p_rnum, p_domain
				);
				-- Create a new identifier in the assoc class
				perform mirrid.method_rr_assoc_mm_identifier_new(
					p_part_class, p_assoc_class, p_domain, p_ref_type, p_rnum
				);
			else
				insert into to_many_in_mx_mx_assoc_pref( type, rnum, domain ) values(
					p_ref_type, p_rnum, p_domain
				);
				-- Get the id num of counterpart
				select number from rr_assoc_mm_identifier where
					assoc_class = p_assoc_class and
					domain = p_domain and
					rnum = p_rnum
				into mm_id_num;

				-- Add to the same identifier
				perform mirrid.method_rr_assoc_mm_identifier_add(
					mm_id_num, p_part_class, p_assoc_class, p_domain, p_ref_type, p_rnum
				);
			end if;
		end if;
	end if;

end
$$
language plpgsql;

