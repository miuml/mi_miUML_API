create or replace function miclass.method_class_next_id_num(
	p_class		class.name%type,
	p_domain	domain.name%type
) returns identifier.number%type as 
$$
--
-- Returns the next available ID number for this class.  Always returns the lowest available
-- number.
-- 
-- Since the quantity of Identifiers for a Class will usually be
-- betweeen 1 and 3, rarely ever over 4, it is overkill to use
-- the postgres seqeuencer mechanism.  Furthermore, we want to avoid holes in the sequence
-- so if I1 and I3 are assigned, the next value should be I2 and not I4.
--
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
	i	identifier.number%type := 1;
begin
	loop
		perform * from identifier where number = i and
			class = p_class and domain = p_domain;
		if not found then
			return i;
		end if;
		i := i + 1;

		-- Safety valve to prevent endless iteration
		if i > 50 then -- Absurdly high ID number
			raise exception 'SYS: ID number assigner exceeded maximum.';
		end if;
	end loop;
end
$$
language plpgsql;
