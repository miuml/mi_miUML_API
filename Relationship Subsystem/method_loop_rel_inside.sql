create or replace function mirel.method_loop_rel_inside(
	p_rnum		relationship.rnum%type,
	p_loop		constrained_loop.element%type,
	p_domain	relationship.domain%type
) returns boolean as 
$$
--
-- Method: Constrained Loop.Inside
--
-- Verifies that the specified Relationship is inside this loop.
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
	perform * from loop_segment where cloop = p_loop and rnum = p_rnum and domain = p_domain;
	return found;
end
$$
language plpgsql;
