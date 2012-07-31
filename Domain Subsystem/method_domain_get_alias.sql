create or replace function midom.method_domain_get_alias(
	p_name		domain.name%type
) returns domain.alias%type as 
$$
--
-- Method: Domain.Get alias
--
-- Returns the alias of the specified domain.
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
declare
	self	domain%rowtype;
begin
	select * into strict self from domain where name = p_name;
	return self.alias;

exception
	when no_data_found then
		raise exception 'SYS: Domain [%] does not exist.', p_name;
end
$$
language plpgsql;
