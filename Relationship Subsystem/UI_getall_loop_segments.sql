create or replace function mirel.UI_getall_loop_segments(
	-- IN
	p_domain	mi.name,
	-- OUT
	o_loop		OUT mi.nominal,
	o_rnum		OUT mi.nominal
) returns setof record as  -- Loop Segment
$$
--
-- Returns all Loop Segments in the specified Domain
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
begin
	perform * from domain where name = p_domain;
	if not found then
		raise exception 'UI: Domain [%] does not exist.', p_domain;
	end if;

return query
	select cloop, rnum from loop_segment where domain = p_domain
	order by cloop, rnum;

end
$$
language plpgsql;
