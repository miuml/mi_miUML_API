create or replace function midom.method_realized_domain_new(
	p_name	domain.name%type,
	p_alias	domain.alias%type
) returns void as 
$$
--
-- Creates a new Realized Domain.
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
begin
	perform method_domain_new( p_name, p_alias );

	insert into realized_domain( name ) values ( p_name );
end
$$
language plpgsql;
