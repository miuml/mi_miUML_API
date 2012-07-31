create or replace function midom.UI_get_domains(
	o_name		OUT mi.name,
	o_alias		OUT mi.short_name,
	o_dtype		OUT text
) returns setof record as 
$$
--
-- Returns all Domain names and aliases.
--
--
-- Copyright 2011, 2012 Model Integration, LLC
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
        select name, alias, dtype from(
            select domain.name, alias, 'realized' as dtype
            from realized_domain join domain using( name )
        union
            select domain.name, alias, 'modeled' as dtype
            from modeled_domain join domain using( name )
        ) dun order by name;
end
$$
language plpgsql;
