create or replace function midom.method_modeled_domain_delete(
	-- id
	p_domain		domain.name%type -- Modeled Domain to delete
	-- args
) returns boolean as -- subclass status 
$$
--
-- Removes an existing Modeled Domain.
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
declare
	self		modeled_domain%rowtype;
	this_subsys	subsystem%rowtype;
begin
	-- Get self
	select * into strict self from modeled_domain where name = p_domain;

	-- Delete each subsystem (which will clear its sequence generator)
	for this_subsys in
		select * from subsystem where domain = self.name
	loop
		perform method_subsystem_delete( this_subsys.name, self.name );
	end loop;

	-- Delete self
	delete from modeled_domain where name = self.name;
	return true; -- This was the correct subclass

exception
	when no_data_found then
		return false; -- Some other subclass
end
$$
language plpgsql;
