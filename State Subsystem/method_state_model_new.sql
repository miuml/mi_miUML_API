create or replace function mistate.method_state_model_new(
	p_name			state_model.name%type,
	p_sm_type		state_model.sm_type%type,
	p_domain		state_model.domain%type,
	p_sm_err_name	text
) returns void as 
$$
--
-- Method: State Model.New
--
-- Creates a new State Model of the specified type.  An Event number sequence is
-- created.
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
	the_sbspec	state_model_build_spec%rowtype;
	my_evid_seq	mi.var_name;
begin
	-- Get the initial state name
	begin
		select * into strict the_sbspec from
			mistate.state_model_build_spec where name = 'singleton';
	exception
		when no_data_found then
			raise exception 'SYS: State Model Build Specification not initialized';
	end;

	my_evid_seq := p_sm_type || '_' || p_name || '_' || midom.method_domain_get_alias( p_domain );
	-- p_sm_type + p_name + domain alias

	-- Create the State Model instance
	insert into state_model( name, sm_type, domain, evid_generator )
		values( p_name, p_sm_type, p_domain, my_evid_seq );
	-- Insert exceptions will be handled by lifecycle / assigner subclasses

	-- Create the evid sequence
	execute 'create sequence ' || 'mistate' || '.' || my_evid_seq;

	-- Create required initial state
	perform method_state_new(
		the_sbspec.default_initial_state, p_name, p_sm_type, p_domain, p_sm_err_name
	);
end
$$
language plpgsql;
