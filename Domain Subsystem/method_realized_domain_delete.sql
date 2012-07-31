create or replace function midom.method_realized_domain_delete(
	-- id
	p_domain		domain.name%type -- Realized Domain to delete
	-- args
) returns boolean as 
$$
--
-- Removes an existing Realized Domain.
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
	-- Nothing special happens
	delete from realized_domain where name = p_domain;
	-- Subclass status
	if found then
		return true;
	else
		return false;
	end if;
end
$$
language plpgsql;
