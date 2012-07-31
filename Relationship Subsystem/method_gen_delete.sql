create or replace function mirel.method_gen_delete(
	p_rnum		association.rnum%type,
	p_domain	association.domain%type
) returns void as 
$$
--
-- Deletes an Association.
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
	this_gr		generalization_role%rowtype;
begin
	-- Delete all Generalization Roles and Migrate any Specialized Classes
	-- no longer participating in a Generalization
	for this_gr in
		select * from generalization_role where rnum = p_rnum and domain = p_domain
	loop
		delete from generalization_role where
			rnum = this_gr.rnum and domain = this_gr.domain;
		-- Check if the Class is participating in any Generalizations now
		perform * from generalization_role where
			class = this_gr.class and domain = this_gr.domain;
		if not found then
			-- Make this class a Non Specialized Class
			perform miclass.method_class_migrate_nonspec( this_gr.class, this_gr.domain );
		end if;
	end loop;

	-- Cascade delete self instance
end
$$
language plpgsql;

