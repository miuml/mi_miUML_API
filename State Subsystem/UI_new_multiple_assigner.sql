create or replace function mistate.UI_new_multiple_assigner(
	p_rnum			mi.nominal,	-- Must be an Association relationship
	p_loop			mi.nominal, -- Element number of constrained loop
	p_partition		mi.name,	-- Class within same Constrained Loop as Association
	p_domain		mi.name
) returns void as 
$$
--
-- UI:  New multiple assigner
--
-- Creates a new Multiple Assigner State Model on the specified Association.  Error returned
-- if one is already defined.  Also, both Constrained Loop and partitioning Class will be
-- validated to ensure that the meet requirements annotated in signature above.
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
	perform method_multiple_assigner_new( p_rnum, p_loop, p_partition, p_domain );
end
$$
language plpgsql;
