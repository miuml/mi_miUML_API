create or replace function mirel.UI_delete_relationship(
	-- Existing
	p_rnum		mi.nominal,		-- The rnum (R13, for example, but omit the R)
	p_domain	mi.name			-- The domain name
) returns void as 
$$
--
-- Deletes a Relationship, removing each supporting Reference.  If a
-- Formalizing Class would be left without any ID Attributes a new
-- default ID will be inserted in the Formalizing Class.
--
-- If any Referential Attribute formalizing the Relationship to be
-- deleted is itself referenced in some other Relationship,
-- the Referential Attribute will be converted to an Independent
-- Attribute with the same Name and Type.
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
	perform mirel.method_rel_delete( p_rnum, p_domain );
end
$$
language plpgsql;
