create or replace function miclass.read_class_cnum(
	p_cname		miclass.class.name%type,
	p_domain	miclass.class.domain%type
) returns miclass.class.cnum%type as 
$$
--
-- Read: Class.cnum
--
-- Returns the cnum of this Class if it exists.  Otherwise, an exception is thrown.
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
declare
	my_cnum		miclass.class.cnum%type;
begin
	select cnum from miclass.class where name = p_cname and domain = p_domain
		into my_cnum;
	if not found then raise exception
		'UI: Class [%::%] does not exist.', p_cname, p_domain;
	end if;

	return my_cnum;
end
$$
language plpgsql;
