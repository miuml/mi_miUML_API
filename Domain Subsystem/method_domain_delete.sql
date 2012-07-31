create or replace function midom.method_domain_delete(
	p_name		domain.name%type -- Domain to delete
) returns void as 
$$
--
-- Removes an existing Domain.
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
declare
	self	domain%rowtype;
begin

	select * into strict self from domain where name = p_name;
	case -- Choose subclass method
		when ( select method_modeled_domain_delete( self.name ) ) then null;
		when ( select method_realized_domain_delete( self.name ) ) then null;
	else
		raise exception 'SYS: Missing subclass for domain [%].', self.name;
	end case;

	delete from domain where name = self.name;

exception
	when no_data_found then
		raise 'UI: Domain [%] does not exist.', p_name;
end
$$
language plpgsql;
