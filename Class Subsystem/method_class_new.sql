create or replace function miclass.method_class_new(
	p_name			miclass.class.name%type,				-- Full name of the class, spaces okay
	p_alias			miclass.class.alias%type,				-- Short name, no whitespace
	p_subsys		midom.subsystem.name%type,					-- Subsystem
	p_domain		miclass.class.domain%type,				-- Domain
	p_cnum			miclass.class.cnum%type default null,
	p_formalizing	boolean default false,					-- This is a formalizing Class
	p_id_name		attribute.name%type default null,		-- Optional ID Attr name
	p_id_type		native_attribute.type%type default null	-- Optional ID Attr type
) returns mi.nominal as 
$$
--
-- Create a new Class with a default initial Identifier Attribute.
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
	my_domain			domain%rowtype;
	my_subsys			subsystem%rowtype;
	my_element_number	mi.nominal;
	my_cnum				mi.nominal;
begin
	-- Get my Subsystem
	begin
		select * from subsystem into strict my_subsys where(
			name = p_subsys and domain = p_domain
		);
	exception
		when no_data_found then
			raise exception 'UI: Subsystem [%::%] does not exist.', p_subsys, p_domain;
	end;

	-- And my Domain
	select * from domain into strict my_domain where(
		name = p_domain
	); -- If the Subsystem exists, then its Domain must also, it is part of the key

	-- Create this Class's superclass Element / Subsystem Element 
	select method_subsystem_element_new( my_subsys.name, my_subsys.domain ) into my_element_number;

	-- Get a cnum
	select method_subsystem_assign_cnum( my_subsys.name, my_subsys.domain, p_cnum ) into my_cnum;
	
	-- Create self
	begin
		insert into class( name, domain, element, cnum, alias ) values (
			p_name,
			p_domain,
			my_element_number,
			my_cnum,
			p_alias
		);
	exception
		when unique_violation then
			raise exception 'UI: Class [%::% - %] already exists.', p_domain, p_name, p_alias;
	end;
	perform CL_edit(
		p_domain || ':' || p_name,
		'new',
		'class'
	);

	-- Always create as non specialized initially
	-- Creation of a generalization relationship can change this later
	insert into non_specialized_class( name, domain ) values ( p_name, p_domain );

	-- If this class is being created to formalize a relationship
	-- the ID's will be created by the relationship constructor method,
	-- so we're done.
	if p_formalizing then
		return my_cnum;
	end if;

	-- If not a formalizing class, create a minimum required ID
	perform method_class_new_default_id( p_name, p_domain, p_id_name, p_id_type );

	return my_cnum;
end
$$
language plpgsql;

