create or replace function mistate.method_deletion_pstate_new(
	p_name			deletion_pstate.name%type,	-- Name of the State
	p_cnum			deletion_pstate.cnum%type,	-- State model name
	p_class_name	miclass.class.name%type,	-- For error messages
	p_domain		deletion_pstate.domain%type	-- Domain
) returns void as 
$$
--
-- Method: Deletion Pseudo State.New
--
-- Creates a new Deletion Pseudo State in the specified Lifecycle State Model.
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
	-- Create the Destination instance
	begin
		insert into destination( name, state_model, sm_type, domain )
			values( p_name, p_cnum, 'lifecycle', p_domain );
	exception
		when unique_violation then
			raise exception 'UI: State [%] on [%::%] already exists.',
				p_name, p_class_name, p_domain;
	end;

	-- Create the Deletion Pseudo State instance
	begin
		insert into deletion_pstate( name, cnum, sm_type, domain ) values(
			p_name, p_cnum, 'lifecycle', p_domain
		);
	exception
		when foreign_key_violation then
			raise exception 'UI: Class [%::%] has no lifecycle.',
				p_class_name, p_domain;
	end;
end
$$
language plpgsql;
