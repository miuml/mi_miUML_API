create or replace function mistate.method_creation_event_new(
	p_event_name	mipoly.event_spec.name%type,	-- Event specification name
	p_cnum			creation_event.cnum%type,		-- Lifecycle state model on this Class
	p_cname			miclass.class.name%type,		-- Class name for error messages
	p_to_state		creation_event.to_state%type,	-- Creation state
	p_domain		creation_event.domain%type,		-- Domain
	p_ev_num		mipoly.event_spec.number%type default null,	-- Optional desired ev num
	-- Returned
	o_number		OUT mipoly.event_spec.number%type,
	o_id			OUT creation_event.id%type
) as 
$$
--
-- Method: Creation event.New
--
-- Defines a new Creation Event on the specified Lifecycle.  An Event ID will be
-- generated along with an Event Specification number, if none is specified.  Both
-- the assigned Event.ID and Event Specification.Number will be returned.  If a
-- desired Event Specification number is specified, it will be used unless the
-- number is already taken, in which case any available number will be assigned.
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
	-- Create the Local Effective Event superclass
	select * from mipoly.method_local_eff_event_new(
		p_event_name, p_cnum, 'lifecycle', p_cname, p_domain, p_ev_num
	) into o_number, o_id;

	-- Create the Creation Event
	begin
		insert into creation_event( id, cnum, sm_type, domain, to_state ) values(
			o_id, p_cnum, 'lifecycle', p_domain, p_to_state
		);
	exception
		when foreign_key_violation then
			-- We have already verified that the Lifecycle exists...
			-- Is the destination State missing?
			perform * from state where
				name = p_to_state and
				state_model = p_cnum and sm_type = 'lifecycle' and
				domain = p_domain;
			if not found then
				raise exception 'UI: To state [%] on lifecycle [%::%] does not exist.',
					p_to_state, p_cname, p_domain;
			end if;
		when unique_violation then
			-- Is there already a creation Transition into this State?
			perform * from creation_event where
				cnum = p_cnum and state = p_to_state and domain = p_domain;
			if found then raise exception
				'UI: There is already a creation transition entering state [%] on [%::%].',
					p_to_state, p_cname, p_domain;
			end if;
	end;
end
$$
language plpgsql;
