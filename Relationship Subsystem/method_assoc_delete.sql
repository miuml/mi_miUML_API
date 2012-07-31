create or replace function mirel.method_assoc_delete(
	p_rnum		binary_association.rnum%type,
	p_domain	binary_association.domain%type
) returns void as 
$$
--
-- Deletes an Association (Unary or Binary).
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
	-- Delete Active and Passive Perspectives
	delete from perspective where rnum = p_rnum and domain = p_domain;

	-- Cascade delete self instance
end
$$
language plpgsql;

