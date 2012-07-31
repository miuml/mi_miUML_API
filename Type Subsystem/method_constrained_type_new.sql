create or replace function mitype.method_constrained_type_new(
	-- args
	p_name		mi.name
) returns void as 
$$
--
-- Creates a new Type.
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
	insert into constrained_type( name ) values( p_name ); 

	exception
		when unique_violation then
			raise exception 'UI: Type [%] already exists.', p_name;
end
$$
language plpgsql;
