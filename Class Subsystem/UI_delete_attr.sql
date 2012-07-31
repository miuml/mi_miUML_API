create or replace function miclass.UI_delete_attr(
	-- Existing
	p_attr		mi.name,	-- The Attribute to delete
	p_class		mi.name,	-- Its Class
	p_domain	mi.name		-- The Class's Domain
) returns void as 
$$
--
-- Removes an existing Attribute. (SAI/MAI = Single/Multiple Attribute Identifier)
--
-- Fails under the following conditions
--
-- 		Attribute is an SAI and the only Identifier of the Class.
--
--		Attribute is an SAI, not the only Identifier of the Class and participates
--			in a Referential Role (as the To side).
--
-- If the Attribute is part of an MAI and participates in a Referential Role,
-- the Referential Role will be deleted, leaving its Relationship intact,  But
-- the Referential Attribute on the from side will be deleted.  If that
-- Referential Attribute is itself an Identifier Attribute, then it too may be
-- deleted subject to the fail conditions above.  If any Referential Attribute
-- meets those conditions and cannot be deleted, the entire transaction
-- will fail.
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
begin
	perform method_ind_attr_delete( p_attr, p_class, p_domain );
end
$$
language plpgsql;
