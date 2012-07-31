-- init_relvars.sql
--
-- Initializes content local to the miUML domain (all subsystems)
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
set client_min_messages=ERROR;

drop schema if exists miuml cascade;
create schema miuml;
set search_path to miuml;

-- Constrained Types - >>>
--
-- These are Constrained Types available to all Subsystems in the miUML Domain
--
create domain domain_type as text
	constraint bad_domain_type_value check(
		value = 'modeled' OR value = 'realized'
);

create domain ev_response as text
	constraint bad_ev_response_value check(
		value = 'CH' OR value = 'IGN'
); -- can't happen or ignore

create domain sig_type as text
	constraint bad_sig_type_value check(
		value = 'state' OR value = 'event'
);
	
create domain sig_type_e as text
	constraint bad_sig_type_value check( value = 'event' );
	
create domain sig_type_s as text
	constraint bad_sig_type_value check( value = 'state' );
	
create domain sm_type as text
	constraint bad_sm_type_value check(
		value = 'assigner' OR value = 'lifecycle'
); -- assoc or class

create domain sm_type_a as text
	constraint bad_sm_type_a_value check( value = 'assigner' ); -- assoc only

create domain sm_type_l as text
	constraint bad_sm_type_l_value check( value = 'lifecycle' ); -- class only

-- mult - Simple Multiplicity
create domain mult as text
	constraint bad_multiplicity_value check( value = '1' OR value = 'M' );

-- uml_mult - UML Multiplicity
create domain uml_mult as text
	constraint bad_uml_multiplicity_value check(
		value = '1' OR value = '1..*' OR value = '0..1' OR value = '0..*'
	);

-- side - Perspective Side
create domain side as text
	constraint bad_perspective_value check(
		value = 'A' OR value = 'P' OR value = 'S'
	); -- Active, Passive, Symmetric

-- binary side - Binary Perspective Side
create domain binary_side as text
	constraint bad_binary_perspective_value check(
		value = 'A' OR value = 'P'
	); -- Active or Passive

-- unary side - Unary Perspective Side
create domain unary_side as text
	constraint bad_unary_perspective_value check( value = 'S' ); -- Active or Passive

-- ref type - Reference Type
create domain ref_type as text
	constraint bad_ref_type_value check(
		value = 'T' OR value = 'P' OR value = 'S' OR value = 'O'
	); -- T assoc, P assoc, Superclass, To One

-- super ref type - subset of Reference Type
create domain super_ref_type as text
	constraint bad_super_ref_type_value check( value = 'S' );

-- to one ref type - subset of Reference Type
create domain to_one_ref_type as text
	constraint bad_to_one_ref_type_value check( value = 'O' );

-- assoc ref type - subset of Reference Type
create domain assoc_ref_type as text
	constraint bad_assoc_ref_type_value check(
		value = 'T' OR value = 'P'
	);

-- t ref type - subset of Reference Type
create domain t_ref_type as text
	constraint bad_assoc_ref_type_value check( value = 'T' ); 

-- p ref type - subset of Reference Type
create domain p_ref_type as text
	constraint bad_assoc_ref_type_value check( value = 'P' ); 

-- Constrained Types - <<<

set client_min_messages=NOTICE;
