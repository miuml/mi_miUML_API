create or replace function mistate.method_lifecycle_new(
	p_cnum			lifecycle.cnum%type,
	p_class			miclass.class.name%type,	-- For error message
	p_domain		lifecycle.domain%type
) returns void as 
$$
--
-- Creates a new Lifecycle State Model on the specified Class.  Error returned if one
-- is already defined.
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
	-- Create the State Model instance
	begin
		perform method_state_model_new( p_cnum, 'lifecycle', p_domain, p_class );
	exception
		when unique_violation then
			raise exception 'UI: A lifecycle is already defined on [%::%].',
				p_class, p_domain;
	end;

	-- Create the Lifecycle instance
	insert into lifecycle( cnum, sm_type, domain ) values(
		p_cnum, 'lifecycle', p_domain
	);
end
$$
language plpgsql;
