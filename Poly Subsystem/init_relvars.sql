-- init_relvars.sql
--
-- These are all of the relvars for the miUML Metamodel Polymorphism Subsystem
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
set client_min_messages=ERROR;
drop schema if exists mipoly cascade;
create schema mipoly;
set search_path to mipoly;

-- Types (from class models)

-- Relvars >>>

-- All constraint comments prefixed with an * are specific to this Postgres implementation
-- and do not appear on the miUML metamodel

-- Delegation Direction --
create table delegation_dir(
	delegated_evid			mi.nominal,		-- I, R569->Delegated Event.ID
	super_cnum				mi.nominal,		-- I, R569->Delegated Event.Cnum
	domain					mi.name,		-- I, R569->Delegated Event.Domain, R569->Gen.Domain
	gen_rnum				mi.nominal,		-- I, R569->Generalization.Rnum

	primary key( delegated_evid, super_cnum, domain, gen_rnum )
);

-- Delegated Event --
create table delegated_event(
	id			mi.nominal,			-- I, R560->Event.ID
	cnum		mi.nominal, 		-- I, R560->Event.State model
	sm_type		miuml.sm_type_l not null,	-- * R560->Event.SM type
	domain		mi.name,			-- I, R560->Event.Domain

	primary key( id, cnum, domain )
);

-- Delegation Path --
create table delegation_path(
	delegated_evid		mi.nominal,		-- I, *I2, R553->Delegation Dir.Delegated event ID
	super_cnum			mi.nominal,		-- I, R553->Delegation Dir.Super cnum
	sub_cname			mi.name,		-- *I2, R553->Subclass.Class
	sub_cnum			mi.nominal not null,		-- * I, -> miclass.cnum
	gen_rnum			mi.nominal,		-- I, *I2, R553->Subclass.Rnum, R553->Del Dir.Gen Rnum
	domain				mi.name,		-- I, *I2, R553->Delegation Dir.Domain, Subclass.Domain

	-- sub_cnum is required so that inherited event.subclass is a nominal
	primary key( delegated_evid, super_cnum, sub_cnum, gen_rnum, domain ),
	-- sub_cname is also used so that R553 constraint is enforced
	unique( delegated_evid, super_cnum, sub_cname, gen_rnum, domain )
);

-- Effective Event --
create table effective_event(
	id			mi.nominal,		-- I, R560->Event.ID
	state_model	mi.nominal, 	-- I, R560->Event.State model
	sm_type		miuml.sm_type,	-- * I, R560->Event.SM type
	domain		mi.name,		-- I, R560->Event.Domain

	primary key( id, state_model, sm_type, domain )
);

-- Event --
create table event(
	id				mi.nominal,		-- I
	state_model		mi.nominal,		-- I
	sm_type			miuml.sm_type,	-- * I
	domain			mi.name,		-- I

	primary key( id, state_model, sm_type, domain )
);

-- Event Signature --
create table event_signature(
	ev_spec			mi.name,			-- I, R556->Event Spec.Name, R562->SM Sig.Name
	state_model		mi.nominal,			-- I, R556->Event Spec.State model, R562->SM Sig.State model
	sm_type			miuml.sm_type,		-- I, R556->Event Spec.SM type, R562->SM Sig.SM type
	sig_type		miuml.sig_type_e not null,	-- * R562-> State Model Sig.Sig type
	domain			mi.name,			-- I, R556->Event Spec.Domain, R562->SM Sig.Domain

	primary key( ev_spec, state_model, sm_type, domain )
);

-- Event Specification --
create table event_spec(
	number			mi.nominal,			-- I
	name			mi.name not null,	-- I2
	state_model		mi.nominal,			-- I, I2, R565->State model.Name
	sm_type			miuml.sm_type,		-- * I, R565->State model.SM type
	domain			mi.name,			-- I, R565->State model.Domain

	primary key( number, state_model, sm_type, domain ),
	unique( name, state_model, sm_type, domain )
);

-- Inherited Event --
create table inherited_event(
	id				mi.nominal,		-- I, union Inherited Effective Event.ID and 
									--	Inherited Delegated Event.ID
	sub_cnum		mi.nominal,		-- I, I2, R559->Delegation Path.Subclass
	domain			mi.name,		-- I, I2, R559->Delegation Path.Domain
	parent_evid		mi.nominal not null,	-- I2, R559->Delegation Path.Delegated event ID
	super_cnum		mi.nominal not null,	-- I2, R559->Delegation Path.Superclass
	gen_rnum		mi.nominal not null,	-- I2, R559->Delegation Path.Generalization

	primary key( id, sub_cnum, domain ),
	unique( sub_cnum, super_cnum, parent_evid, gen_rnum, domain ) -- I2
);

-- Inherited Delegated Event --
create table inherited_delegated_event(
	id			mi.nominal,		-- I, R561->Delegated Event.ID, R552->Inherited Event.ID
	cnum		mi.nominal,		-- * I, R561->Delegated Event.Class, R552->Inherited Event.Subclass
	domain		mi.name,		-- I, R561->Delegated Event.Domain, R552->Inherited Event.Domain

	primary key( id, cnum, domain )
);

