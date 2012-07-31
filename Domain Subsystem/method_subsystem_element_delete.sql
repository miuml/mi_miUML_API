create or replace function midom.method_subsystem_element_delete(
	-- id
	p_number	subsystem_element.number%type,
	p_domain	subsystem_element.domain%type
) returns void as 
$$
--
-- Deletes a Subsystem Element.  (called from subclass)
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
begin
	-- Delete self
	delete from subsystem_element where number = p_number and domain = p_domain;

	-- Delete superclass instance
	perform method_element_delete( p_number, p_domain );
end
$$
language plpgsql;
