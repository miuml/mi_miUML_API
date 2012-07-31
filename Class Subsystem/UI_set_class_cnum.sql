create or replace function miclass.UI_set_class_cnum(
	-- Existing
	p_name		mi.name,	-- Class name
	p_domain	mi.name,	-- The Class is in this Domain
	-- New
	p_new_cnum	int			-- mi.posint: New Class number
) returns void as 
$$
--
-- Changes a Class's cnum to an unused value within the Class's Subsystem Range.
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
	v_new_cnum		mi.posint;
begin
	-- Input validation
	begin
		v_new_cnum := p_new_cnum;
	exception
		when check_violation then
			raise exception 'UI: New cnum [%] must be a positive integer.', p_new_cnum;
	end;

	-- Invoke function
	perform method_class_set_cnum( p_name, p_domain, v_new_cnum );
end
$$
language plpgsql;
