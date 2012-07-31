create or replace function mirel.UI_get_segments_for_loop(
	-- IN
	p_loop		mi.nominal,
	p_domain	mi.name,
	-- OUT
	o_rnum		OUT mi.nominal
) returns setof mi.nominal as  -- rnum
$$
--
-- Returns all Loop Segments in the specified Loop
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
	perform * from constrained_loop where element = p_loop and domain = p_domain;
	if not found then
		raise exception 'UI: Constrained loop [%::%] does not exist.', p_domain, p_loop;
	end if;

return query
	select rnum from loop_segment where cloop = p_loop and domain = p_domain
		order by rnum;
end
$$
language plpgsql;
