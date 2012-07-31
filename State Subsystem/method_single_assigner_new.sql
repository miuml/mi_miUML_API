create or replace function mistate.method_single_assigner_new(
	p_rnum			single_assigner.rnum%type,
	p_domain		single_assigner.domain%type
) returns void as 
$$
--
-- Method:  Single Assigner.New
--
-- Creates a new Single Assigner State Model on the specified Association.  Error returned if one
-- is already defined.  Called from subclass.
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
	-- Create the superclass
	perform method_assigner_new( p_rnum, p_domain );

	-- Create the instance
	insert into single_assigner( rnum, domain )
		values( p_rnum, p_domain );
end
$$
language plpgsql;
