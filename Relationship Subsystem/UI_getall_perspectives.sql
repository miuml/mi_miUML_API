create or replace function mirel.UI_getall_perspectives(
	-- IN
	p_domain		mi.name,
	-- OUT
	o_rnum			OUT mi.nominal,
	o_side			OUT text, -- 'S', 'A', or 'P', symmetric, active or passive
	o_viewed_class	OUT mi.name, -- perspective is attached to this class
	o_phrase		OUT mi.name,
	o_mult			OUT text, -- '1' or 'M' / Shlaer-Mellor - miUML multiplicity
	o_cond			OUT boolean, -- Conditionality, is zero possible
	o_uml_mult		OUT text -- '0..1', '0..*', '1', '1..*' combines mult and cond
) returns setof record as  -- Each assoc perspective
$$
--
-- Returns all Association Perspectives for each Association in the specified Domain.
--
--
-- Copyright 2011, Model Integration, LLC
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
	perform * from midom.domain where name = p_domain;
		if not found then
			raise exception 'UI: Domain [%] does not exist.', p_domain;
		end if;

return query
	select
		rnum,
		side,
		viewed_class,
		phrase,
		mult,
		conditional,
		uml_multiplicity::text from perspective join(
			select
				'1' as mult,
				rnum,
				domain,
				side::text from one_perspective
			union select
				'M' as mult,
				rnum,
				domain,
				side::text from many_perspective
		) as pun using( side, rnum, domain ) where
			domain = p_domain order by rnum, side;
end
$$
language plpgsql;
