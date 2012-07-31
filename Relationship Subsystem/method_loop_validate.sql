create or replace function mirel.method_loop_validate(
	p_rels		integer[],
	p_domain	relationship.domain%type
) returns void as 
$$
--
-- Verifies that the supplied set of Relationships is contiguous.  If not,
-- an exception is raised.  An origin Class visits[1] is selected by finding
-- a Classed shared by the first Relationship p_rels[1] and some other
-- specified Relationship, p_rels[2..n].  If a path can be traced starting at this
-- Class, through each Relationship leading back to the origin Class, the loop is
-- valid.
--
-- Cases where the loop may be invalid:
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
	visits					text[];		-- Visited classes so far
	r						integer;	-- Relationship count iterator
	last_r					integer;	-- Number of rels in loop
	last_rnum				mi.nominal;	-- The final hop
	v_class					mi.name;	-- Last visited class
	v_hop					mi.nominal;	-- Last visited rel
	next_rel				mi.nominal; -- The next rel to visit
	reachable_class_name	mi.name;	-- Class that can be reached in hop
begin
	-- First check to see if the loop consists of a single reflexive Association.
	-- If so, the loop is closed and no further validiation is required.
	if ( array_length( p_rels, 1 ) = 1 ) then
		if method_rel_subclass( p_rels[1], p_domain ) = 'assoc' and
			method_assoc_reflexive( p_rels[1], p_domain ) then
			return; -- A single Reflexive Association is valid
		else
			-- If the first Relationship is a Generalization or non-reflexive,
			--we'll need at least one more Relationship to close the loop.
			raise 'UI: At least two Relationships are required to close non-reflexive loop.';
		end if;
	end if;

	-- Each traversal across a Relationship constitutes a 'hop'.
	-- Create hop table to track which Relationships have been traversed
	create temp table hop(
		rnum		mi.nominal,
		traversed 	boolean default false not null,

		primary key( rnum )
	) on commit drop;

	-- Fill table with all p_rels, not traversed by default
	begin
		insert into hop( rnum )
			select p_rels[i] as r_val from generate_series( 1, array_upper( p_rels, 1 ) ) as i;
	exception
		when unique_violation then
			raise 'UI: Duplicate relationships specified in loop.';
		-- A Relationship can appear only once in a valid loop.
	end;

	-- Choose a Class as the origin by intersecting the first
	-- Relationship with each of the others until a shared Class is found
	last_r := array_upper( p_rels, 1 );
	for r in 2 .. last_r loop
		select method_rel_class_intersection( p_rels[1], p_rels[r], p_domain )
		limit 1 into v_class;
		if v_class is not NULL then
			visits := visits || v_class::text;
			v_hop := p_rels[r]; -- p_rels[1] could also be the first rel to visit
			exit;
		end if;
	end loop;
	-- If no shared Class is found, then the first Relationship doesn't connect
	-- to any of the others.
	if v_class is NULL then
		raise 'UI: Loop not contiguous beyond [%::R%].', p_domain, p_rels[1];
	end if;

	-- Process each hop
	for r in 1 .. last_r loop

		-- Final hop
		if r = last_r then
			-- There is only one non-visited Relationship left.
			-- One of its Classes must be the first visited Class
			-- to close the Constrained Loop.

			-- Get the remaining non-visited Relationship.
			select rnum from hop where not traversed into last_rnum limit 1;
			-- Verify that it includes the origin Class.
			perform * from method_rel_get_class_names( last_rnum, p_domain )
				where o_name = visits[1];
			if found then
				return; -- Loop is contiguous
			else
				raise 'UI: Loop not contiguous.  Relationship [%::R%] does not close loop.',
					p_domain, last_rnum;
			end if;
		end if;

		-- Intermediate hop

		-- Mark the current rel as traversed, so that we don't pick it again
		update hop set traversed = true where rnum = v_hop;
		next_rel := NULL;
		-- A Class is reachable if it is an unvisited part of the hop Relationship
		-- An Association formalized with an Association class will offer two
		-- reachable classes while a Generalization will offer two or more
		-- It is only in the non-associative case where there will be only one
		-- reachable Class, so...
		--
		-- ...for each Class on the current hop that hasn't yet been visited
		for reachable_class_name in
			select o_name from method_rel_get_class_names( v_hop, p_domain )
				where o_name != all( visits )
		loop
			-- This class is reachable, but does it connect to a
			-- non-visited relationship?
			select method_class_get_rels( reachable_class_name, p_domain )
				intersect
			select rnum from hop where not traversed limit 1 into next_rel;
			if found then
				-- The reachable class connects to an unvisited Relationship
				-- so update the current location and make the next hop
				v_hop := next_rel;
				v_class := reachable_class_name;
				visits := visits || v_class::text;
				exit;
			end if;
		end loop;
		if next_rel is NULL then
			-- No reachable class connected to another non-visited Relationship.
			raise 'UI: Loop not contiguous.  Gap beyond [%::R%].', p_domain, v_hop;
		end if;

		-- Test for fork
		-- Is there more than one non-visited Relationship connected to the
		-- current visit Class?  This case is legal only for our very first hop
		-- where we could go either direction from the origin class.  So we must
		-- test AFTER each intermediate hop.
		if ( select count(*) from(
				select method_class_get_rels( v_class, p_domain ) as rnum
					intersect
				select rnum from hop where not traversed
		) diverging_hops ) > 1 then
			raise 'UI: Loop not contiguous.  Fork detected after class [%::%].',
				p_domain, v_class;
		end if;
	end loop;

	-- We always evaluate success or failure during a hop, so we should never arrive beyond
	-- the loop.
	raise 'SYS: Contiguous loop failed unexpectedly.';
end
$$
language plpgsql;
