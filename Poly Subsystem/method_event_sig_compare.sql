create or replace function mipoly.method_event_sig_compare(
	-- ID
	p_ev_spec		event_signature.ev_spec%type,
	p_state_model	event_signature.state_model%type,
	p_sm_type		event_signature.sm_type%type,
	p_domain		event_signature.domain%type,
	-- Args
	p_state_name	state_signature.state%type
) returns boolean as 
$$
--
-- Method: Event Signature.Compare
--
-- Compares self with the supplied State Signature of the same State Model to verify
-- that each has the same number, types and names of parameters.  Returns true if
-- identical and therefore compatible.
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
	-- We are comparing two relations for equality using set operations
	-- wrapped in a boolean test: ( count( E - S ) + count( S - E ) = 0 )
	-- where E is the set of params in the event signature and S is the set of
	-- params in the state signature.  Since (E -S) != (S - E) and either
	-- set may be empty, it is important to take the sum of each subtraction
	-- and see if we get zero.  Zero means that the relations are identical
	-- returning a true result.

	return (

	-- First get the count of  E - S
	( select count(*) from (
		select name, type, state_model, sm_type, domain from state_model_parameter where
			signature = p_ev_spec and
			state_model = p_state_model and sm_type = p_sm_type and
			sig_type = 'event' and domain = p_domain except all
		select name, type, state_model, sm_type, domain from state_model_parameter where
			signature = p_state_name and
			state_model = p_state_model and sm_type = p_sm_type and
			sig_type = 'state' and domain = p_domain ) as e_s ) +

	-- Now get the count of S - E and compare to 0
	( select count(*) from (
		select name, type, state_model, sm_type, domain from state_model_parameter where
			signature = p_state_name and
			state_model = p_state_model and sm_type = p_sm_type and
			sig_type = 'state' and domain = p_domain except all
		select name, type, state_model, sm_type, domain from state_model_parameter where
			signature = p_ev_spec and
			state_model = p_state_model and sm_type = p_sm_type and
			sig_type = 'event' and domain = p_domain ) as s_e ) = 0
	);
end
$$
language plpgsql;
