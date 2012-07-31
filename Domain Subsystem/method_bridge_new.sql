create or replace function midom.method_bridge_new(
	p_client		domain.name%type,
	p_service		domain.name%type
) returns void as 
$$
--
-- Creates a new Bridge between a Domain in the client role and another in the service role.
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
	-- Create the Subsystem object
	insert into bridge( client, service ) values(
		p_client,
		p_service
	);

	exception
		when check_violation then
			if p_client = p_service then
				raise exception 'UI: Client and service domains must be different.';
			end if;
		when unique_violation then
			raise exception 'UI: Bridge [%->%] already exists.', p_client, p_service;
		when foreign_key_violation then
			perform * from domain where name = p_client;
			if not found then
				raise exception 'UI: Client domain [%] does not exist.', p_client;
			else
				raise exception 'UI: Service domain [%] does not exist.', p_service;
			end if;
end
$$
language plpgsql;
