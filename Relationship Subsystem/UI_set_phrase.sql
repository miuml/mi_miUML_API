create or replace function mirel.UI_set_phrase(
	-- New
	p_new_phrase	text,		-- mi.name
	-- Existing
	p_rnum			mi.nominal,	-- Rnum is assigned if not provided			
	p_persp			text,		-- miuml.side: A, P, or S
	p_domain		mi.name		-- Domain
) returns void as 
$$
--
-- Changes the text on the specified Perspective of an Association.
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
	v_new_phrase			mi.name;
	v_persp					miuml.side;
begin
	
	-- Input validation
	begin
		v_new_phrase := rtrim( p_new_phrase );
	exception
		when check_violation then
			raise exception 'UI: New phrase [%] violates format.', p_new_phrase;
	end;

	begin
		v_persp := p_persp;
	exception
		when check_violation then
			raise 'UI: Perspective [%] must be A, P or S.', p_persp;
	end;

	-- Invoke function
	perform method_assoc_set_phrase( v_new_phrase, p_rnum, v_persp, p_domain );
end
$$
language plpgsql;
