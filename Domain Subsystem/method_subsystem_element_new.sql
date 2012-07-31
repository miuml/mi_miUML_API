create or replace function midom.method_subsystem_element_new(
	-- args
	p_subsystem	subsystem.name%type,
	p_domain	domain.name%type
) returns mi.nominal as 
$$
--
-- Create a Subsystem Element and return its number.  Invoked by subclass.
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
	my_element_number	mi.nominal;
begin
	-- Create an Element first
	select method_element_new( p_domain ) into my_element_number;

	-- Create self
	insert into subsystem_element( number, domain, subsystem ) values (
		my_element_number, p_domain, p_subsystem
	);

	return my_element_number;
end
$$
language plpgsql;
