-- ++ post-update
    if p_new_alias is not NULL then
        perform event_subsystem_alias_renamed(
            self.name, self.domain
        );
    end if;
-- ==
