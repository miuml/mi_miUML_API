create or replace function mistate.method_multiple_assigner_set_partition(
	p_rnum			multiple_assigner.rnum%type,
	p_domain		multiple_assigner.domain%type,
	p_partition		multiple_assigner.pclass%type
) returns void as 
$$
--
-- Method:  Multiple Assigner.Set partition
--
-- Changes the partition class that this Multiple Assigner references.  It must be
-- a Class in the same Constrained Loop as this Multiple Assigner.
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
	begin
		select * into strict self from multiple_assigner where
			rnum = p_rnum and domain = p_domain;
	exception
		when no_data_found then raise exception
			'UI: Multiple assigner not defined on [R%] in [%] domain.',
				p_rnum, p_domain;
	end;

	-- Noop if the new partition is the same as the existing partition
	if self.pclass = p_partition then return; end if;
	
	-- Validate partitioning class
	if not mirel.method_loop_class_inside( p_partition, self.cloop, self.domain ) then
		raise exception 'UI: Class [%::%] is not inside constrained loop [%].',
			p_partition, p_domain, self.cloop;
	end if;

	-- Set the new partition class
	update multiple_assigner set pclass = p_partition where
		rnum = self.rnum and domain = self.domain;

	-- Assert that an update occurred
	if not found then raise exception
		'SYS: Assertion failed.  Multiple assigner not updated.';
	end if;
end
$$
language plpgsql;
