create or replace function mirel.derive_perspective_uml_mult(
	p_mult			miuml.mult,	-- 1, M
	p_cond			perspective.conditional%type -- boolean
) returns perspective.uml_multiplicity%type as 
$$
--
-- Derives the value for \ UML Multiplicity in Perspective
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
	if p_cond then
		if p_mult = '1' then
			return '0..1';
		else
			return '0..*';
		end if;
	else
		if p_mult = '1' then
			return '1';
		else
			return '1..*';
		end if;
	end if;
end
$$
language plpgsql;
