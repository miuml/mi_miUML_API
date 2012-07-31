create or replace function mistate.UI_new_lifecycle(
	-- Existing
	p_cname			mi.name,	-- Name of a Class without a Lifecycle
	p_domain		mi.name		-- In this Domain
) returns void as 
$$
--
-- UI: New lifecycle
--
-- Creates a new Lifecycle State Model on the specified Class.  Error returned if one
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
declare
	v_cnum		mi.nominal;
begin
	-- Get the cnum
	v_cnum := miclass.read_class_cnum( p_cname, p_domain );

	-- Call app
	perform method_lifecycle_new( v_cnum, p_cname, p_domain );
end
$$
language plpgsql;
