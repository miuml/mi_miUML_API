create or replace function miclass.method_id_attr_new(
	p_attr		attribute.name%type,	-- Attribute to add to an Identifier
	p_class		class.name%type,		-- Class of both Attribute and Identifier
	p_domain	domain.name%type,		-- Domain of both Attribute and Identifier
	p_id_num	identifier_attribute.identifier%type default null -- The Identifier 
) returns identifier_attribute.identifier%type as 
$$
--
-- Creates an Identifier Attribute, thus adding an Attribute to an Identifier
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
declare
	id_num		identifier_attribute.identifier%type;
	this_ref	miform.reference%rowtype;
begin
	-- If no ID number was specified, create a new Identifier, next highest in sequence
	if p_id_num is NULL then
		id_num := method_id_new( p_class, p_domain );
	else
		-- Use the specified ID number
		id_num := p_id_num;
	end if;

	-- Try to create the Identifier Attribute, failing with bad user input
	begin
		insert into identifier_attribute( identifier, attribute, class, domain ) values(
			id_num, p_attr, p_class, p_domain
		);
	exception 
		when unique_violation then
			raise exception 'UI: Attribute [%::%.%] is already part of ID number [%].',
				p_domain, p_class, p_attr, id_num;
		when foreign_key_violation then
			perform * from attribute where
				name = p_attr and class = p_class and domain = p_domain;
			if not found then
				raise exception 'UI: Attribute [%::%.%] does not exist.',
					p_domain, p_attr, p_class;
			else
				raise exception 'UI: ID number [%] is not defined on [%::%].',
					id_num, p_domain, p_class;
			end if;
	end;
	perform CL_edit(
		p_domain || ':' || p_class || ':' || id_num,
		'add attr',
		'identifier'
	);


	-- Update any affected References
	for this_ref in
		-- Get all References pointing to this Identifier.
		-- Here we perform a JOIN on the Reference and Referential Role relvars.
		-- Since multiple Referential Attributes in the same Reference may point to
		-- an Identifier, the DISTINCT selector ensures that each Reference is selected
		-- only once.
		select distinct ref.type, ref.from_class, ref.to_class, ref.rnum, ref.domain from
			referential_role as rr join reference as ref on(
				ref.type = rr.reference_type and
				ref.from_class = rr.from_class and
				ref.to_class = rr.to_class and
				ref.rnum = rr.rnum and
				ref.domain = rr.domain
			) where rr.to_identifier = id_num and
				rr.to_class = p_class and rr.domain = p_domain
	loop
		perform miform.event_reference_id_attr_added(
			this_ref.type, this_ref.from_class, this_ref.to_class,
			this_ref.rnum, this_ref.domain, p_attr, id_num
		);
	end loop;

	return id_num;  -- Either the user specified value, or newly assigned
end
$$
language plpgsql;
