create or replace function midom.method_subsystem_assign_cnum(
	p_subsystem	subsystem.name%type,
	p_domain	domain.name%type,
	p_cnum		mi.nominal			-- Suggested cnum or NULL (if specified, we'll try to use it)
) returns mi.nominal as 
$$
--
-- If a Cnum is specified, and it is in the Subsystem Range, it is simply returned.
-- Otherwise, returns the next available class number for this Subsystem. 
-- If no more numbers are available
-- in the Subsystem number range, an exception is thrown.
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
--
declare
	self				subsystem%rowtype;
	new_cnum			mi.nominal;			-- The newly issued cnum
	cycle_mark			mi.nominal;			-- Marks the beginning of a sequence number cycle
	cmd_get_new_cnum	text;				-- Command to generate the next cnum
	my_range			subsystem_range%rowtype;
begin
	-- Get self
	begin
		select * from subsystem into strict self where(
			name = p_subsystem and domain = p_domain
		);
	exception
		when no_data_found then
			raise exception 'UI: Subsystem [%::%] does not exist.', p_subsystem, p_domain;
	end;

	-- Get my range
	select * from subsystem_range into strict my_range where(
		subsystem = self.name and domain = self.domain
	);

	-- Return the supplied Cnum if it is in range
	if p_cnum is not null and p_cnum >= my_range.floor and p_cnum <= my_range.ceiling then
		return p_cnum;
	end if;

	-- In both alternate cases, p_cnum is null or not in range, try to assign a correct cnum
	-- No error is issued for an out of range suggested p_cnum

	-- Build and execute next cnum command
	cmd_get_new_cnum = 'select nextval(' || quote_literal( self.cnum_generator ) || ')';
	execute cmd_get_new_cnum into new_cnum;

	-- Remember where we are starting, so we only cycle through the number range once
	-- looking for an available cnum
	cycle_mark := new_cnum;

	loop
		-- Loop through the number range looking for an available cnum

		-- Verify that the current cnum is available for use in the Subsystem
		perform * from class join subsystem_element on(
			miclass.class.domain = subsystem_element.domain and
			miclass.class.element = subsystem_element.number
		) where cnum = new_cnum;
		if not found then -- The cnum not currently in use.  Use it.
			return new_cnum;
		end if;

		-- The cnum was in use by another Class in this Subsystem.  Try again.
		execute cmd_get_new_cnum into new_cnum;
		if new_cnum = cycle_mark then
			-- We've already tried this cnum, so we must have made a full cycle
			-- without finding anything available.  Give up.
			raise exception 'UI: No more cnums available in subsys [%] number range.', self.name;
		end if;
	end loop;

end
$$
language plpgsql;
