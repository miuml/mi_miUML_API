create or replace function miclass.UI_delete_class(
	-- Existing
	p_name		mi.name,	-- Name of the Class to delete
	p_domain	mi.name,	-- The Class's Domain
	-- Modify
	p_force		boolean default false

) returns void as 
$$
--
-- Removes an existing Class.  If force is false, this command fails if the Class
-- participates in any Relationships.  If true, the Relationships will be deleted
-- also.
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
	perform method_class_delete( p_name, p_domain, p_force );
end
$$
language plpgsql;
