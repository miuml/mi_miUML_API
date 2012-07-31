create or replace function mirel.method_rel_delete(
	p_rnum		relationship.rnum%type,
	p_domain	relationship.domain%type
) returns void as 
$$
--
-- Deletes a Relationship.
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
	self			relationship%rowtype;
	this_loop_num	constrained_loop.element%type;
begin
	-- Get self
	begin
		select * from relationship into strict self where(
			rnum = p_rnum and domain = p_domain
		);
	exception
		when no_data_found then
			raise exception 'UI: Relationship [%::R%] does not exist.', p_domain, p_rnum;
	end;

	-- Delete any Assigner State Model
	perform mistate.method_state_model_delete(
		p_sm_name := self.rnum, p_sm_type := 'assigner', p_domain := self.domain,
		p_sm_err_name := 'R' || self.rnum, p_quiet := true
	);
	
	-- Delete any Constrained Loop in which this Relationship participates
	for this_loop_num in
		select distinct element from loop_segment join constrained_loop on
			loop_segment.cloop = constrained_loop.element
	loop
		perform method_loop_delete( this_loop_num, self.domain );
	end loop;

	-- Delete all References and Formalizing Classes
	perform method_rel_clean( p_rnum, p_domain );

	-- Generalization or Association specific deletion
	perform * from association where rnum = self.rnum and domain = self.domain;
	if found then -- It's an Association
		perform method_assoc_delete( self.rnum, self.domain );
	else -- It must be a Generalization
		perform method_gen_delete( self.rnum, self.domain );
	end if;

	-- Delete my Element
	perform midom.method_element_delete( self.element, self.domain );

	-- Cascade delete self
end
$$
language plpgsql;
