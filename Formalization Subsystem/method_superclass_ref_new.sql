create or replace function miform.method_superclass_ref_new(
	p_subclass		superclass_reference.subclass%type,
	p_superclass	superclass_reference.superclass%type,
	p_rnum			superclass_reference.rnum%type,
	p_domain		superclass_reference.domain%type
) returns void as 
$$
--
-- Creates a new Superclass Reference
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
	to_id_attr		identifier_attribute%rowtype;
begin
	-- Create self
	insert into reference( type, from_class, to_class, rnum, domain )
		values( 'S', p_subclass, p_superclass, p_rnum, p_domain );

	insert into superclass_reference( subclass, superclass, rnum, domain, type )
		values( p_subclass, p_superclass, p_rnum, p_domain, 'S' );

	-- Add referential attributes to this Reference
	for to_id_attr in
		select * from miclass.identifier_attribute where
			identifier = 1 and -- take reference to primary id
			class = p_superclass and domain = p_domain
	loop
		perform miclass.method_ref_attr_new(
			-- From
			p_subclass,
			-- To
			to_id_attr.attribute, p_superclass, 1,
			-- Ref Role
			'S', p_rnum, p_domain
		);
	end loop;
	
	-- Create RR identifier
	-- Create a new identifier in the Subclass
	perform mirrid.method_rr_subclass_identifier_new(
		p_subclass, p_superclass, p_rnum, p_domain
	);
end
$$
language plpgsql;
