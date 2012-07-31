create or replace function mirrid.method_rr_subclass_identifier_new(
	p_subclass		rr_subclass_identifier.subclass%type,
	p_superclass	rr_subclass_identifier.superclass%type,
	p_rnum			rr_subclass_identifier.rnum%type,
	p_domain		rr_subclass_identifier.domain%type
) returns void as 
$$
--
-- Creates a Required Referential Subclass Identifier (called by subclass only)
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
	my_id_num		rr_subclass_identifier.number%type;
begin
	-- Get the next ID Number
	my_id_num := method_rr_identifier_new(
		p_superclass, p_subclass, 'S', p_rnum, p_domain
	);

	insert into rr_subclass_identifier( number, subclass, superclass, rnum, domain ) values(
		my_id_num, p_subclass, p_superclass, p_rnum, p_domain
	);
end
$$
language plpgsql;
