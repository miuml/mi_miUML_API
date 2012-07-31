-- ++ pre-update
    -- The cnum requires special validation logic
    if p_new_cnum is not NULL then
        perform method_class_validate_cnum( p_name, p_domain, p_new_cnum );
        -- Will throw an erorr if the cnum is invalid
    end if;
-- ==
