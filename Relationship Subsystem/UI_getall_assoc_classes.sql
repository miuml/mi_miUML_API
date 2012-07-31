create or replace function mirel.UI_getall_assoc_classes(
	-- IN
	p_domain	mi.name,
	-- OUT
	o_rnum		OUT mi.nominal,
	o_aclass	OUT mi.name,	-- Name of association class or NULL, if none
	o_atype		OUT text		-- 'unary' or 'binary'
) returns setof record as  -- Generalization
$$
--
-- Returns the name of the Association Class, if any, for each Association.
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
	select rnum, class, atype as assoc_class from(
		select
			-- Unary Association
			rnum,
			'unary' as atype,
			domain
			from unary_association
		union select
			-- Binary Association
			rnum,
			'binary' as atype,
			domain
			from binary_association
	) as aun left join association_class using( rnum, domain )
	where domain = p_domain order by rnum;
end
$$
language plpgsql;
