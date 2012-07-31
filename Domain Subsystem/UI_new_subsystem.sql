create or replace function midom.UI_new_subsystem(
	-- Existing
	p_domain    mi.name,	-- Name of an existing Domain
	-- New
	p_name      text,		-- ::mi.name, Name of the new Subsystem: Specification
	p_alias     text,		-- ::mi.short_name, Alias for new Subsystem: Spec
	p_floor     mi.posint,	-- Lower range of numbered elements in the new Subsystem: 1
	p_ceiling   mi.posint	-- Upper range of numbered elements in the new Subsystem: 99
							-- The above range must not overlap with any other Subsystem
							-- in the same Domain.  The floor must be less than the ceiling.
) returns void as 
$$
-- Create a new Subsystem in the specified Domain
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
	v_name      mi.name;
	v_alias     mi.short_name;
	v_floor     mi.posint;
	v_ceiling   mi.posint;
begin
	begin
		v_name := trim( p_name );
	exception
		when check_violation then
			raise exception 'UI: Subsystem name [%] violates format.', p_name;
	end;

	begin
		v_alias := trim( p_alias );
	exception
		when check_violation then
			raise exception 'UI: Subsystem alias [%] violates format.', p_alias;
	end;

	begin
		v_floor := p_floor;
	exception
		when check_violation then
			raise exception 'UI: Floor must be a positive integer.', p_floor;
	end;

	begin
		v_ceiling := p_ceiling;
	exception
		when check_violation then
			raise exception 'UI: Ceiling must be a positive integer.', p_ceiling;
	end;

	-- Call App
	perform method_subsystem_new( v_name, p_domain, v_alias, v_floor, v_ceiling );
end
$$
language plpgsql;
