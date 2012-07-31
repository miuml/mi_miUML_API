create or replace function mipoly.method_event_sig_new(
	p_ev_spec		event_signature.ev_spec%type,
	p_state_model	event_signature.state_model%type,
	p_sm_type		event_signature.sm_type%type,
	p_domain		event_signature.domain%type	
) returns void as 
$$
--
-- Method: Event Signature.New
--
-- Creates a new Event Signature with zero parameters
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
	--raise info '5> event_sig_new > evspec[%], sm[%:%::%]',
	--	p_ev_spec, p_state_model, p_sm_type, p_domain;

	-- First create the State Model Signature superclass instance
	perform method_sm_sig_new( p_ev_spec, 'event', p_state_model, p_sm_type, p_domain );

	-- Now create my instance
	insert into event_signature( ev_spec, sig_type, state_model, sm_type, domain )
		values( p_ev_spec, 'event', p_state_model, p_sm_type, p_domain );
end
$$
language plpgsql;
