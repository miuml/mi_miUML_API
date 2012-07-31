create or replace function miclass.method_class_delete(
	p_name		miclass.class.name%type,
	p_domain	midom.domain.name%type,
	p_force		boolean
) returns void as 
$$
--
-- Deletes a Class.  Fails if force is false and the Class participates in any
-- Relationships.  If force is true, each Relationship involving the Class is deleted
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
--
declare
	self		miclass.class%rowtype;
	this_rel	mirel.relationship%rowtype;
begin
	-- Get self
	begin
		select * from class into strict self where(
			name = p_name and domain = p_domain
		);
	exception
		when no_data_found then
			raise exception 'UI: Class [%::%] does not exist.', p_domain, p_name;
	end;

	-- If Partition, fail
	perform * from mistate.multiple_assigner where pclass = self.name and domain = self.domain;
	if found then raise exception
		'UI: Cannot delete class [%::%] because it partitions a multiple assigner.',
			self.name, self.domain;
	end if;

	-- Delete any Lifecycle State Model
	perform mistate.method_state_model_delete(
		p_sm_name := self.cnum, p_sm_type := 'lifecycle', p_domain := self.domain,
		p_sm_err_name := self.name, p_quiet := true
	);

	-- Delete each relationship formalized with a to or from reference
	-- on this class.
	for this_rel in
		-- A Class may participate in multiple roles in the same Relationship
		-- so we need to sift through the Referential Role instances eliminating
		-- duplicate rnums which we then join against the Relationship relvar.
		select * from relationship join (
			select distinct on (rnum) rnum from referential_role where
				to_class = self.name or from_class = self.name
		) as x using( rnum )
	loop
		if not p_force then
			raise exception 'UI: Class [%::%] participates in at least one relationship.',
				self.domain, self.name;
		end if;
		-- Now delete any found Relationships
		perform mirel.method_rel_delete( this_rel.rnum, self.domain );
	end loop;
	
	-- Delete my Element
	perform midom.method_element_delete( self.element, self.domain );
end
$$
language plpgsql;
