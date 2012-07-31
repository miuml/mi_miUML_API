create or replace function midom.UI_set_subsystem_next_cnum(
	-- Existing
	p_name		    mi.name,	-- Existing Subsystem
	p_domain		mi.name,	-- Existing Domain
	-- New
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
	v_next_value	mi.posint;
begin
	-- Validate input
	begin
		v_next_value := p_next_value;
	exception
		when check_violation then
			raise exception 'UI: New value [%] must be a positive integer.', p_new_value;
	end;

	-- Invoke function
	perform method_subsystem_set_next_cnum( p_name, p_domain, v_next_value );
end
$$
language plpgsql;
