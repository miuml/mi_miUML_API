create or replace function mipoly.UI_delegate_event(
	-- Existing
	p_ev_name		mi.name,	-- Name of an Event Specification
	p_ev_cname		mi.name,	-- Event Specification's Class
	p_domain		mi.name,	-- Domain

	p_del_cname		mi.name default NULL,		-- Class where delegation occurs,
												-- Leave NULL if non-polymorphic
	p_del_rnum		mi.nominal	default NULL	-- Delegate down this Generalization
												-- NULL means all from delegation Class
) returns void as 
$$
--
-- UI: Delegate event
--
-- Delegates an Effective Signaling Event so that it is handled in the Subclass Lifecycle
-- State Models of the specified Generalization.  If no Generalization is specified, the
-- Event is delegated down all Generalizations rooted in the specified Class.
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
	-- Call the app
	perform method_event_spec_delegate(
		p_ev_name, miclass.read_class_cnum( p_ev_cname, p_domain ), p_domain, 	-- Event Spec
		p_ev_cname,					-- Error reporting
		p_del_cname, p_del_rnum		-- Delegation
	);
end
$$
language plpgsql;
