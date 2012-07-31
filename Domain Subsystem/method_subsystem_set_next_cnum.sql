create or replace function midom.method_subsystem_set_next_cnum(
	-- id
	p_subsystem		mi.name,	-- Existing Subsystem
	p_domain		mi.name,	-- Existing Domain
	-- args
	p_next_value	int		-- ::mi.posint, Start issuing Cnums starting here
) returns void as 
$$
--
-- Resets the Cnum sequence generator so that it starts from a different value
-- within the Subsystem numbering range.
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
declare
	my_schema	text := 'midom';
	self		subsystem%rowtype;
	my_range	subsystem_range%rowtype;
begin
	-- Get self
	begin
		select * into strict self from subsystem where
			name = p_subsystem and domain = p_domain;
	exception
		when no_data_found then
			raise exception 'UI: Subsystem [%:%] does not exist.', p_subsystem, p_domain;
	end;

	-- Get my range
	select * into strict my_range from subsystem_range where
		subsystem = self.name and domain = self.domain;

	-- Reject if out of range
	if p_next_value < my_range.floor or p_next_value > my_range.ceiling then
		raise exception 'UI: Next cnum value is outside subsystem [%:%] range [%-%].',
			self.name, self.domain, my_range.floor, my_range.ceiling;
	end if;

	-- Set it
	execute 'alter sequence ' || my_schema || '.' || self.cnum_generator
		|| ' restart with ' || p_next_value;
end
$$
language plpgsql;
