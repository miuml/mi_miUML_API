create or replace function miclass.method_class_reseq_ids(
	p_class			miclass.class.name%type,
	p_domain		miclass.class.domain%type,
	p_start_num		mi.nominal default 1
) returns void as 
$$
--
-- Resequences all of the identifier numbers to ensure that the sequence begins
-- the specified starting value, one by default, and that there are no gaps in
-- the sequence.
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
	shift			mi.posint; -- Number of slots to push ID's forward
	slot			int; 		-- Possible id numbers 1, 2, 3 ... are occupied or empty slots
	fwd_id_num		mi.nominal; -- The next higher identifier past an empty slot
	moved_id		identifier%rowtype; -- For strict update - to ensure only one updated
begin
	-- For each slot, while ids remain
	slot := 1;
	loop
		-- See if there is an identifier in this slot
		perform * from identifier where number = slot and
			class = p_class and domain = p_domain;
		-- If the slot is empty, fill it with the next highest identifier
		if not found then
			-- Get the next highest id past this slot
			select min( number ) into fwd_id_num from identifier where number > slot and
				class = p_class and domain = p_domain limit 1;
			
			if fwd_id_num is not null then
				update identifier set number = slot where number = fwd_id_num and
					class = p_class and domain = p_domain returning * into strict moved_id;
			else
				exit; -- No more identifiers, all done
			end if;
		end if;
	
		slot := slot + 1;
	end loop;

	perform CL_edit(
		p_domain || ':' || p_class,
		'reseq id',
		'class'
	);

	-- If ID's should be numbered starting from 1, we are done
	if p_start_num = 1 then
		return;
	end if;

	-- Increment each ID number by the start delta to leave space in front
	-- Start from the last slot and work backward so no duplicate IDs are created
	select max( number ) into slot from identifier where
		class = p_class and domain = p_domain limit 1; -- Must exist
	shift = p_start_num - 1; -- Amount to push everything forward
	loop
		update identifier set number = slot + shift where number = slot and
			class = p_class and domain = p_domain;
		slot = slot - 1;
		if slot = 0 then exit; end if; -- All slots back to 1 are always processed
	end loop;
	return;
end
$$
language plpgsql;
