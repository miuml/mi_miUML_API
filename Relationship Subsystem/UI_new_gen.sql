create or replace function mirel.UI_new_gen(
	-- New or Existing
	p_superclass		text,		-- Superclass
	-- New
	p_super_alias		text,	-- Required if Superclass does not exist
	-- New or Existing
	p_subclasses		text[],		-- A list of subclasses
	-- New
	p_sub_aliases		text[],		-- A list of subclasses
	-- Existing
	p_subsys			mi.name,	-- Subsystem
	p_domain			mi.name,	-- Domain
	p_rnum				integer default null	-- Rnum is assigned if not provided
) returns mi.nominal as 
$$
--
-- Creates a new Generalization.  A new Class will be created for each supplied name
-- that does not match an existing Class.  An alias must be supplied for each Class
-- that does not already exist.  Any alias provided for an existing class will be
-- ignored.
--
-- Any newly created Superclass will be assigned the system default identifier
-- attribute.
--
-- Any newly created Suclass will be created with a Reference to the Superclass
-- which will also play the role as a Required Referential ID.  An existing
-- Subclass will take on a Required Referential ID in addition to its
-- other Identifiers.
--
-- Example Usage where superclass exists already, and 2 of three subclasses are new:
--
-- rnum = UI_new_generalization( 'Fruit', NULL, [ 'Apple', 'Pear', 'Melon' ], 
-- 				[ 'A', NULL, 'M' ], NULL, 'Main', 'Nutrition' )
-- Since the 'Pear' subclass already exists, no alias is provided.
-- There must always be the same number of elements in the name and alias arrays.
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
	v_superclass	superclass.class%type;
	v_super_alias	miclass.class.alias%type;
	v_subclass		subclass.class%type;
	v_alias			miclass.class.alias%type;
	s				text;
begin
	-- Validate the name formats
	begin
		v_superclass := p_superclass;
	exception
		when check_violation then
			raise 'UI: Superclass name [%] violates format.', p_superclass;
	end;

	begin
		v_super_alias := p_super_alias;
	exception
		when check_violation then
			raise 'UI: Superclass alias [%] violates format.', p_super_alias;
	end;

	-- Verify that subclass name and alias arrays are the same size
	if array_length( p_subclasses, 1 ) != array_length( p_sub_aliases, 1 ) then
		raise 'UI: Number of elements in subclass name and alias arrays do not match.';
	end if;
	-- Additional array dimensions should not be specified.  If so, they are ignored.

	if array_upper( p_subclasses, 1) is null then
		raise 'UI: At least two subclasses must be specified.';
	end if;

	for s in 1 .. array_upper( p_subclasses, 1 )
	loop
		begin
			-- Verify subclass name format
			v_subclass := p_subclasses[s];
		exception
			when check_violation then
				raise 'UI: Subclass name [%] violates format.', p_subclasses[s];
		end;

		begin
			-- Verify corresponding subclass alias format
			v_alias := p_sub_aliases[s];
		exception
			when check_violation then
				raise 'UI: Subclass alias [%] violates format.', p_sub_aliases[s];
		end;
	end loop;

	-- Postgresql arrays must be in a native type, thus we must pass
	-- the validated p_subclasses array, still of type text.
	-- Names will be converted to mi.name type when extracted from the array.
	return method_gen_new(
		v_superclass, v_super_alias, p_subclasses, p_sub_aliases, p_subsys, p_domain, p_rnum
	);
end
$$
language plpgsql;
