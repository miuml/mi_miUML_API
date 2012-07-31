create or replace function mistate.method_multiple_assigner_to_single(
	p_rnum			multiple_assigner.rnum%type,
	p_domain		multiple_assigner.domain%type
) returns void as 
$$
--
-- Method:  Multiple Assigner.To single
--
-- Migrates this Multiple Assigner to a Single Assigner.
--
--
-- Copyright 2012, Model Integration, LLC
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
	self	multiple_assigner%rowtype;
begin
	-- Verify existence
	begin
		select * into strict self from multiple_assigner where
			rnum = p_rnum and domain = p_domain;
	exception
		when no_data_found then raise exception
			'UI: Multiple assigner not defined on [R%] in domain [%].',
				p_rnum, p_domain;
	end;

	-- Delete the old self instance
	delete from multiple_assigner where
		rnum = self.rnum and domain = self.domain;

	-- Create the new self instance
	insert into single_assigner( rnum, domain )
		values( self.rnum, self.domain );
end
$$
language plpgsql;
