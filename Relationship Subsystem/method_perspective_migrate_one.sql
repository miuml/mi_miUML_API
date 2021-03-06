create or replace function mirel.method_perspective_migrate_one(
	p_rnum		perspective.rnum%type,
	p_side		perspective.side%type,
	p_domain	perspective.domain%type
) returns void as 
$$
--
-- Migrates this Class to a One Perspective
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
	self	perspective%rowtype;
begin
	-- Get self
	select * into strict self from perspective where
		rnum = p_rnum and side = p_side and domain = p_domain;

	-- Delete Many Perspective (if it exists)
	delete from many_perspective where
		rnum = p_rnum and side = p_side and domain = p_domain;

	-- New One Perspective
	begin
		insert into one_perspective( rnum, side, domain ) values( p_rnum, p_side, p_domain );
	exception
		when unique_violation then
		-- It was already a one_perspective, do nothing
	end;
end
$$
language plpgsql;
