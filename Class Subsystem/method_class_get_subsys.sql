create or replace function miclass.method_class_get_subsys(
	p_class		miclass.class.name%type,
	p_domain	miclass.class.domain%type
) returns midom.subsystem_element.subsystem%type as 
$$
--
-- Returns the set of all Relationship rnums surrounding this class.
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
	my_subsys	midom.subsystem_element.subsystem%type;
begin
	select subsystem into strict my_subsys from
		miclass.class join midom.subsystem_element on(
			subsystem_element.number = miclass.class.element
		) where miclass.class.name = p_class and
		miclass.class.domain = p_domain;
	return my_subsys;
end
$$
language plpgsql;