-- Inherited Effective Event --
create table inherited_effective_event(
	id			mi.nominal,		-- I, R554->Effective Event.ID,
								-- R552->Inherited Event.ID,
								-- R568->Effective Sig Event.ID

	cnum		mi.nominal, 	-- I, R554->Effective Event.State model,
								-- R552->Inherited Event.Subclass,
								-- R568->Effective Sig Event.State model
								

	sm_type		miuml.sm_type_l not null,	-- * R554->Effective Event.SM type, 
								-- R568->Effective Sig Event.SM type

	domain		mi.name,		-- I, R554->Effective Event.Domain,
								-- R552->Inherited Event.Domain,
								-- R568->Effective Sig Event.Domain

	primary key( id, cnum, domain )
);

-- Local Delegated Event --
create table local_delegated_event(
	id			mi.nominal,		-- I, R561->Delegated Event.ID

	cnum		mi.nominal,		-- I, I2, R561->Delegated Event.Class,
								-- R558->Polymorphic Event Spec.Superclass

	domain		mi.name,		-- I, I2, R561->Delegated Event.Domain,
								-- R558->Polymorphic Event Spec.Domain

	ev_spec		mi.nominal not null,	-- I2, R558->Polymorphic Event Spec.Number

	primary key( id, cnum, domain ),
	unique( ev_spec, cnum, domain )
);

-- Local Effective Event --
create table local_effective_event(
	id			mi.nominal,		-- I, R554->Effective Event.ID

	state_model	mi.nominal, 	-- I, R554->Effective Event.State model,
								-- R557->Monomorphic Event Spec.State model

	sm_type		miuml.sm_type,	-- * I, R554->Effective Event.SM type, 
								-- R557->Monomorphic Event Spec.SM type

	domain		mi.name,		-- I, R554->Effective Event.Domain,
								-- R557->Monomorphic Event Spec.Domain

	ev_spec		mi.nominal,		-- I2, R557->Monomorphic Event Spec.Number

	primary key( id, state_model, sm_type, domain ),
	unique( ev_spec, state_model, sm_type, domain )
);

-- Local Effective Signaling Event --
create table local_effective_signaling_event(

	id			mi.nominal,		-- I, R567->Local Eff Event.ID,
								-- R568->Effective Signaling Event.ID

	state_model	mi.nominal,		-- I, R567->Local Eff Event.ID,
								-- R568->Effective Signaling Event.ID

	sm_type		miuml.sm_type,	-- * I, R567->Local Eff Event.SM type, 
								-- R568->Effective Sig Event.SM type

	domain		mi.name,		-- I, R567->Local Eff Event.Domain,
								-- R568->Effective Sig Event.Domain

	primary key( id, state_model, sm_type, domain )
);

-- Monomorphic Event Specification --
create table monomorphic_event_spec(
	number			mi.nominal,			-- I, R550->Event Spec.Number
	state_model		mi.nominal,			-- I, R550->Event Spec.State model
	sm_type			miuml.sm_type,		-- I, R550->Event Spec.SM type
	domain			mi.name,			-- I, R550->Event Spec.Domain

	primary key( number, state_model, sm_type, domain )
);

-- Polymrophic Event Specification --
create table polymorphic_event_spec(
	number			mi.nominal,			-- I, R550->Event Spec.Number

	-- Since R551 cannot access a cnum:nominal, use procedural constraint enforcement
	cnum			mi.nominal,			-- I, R550->Event Spec.State model, * verify superclass
	sm_type			miuml.sm_type_l not null,	-- I, I2, R550->Event Spec.SM type
	domain			mi.name,			-- I, I2, R550->Event Spec.Domain, R551->Superclass.Domain

	primary key( number, cnum, domain ) -- To support formulation of state model.name nominal
);

-- State Model Parameter --
create table state_model_parameter(
	name			mi.name,		-- I
	signature		mi.name,		-- I, R563->State Model Sig.Name
	sig_type		miuml.sig_type,	-- I, R563->State Model Sig.Sig type
	state_model		mi.nominal,		-- I, R563->State Model Sig.State model
	sm_type			miuml.sm_type,	-- * I, R563->State Model Sig.SM type
	domain			mi.name,		-- I, R563->State Model Sig.Domain, R566->Constrained
	type			mi.compound_name not null,	-- R566->Constrained Type.Name

	primary key( name, signature, sig_type, state_model, sm_type, domain )
);

-- State Model Signature --
create table state_model_signature(
	name			mi.name,			-- I 
	state_model		mi.nominal,			-- I
	sm_type			miuml.sm_type,		-- I
	sig_type		miuml.sig_type,		-- I
	domain			mi.name,			-- I

	primary key( name, sig_type, state_model, sm_type, domain )
);

-- State Signature --
create table state_signature(
	state			mi.name,			-- I, R564->Destination.Name, R562->State Model Sig.Name
	state_model		mi.nominal,			-- I
	sm_type			miuml.sm_type,		-- I
	sig_type		miuml.sig_type_s not null,	-- * R562-> State Model Sig.Sig type
	domain			mi.name,			-- I

	primary key( state, state_model, sm_type, domain )
);

