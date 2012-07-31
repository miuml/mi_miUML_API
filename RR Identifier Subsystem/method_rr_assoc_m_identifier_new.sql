create or replace function mirrid.method_rr_assoc_m_identifier_new(
	p_part_class	associative_reference.part_class%type,
	p_assoc_class	rr_assoc_m_identifier.assoc_class%type,
	p_domain		rr_assoc_m_identifier.domain%type,
	p_ref_type		rr_assoc_m_identifier.type%type,
	p_rnum			rr_assoc_m_identifier.rnum%type
) returns void as 
$$
--
-- Creates a new RR Associative M Identifier
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
	my_id_num		rr_assoc_m_identifier.number%type;
begin
	my_id_num := method_rr_assoc_identifier_new(
		p_ref_type, p_part_class, p_assoc_class, p_rnum, p_domain
	);

	insert into rr_assoc_m_identifier( number, assoc_class, domain, type, rnum ) values( 
		my_id_num, p_assoc_class, p_domain, p_ref_type, p_rnum
	);
end
$$
language plpgsql;
