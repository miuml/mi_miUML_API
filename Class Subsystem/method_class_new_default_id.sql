create or replace function miclass.method_class_new_default_id(
	p_class			miclass.class.name%type,
	p_domain		miclass.class.domain%type,
	p_id_name		attribute.name%type default null,		-- Optional ID Attr name
	p_id_type		native_attribute.type%type default null	-- Optional ID Attr type
) returns void as 
$$
--
-- Creates a new default ID numbered 1 on the specified class.
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
declare
	the_dbspec			domain_build_spec%rowtype;
	my_id_name			attribute.name%type;
	my_id_type			native_attribute.type%type;
begin
	-- If there is an existing primary identifier, push it forward to secondary
	perform * from identifier where number = 1 and class = p_class and domain = p_domain;
	if found then
		perform method_class_reseq_ids( p_class, p_domain, 2 );
	end if;
	-- ID 1 slot is definitely unoccupied now

	-- Get the default ID name and type and use if values not specified
	select * from domain_build_spec into strict the_dbspec;

	if p_id_name is not null then
		my_id_name := p_id_name;
	else
		my_id_name := the_dbspec.default_id_name;
	end if;

	if p_id_type is not null then
		my_id_type := p_id_type;
	else
		my_id_type := the_dbspec.default_id_type;
	end if;

	-- Create an attribute to use as the primary identifier
	perform method_ind_attr_new(
		my_id_name,
		p_class,
		p_domain,
		my_id_type
	);

	-- Now make the default ID which will assign empty id number slot #1
	perform method_modeled_id_new(
		my_id_name,
		p_class,
		p_domain
	);
end
$$
language plpgsql;
