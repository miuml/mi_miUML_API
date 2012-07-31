create or replace function mirel.method_loop_new(
	p_rels		integer[],
	p_domain	relationship.domain%type
) returns constrained_loop.element%type as 
$$
--
-- Creates a new Constrained Loop from the supplied Relationships.
-- The Relationships must be contiguous.  Returns the element number
-- of the newly created Constrained Loop.
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
	my_element_number	constrained_loop.element%type;
	r					integer;
begin
	-- Assign the next Element number
	select method_spanning_element_new( p_domain ) into my_element_number;

	insert into constrained_loop( element, domain ) values(
		my_element_number, p_domain
	);

	-- Raise exception if not contiguous
	perform method_loop_validate( p_rels, p_domain );

	-- Create Loop Segments
	for r in 1 .. array_upper( p_rels, 1 )
	loop
		insert into loop_segment( cloop, rnum, domain )
			values( my_element_number, p_rels[r], p_domain );
	end loop;

	return my_element_number;
end
$$
language plpgsql;
