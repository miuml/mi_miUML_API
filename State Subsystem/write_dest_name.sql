create or replace function mistate.write_dest_name(
	-- ID
	p_sname			destination.name%type,
	p_sm_name		destination.state_model%type,
	p_sm_type		destination.sm_type%type,
	p_domain		destination.domain%type,
	-- Args
	p_new_sname		destination.name%type
) returns void as 
$$
--
-- Write: Destination.Name
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
declare
	self	destination%rowtype;
begin
	-- Since State Signature.State simultaneously refers to Destination.Name
	-- and Signature Model Signature.Name, we need to update the primary key
	-- components at the same time.

	-- Multi update (transaction wrapper must defer constraints)
	begin
		update destination set name = p_new_sname where 
			name = p_sname and
			state_model = p_sm_name and sm_type = p_sm_type and domain = p_domain
			returning * into strict self;
	exception
		when no_data_found then
			raise exception 'UI: State [% - % on %::%] does not exist.',
				p_sname, p_sm_name, p_sm_type, p_domain;
	end;

	update state_model_signature set name = p_new_sname where 
		name = p_sname and
		state_model = p_sm_name and sm_type = p_sm_type and
		sig_type = 'state' and domain = p_domain;
end
$$
language plpgsql;
