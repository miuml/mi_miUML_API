-- init_relvars.sql
--
-- These are all of the relvars for the miUML Metamodel State Subsystem
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
drop schema if exists mistate cascade;
create schema mistate;
set search_path to mistate;

-- Types (from class models)

-- Relvars >>>

-- All constraint comments prefixed with an * are specific to this Postgres implementation
-- and do not appear on the miUML metamodel

-- Assigner --
create table assigner(
	rnum		mi.nominal,		-- I, R514->Assigner.Rnum
	domain		mi.name,		-- I, R514->Assigner.Domain

	sm_type		miuml.sm_type_a not null,	-- * R502->State Model.SM type

	primary key( rnum, domain )
);

-- Creation Event --
create table creation_event(
	id			mi.nominal,	-- I, R511->Effective Event.ID
	cnum		mi.nominal, -- I, I2, R511->Effective Event.State model, R519->Lifecycle.Class,
							-- R508->State.State model
	sm_type		miuml.sm_type_l not null,	-- * R508->State.SM type, R511->Effective Event.SM type
	domain		mi.name,					-- I, R508->State.Domain, R511->Effective Event.Domain,
									-- R519->Lifecycle.Domain
	to_state	mi.name	not null,	-- I2, R508->State.Name

	primary key( id, cnum, domain ),
	unique( cnum, to_state, domain )		-- I2
);

-- Deletion Pseudo State --
create table deletion_pstate(
	name	mi.name,	-- I, R510->Destination.Name
	cnum	mi.nominal,	-- I, R513->Lifecycle.Cnum, R510->Destination.State model
	sm_type	miuml.sm_type_l,	-- * R513->Lifecycle.sm_type, R510->Destination.SM type
	domain	mi.name,	-- I, R513->Lifecycle.Domain, R510->Destination.Domain

	primary key( name, cnum, sm_type, domain )
);

-- Destination --
create table destination(
	name		mi.name,		-- I
	state_model	mi.nominal, 	-- I
	sm_type		miuml.sm_type,	-- * I
	domain		mi.name,		-- I

	primary key( name, state_model, sm_type, domain )
);

-- Effecitve Signaling Event --
create table effective_signaling_event(
	id			mi.nominal,	-- I, R511->Effective Event.ID
	state_model	mi.nominal, -- I, R511->Effective Event.State model
	sm_type		miuml.sm_type,	-- * R511->Effective Event.SM type
	domain		mi.name,			-- I, R511->Effective Event.Domain,

	primary key( id, state_model, sm_type, domain )
);

-- Event Response --
create table event_response(
	state			mi.name,	-- I, R505->State.Name
	event			mi.nominal,	-- I, R505->Signaling Event.ID
	state_model		mi.nominal,	-- I, R505->State.State model, R505->Effective Event.State model
	sm_type			miuml.sm_type,	-- * I, R505->State.SM type, R505->Effective Event.SM type
	domain			mi.name,	-- I, R505->State.Domain, R505->Effective Event.Domain

	primary key( state, event, state_model, sm_type, domain )
);

-- Lifecycle --
create table lifecycle(
	cnum		mi.nominal,		-- * I, R500->Class.Number
	domain		mi.name,		-- I, R500->Class.Domain

	sm_type		miuml.sm_type_l not null,	-- * R502->State Model.SM type

	primary key( cnum, domain )	-- * replaces Class + Domain on metamodel
);

-- Multiple Assigner -- 
create table multiple_assigner(
	rnum		mi.nominal,		-- I, R514->Assigner.Rnum
	domain		mi.name,		-- I, R514->Assigner.Rnum, R517->Loop.Domain, R518->Class.Domain
	cloop		mi.nominal not null,	-- R517->Constrained Loop.Element
	pclass		mi.name not null,	-- R518->Class.Name, constrained in procedure

	primary key( rnum, domain )
);

-- Non Transition Rresponse --
create table nt_response(
	state	mi.name,	-- I, R506->Event Response.State
	event	mi.nominal,	-- I, R506->Event Response.Event

	state_model		mi.nominal,	-- I, R506->Event Response.State model,
								--	R507->Destination.State model
	sm_type			miuml.sm_type,	-- * I, R506->Event Responce.SM type,
								--	R507->Destination.SM type
	domain			mi.name,	-- I, R506->Event Response.Domain, R507->Destination.Domain
	behavior		miuml.ev_response not null,
	reason			mi.description not null,

	primary key( state, event, state_model, sm_type, domain )
);

-- Single Assigner -- 
create table single_assigner(
	rnum		mi.nominal,		-- I, R514->Assigner.Rnum
	domain		mi.name,		-- I, R514->Assigner.Domain

	primary key( rnum, domain )
);

-- State --
create table state(
	name		mi.name,	-- I, R510->Destination.Name
	snum		mi.nominal,	-- I2
	state_model	mi.nominal,	-- I, R503->State Model.Name, R510->Destination.State model
	sm_type		miuml.sm_type,	-- * I, R503->State Model.sm_type, R510->Destination.SM type
	domain		mi.name,	-- I, R510->Destination.Domain, R503->State Model.Domain

	primary key( name, state_model, sm_type, domain ),
	unique( snum, state_model, sm_type, domain )
);

-- State Model --
create table state_model(
	name		mi.nominal,		-- * I, replaces Name in metamodel
	sm_type		miuml.sm_type,	-- * I, not on metamodel
	domain		mi.name,		-- I

	-- Database attribute (non-modeled)
	evid_generator	mi.var_name not null,	-- Event id generator

	primary key( name, sm_type, domain ),
	unique( evid_generator )	-- because derived from name + sm_type + domain
);

