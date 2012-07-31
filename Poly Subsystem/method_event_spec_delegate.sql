create or replace function mipoly.method_event_spec_delegate(
	-- ID
	p_ev_name		event_spec.name%type,
	p_ev_cnum		event_spec.state_model%type,	-- State model is a lifecycle
	p_domain		event_spec.domain%type,
	-- Arg
	p_ev_cname		miclass.class.name%type,		-- For error reporting
	p_del_cname		miclass.class.name%type,		-- May be NULL (when non-poly)
	p_del_rnum		mirel.generalization.rnum%type	-- May be NULL
) returns void as 
$$
--
-- Method: Event Specification.Delegate
--
-- Delegates an Effective Signaling Event so that it is handled in the Subclass Lifecycle
-- State Models of the specified Generalization.  This action is relevant only to Lifecycle
-- State Models, so it will be rejected if an Assigner State Model is specified.
-- 
-- The Event may be mono or polymorphic and the procedure for migrating from Effective
-- to Delegated varies considerably in each case.  So the first step is to idenfify
-- the relevant case and trigger it.
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
	self				event_spec%rowtype;

begin
	-- Get self (validate existence)
	begin
		select * into strict self from event_spec where
			name = p_ev_name and
			state_model = p_ev_cnum and sm_type = 'lifecycle' and
			domain = p_domain;
	exception
		when no_data_found then raise exception
			'UI: Event spec [%] not defined in domain [%].', p_ev_name, p_domain;
	end;

	-- Check spec type and call relevant function
	perform * from monomorphic_event_spec where
		number = self.number and
		state_model = self.state_model and sm_type = 'lifecycle' and
		domain = self.domain;
	if found then
		-- Monomorphic
		perform method_mono_event_spec_delegate(
			self.number, p_ev_name, p_ev_cname, self.state_model, self.domain,
			p_del_rnum
		);
	else
		-- Polymorphic
		perform method_poly_event_spec_delegate(
			self.number, p_ev_name, p_ev_cname, self.state_model, self.domain,
			miclass.read_class_cnum( p_del_cname, p_domain ),
			p_del_cname, p_del_rnum  -- Ev spec and del classes will be different
		);
	end if;
end
$$
language plpgsql;
