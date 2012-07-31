create or replace function mistate.method_single_assigner_to_multiple(
	-- ID
	p_rnum			single_assigner.rnum%type,
	p_domain		single_assigner.domain%type,
	-- Args
	p_loop			multiple_assigner.cloop%type,
	p_partition		multiple_assigner.pclass%type
) returns void as 
$$
--
-- Method:  Single Assigner.To multiple
--
-- Changes the specified Single Assigner to a Multiple Assigner.
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
	self	single_assigner%rowtype;
begin
	-- Verify existence
	begin
		select * into strict self from single_assigner where
			rnum = p_rnum and domain = p_domain;
	exception
		when no_data_found then raise exception
			'UI: Single assigner not defined on [R%] in domain [%].',
				p_rnum, p_domain;
	end;

	-- Delete old self instance
	delete from single_assigner where
			rnum = self.rnum and domain = self.domain;
	
	-- The code below is copied from the Multiple Assigner.New method and
	-- it should really be refactored.  In the interest of speed, we'll 
	-- deal with that later.

	-- Validate constrained loop
	if not mirel.method_loop_rel_inside( self.rnum, p_loop, self.domain ) then
		raise exception 'UI: Association [R%::%] is not inside constrained loop [%].',
			self.rnum, self.domain, p_loop;
	end if;

	-- Validate partitioning class
	if not mirel.method_loop_class_inside( p_partition, p_loop, self.domain ) then
		raise exception 'UI: Class [%::%] is not inside constrained loop [%] in domain [%].',
			self.rnum, p_loop, self.domain;
	end if;

	-- Create the instance
	insert into multiple_assigner( rnum, domain, cloop, pclass )
		values( self.rnum, self.domain, p_loop, p_partition );
end
$$
language plpgsql;