-- State Model Build Specification --
create table state_model_build_spec(
	name						mi.name,	-- I,	singleton name
	default_initial_state		mi.name not null,	-- default name of initial state
	max_event_specs				mi.posint not null, -- per state model
	max_states					mi.posint not null, -- per state model

	primary key( name )
);

-- Transition --
create table transition(
	state	mi.name,	-- I, R506->Event Response.State
	event	mi.nominal,	-- I, R506->Event Response.Event

	state_model		mi.nominal,	-- I, R506->Event Response.State model,
								--	R507->Destination.State model
	sm_type			miuml.sm_type,	-- * I, R506->Event Responce.SM type,
								--	R507->Destination.SM type
	domain			mi.name,	-- I, R506->Event Response.Domain, R507->Destination.Domain
	destination		mi.name not null,	-- R507->Destination.Name

	primary key( state, event, state_model, sm_type, domain )
);


-- Relvars <<<

-- Constraints >>>
-- R500
alter table lifecycle add
	foreign key( cnum, domain ) references miclass.class( cnum, domain ) 
	on update cascade on delete cascade deferrable;

-- R501
alter table assigner add
	foreign key( rnum, domain ) references mirel.association( rnum, domain ) 
	on update cascade on delete cascade deferrable;

-- R502
alter table lifecycle add constraint
    R502_Lifecycle__is_a__State_Model
	foreign key( cnum, sm_type, domain ) references state_model( name, sm_type, domain ) 
	on update cascade on delete cascade deferrable;

alter table assigner add constraint
    R502_Assigner__is_a__State_Model
	foreign key( rnum, sm_type, domain ) references state_model( name, sm_type, domain ) 
	on update cascade on delete cascade deferrable;

-- R503
alter table state add
	foreign key( state_model, sm_type, domain ) references state_model( name, sm_type, domain ) 
	on update cascade on delete cascade deferrable;

-- R505
alter table event_response add
	foreign key( state, state_model, sm_type, domain ) references
		state( name, state_model, sm_type, domain ) 
	on update cascade on delete cascade deferrable;

alter table event_response add
	foreign key( event, state_model, sm_type, domain ) references
		effective_signaling_event( id, state_model, sm_type, domain ) 
	on update cascade on delete cascade deferrable;

-- R506
alter table transition add
	foreign key( state, event, state_model, sm_type, domain ) references
		event_response( state, event, state_model, sm_type, domain ) 
	on update cascade on delete cascade deferrable;

alter table nt_response add
	foreign key( state, event, state_model, sm_type, domain ) references
		event_response( state, event, state_model, sm_type, domain ) 
	on update cascade on delete cascade deferrable;

-- R507
alter table transition add
	foreign key( destination, state_model, sm_type, domain ) references
		destination( name, state_model, sm_type, domain ) 
	on update cascade on delete cascade deferrable;

-- R508
alter table creation_event add
	foreign key( to_state, cnum, sm_type, domain ) references
		state( name, state_model, sm_type, domain ) 
	on update cascade on delete cascade deferrable;

-- R510
alter table deletion_pstate add constraint
    R510_Deletion_Pstate__is_a__Destination
	foreign key( name, cnum, sm_type, domain ) references
		destination( name, state_model, sm_type, domain ) 
	on update cascade on delete cascade deferrable;

alter table state add constraint
    R510_State__is_a__Destination
	foreign key( name, state_model, sm_type, domain ) references
		destination( name, state_model, sm_type, domain ) 
	on update cascade on delete cascade deferrable;

-- R513
alter table deletion_pstate add
	foreign key( cnum, domain ) references lifecycle( cnum, domain ) 
	on update cascade on delete cascade deferrable;

-- R514
alter table single_assigner add
	foreign key( rnum, domain ) references assigner( rnum, domain ) 
	on update cascade on delete cascade deferrable;

alter table multiple_assigner add
	foreign key( rnum, domain ) references assigner( rnum, domain ) 
	on update cascade on delete cascade deferrable;

-- R517
alter table multiple_assigner add
	foreign key( cloop, domain ) references mirel.constrained_loop( element, domain ) 
	on update cascade on delete cascade deferrable;

-- R518
alter table multiple_assigner add
	foreign key( pclass, domain ) references miclass.class( name, domain ) 
	on update cascade on delete cascade deferrable;

-- R519
alter table creation_event add
	foreign key( cnum, domain ) references lifecycle( cnum, domain ) 
	on update cascade on delete cascade deferrable;

-- FOR Polymorphism Subsystem


-- R564
alter table mipoly.state_signature add
	foreign key( state, state_model, sm_type, domain ) references
		destination( name, state_model, sm_type, domain )
	on update cascade on delete cascade deferrable;

-- R565
alter table mipoly.event_spec add
	foreign key( state_model, sm_type, domain ) references
		state_model( name, sm_type, domain )
	on update cascade on delete cascade deferrable;

-- R567
alter table creation_event add
	foreign key( id, cnum, sm_type, domain ) references
		mipoly.local_effective_event( id, state_model, sm_type, domain ) 
	on update cascade on delete cascade deferrable;

-- R568
alter table mipoly.local_effective_signaling_event add constraint
    R568_Local_Effective_Signaling_Event__is_an__Effective_Signaling_Event
	foreign key( id, state_model, sm_type, domain ) references
		effective_signaling_event( id, state_model, sm_type, domain ) 
	on update cascade on delete cascade deferrable;

alter table mipoly.inherited_effective_event add constraint
    R568_Inherited_Effective_Event__is_an__Effective_Signaling_Event
	foreign key( id, cnum, sm_type, domain ) references
		effective_signaling_event( id, state_model, sm_type, domain ) 
	on update cascade on delete cascade deferrable;

-- Constraints <<<
set client_min_messages=NOTICE;
