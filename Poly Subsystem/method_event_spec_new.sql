create or replace function mipoly.method_event_spec_new(
	p_name			event_spec.name%type,
	p_state_model	event_spec.state_model%type,
	p_sm_err_name	text,
	p_sm_type		event_spec.sm_type%type,
	p_domain		event_spec.domain%type,
	p_ev_num		event_spec.number%type
) returns event_spec.number%type as
$$
--
-- Method: Event Specification.New
--
-- Creates a new Event Specification and returns its Number.  Called by subclass only.
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
	my_number	event_spec.number%type;
begin
	my_number := method_event_spec_assign_num( p_state_model, p_sm_type, p_domain, p_ev_num );

	--raise info '4> my_num [%]', my_number;
	--raise info '4> Insert Event Spec number[%] name[%] smn[%] smt[%] d[%]',
		--my_number, p_name, p_state_model, p_sm_type, p_domain;

	begin
		insert into event_spec( number, name, state_model, sm_type, domain )
			values ( my_number, p_name, p_state_model, p_sm_type, p_domain );
	exception
		when unique_violation then
			raise exception 'Event spec [%] already exists on [%::%].',
				p_name, p_sm_err_name, p_domain;
		when foreign_key_violation then
			raise exception 'No state model defined on [%::%].',
				p_sm_err_name, p_domain;
	end;

	-- Add an Event Signature with zero parameters
	perform method_event_sig_new( p_name, p_state_model, p_sm_type, p_domain );

	return my_number;
end
$$
language plpgsql;
