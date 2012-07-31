create or replace function midom.method_bridge_delete(
	p_client		domain.name%type,
	p_service		domain.name%type
) returns void as 
$$
--
-- Removes an existing Bridge.
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
begin
	delete from bridge where client = p_client and service = p_service;
	if not found then
		raise exception 'UI: Bridge [%->%] does not exist.', p_client, p_service;
	end if;
end
$$
language plpgsql;
