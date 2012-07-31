create or replace function mipoly.create_sm_parameter(
	p_name			state_model_parameter.name%type,
	p_type			state_model_parameter.type%type,
	p_sig			state_model_parameter.signature%type,
	p_sig_type		state_model_parameter.sig_type%type,
	p_state_model	state_model_parameter.state_model%type,
	p_sm_type		state_model_parameter.sm_type%type,
	p_domain		state_model_parameter.domain%type,
	p_sig_err_name	text,	-- Readable name of sig (state or event name) for err msg
	p_ignore_dup	boolean default false -- No error if parameter already exists
) returns void as 
$$
--
-- Create: State Model Parameter
--
-- Creates a new State Model Parameter with zero parameters
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
	insert into state_model_parameter(
		name, signature, sig_type, state_model, sm_type, domain, type
	) values(
		p_name, p_sig, p_sig_type, p_state_model, p_sm_type, p_domain, p_type
	);

exception
	when unique_violation then
		-- Parameter of the same name
		if not p_ignore_dup then
			raise exception 'UI: Parameter [%] already exists on % [%::%].',
				p_name, p_sig_type, p_sig_err_name, p_domain;
		end if;
		-- Otherwise, ignore
	when foreign_key_violation then
		perform * from mitype.constrained_type where name = p_type;
		if not found then
			-- Missing type
			raise exception 'UI: Constrained type [%] is not defined.', p_type;
		end if;
		-- Else missing signature
		raise exception 'UI: % [%::%] does not exist.', p_sig_type, p_sig_err_name, p_domain;
end
$$
language plpgsql;