-- Relvars <<<

-- Constraints >>>

-- R550
alter table monomorphic_event_spec add
	foreign key( number, state_model, sm_type, domain ) references
		event_spec( number, state_model, sm_type, domain ) 
	on update cascade on delete cascade deferrable;

alter table polymorphic_event_spec add
	foreign key( number, cnum, sm_type, domain ) references
		event_spec( number, state_model, sm_type, domain ) 
	on update cascade on delete cascade deferrable;

-- R552
alter table inherited_delegated_event add
	foreign key( id, cnum, domain ) references
		inherited_event( id, sub_cnum, domain ) 
	on update cascade on delete cascade deferrable;

alter table inherited_effective_event add
	foreign key( id, cnum, domain ) references
		inherited_event( id, sub_cnum, domain ) 
	on update cascade on delete cascade deferrable;

-- R553
alter table delegation_path add
	foreign key( delegated_evid, super_cnum, gen_rnum, domain ) references
		delegation_dir( delegated_evid, super_cnum, gen_rnum, domain ) 
	on update cascade on delete cascade deferrable;

alter table delegation_path add
	foreign key( sub_cname, gen_rnum, domain ) references
		mirel.subclass( class, rnum, domain ) 
	on update cascade on delete cascade deferrable;

-- R554
alter table inherited_effective_event add
	foreign key( id, cnum, sm_type, domain ) references
		effective_event( id, state_model, sm_type, domain )
	on update cascade on delete cascade deferrable;

alter table local_effective_event add
	foreign key( id, state_model, sm_type, domain ) references
		effective_event( id, state_model, sm_type, domain )
	on update cascade on delete cascade deferrable;

-- R556
alter table event_signature add
	foreign key( ev_spec, state_model, sm_type, domain ) references
		event_spec( name, state_model, sm_type, domain )
	on update cascade on delete cascade deferrable;

-- R557
alter table local_effective_event add
	foreign key( ev_spec, state_model, sm_type, domain ) references
		monomorphic_event_spec( number, state_model, sm_type, domain ) 
	on update cascade on delete cascade deferrable;

-- R558
alter table local_delegated_event add
	foreign key( ev_spec, cnum, domain ) references
		polymorphic_event_spec( number, cnum, domain ) 
	on update cascade on delete cascade deferrable;

-- R559
alter table inherited_event add
	foreign key( sub_cnum, super_cnum, gen_rnum, parent_evid, domain ) references
		delegation_path( sub_cnum, super_cnum, gen_rnum, delegated_evid, domain ) 
	on update cascade on delete cascade deferrable;

-- R560
alter table effective_event add constraint
    R560_Effective_Event__is_an__Event
	foreign key( id, state_model, sm_type, domain ) references
		event( id, state_model, sm_type, domain ) 
	on update cascade on delete cascade deferrable;

alter table delegated_event add constraint
    R560_Delegated_Event__is_an__Event
	foreign key( id, cnum, sm_type, domain ) references
		event( id, state_model, sm_type, domain ) 
	on update cascade on delete cascade deferrable;

-- R561
alter table local_delegated_event add
	foreign key( id, cnum, domain ) references
		delegated_event( id, cnum, domain ) 
	on update cascade on delete cascade deferrable;

alter table inherited_delegated_event add
	foreign key( id, cnum, domain ) references
		delegated_event( id, cnum, domain ) 
	on update cascade on delete cascade deferrable;

-- R562
alter table event_signature add constraint
    R562_Event_Signature__is_a__State_Model_Signature
	foreign key( ev_spec, sig_type, state_model, sm_type, domain ) references
		state_model_signature( name, sig_type, state_model, sm_type, domain ) 
	on update cascade on delete cascade deferrable;

alter table state_signature add constraint
    R562_State_Signature__is_a__State_Model_Signature
	foreign key( state, sig_type, state_model, sm_type, domain ) references
		state_model_signature( name, sig_type, state_model, sm_type, domain ) 
	on update cascade on delete cascade deferrable;

-- R563
alter table state_signature add
	foreign key( state, sig_type, state_model, sm_type, domain ) references
		state_model_signature( name, sig_type, state_model, sm_type, domain ) 
	on update cascade on delete cascade deferrable;

-- R564, R565
-- Constraints defined in State Subsystem init_relvar file

-- R566
alter table state_model_parameter add
	foreign key( type ) references
		mitype.constrained_type( name ) 
	on update cascade on delete cascade deferrable;

-- R567
alter table local_effective_signaling_event add
	foreign key( id, state_model, sm_type, domain ) references
		local_effective_event( id, state_model, sm_type, domain ) 
	on update cascade on delete cascade deferrable;

-- R569
alter table delegation_dir add
	foreign key( delegated_evid, super_cnum, domain ) references
		delegated_event( id, cnum, domain ) 
	on update cascade on delete cascade deferrable;

alter table delegation_dir add
	foreign key( gen_rnum, domain ) references
		mirel.generalization( rnum, domain ) 
	on update cascade on delete cascade deferrable;

-- Constraints <<<
set client_min_messages=NOTICE;
