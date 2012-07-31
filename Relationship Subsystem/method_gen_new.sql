create or replace function mirel.method_gen_new(
	-- New or Existing
	p_superclass		superclass.class%type,	-- Superclass
	-- New
	p_super_alias		miclass.class.alias%type,	-- Alias required if new class
	-- New or Existing
	p_subclasses		text[],					-- All validated for type 
	-- New
	p_sub_aliases		text[],					-- Aliases required for new classes
	-- Existing
	p_subsys			midom.subsystem.name%type,				-- Subsystem
	p_domain			generalization.domain%type,				-- Domain
	p_rnum				generalization.rnum%type default null	-- Requested rnum
) returns generalization.rnum%type as 
$$
--
-- Creates a new Generalization.  A new Class will be created for each supplied name
-- that does not match an existing Class.
--
-- Any newly created Superclass will be assigned the system default identifier
-- attribute.
--
-- Any newly created Suclass will be created with a Reference to the Superclass
-- which will also play the role as a Required Referential ID.  An existing
-- Subclass will take on a Required Referential ID in addition to its
-- other Identifiers.
--
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
	my_rnum			generalization.rnum%type;
begin
	-- Create self
	my_rnum := method_rel_new( p_subsys, p_domain, p_rnum );
	insert into generalization( rnum, domain, superclass ) values(
		my_rnum, p_domain, p_superclass
	); -- Ref attr constraints must be deferred since superclass not inserted yet

	-- Create superclass
	perform method_superclass_new(
		p_superclass, p_super_alias, p_subsys, my_rnum, p_domain
	);
	-- The constraint is complete now with Generalization refering to an existing
	-- instance of Superclass

	-- Create subclasses
	for s in 1 .. array_upper( p_subclasses, 1 )
	loop
		perform method_subclass_new(
			p_subclasses[s], p_sub_aliases[s], p_superclass, p_subsys, my_rnum, p_domain
		);
	end loop;

	-- Verify minimal partition
	-- In effect, we are just checking to ensure there are at least two subclasses.
	-- Admittedly, roundabout, but we are just faithfully following the class model.
	-- Ability to build a Minimal Partition = At least two Subclasses in a Gen
	begin
		insert into minimal_partition( a_subclass, b_subclass, rnum, domain ) values(
			p_subclasses[1], p_subclasses[2], my_rnum, p_domain
		);
	exception
		when not_null_violation then
			raise exception 'UI: At least two subclasses must be specified.';
	end;

	return my_rnum;
end
$$
language plpgsql;
