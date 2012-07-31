create or replace function mirel.UI_new_loop(
	-- Existing
	p_rels		integer[],	-- A list of rnums
	p_domain	mi.name		-- Domain
) returns mi.nominal as  -- Spanning element number
$$
--
-- Creates a new Constrained Loop from the supplied Relationships.
-- The Relationships must be contiguous.  Returns the element number
-- of the newly created Constrained Loop.
--
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
	v_rnum			relationship.rnum%type;
	r				integer;
	nrels			integer;
begin
	nrels = array_length( p_rels, 1);
	if ( nrels is null ) or ( nrels is not null and nrels < 1 ) then
		raise 'UI: At least one relationship must be specified in a constrained loop.';
	end if;

	for r in 1 .. array_upper( p_rels, 1 )
	loop
		begin
			-- Verify rnum format and Relationship existence
			v_rnum := p_rels[r];
			perform * from relationship where rnum = v_rnum and domain = p_domain;
			if not found then
				raise 'UI: [%::R%] does not exist.', p_domain, v_rnum;
			end if;
		exception
			when check_violation then
				raise 'UI: R[%] violates rnum format.', p_rels[r];
		end;
	end loop;

	-- Valid data, but
	return method_loop_new( p_rels, p_domain );
end
$$
language plpgsql;
