create or replace function mipoly.method_mono_event_spec_new(
	p_name			event_spec.name%type,
	p_state_model	monomorphic_event_spec.state_model%type,
	p_sm_type		monomorphic_event_spec.sm_type%type,
	p_sm_err_name	text,
	p_domain		monomorphic_event_spec.domain%type,
	p_ev_num		monomorphic_event_spec.number%type
) returns monomorphic_event_spec.number%type as 
$$
--
-- Method: Monomorphic Event Specification.New
--
-- Creates a Monomorphic Event Specification for a new Local Effective Event.
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
	my_number	monomorphic_event_spec.number%type;
begin
	--raise info '3> ev[%:%] sm[%:%::%]', p_ev_num, p_name, p_state_model, p_sm_type, p_domain;
	-- Create Event Spec instance first
	my_number := method_event_spec_new(
		p_name, p_state_model, p_sm_err_name, p_sm_type, p_domain, p_ev_num
	);

	-- Create self instance
	insert into monomorphic_event_spec( number, state_model, sm_type, domain )
		values( my_number, p_state_model, p_sm_type, p_domain );
	

	return my_number;
end
$$
language plpgsql;
