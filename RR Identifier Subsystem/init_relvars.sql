-- init_relvars.sql
--
-- These are all of the relvars for the miUML Metamodel Formalization Subsystem
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
set client_min_messages=ERROR;
drop schema if exists mirrid cascade;
create schema mirrid;
set search_path to mirrid, miform, mirel, miclass, midom, mitype, mi, miuml;

-- Types (from class models)


-- Architectural, for optimization

-- create domain archid as serial; -- Architectural ID, for primary keys


-- Base Relvars (relation variables from class models)
-- Model comments to be filled in by Model->SQL generator
-- Model: Class Name (initial caps w/spaces) -> SQL: table name (lowercase w/underscores)
-- Model: {I<n>} = Identity Constraint  -> SQL: Primary Key component I and Unique for I2..n
-- Model: {R<n>} = Relationship -> SQL: Foreign Key

-- Relvars >>>

-- RR Associative Identifier
create table rr_assoc_identifier(
	number			mi.nominal,		-- I, R30->Identifier.Number
	assoc_class		mi.name,		-- I, R30->Identifier.Class
	domain			mi.name,		-- I, R30->Identifier.Domain

	primary key( number, assoc_class, domain )
);

-- RR Associative 1 Identifier
create table rr_assoc_1_identifier(

	number		mi.nominal,			-- I, R52->RR Associative Identifier.Number

	assoc_class	mi.name,			-- I, R52->RR Associative Identifier.Association Class

	domain		mi.name,			-- I, I2, R52->RR Associative Identifier.Domain
									-- I, R56->To One in 1x:1x Associative Reference.Domain

	type		miuml.assoc_ref_type,	-- I2, R56->To One in 1x:1x Associative Reference.Type

	rnum		mi.nominal,			-- I2, R56->To One in 1x:1x Associative Reference.Rnum

	primary key( number, assoc_class, domain ),
	unique( domain, type, rnum )
);

-- RR Associative M Identifier
create table rr_assoc_m_identifier(

	number		mi.nominal,			-- I, R52->RR Associative Identifier.Number

	assoc_class	mi.name,			-- I, R52->RR Associative Identifier.Association Class

	domain		mi.name,			-- I, I2, R52->RR Associative Identifier.Domain
									-- I, R55->To Many in 1x:Mx Associative Reference.Domain

	type		miuml.assoc_ref_type,	-- I2, R55->To Many in 1x:Mx Associative Reference.Type

	rnum		mi.nominal,			-- I2, R55->To Many in 1x:Mx Associative Reference.Rnum

	primary key( number, assoc_class, domain ),
	unique( domain, type, rnum )
);

-- RR Associative MM Identifier
create table rr_assoc_mm_identifier(
	number			mi.nominal,		-- I, R52->RR Associative Identifier.Number

	assoc_class		mi.name,		-- I, R52->RR Associative Identifier.Association Class

	domain			mi.name,		-- I, R52->RR Associative Identifier.Domain
									-- I, R54->To Many in Mx:Mx Associative T Reference.Domain
									-- I, R57->To Many in Mx:Mx Associative P Reference.Domain

	rnum			mi.nominal,		-- R54->To Many in Mx:Mx Associative T Reference.Rnum
									-- R57->To Many in Mx:Mx Associative P Reference.Rnum

	primary key( number, assoc_class, domain )
);

-- RR Subclass Identifier
create table rr_subclass_identifier(

	number			mi.nominal,		-- I, R51->Required Referential Identifier.Number

	subclass		mi.name,		-- I, I2, R51->Required Referential Identifier.Class
									-- R53->Superclass Reference.Subclass
	superclass		mi.name,		-- I2, R53->Superclass Reference.Superclass

	rnum			mi.nominal,		-- I2, R53->Superclass Reference.Rnum

	domain			mi.name,		-- I, I2, R51->Required Referential Identifier.Domain
									-- R53->Superclass Reference.Domain

	primary key( number, subclass, domain ),
	unique( subclass, superclass, rnum, domain ) 	-- I2
);

-- RR To One Unconditional Identifier
create table rr_to_one_uncond_identifier(
	number			mi.nominal,		-- I, R51->Required Referential Identifier.Number
	from_class		mi.name,		-- I, I2, R51->Required Referential Identifier.Class
									-- R59->To One Reference.From class
	rnum			mi.nominal,		-- I2, R59->To One Reference.Rnum
	domain			mi.name,		-- I, I2, R51->Required Referential Identifier.Domain
									-- R59->To One Reference.Domain

	primary key( number, from_class, domain ),
	unique( from_class, rnum, domain )
);

-- Required Referential Identifier
create table rr_identifier(
	number		mi.nominal,		-- I, R30->Identifier.Number
	class		mi.name,		-- I, R30->Identifier.Class
	domain		mi.name,		-- I, R30->Identifier.Domain

	primary key( number, class, domain )
);

-- To Many in 1x:Mx Associative Reference
create table to_many_in_1x_mx_assoc_ref(
	type		miuml.assoc_ref_type,	-- I, R50->Associative Reference
	rnum		mi.nominal,				-- I, R50->Associative Reference.Rnum
	domain		mi.name,				-- I, R50->Associative Reference.Domain

	primary key( type, rnum, domain )
);

-- To Many in Mx:Mx Associative Reference
create table to_many_in_mx_mx_assoc_ref(
	type		miuml.assoc_ref_type,	-- I, R50->Associative Reference
	rnum		mi.nominal,				-- I, R50->Associative Reference.Rnum
	domain		mi.name,				-- I, R50->Associative Reference.Domain

	primary key( type, rnum, domain )
);

