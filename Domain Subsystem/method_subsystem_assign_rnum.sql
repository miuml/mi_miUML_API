create or replace function midom.method_subsystem_assign_rnum(
	p_subsystem	subsystem.name%type,
	p_domain	domain.name%type,
	p_rnum		mi.nominal		-- Suggested rnum or NULL (if specified, we'll try to use it)
) returns mi.nominal as 
$$
--
-- If an Rnum is specified, and it is in the Subsystem Range, it is simply returned.
-- Otherwise, returns the next available rnum for this Subsystem. 
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
	new_rnum			mi.nominal;			-- The newly issued rnum
	cycle_mark			mi.nominal;			-- Marks the beginning of a sequence number cycle
	cmd_get_new_rnum	text;				-- Command to generate the next rnum
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

	-- Return the supplied rnum if it is in range
	if p_rnum is not null and p_rnum >= my_range.floor and p_rnum <= my_range.ceiling then
		return p_rnum;
	end if;

	-- In both alternate cases, p_rnum is null or not in range, try to assign a correct rnum
	-- No error is issued for an out of range suggested p_rnum

	-- Build and execute next rnum command
	cmd_get_new_rnum = 'select nextval(' || quote_literal( self.rnum_generator ) || ')';
	execute cmd_get_new_rnum into new_rnum;

	-- Remember where we are starting, so we only cycle through the number range once
	-- looking for an available rnum
	cycle_mark := new_rnum;

	loop
		-- Loop through the number range looking for an available rnum

		-- Verify that the current rnum is available for use in the Subsystem
		perform * from relationship join subsystem_element on(
			relationship.domain = subsystem_element.domain and
			relationship.element = subsystem_element.number
		) where rnum = new_rnum;
		if not found then -- The rnum not currently in use.  Use it.
			return new_rnum;
		end if;

		-- The rnum was in use by another Relationship in this Subsystem.  Try again.
		execute cmd_get_new_rnum into new_rnum;
		if new_rnum = cycle_mark then
			-- We've already tried this rnum, so we must have made a full cycle
			-- without finding anything available.  Give up.
			raise exception 'UI: No more rnums available in subsys [%] number range.', self.name;
		end if;
	end loop;
end
$$
language plpgsql;
