create or replace function mistate.UI_new_single_assigner(
	p_rnum			mi.nominal,	-- Must be an Association relationship
	p_domain		mi.name
) returns void as 
$$
--
-- UI:  New single assigner
--
-- Creates a new Single Assigner State Model on the specified Association.  Error returned if one
-- is already defined.
--
--
-- Copyright 2012, Model Integration, LLC
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
	-- Call the app
	perform method_single_assigner_new( p_rnum, p_domain );
end
$$
language plpgsql;
