-- ++ post-update
    declare
        my_subsystem    subsystem%rowtype;
    begin
        if p_name is not NULL then
            -- Manually cascade each State Model
            update mistate.state_model set domain = p_new_name
            where domain = p_name;
            update mistate.destination set domain = p_new_name
            where domain = p_name;
            update mipoly.event set domain = p_new_name
            where domain = p_name;
            update mistate.effective_signaling_event set domain = p_new_name
            where domain = p_name;
            update mipoly.state_model_signature set domain = p_new_name
            where domain = p_name;
        end if;

        -- Assert self exists
        if p_new_alias is not NULL then
            -- Update all my subsystem sequence names, if the alias changed
            for my_subsystem in
                select * from subsystem where domain = self.name
            loop
                perform event_subsystem_domain_alias_renamed(
                    my_subsystem.name, self.name, p_new_alias
                );
            end loop;
        end if;
    end;
-- ==
