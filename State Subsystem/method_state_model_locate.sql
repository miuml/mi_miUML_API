create or replace function mistate.method_state_model_locate(
	p_name			text,
	p_domain		state_model.domain%type,
	o_sm_name		OUT state_model.name%type,	-- State Model.Name value
	o_sm_type		OUT miuml.sm_type,			-- [ lifecycle | assigner ]
	o_sm_err_name	OUT text					-- State Model name for err msgs
) as
$$
--
-- Method: State model.Locate
--
-- Processes the p_name and figures out if it is an Association Rnum or a Class name.
-- If it is a valid association Rnum, the sm_type will be 'assigner' and the rnum will
-- be returned.  Otherwise it may be a valid Class name, returned along with the sm_type
-- 'lifecycle'.  An exception is thrown if either the Class or Association does not exist.
--
--
-- Copyright 2012, Model Integration, LLC
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
	v_nominal		mi.nominal; -- A valid nominal
	v_name			mi.name;	-- A valid name
	my_cnum			mi.nominal;	-- Class number, if this is a lifecycle
begin
	-- Try casting the supplied name to the nominal type
	<<try_rnum>>
	begin
		-- Exception thrown if not a number
		v_nominal := p_name;

		-- Verify that the number corresponds to an existing Association
		perform * from mirel.association where rnum = v_nominal and domain = p_domain;
		if not found then
			raise exception 'UI: Association [R%::%] does not exist.', v_nominal, p_domain;
		end if;
		o_sm_name := v_nominal;
		o_sm_type := 'assigner';
		o_sm_err_name := 'R' || v_nominal;	-- To get the R<num> format
		return;

	exception
		when invalid_text_representation then
			exit try_rnum; -- Continue processing as a class name
	end;

	-- Class name

	-- First, validate it as an mi.name type
	begin
		v_name := p_name;
	exception
		when check_violation then
			raise exception 'UI: Class name [%] violates format.', p_name;
	end;

	-- Verify that the class exists
	my_cnum := miclass.read_class_cnum( v_name, p_domain );
	o_sm_name := my_cnum;
	o_sm_type := 'lifecycle';
	o_sm_err_name := v_name;  -- It's just the Class name
end
$$
language plpgsql;
