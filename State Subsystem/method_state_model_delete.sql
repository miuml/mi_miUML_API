create or replace function mistate.method_state_model_delete(
	-- ID
	p_sm_name		state.state_model%type,
	p_sm_type		state.sm_type%type,
	p_domain		state.domain%type,
	-- Args
	p_sm_err_name	text,
	p_quiet			boolean default false	-- No error if non-existent
) returns void as
$$
--
-- Method: State Model.Delete
--
-- Deletes this State Model
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
	self			state_model%rowtype;
	this_inh_event	mipoly.inherited_event%rowtype;
	parent_cname	miclass.class.name%type;
	this_ev_spec	mipoly.event_spec%rowtype;
begin
	-- Get self and validate
	begin
		select * into strict self from state_model where
			name = p_sm_name and sm_type = p_sm_type and domain = p_domain;
	exception
		when no_data_found then
			if not p_quiet then
				raise exception 'UI: No state model defined on [%::%].',
					p_sm_err_name, p_domain;
			end if;
			return;  -- Quietly
	end;

	-- Lifecycle specific deletion
	if self.sm_type = 'lifecycle' then
		-- Delete all creation events (lifecycles only)
		delete from creation_event where
			cnum = self.name and domain = self.domain;
		-- Undelegate the parent of any Inherited Events in this Lifecycle
		for this_inh_event in
			select * from mipoly.inherited_event where
				sub_cnum = self.name and domain = self.domain
		loop
			parent_cname := miclass.read_class_name(
				this_inh_event.super_cnum, self.domain
			);
			this_ev_spec := mipoly.method_event_get_spec(
				this_inh_event.parent_evid,
				this_inh_event.super_cnum,
				'lifecycle', self.domain
			);
			perform mipoly.method_del_event_undelegate(
				this_inh_event.parent_evid, this_inh_event.super_cnum, parent_cname,
				self.domain, this_ev_spec.number, this_inh_event.gen_rnum
			);
		end loop;
	end if;

	-- Delete all Event Specs
	for this_ev_spec in
		select * from event_spec where state_model = self.name and
			sm_type = self.sm_type and domain = self.domain
	loop
		perform mipoly.method_event_spec_delete(
			this_ev_spec.name, this_ev_spec.state_model,
			this_ev_spec.sm_type, this_ev_spec.domain,
			p_sm_err_name
		);
	end loop;

	-- Delete all Destinations
	delete from destination where
		state_model = self.name and sm_type = self.sm_type and domain = self.domain;

	-- Delete state model
	delete from state_model where
		name = self.name and sm_type = self.sm_type and domain = self.domain;
end
$$
language plpgsql;
