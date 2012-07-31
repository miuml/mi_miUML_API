create or replace function mirel.method_assoc_set_phrase(
	-- New
	p_new_phrase	perspective.phrase%type,
	-- Existing
	p_rnum			perspective.rnum%type,
	p_side			perspective.side%type,
	p_domain		perspective.domain%type
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
	self	perspective%rowtype;
begin
	update perspective set phrase = p_new_phrase where 
		side = p_side and rnum = p_rnum and domain = p_domain
		returning * into strict self;
exception
	when no_data_found then
		raise 'UI: Perspective [%] on [%::R%] does not exist.',
			p_side, p_domain, p_rnum;
end
$$
language plpgsql;
