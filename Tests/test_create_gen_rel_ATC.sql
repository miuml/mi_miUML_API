-- Existing Superclass, new Subclasses
-- For ATC Example

-- Assume domain, subsys and superclass already exist

begin;
set constraints R103_Generalization__requires__Superclass deferred;
select UI_new_gen(
	p_superclass:='Air Traffic Controller',
    p_subclasses:=array[ 'On Duty Controller', 'Off Duty Controller' ],
    p_sub_aliases:=array[ 'ON', 'OFF' ],
    p_subsys:='Airfield Management',
    p_domain:='Air Traffic Control'
);
commit;
