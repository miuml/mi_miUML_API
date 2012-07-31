create or replace function mistate.method_assigner_new(
	p_rnum			assigner.rnum%type,
	p_domain		assigner.domain%type
) returns void as 
$$
--
-- Method: Assigner.New
--
-- Creates a new Assigner State Model on the specified Association.  Error returned if one
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
	-- Create the State Model instance
	begin
		perform method_state_model_new( p_rnum, 'assigner', p_domain, 'R' || p_rnum );
	exception
		when unique_violation then
			raise exception 'UI: An assigner is already defined on [R%::%].',
				p_rnum, p_domain;
	end;

	-- Create the Lifecycle instance
	begin
		insert into assigner( rnum, sm_type, domain ) values(
			p_rnum, 'assigner', p_domain
		);
	exception
		when foreign_key_violation then
			raise exception 'UI: Relationship [R%::%] is not an association relationship.',
				p_rnum, p_domain;
	end;
end
$$
language plpgsql;
