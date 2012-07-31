create or replace function midom.method_element_delete(
	-- id
	p_number	element.number%type,
	p_domain	domain.name%type
) returns void as 
$$
--
-- Deletes an Element.  (called from the subclass)
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
	delete from element where number = p_number and domain = p_domain;
	-- Cascade delete out to all subclasses
end
$$
language plpgsql;
