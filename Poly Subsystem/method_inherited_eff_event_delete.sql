create or replace function mipoly.method_inherited_eff_event_delete(
	p_evid			inherited_effective_event.id%type,
	p_cnum			inherited_effective_event.cnum%type,
	p_domain		inherited_effective_event.domain%type
) returns void as 
$$
--
-- Method: Inherited Effective Event.Delete
--
-- Deletes this Inherited Effective Event instance and triggers the deletion of
-- the entire Event with all of its instances.
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
	-- Delete the Effective Signaling instance, cascading to self
	perform mistate.method_eff_signaling_event_delete(
		p_evid, p_cnum, 'lifecycle', p_domain
	);

	-- Delete Inherited Event instance
	perform method_inherited_event_delete( p_evid, p_cnum, p_domain );
end
$$
language plpgsql;
