create or replace function miuml.CL_new_command(
) returns void as 
$$
--
-- Bridge to Service Function
--
-- A new command is about to be processed.  Clear out any prior
-- changes.
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
begin
	perform mitrack.function_clear_changes();
end
$$
language plpgsql;
