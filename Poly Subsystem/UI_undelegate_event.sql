create or replace function mipoly.UI_undelegate_event(
	-- Existing
	p_ev_name		mi.name,	-- Name of an Event Specification
	p_ev_cname		mi.name,	-- Event Specification's Class
	p_domain		mi.name,	-- Domain

	p_del_cname		mi.name,
	p_del_rnum		mi.nominal	default NULL	-- Un-delegate along this Generalization
												-- NULL means un-delegate all
) returns mi.nominal as 
$$
--
-- UI: Un delegate event
--
-- Migrates a Delegated Event to an Effective Event.  If the specified Event is a
-- Local Delegated Event (on the same class as its Polymorphic Event Spec), and
-- un-delegation would result in no Inherited Effective Events descended from the
-- Polymorphic Event Spec, the Polymorphic Event Spec is migrated to Monomorphic.
--
-- Returns the ID of any newly created Effective Event or the same ID if none is created.
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
	v_cnum		mi.nominal;
	v_del_cnum	mi.nominal;
	v_ev_num	mi.nominal;
begin
	-- Get numbers for app call and validate existence of entities
	v_cnum := miclass.read_class_cnum( p_ev_cname, p_domain );
	v_ev_num := read_event_spec_number( p_ev_name, v_cnum, 'lifecycle', p_domain );
	v_del_cnum := miclass.read_class_cnum( p_del_cname, p_domain );

	-- Call the app
	return method_poly_event_spec_undelegate(
		v_ev_num, p_ev_name, v_cnum, p_ev_cname, p_domain,
		v_del_cnum, p_del_cname, p_del_rnum		-- Delegation
	);
end
$$
language plpgsql;
