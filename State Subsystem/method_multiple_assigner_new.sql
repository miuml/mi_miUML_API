create or replace function mistate.method_multiple_assigner_new(
	p_rnum			multiple_assigner.rnum%type,	-- Must be an Association relationship
	p_loop			multiple_assigner.cloop%type,	-- Element number of constrained loop
	p_partition		multiple_assigner.pclass%type,	-- Class within same Constrained Loop 
	p_domain		multiple_assigner.domain%type
) returns void as 
$$
--
-- Method:  Multiple Assigner.New
--
-- Creates a new Multiple Assigner State Model on the specified Association.  Error returned
-- if one is already defined.  Also, both Constrained Loop and partitioning Class will be
-- validated to ensure that the meet requirements annotated in signature above.
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
begin
	-- Create the superclass
	perform method_assigner_new( p_rnum, p_domain );

	-- Validate constrained loop
	if not mirel.method_loop_rel_inside( p_rnum, p_loop, p_domain ) then
		raise exception 'UI: Association [R%::%] is not inside constrained loop [%].',
			p_rnum, p_domain, p_loop;
	end if;

	-- Validate partitioning class
	if not mirel.method_loop_class_inside( p_partition, p_loop, p_domain ) then
		raise exception 'UI: Class [%::%] is not inside constrained loop [%] in domain [%].',
			p_rnum, p_loop, p_domain;
	end if;

	-- Create the instance
	insert into multiple_assigner( rnum, domain, cloop, pclass )
		values( p_rnum, p_domain, p_loop, p_partition );
end
$$
language plpgsql;
