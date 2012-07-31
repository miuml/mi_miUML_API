create or replace function mistate.method_eff_signaling_event_delete(
	p_evid			effective_signaling_event.id%type,
	p_sm_name		effective_signaling_event.state_model%type,
	p_sm_type		effective_signaling_event.sm_type%type,
	p_domain		effective_signaling_event.domain%type
) returns void as 
$$
--
-- Method: Effective Signaling Event.Delete
--
-- Deletes an existing Effective Signaling Event
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
	delete from effective_signaling_event where
		id = p_evid and
		state_model = p_sm_name and
		sm_type = p_sm_type and
		domain = p_domain;
	
	-- This will cascade through Event Response, Transition and Non Transition Response
end
$$
language plpgsql;
