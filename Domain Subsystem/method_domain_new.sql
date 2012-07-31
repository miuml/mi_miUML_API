create or replace function midom.method_domain_new(
	p_name domain.name%type,
	p_alias domain.alias%type
) returns void as 
$$
--
-- Creates a new Domain superclass instance.
--
--
-- Copyright 2011,2012 Model Integration, LLC
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
begin
	
	insert into domain( name, alias ) values ( p_name, p_alias );

	exception
		when unique_violation then
            perform * from domain where name = p_name;
            if found then raise exception
                'UI: Domain name [%] already exists.', p_name;
            end if;
            raise exception 'UI: Alias [%] used with domain [%].', p_alias, p_name;
end
$$
language plpgsql;
