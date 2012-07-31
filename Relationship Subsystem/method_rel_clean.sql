create or replace function mirel.method_rel_clean(
	p_rnum		relationship.rnum%type,
	p_domain	relationship.domain%type
) returns void as 
$$
--
-- Deletes all References and Formalizing Classes on a Relationship.
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
	this_ref		reference%rowtype;
begin
	-- Delete all References formalizing this Relationship
	for this_ref in
		select * from reference where rnum = p_rnum and domain = p_domain
	loop
		perform miform.method_reference_delete(
			this_ref.type, this_ref.from_class, this_ref.to_class,
			this_ref.rnum, this_ref.domain
		);
	end loop;

	-- Delete all Formalizing Class roles (multiple if Generalization)
	-- and cascading delete to Reference Path
	delete from miform.formalizing_class where rnum = p_rnum and domain = p_domain;
end
$$
language plpgsql;
