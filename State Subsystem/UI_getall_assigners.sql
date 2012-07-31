create or replace function mistate.UI_getall_assigners(
	-- IN
	p_domain		mi.name,
	-- OUT
	o_rnum			OUT mi.nominal,	-- Association Rnum
	o_mult			OUT text		-- 'single' or 'multiple'
) returns setof record as
$$
--
-- Query: Get all assigners
--
-- Returns the number of each Relationship with a defined Assigner.
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
	perform * from midom.domain where name = p_domain;
	if not found then raise exception
		'UI: Domain [%] does not exist.', p_domain;
	end if;

	return query
		select rnum, mult from assigner join(
			select 
				rnum, 'single' as mult, domain from single_assigner
			union select
				rnum, 'multiple' as mult, domain from multiple_assigner
		) as aun using( rnum, domain ) where domain = p_domain order by rnum;
end
$$
language plpgsql;
