create or replace function mirel.method_loop_class_inside(
	p_class		miclass.class.name%type,
	p_loop		constrained_loop.element%type,
	p_domain	relationship.domain%type
) returns boolean as 
$$
--
-- Method: Constrained Loop.Inside
--
-- Verifies that the specified class is inside this loop.
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
	this_loop_seg	loop_segment%rowtype;
begin
	for this_loop_seg in
		select * from loop_segment where cloop = p_loop and domain = p_domain
	loop
		perform * from perspective where
			viewed_class = p_class and rnum = this_loop_seg.rnum and
			domain = this_loop_seg.domain;
		if found then return true; end if;
	end loop;

	return false;
end
$$
language plpgsql;
