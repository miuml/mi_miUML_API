create or replace function midom.UI_get_subsystems(
	-- IN
	p_domain	text default null,
	-- OUT
    o_domain    OUT mi.name,
	o_name		OUT mi.name,
	o_alias		OUT mi.short_name,
	o_floor		OUT mi.posint,
	o_ceiling	OUT mi.posint
) returns setof record as 
$$
--
-- Returns all Subsystem names and aliases or just those in the specified Domain.
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
    return query
        select subsystem.domain, name, alias, floor, ceiling from
            subsystem join subsystem_range on(
            subsystem_range.subsystem = subsystem.name and
            subsystem_range.domain = subsystem.domain
        ) where subsystem.domain = coalesce(p_domain, subsystem.domain) order by name;
end
$$
language plpgsql;
