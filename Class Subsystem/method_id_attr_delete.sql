create or replace function miclass.method_id_attr_delete(
	-- Existing
	p_attr		identifier_attribute.attribute%type,	-- Attribute to add to an Identifier
	p_class		identifier_attribute.class%type,		-- Class of both Attribute and Identifier
	p_domain	identifier_attribute.domain%type,		-- Domain of both Attribute and Identifier
	p_id_num	identifier_attribute.identifier%type 	-- The Identifier 
) returns void as 
$$
--
-- Removes an Attribute from an Identifier and deletes the Identifier if it is
-- an SAI.  (SAI/MAI = Single/Multiple Attribute Identifier)
--
-- Fails if removal of the Identifier would break any incoming Reference.
--
-- Fails if Attribute is an SAI, and participates in a
-- Referential Role (as the To side).
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
declare
	self			identifier_attribute%rowtype;
	this_ref_role	referential_role%rowtype;
begin
	-- Get self (relevant when called directly from UI)
	select * from identifier_attribute into strict self where
		identifier = p_id_num and attribute = p_attr and class = p_class and domain = p_domain;
	if not found then
		raise exception 'UI: Attribute [%::%.%] is not part of identifier [%].',
			p_domain, p_class, p_attr, p_id_num;
	end if;

	for this_ref_role in
		select * from referential_role where
			to_attribute = self.attribute and
			to_class = self.class and
			domain = self.domain
	loop
		perform method_ref_role_delete(
			this_ref_role.from_attribute, this_ref_role.from_class,
			this_ref_role.reference_type, this_ref_role.to_class,
			this_ref_role.rnum, this_ref_role.domain
		); -- Will fail if it is the sole Reference component of a Relationship
	end loop;

	delete from identifier_attribute where
		identifier = self.identifier and
		attribute = self.attribute and
		class = self.class and
		domain = self.domain;

	perform CL_edit(
		self.domain || ':' || self.class || ':' || self.identifier || ':' || self.attribute,
		'delete',
		'identifier attribute'
	);

	-- Notify the ID
	perform event_id_attr_removed( p_id_num, p_class, p_domain );
end
$$
language plpgsql;
