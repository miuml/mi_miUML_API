create or replace function mirel.method_perspective_mult(
	p_rnum		perspective.rnum%type,
	p_side		perspective.side%type,
	p_domain	perspective.domain%type
) returns miuml.mult as 
$$
--
-- Returns the multiplicity of the Perspective
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
	perform * from one_perspective where
		rnum = p_rnum and side = p_side and domain = p_domain;
	if found then
		return '1';
	end if;

	perform * from many_perspective where
		rnum = p_rnum and side = p_side and domain = p_domain;
	if found then
		return 'M';
	end if;

	raise 'SYS: No mult subclass instance found for perspective [%::R%.%]',
		p_domain, p_rnum, p_side;
end
$$
language plpgsql;