-- To Many in Mx:Mx Associative P Reference
create table to_many_in_mx_mx_assoc_pref(
	type		miuml.p_ref_type,		-- I, R58->Associative Reference
	rnum		mi.nominal,				-- I, R58->Associative Reference.Rnum
	domain		mi.name,				-- R58->Associative Reference.Domain

	primary key( rnum, domain ),
	unique( type, rnum, domain )		-- Superkey
);

-- To Many in Mx:Mx Associative T Reference
create table to_many_in_mx_mx_assoc_tref(
	type		miuml.t_ref_type,		-- I, R58->Associative Reference
	rnum		mi.nominal,				-- I, R58->Associative Reference.Rnum
	domain		mi.name,				-- R58->Associative Reference.Domain

	primary key( rnum, domain ),
	unique( type, rnum, domain )		-- Superkey
);

-- To One in 1x:1x Associative Reference
create table to_one_in_1x_1x_assoc_ref(
	type		miuml.assoc_ref_type,	-- I, R50->Associative Reference
	rnum		mi.nominal,				-- I, R50->Associative Reference.Rnum
	domain		mi.name,				-- I, R50->Associative Reference.Domain

	primary key( type, rnum, domain )
);

-- To One in 1x:Mx Associative Reference
create table to_one_in_1x_mx_assoc_ref(
	type		miuml.assoc_ref_type,	-- I, R50->Associative Reference
	rnum		mi.nominal,				-- I, R50->Associative Reference.Rnum
	domain		mi.name,				-- I, R50->Associative Reference.Domain

	primary key( type, rnum, domain )
);

-- Constraints >>>
-- R30
alter table rr_identifier add
	foreign key( number, class, domain ) references miclass.identifier( number, class, domain )
	on update cascade on delete cascade deferrable;

-- R50
alter table to_many_in_mx_mx_assoc_ref add
	foreign key( type, rnum, domain ) references
		miform.associative_reference( type, rnum, domain ) 
	on update cascade on delete cascade deferrable;

alter table to_many_in_1x_mx_assoc_ref add
	foreign key( type, rnum, domain ) references
		miform.associative_reference( type, rnum, domain ) 
	on update cascade on delete cascade deferrable;

alter table to_one_in_1x_1x_assoc_ref add
	foreign key( type, rnum, domain ) references
		miform.associative_reference( type, rnum, domain ) 
	on update cascade on delete cascade deferrable;

alter table to_one_in_1x_mx_assoc_ref add
	foreign key( type, rnum, domain ) references
		miform.associative_reference( type, rnum, domain ) 
	on update cascade on delete cascade deferrable;

-- R51
alter table rr_subclass_identifier add
	foreign key( number, subclass, domain ) references
		rr_identifier( number, class, domain )
	on update cascade on delete cascade deferrable;

alter table rr_to_one_uncond_identifier add
	foreign key( number, from_class, domain ) references
		rr_identifier( number, class, domain )
	on update cascade on delete cascade deferrable;

alter table rr_assoc_identifier add
	foreign key( number, assoc_class, domain ) references
		rr_identifier( number, class, domain )
	on update cascade on delete cascade deferrable;

-- R52
alter table rr_assoc_mm_identifier add
	foreign key( number, assoc_class, domain ) references
		rr_assoc_identifier( number, assoc_class, domain )
	on update cascade on delete cascade deferrable;

alter table rr_assoc_m_identifier add
	foreign key( number, assoc_class, domain ) references
		rr_assoc_identifier( number, assoc_class, domain )
	on update cascade on delete cascade deferrable;

alter table rr_assoc_1_identifier add
	foreign key( number, assoc_class, domain ) references
		rr_assoc_identifier( number, assoc_class, domain )
	on update cascade on delete cascade deferrable;

-- R53
alter table rr_subclass_identifier add
	foreign key( subclass, superclass, rnum, domain ) references
		miform.superclass_reference( subclass, superclass, rnum, domain )
	on update cascade on delete cascade deferrable;

-- R54
alter table rr_assoc_mm_identifier add
	foreign key( domain, rnum ) references
		to_many_in_mx_mx_assoc_tref( domain, rnum )
	on update cascade on delete cascade deferrable;

-- R55
alter table rr_assoc_m_identifier add
	foreign key( domain, type, rnum ) references
		to_many_in_1x_mx_assoc_ref( domain, type, rnum )
	on update cascade on delete cascade deferrable;

-- R56
alter table rr_assoc_1_identifier add
	foreign key( domain, type, rnum ) references
		to_one_in_1x_1x_assoc_ref( domain, type, rnum )
	on update cascade on delete cascade deferrable;

-- R57
alter table rr_assoc_mm_identifier add
	foreign key( domain, rnum ) references
		to_many_in_mx_mx_assoc_pref( domain, rnum )
	on update cascade on delete cascade deferrable;

-- R58
alter table to_many_in_mx_mx_assoc_tref add
	foreign key( rnum, domain, type ) references
		to_many_in_mx_mx_assoc_ref( rnum, domain, type ) 
	on update cascade on delete cascade deferrable;

alter table to_many_in_mx_mx_assoc_pref add
	foreign key( rnum, domain, type ) references
		to_many_in_mx_mx_assoc_ref( rnum, domain, type ) 
	on update cascade on delete cascade deferrable;

-- R59
alter table rr_to_one_uncond_identifier add
	foreign key( from_class, rnum, domain ) references
		miform.to_one_reference( from_class, rnum, domain )
	on update cascade on delete cascade deferrable;

-- Constraints <<<

set client_min_messages=NOTICE;
