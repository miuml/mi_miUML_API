create or replace function mistate.UI_set_partition_class(
	-- Existing
	p_rnum			mi.nominal,	-- Multiple Assigner Association
	p_domain		mi.name,	-- In this Domain
	-- Args
	p_partition		mi.name		-- mi.name: Partitioning class
) returns void as 
$$
--
-- UI: Set partition class
--
-- Changes the class playing a partitioning role in the Constrained Loop in which
-- a Multiple Assigner is defined.  This new Class must belong to the same Constrained
-- Loop as the Multiple Assigner's Association.
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
	perform method_multiple_assigner_set_partition( p_rnum, p_domain, p_partition );
end
$$
language plpgsql;
