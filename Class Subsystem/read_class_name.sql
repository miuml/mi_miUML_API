create or replace function miclass.read_class_name(
	p_cnum		miclass.class.cnum%type,
	p_domain	miclass.class.domain%type
) returns miclass.class.name%type as 
$$
--
-- Read: Class.Name
--
-- Returns the name of this Class and if it exists.  Otherwise, an exception is thrown.
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
declare
	my_cname		miclass.class.name%type;
begin
	select name from miclass.class where cnum = p_cnum and domain = p_domain
		into my_cname;
	
	if not found then raise exception
		'UI: Class [%:%] does not exist.', p_cnum, p_domain;
	end if;

	return my_cname;
end
$$
language plpgsql;
