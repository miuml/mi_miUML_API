create or replace function miform.method_reference_new(
	p_ref_type		reference.type%type,
	p_from_class	reference.from_class%type,
	p_to_class		reference.to_class%type,
	p_rnum			reference.rnum%type,
	p_domain		reference.domain%type
) returns void as 
$$
--
-- Creates a new Reference
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
	-- The Reference Path must already exist

	-- Create self instance
	insert into reference( type, from_class, to_class, rnum, domain )
		values( p_ref_type, p_from_class, p_to_class, p_rnum, p_domain );
end
$$
language plpgsql;
