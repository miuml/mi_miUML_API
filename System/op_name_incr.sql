create or replace function mi.op_name_incr(
	p_name		mi.name
) returns mi.name as 
$$
--
-- Appends or increments a numeric suffic on a name to make it unique.  Useful for
-- creating a new referential attribute, for example.
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
	suffix		text;
	rindex		int;
	base_name	text;
begin
	-- See if there is already a ref attr suffix such as 'name _1'
	suffix := substring( p_name from E'_\\d+$' );
	if length( suffix ) > 0 then
		-- There is a suffix, so we will increment the number
		rindex := ltrim(suffix, '_')::int;
		base_name := rtrim( p_name, suffix ); -- Whitespace still on right
		return base_name || '_' || rindex + 1;
	else
		-- There is no suffix, so start numbering from 1
		return p_name || ' _1';
	end if;
end
$$
language plpgsql;
