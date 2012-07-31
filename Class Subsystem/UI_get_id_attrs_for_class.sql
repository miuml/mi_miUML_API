create or replace function miclass.UI_get_id_attrs_for_class(
	-- IN
	p_class		mi.name,
	p_domain	mi.name,
    p_id_num    mi.nominal default NULL,
	-- OUT
	o_id_num	OUT mi.nominal,
	o_attr		OUT mi.name,
	o_source	OUT	text
) returns setof record as  -- Identifier Attribute
$$
--
-- Returns all Identifier Attributes for the given Class.  Or, if an Identifier number
-- is specified, just those Attributes participating in that Identifier.
--
--
-- Copyright 2011, 2012 Model Integration, LLC
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
	perform * from miclass.class where name = p_class and domain = p_domain;
		if not found then
			raise exception 'UI: Class [%:%] does not exist.', p_domain, p_class;
		end if;

return query
	select identifier, attribute, source from identifier_attribute join(
		select
			'modeled' as source,
			number,
			class,
			domain from modeled_identifier
		union select
			'rr' as source,
			number,
			class,
			domain from rr_identifier
	) as iun on(
		identifier_attribute.identifier = iun.number and
		identifier_attribute.class = iun.class and
		identifier_attribute.domain = iun.domain
	) where identifier_attribute.class = p_class and
		identifier_attribute.domain = p_domain and
        identifier_attribute.identifier = coalesce( p_id_num, identifier_attribute.identifier )
        order by identifier;
end
$$
language plpgsql;
