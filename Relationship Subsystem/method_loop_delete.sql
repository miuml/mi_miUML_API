create or replace function mirel.method_loop_delete(
	p_loop		constrained_loop.element%type,
	p_domain	midom.domain.name%type
) returns void as 
$$
--
-- Deletes a Constrained Loop
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
	self		constrained_loop%rowtype;
begin
	-- Get self
	begin
		select * from constrained_loop into strict self where(
			element = p_loop and domain = p_domain
		);
	exception
		when no_data_found then
			raise exception 'UI: Constrained loop [%::%] does not exist.', p_domain, p_loop;
	end;

	-- Delete my Element
	perform midom.method_element_delete( self.element, self.domain );

	-- Cascade delete self
end
$$
language plpgsql;
