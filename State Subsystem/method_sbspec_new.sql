create or replace function midom.method_sbspec_new(
	-- Args
	p_default_initial_state		mi.name,	-- Default initial state name
	p_max_event_specs			mi.posint,	-- Max event specs per state model
	p_max_states				mi.posint	-- Max states per state model
) returns void as
$$
--
-- Method: Sbspec.New
--
-- Creates the State Model Build Specification singleton.  One object must be created
-- at initialization (prior to run-time) or any code that creates new State Models
-- will fail.
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
begin
	insert into state_model_build_spec( name, default_initial_state, max_event_specs, max_states )
		values ( 'singleton', p_default_initial_state, p_max_event_specs, p_max_states );
exception
	when unique_violation then
		raise notice 'SYS: State model build specification was already initialized.';
end
$$
language plpgsql;
