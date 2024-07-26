--
-- This script is a SAMPLE and can be modified as appropriate by the
-- customer as long as the equivalent tables and indexes are created.
-- The database name, user, and password must match those defined in
-- iiq.properties in the IdentityIQ installation.
--  

-- Note that we do not specify a COLLATE - use default value from each MySQL release.
-- IdentityIQ requires a case-insensitive collation.
CREATE DATABASE IF NOT EXISTS identityiq CHARACTER SET utf8mb4;

--
-- MYSQL - Use the following statements to create users for MySql databases.
-- If installing on Aurora, remove the following statements and run the Aurora specific ones below.
--
-- The 'WITH mysql_native_password' is used here to prevent the need
-- for complex MySQL configuration.  For production systems, consult 
-- your DBA for the recommended authentication plugin.
--  
CREATE USER IF NOT EXISTS 'identityiq'@'%' IDENTIFIED WITH mysql_native_password BY 'identityiq';
GRANT ALL PRIVILEGES ON identityiq.* TO 'identityiq'@'%';

CREATE USER IF NOT EXISTS 'identityiq'@'localhost' IDENTIFIED WITH mysql_native_password BY 'identityiq';
GRANT ALL PRIVILEGES ON identityiq.* TO 'identityiq'@'localhost';
--
-- End MYSQL

--
-- AURORA - Use the following statements to create users for Aurora databases.
-- If installing on MySql, do not run these statements.
--
-- nowarning; -- Ignore warnings from MySql 5.7 suggesting use of newer ALTER USER.
--
-- GRANT ALL PRIVILEGES ON identityiq.*
--     TO 'identityiq' IDENTIFIED BY 'identityiq';
-- GRANT ALL PRIVILEGES ON identityiq.*
--     TO 'identityiq'@'%' IDENTIFIED BY 'identityiq';
-- GRANT ALL PRIVILEGES ON identityiq.*
--     TO 'identityiq'@'localhost' IDENTIFIED BY 'identityiq';
--
-- warnings; -- resume warnings
--
-- End AURORA

USE identityiq;


-- Note that we do not specify a COLLATE - use default value for each MySQL release,
-- which causes queries to be case-insensitive.
CREATE DATABASE IF NOT EXISTS identityiqPlugin CHARACTER SET utf8mb4;

--
-- MYSQL - Use the following statements to create users for MySql databases.
-- If installing on Aurora, remove the following statements and run the Aurora specific ones below.
--  
-- The 'WITH mysql_native_password' is used here to prevent the need
-- for complex MySQL configuration.  For production systems, consult 
-- your DBA for the recommended authentication plugin.
--  
CREATE USER IF NOT EXISTS 'identityiqPlugin'@'%' IDENTIFIED WITH mysql_native_password BY 'identityiqPlugin';
GRANT ALL PRIVILEGES ON identityiqPlugin.* TO 'identityiqPlugin'@'%';

CREATE USER IF NOT EXISTS 'identityiqPlugin'@'localhost' IDENTIFIED WITH mysql_native_password BY 'identityiqPlugin';
GRANT ALL PRIVILEGES ON identityiqPlugin.* TO 'identityiqPlugin'@'localhost';
--
-- End MYSQL

--
-- AURORA - Use the following statements to create users for Aurora databases.
-- If installing on MySql, do not run these statements.
--
-- nowarning; -- Ignore warnings from 5.7 suggesting use of newer ALTER USER.
--
-- GRANT ALL PRIVILEGES ON identityiqPlugin.*
--     TO 'identityiqPlugin' IDENTIFIED BY 'identityiqPlugin';
-- GRANT ALL PRIVILEGES ON identityiqPlugin.*
--     TO 'identityiqPlugin'@'%' IDENTIFIED BY 'identityiqPlugin';
-- GRANT ALL PRIVILEGES ON identityiqPlugin.*
--     TO 'identityiqPlugin'@'localhost' IDENTIFIED BY 'identityiqPlugin';
--
-- warnings; -- resume warnings
--
-- End AURORA
-- From the Quartz 1.5.2 Distribution
--
-- IdentityIQ NOTES:
--
-- Since things like Application names can make their way into TaskSchedule
-- object names, we are forced to modify the Quartz schema in places where
-- the original column size is insufficient. Thus JOB_NAME and TRIGGER_NAME
-- have been increased from VARCHAR(80) to VARCHAR(200).
--
-- Future upgrades to Quartz will have to carry forward these changes.
-- 
-- 12/17/2013 Updated for Quartz 2.2.1
--

#
# Quartz seems to work best with the driver mm.mysql-2.0.7-bin.jar
#
# In your Quartz properties file, you'll need to set
# org.quartz.jobStore.driverDelegateClass = org.quartz.impl.jdbcjobstore.StdJDBCDelegate
#
CREATE TABLE QRTZ221_JOB_DETAILS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    JOB_NAME  VARCHAR(200) NOT NULL,
    JOB_GROUP VARCHAR(200) NOT NULL,
    DESCRIPTION VARCHAR(250) NULL,
    JOB_CLASS_NAME   VARCHAR(250) NOT NULL,
    IS_DURABLE VARCHAR(1) NOT NULL,
    IS_NONCONCURRENT VARCHAR(1) NOT NULL,
    IS_UPDATE_DATA VARCHAR(1) NOT NULL,
    REQUESTS_RECOVERY VARCHAR(1) NOT NULL,
    JOB_DATA BLOB NULL,
    PRIMARY KEY (SCHED_NAME,JOB_NAME,JOB_GROUP)
) ENGINE=InnoDB;

CREATE TABLE QRTZ221_TRIGGERS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    TRIGGER_NAME VARCHAR(200) NOT NULL,
    TRIGGER_GROUP VARCHAR(200) NOT NULL,
    JOB_NAME  VARCHAR(200) NOT NULL,
    JOB_GROUP VARCHAR(200) NOT NULL,
    DESCRIPTION VARCHAR(250) NULL,
    NEXT_FIRE_TIME BIGINT NULL,
    PREV_FIRE_TIME BIGINT NULL,
    PRIORITY INTEGER NULL,
    TRIGGER_STATE VARCHAR(16) NOT NULL,
    TRIGGER_TYPE VARCHAR(8) NOT NULL,
    START_TIME BIGINT NOT NULL,
    END_TIME BIGINT NULL,
    CALENDAR_NAME VARCHAR(200) NULL,
    MISFIRE_INSTR SMALLINT NULL,
    JOB_DATA BLOB NULL,
    PRIMARY KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    FOREIGN KEY (SCHED_NAME,JOB_NAME,JOB_GROUP)
        REFERENCES QRTZ221_JOB_DETAILS(SCHED_NAME,JOB_NAME,JOB_GROUP)
) ENGINE=InnoDB;

CREATE TABLE QRTZ221_SIMPLE_TRIGGERS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    TRIGGER_NAME VARCHAR(200) NOT NULL,
    TRIGGER_GROUP VARCHAR(200) NOT NULL,
    REPEAT_COUNT BIGINT NOT NULL,
    REPEAT_INTERVAL BIGINT NOT NULL,
    TIMES_TRIGGERED BIGINT NOT NULL,
    PRIMARY KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    FOREIGN KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
        REFERENCES QRTZ221_TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
) ENGINE=InnoDB;

CREATE TABLE QRTZ221_CRON_TRIGGERS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    TRIGGER_NAME VARCHAR(200) NOT NULL,
    TRIGGER_GROUP VARCHAR(200) NOT NULL,
    CRON_EXPRESSION VARCHAR(200) NOT NULL,
    TIME_ZONE_ID VARCHAR(80),
    PRIMARY KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    FOREIGN KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
        REFERENCES QRTZ221_TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
) ENGINE=InnoDB;

CREATE TABLE QRTZ221_SIMPROP_TRIGGERS
  (          
    SCHED_NAME VARCHAR(120) NOT NULL,
    TRIGGER_NAME VARCHAR(200) NOT NULL,
    TRIGGER_GROUP VARCHAR(200) NOT NULL,
    STR_PROP_1 VARCHAR(512) NULL,
    STR_PROP_2 VARCHAR(512) NULL,
    STR_PROP_3 VARCHAR(512) NULL,
    INT_PROP_1 INT NULL,
    INT_PROP_2 INT NULL,
    LONG_PROP_1 BIGINT NULL,
    LONG_PROP_2 BIGINT NULL,
    DEC_PROP_1 NUMERIC(13,4) NULL,
    DEC_PROP_2 NUMERIC(13,4) NULL,
    BOOL_PROP_1 VARCHAR(1) NULL,
    BOOL_PROP_2 VARCHAR(1) NULL,
    PRIMARY KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    FOREIGN KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP) 
    REFERENCES QRTZ221_TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
) ENGINE=InnoDB;

CREATE TABLE QRTZ221_BLOB_TRIGGERS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    TRIGGER_NAME VARCHAR(200) NOT NULL,
    TRIGGER_GROUP VARCHAR(200) NOT NULL,
    BLOB_DATA BLOB NULL,
    PRIMARY KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    FOREIGN KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
        REFERENCES QRTZ221_TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
) ENGINE=InnoDB;

CREATE TABLE QRTZ221_CALENDARS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    CALENDAR_NAME  VARCHAR(200) NOT NULL,
    CALENDAR BLOB NOT NULL,
    PRIMARY KEY (SCHED_NAME,CALENDAR_NAME)
) ENGINE=InnoDB;

CREATE TABLE QRTZ221_PAUSED_TRIGGER_GRPS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    TRIGGER_GROUP  VARCHAR(200) NOT NULL, 
    PRIMARY KEY (SCHED_NAME,TRIGGER_GROUP)
) ENGINE=InnoDB;

CREATE TABLE QRTZ221_FIRED_TRIGGERS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    ENTRY_ID VARCHAR(95) NOT NULL,
    TRIGGER_NAME VARCHAR(200) NOT NULL,
    TRIGGER_GROUP VARCHAR(200) NOT NULL,
    INSTANCE_NAME VARCHAR(200) NOT NULL,
    FIRED_TIME BIGINT NOT NULL,
    SCHED_TIME BIGINT NOT NULL,
    PRIORITY INTEGER NOT NULL,
    STATE VARCHAR(16) NOT NULL,
    JOB_NAME VARCHAR(200) NULL,
    JOB_GROUP VARCHAR(200) NULL,
    IS_NONCONCURRENT VARCHAR(1) NULL,
    REQUESTS_RECOVERY VARCHAR(1) NULL,
    PRIMARY KEY (SCHED_NAME,ENTRY_ID)
) ENGINE=InnoDB;

CREATE TABLE QRTZ221_SCHEDULER_STATE
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    INSTANCE_NAME VARCHAR(200) NOT NULL,
    LAST_CHECKIN_TIME BIGINT NOT NULL,
    CHECKIN_INTERVAL BIGINT NOT NULL,
    PRIMARY KEY (SCHED_NAME,INSTANCE_NAME)
) ENGINE=InnoDB;

CREATE TABLE QRTZ221_LOCKS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    LOCK_NAME  VARCHAR(40) NOT NULL, 
    PRIMARY KEY (SCHED_NAME,LOCK_NAME)
) ENGINE=InnoDB;

INSERT INTO QRTZ221_LOCKS VALUES('QuartzScheduler', "TRIGGER_ACCESS");
INSERT INTO QRTZ221_LOCKS VALUES('QuartzScheduler', "JOB_ACCESS");
INSERT INTO QRTZ221_LOCKS VALUES('QuartzScheduler', "CALENDAR_ACCESS");
INSERT INTO QRTZ221_LOCKS VALUES('QuartzScheduler', "STATE_ACCESS");
INSERT INTO QRTZ221_LOCKS VALUES('QuartzScheduler', "MISFIRE_ACCESS");

create index idx_qrtz_j_req_recovery on QRTZ221_JOB_DETAILS(SCHED_NAME,REQUESTS_RECOVERY);
create index idx_qrtz_j_grp on QRTZ221_JOB_DETAILS(SCHED_NAME,JOB_GROUP);
create index idx_qrtz_t_j on QRTZ221_TRIGGERS(SCHED_NAME,JOB_NAME,JOB_GROUP);
create index idx_qrtz_t_jg on QRTZ221_TRIGGERS(SCHED_NAME,JOB_GROUP);
create index idx_qrtz_t_c on QRTZ221_TRIGGERS(SCHED_NAME,CALENDAR_NAME);
create index idx_qrtz_t_g on QRTZ221_TRIGGERS(SCHED_NAME,TRIGGER_GROUP);
create index idx_qrtz_t_state on QRTZ221_TRIGGERS(SCHED_NAME,TRIGGER_STATE);
create index idx_qrtz_t_n_state on QRTZ221_TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP,TRIGGER_STATE);
create index idx_qrtz_t_n_g_state on QRTZ221_TRIGGERS(SCHED_NAME,TRIGGER_GROUP,TRIGGER_STATE);
create index idx_qrtz_t_next_fire_time on QRTZ221_TRIGGERS(SCHED_NAME,NEXT_FIRE_TIME);
create index idx_qrtz_t_nft_st on QRTZ221_TRIGGERS(SCHED_NAME,TRIGGER_STATE,NEXT_FIRE_TIME);
create index idx_qrtz_t_nft_misfire on QRTZ221_TRIGGERS(SCHED_NAME,MISFIRE_INSTR,NEXT_FIRE_TIME);
create index idx_qrtz_t_nft_st_misfire on QRTZ221_TRIGGERS(SCHED_NAME,MISFIRE_INSTR,NEXT_FIRE_TIME,TRIGGER_STATE);
create index idx_qrtz_t_nft_st_misfire_grp on QRTZ221_TRIGGERS(SCHED_NAME,MISFIRE_INSTR,NEXT_FIRE_TIME,TRIGGER_GROUP,TRIGGER_STATE);
create index idx_qrtz_ft_trig_inst_name on QRTZ221_FIRED_TRIGGERS(SCHED_NAME,INSTANCE_NAME);
create index idx_qrtz_ft_inst_job_req_rcvry on QRTZ221_FIRED_TRIGGERS(SCHED_NAME,INSTANCE_NAME,REQUESTS_RECOVERY);
create index idx_qrtz_ft_j_g on QRTZ221_FIRED_TRIGGERS(SCHED_NAME,JOB_NAME,JOB_GROUP);
create index idx_qrtz_ft_jg on QRTZ221_FIRED_TRIGGERS(SCHED_NAME,JOB_GROUP);
create index idx_qrtz_ft_t_g on QRTZ221_FIRED_TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP);
create index idx_qrtz_ft_tg on QRTZ221_FIRED_TRIGGERS(SCHED_NAME,TRIGGER_GROUP);
-- End Quartz configuration

    create table identityiq.spt_account_group (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        assigned_scope_path varchar(450),
        name varchar(128),
        description varchar(1024),
        native_identity varchar(322),
        reference_attribute varchar(128),
        member_attribute varchar(128),
        last_refresh bigint,
        last_target_aggregation bigint,
        uncorrelated bit,
        attributes longtext,
        key1 varchar(128),
        key2 varchar(128),
        key3 varchar(128),
        key4 varchar(128),
        owner varchar(32),
        assigned_scope varchar(32),
        application varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_account_group_inheritance (
       account_group varchar(32) not null,
        idx integer not null,
        inherits_from varchar(32) not null,
        primary key (account_group, idx)
    ) engine=InnoDB;

    create table identityiq.spt_account_group_perms (
       accountgroup varchar(32) not null,
        idx integer not null,
        target varchar(255),
        rights varchar(4000),
        annotation varchar(255),
        primary key (accountgroup, idx)
    ) engine=InnoDB;

    create table identityiq.spt_account_group_target_perms (
       accountgroup varchar(32) not null,
        idx integer not null,
        target varchar(255),
        rights varchar(4000),
        annotation varchar(255),
        primary key (accountgroup, idx)
    ) engine=InnoDB;

    create table identityiq.spt_activity_constraint (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        assigned_scope_path varchar(450),
        name varchar(2000),
        description varchar(4000),
        violation_owner_type varchar(255),
        compensating_control longtext,
        disabled bit,
        weight integer,
        remediation_advice longtext,
        violation_summary longtext,
        identity_filters longtext,
        activity_filters longtext,
        time_periods longtext,
        owner varchar(32),
        assigned_scope varchar(32),
        policy varchar(32),
        violation_owner varchar(32),
        violation_owner_rule varchar(32),
        idx integer,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_activity_data_source (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        assigned_scope_path varchar(450),
        name varchar(128) not null,
        description varchar(1024),
        collector varchar(255),
        type varchar(255),
        configuration longtext,
        last_refresh bigint,
        targets longtext,
        owner varchar(32),
        assigned_scope varchar(32),
        correlation_rule varchar(32),
        transformation_rule varchar(32),
        application varchar(32),
        idx integer,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_activity_time_periods (
       application_activity varchar(32) not null,
        idx integer not null,
        time_period varchar(32) not null,
        primary key (application_activity, idx)
    ) engine=InnoDB;

    create table identityiq.spt_alert (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        extended1 varchar(255),
        attributes longtext,
        alert_date bigint,
        native_id varchar(255),
        target_id varchar(255),
        target_type varchar(255),
        target_display_name varchar(255),
        last_processed bigint,
        display_name varchar(128),
        name varchar(255),
        type varchar(255),
        source varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_alert_action (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        alert_def longtext,
        action_type varchar(255),
        result_id varchar(255),
        result longtext,
        alert varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_alert_definition (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        assigned_scope_path varchar(450),
        match_config longtext,
        disabled bit,
        name varchar(128) not null,
        description varchar(1024),
        display_name varchar(128),
        action_config longtext,
        owner varchar(32),
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_app_dependencies (
       application varchar(32) not null,
        idx integer not null,
        dependency varchar(32) not null,
        primary key (application, idx)
    ) engine=InnoDB;

    create table identityiq.spt_application (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        assigned_scope_path varchar(450),
        extended1 varchar(450),
        extended2 varchar(450),
        extended3 varchar(450),
        extended4 varchar(450),
        name varchar(128) not null,
        proxied_name varchar(128),
        app_cluster varchar(255),
        icon varchar(255),
        connector varchar(255),
        type varchar(255),
        features_string varchar(512),
        aggregation_types varchar(128),
        profile_class varchar(255),
        authentication_resource bit,
        case_insensitive bit,
        authoritative bit,
        maintenance_expiration bigint,
        logical bit,
        supports_provisioning bit,
        supports_authenticate bit,
        supports_account_only bit,
        supports_additional_accounts bit,
        no_aggregation bit,
        sync_provisioning bit,
        attributes longtext,
        templates longtext,
        provisioning_forms longtext,
        provisioning_config longtext,
        manages_other_apps bit not null,
        managed_attr_customize_rule varchar(32),
        owner varchar(32),
        assigned_scope varchar(32),
        proxy varchar(32),
        correlation_rule varchar(32),
        creation_rule varchar(32),
        manager_correlation_rule varchar(32),
        customization_rule varchar(32),
        account_correlation_config varchar(32),
        scorecard varchar(32),
        target_source varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_application_remediators (
       application varchar(32) not null,
        idx integer not null,
        elt varchar(32) not null,
        primary key (application, idx)
    ) engine=InnoDB;

    create table identityiq.spt_application_activity (
       id varchar(32) not null,
        time_stamp bigint,
        source_application varchar(128),
        action varchar(255),
        result varchar(255),
        data_source varchar(128),
        instance varchar(128),
        username varchar(128),
        target varchar(128),
        info varchar(512),
        identity_id varchar(128),
        identity_name varchar(128),
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_application_schema (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128),
        object_type varchar(255),
        aggregation_type varchar(128),
        native_object_type varchar(255),
        identity_attribute varchar(255),
        display_attribute varchar(255),
        instance_attribute varchar(255),
        description_attribute varchar(255),
        group_attribute varchar(255),
        hierarchy_attribute varchar(255),
        reference_attribute varchar(255),
        include_permissions bit,
        index_permissions bit,
        child_hierarchy bit,
        perm_remed_mod_type varchar(255),
        cloud_access_mgmt_type varchar(255),
        config longtext,
        features_string varchar(512),
        association_schema_name varchar(255),
        creation_rule varchar(32),
        customization_rule varchar(32),
        correlation_rule varchar(32),
        refresh_rule varchar(32),
        application varchar(32),
        idx integer,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_application_scorecard (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        assigned_scope_path varchar(450),
        incomplete bit,
        composite_score integer,
        attributes longtext,
        items longtext,
        application_id varchar(32),
        owner varchar(32),
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_app_secondary_owners (
       application varchar(32) not null,
        idx integer not null,
        elt varchar(32) not null,
        primary key (application, idx)
    ) engine=InnoDB;

    create table identityiq.spt_arch_cert_item_apps (
       arch_cert_item_id varchar(32) not null,
        idx integer not null,
        application_name varchar(255),
        primary key (arch_cert_item_id, idx)
    ) engine=InnoDB;

    create table identityiq.spt_attachment (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        assigned_scope_path varchar(450),
        name varchar(256),
        description varchar(256),
        content longblob,
        owner varchar(32),
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_audit_config (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        assigned_scope_path varchar(450),
        name varchar(128) not null,
        disabled bit,
        classes longtext,
        resources longtext,
        attributes longtext,
        actions longtext,
        owner varchar(32),
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_audit_event (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        assigned_scope_path varchar(450),
        interface varchar(128),
        source varchar(128),
        action varchar(128),
        target varchar(255),
        application varchar(128),
        account_name varchar(256),
        instance varchar(128),
        attribute_name varchar(128),
        attribute_value varchar(450),
        tracking_id varchar(128),
        attributes longtext,
        string1 varchar(450),
        string2 varchar(450),
        string3 varchar(450),
        string4 varchar(450),
        server_host varchar(128),
        client_host varchar(128),
        owner varchar(32),
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_authentication_answer (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        identity_id varchar(32),
        question_id varchar(32),
        answer varchar(512),
        owner varchar(32),
        idx integer,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_authentication_question (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        assigned_scope_path varchar(450),
        question varchar(1024),
        owner varchar(32),
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_batch_request (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        assigned_scope_path varchar(450),
        file_name varchar(255),
        header varchar(4000),
        run_date bigint,
        completed_date bigint,
        record_count integer,
        completed_count integer,
        error_count integer,
        invalid_count integer,
        message varchar(4000),
        error_message longtext,
        file_contents longtext,
        status varchar(255),
        run_config longtext,
        owner varchar(32),
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_batch_request_item (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        assigned_scope_path varchar(450),
        request_data varchar(4000),
        status varchar(255),
        message varchar(4000),
        error_message longtext,
        result varchar(255),
        identity_request_id varchar(255),
        target_identity_id varchar(255),
        batch_request_id varchar(32),
        owner varchar(32),
        assigned_scope varchar(32),
        idx integer,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_bulk_id_join (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        join_id varchar(128),
        join_property varchar(128),
        user_id varchar(128),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_bundle (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        assigned_scope_path varchar(450),
        extended1 varchar(450),
        extended2 varchar(450),
        extended3 varchar(450),
        extended4 varchar(450),
        name varchar(128) not null,
        display_name varchar(128),
        displayable_name varchar(128),
        disabled bit,
        risk_score_weight integer,
        activity_config longtext,
        mining_statistics longtext,
        attributes longtext,
        type varchar(128),
        selector longtext,
        provisioning_plan longtext,
        templates longtext,
        provisioning_forms longtext,
        or_profiles bit,
        activation_date bigint,
        deactivation_date bigint,
        pending_delete bit,
        iiq_elevated_access bit not null,
        owner varchar(32),
        assigned_scope varchar(32),
        join_rule varchar(32),
        pending_workflow varchar(32),
        role_index varchar(32),
        scorecard varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_bundle_archive (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        assigned_scope_path varchar(450),
        name varchar(128),
        source_id varchar(128),
        version integer,
        creator varchar(128),
        archive longtext,
        owner varchar(32),
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_bundle_children (
       bundle varchar(32) not null,
        idx integer not null,
        child varchar(32) not null,
        primary key (bundle, idx)
    ) engine=InnoDB;

    create table identityiq.spt_bundle_permits (
       bundle varchar(32) not null,
        idx integer not null,
        child varchar(32) not null,
        primary key (bundle, idx)
    ) engine=InnoDB;

    create table identityiq.spt_bundle_profile_relation (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        bundle_id varchar(32),
        source_bundle_id varchar(32),
        source_profile_id varchar(32),
        source_application varchar(32),
        type varchar(255),
        attribute varchar(322),
        value varchar(450),
        display_value varchar(450),
        required bit,
        permitted bit,
        or_member bit,
        inherited bit,
        attributes longtext,
        app_status varchar(255),
        hash varchar(128),
        hash_code integer,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_bundle_profile_relation_object (
       id varchar(32) not null,
        modified_id varchar(1024) not null,
        type varchar(255) not null,
        created bigint,
        modified bigint,
        hash_code integer,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_bundle_profile_relation_step (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        bundle_profile_relation_id varchar(32),
        step_type varchar(255),
        bundle_id varchar(32),
        idx integer,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_bundle_requirements (
       bundle varchar(32) not null,
        idx integer not null,
        child varchar(32) not null,
        primary key (bundle, idx)
    ) engine=InnoDB;

    create table identityiq.spt_capability (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        assigned_scope_path varchar(450),
        name varchar(128) not null,
        description varchar(1024),
        display_name varchar(128),
        applies_to_analyzer bit,
        owner varchar(32),
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_capability_children (
       capability_id varchar(32) not null,
        idx integer not null,
        child_id varchar(32) not null,
        primary key (capability_id, idx)
    ) engine=InnoDB;

    create table identityiq.spt_capability_rights (
       capability_id varchar(32) not null,
        idx integer not null,
        right_id varchar(32) not null,
        primary key (capability_id, idx)
    ) engine=InnoDB;

    create table identityiq.spt_category (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        assigned_scope_path varchar(450),
        name varchar(128) not null,
        targets longtext,
        owner varchar(32),
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_cert_action_assoc (
       parent_id varchar(32) not null,
        idx integer not null,
        child_id varchar(32) not null,
        primary key (parent_id, idx)
    ) engine=InnoDB;

    create table identityiq.spt_certification (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        assigned_scope_path varchar(450),
        attributes longtext,
        iiqlock varchar(128),
        name varchar(256),
        short_name varchar(255),
        description varchar(1024),
        creator varchar(255),
        complete bit,
        complete_hierarchy bit,
        signed bigint,
        approver_rule varchar(512),
        finished bigint,
        expiration bigint,
        automatic_closing_date bigint,
        application_id varchar(255),
        manager varchar(255),
        group_definition varchar(512),
        group_definition_id varchar(128),
        group_definition_name varchar(255),
        comments longtext,
        error longtext,
        entities_to_refresh longtext,
        commands longtext,
        activated bigint,
        total_entities integer,
        excluded_entities integer,
        completed_entities integer,
        delegated_entities integer,
        percent_complete integer,
        certified_entities integer,
        cert_req_entities integer,
        overdue_entities integer,
        total_items integer,
        excluded_items integer,
        completed_items integer,
        delegated_items integer,
        item_percent_complete integer,
        certified_items integer,
        cert_req_items integer,
        overdue_items integer,
        remediations_kicked_off integer,
        remediations_completed integer,
        total_violations integer not null,
        violations_allowed integer not null,
        violations_remediated integer not null,
        violations_acknowledged integer not null,
        total_roles integer not null,
        roles_approved integer not null,
        roles_allowed integer not null,
        roles_remediated integer not null,
        total_exceptions integer not null,
        exceptions_approved integer not null,
        exceptions_allowed integer not null,
        exceptions_remediated integer not null,
        total_grp_perms integer not null,
        grp_perms_approved integer not null,
        grp_perms_remediated integer not null,
        total_grp_memberships integer not null,
        grp_memberships_approved integer not null,
        grp_memberships_remediated integer not null,
        total_accounts integer not null,
        accounts_approved integer not null,
        accounts_allowed integer not null,
        accounts_remediated integer not null,
        total_profiles integer not null,
        profiles_approved integer not null,
        profiles_remediated integer not null,
        total_scopes integer not null,
        scopes_approved integer not null,
        scopes_remediated integer not null,
        total_capabilities integer not null,
        capabilities_approved integer not null,
        capabilities_remediated integer not null,
        total_permits integer not null,
        permits_approved integer not null,
        permits_remediated integer not null,
        total_requirements integer not null,
        requirements_approved integer not null,
        requirements_remediated integer not null,
        total_hierarchies integer not null,
        hierarchies_approved integer not null,
        hierarchies_remediated integer not null,
        type varchar(255),
        task_schedule_id varchar(255),
        trigger_id varchar(128),
        certification_definition_id varchar(128),
        phase varchar(255),
        next_phase_transition bigint,
        phase_config longtext,
        process_revokes_immediately bit,
        next_remediation_scan bigint,
        entitlement_granularity varchar(255),
        bulk_reassignment bit,
        continuous bit,
        continuous_config longtext,
        next_cert_required_scan bigint,
        next_overdue_scan bigint,
        exclude_inactive bit,
        immutable bit,
        electronically_signed bit,
        self_cert_reassignment bit,
        owner varchar(32),
        assigned_scope varchar(32),
        parent varchar(32),
        idx integer,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_certification_def_tags (
       cert_def_id varchar(32) not null,
        idx integer not null,
        elt varchar(32) not null,
        primary key (cert_def_id, idx)
    ) engine=InnoDB;

    create table identityiq.spt_certification_groups (
       certification_id varchar(32) not null,
        idx integer not null,
        group_id varchar(32) not null,
        primary key (certification_id, idx)
    ) engine=InnoDB;

    create table identityiq.spt_certification_tags (
       certification_id varchar(32) not null,
        idx integer not null,
        elt varchar(32) not null,
        primary key (certification_id, idx)
    ) engine=InnoDB;

    create table identityiq.spt_certification_action (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        assigned_scope_path varchar(450),
        owner_name varchar(255),
        email_template varchar(255),
        comments longtext,
        expiration datetime(6),
        work_item varchar(255),
        completion_state varchar(255),
        completion_comments longtext,
        completion_user varchar(128),
        actor_name varchar(128),
        actor_display_name varchar(128),
        acting_work_item varchar(255),
        description varchar(1024),
        status varchar(255),
        decision_date bigint,
        decision_certification_id varchar(128),
        reviewed bit,
        bulk_certified bit,
        mitigation_expiration bigint,
        remediation_action varchar(255),
        remediation_details longtext,
        additional_actions longtext,
        revoke_account bit,
        ready_for_remediation bit,
        remediation_kicked_off bit,
        remediation_completed bit,
        auto_decision bit,
        owner varchar(32),
        assigned_scope varchar(32),
        source_action varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_certification_archive (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        assigned_scope_path varchar(450),
        name varchar(256),
        certification_id varchar(255),
        certification_group_id varchar(255),
        signed bigint,
        expiration bigint,
        creator varchar(128),
        comments longtext,
        archive longtext,
        immutable bit,
        owner varchar(32),
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_certification_challenge (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        assigned_scope_path varchar(450),
        owner_name varchar(255),
        email_template varchar(255),
        comments longtext,
        expiration datetime(6),
        work_item varchar(255),
        completion_state varchar(255),
        completion_comments longtext,
        completion_user varchar(128),
        actor_name varchar(128),
        actor_display_name varchar(128),
        acting_work_item varchar(255),
        description varchar(1024),
        challenged bit,
        decision varchar(255),
        decision_comments longtext,
        decider_name varchar(255),
        challenge_decision_expired bit,
        owner varchar(32),
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_certification_definition (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        assigned_scope_path varchar(450),
        name varchar(255) not null,
        description varchar(1024),
        attributes longtext,
        owner varchar(32),
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_certification_delegation (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        assigned_scope_path varchar(450),
        owner_name varchar(255),
        email_template varchar(255),
        comments longtext,
        expiration datetime(6),
        work_item varchar(255),
        completion_state varchar(255),
        completion_comments longtext,
        completion_user varchar(128),
        actor_name varchar(128),
        actor_display_name varchar(128),
        acting_work_item varchar(255),
        description varchar(1024),
        review_required bit,
        revoked bit,
        owner varchar(32),
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_certification_entity (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        assigned_scope_path varchar(450),
        completed bigint,
        summary_status varchar(255),
        continuous_state varchar(255),
        last_decision bigint,
        next_continuous_state_change bigint,
        overdue_date bigint,
        has_differences bit,
        action_required bit,
        target_display_name varchar(255),
        target_name varchar(255),
        target_id varchar(255),
        custom1 varchar(450),
        custom2 varchar(450),
        custom_map longtext,
        owner varchar(32),
        assigned_scope varchar(32),
        action varchar(32),
        delegation varchar(32),
        type varchar(255),
        bulk_certified bit,
        attributes longtext,
        identity_id varchar(450),
        firstname varchar(255),
        lastname varchar(255),
        composite_score integer,
        snapshot_id varchar(255),
        differences longtext,
        new_user bit,
        account_group varchar(450),
        application varchar(255),
        native_identity varchar(322),
        reference_attribute varchar(255),
        schema_object_type varchar(255),
        certification_id varchar(32),
        pending_certification varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_certification_group (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        assigned_scope_path varchar(450),
        name varchar(256),
        type varchar(255),
        status varchar(255),
        attributes longtext,
        total_certifications integer,
        percent_complete integer,
        completed_certifications integer,
        certification_definition varchar(32),
        messages longtext,
        owner varchar(32),
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_certification_item (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        assigned_scope_path varchar(450),
        completed bigint,
        summary_status varchar(255),
        continuous_state varchar(255),
        last_decision bigint,
        next_continuous_state_change bigint,
        overdue_date bigint,
        has_differences bit,
        action_required bit,
        target_display_name varchar(255),
        target_name varchar(255),
        target_id varchar(255),
        custom1 varchar(450),
        custom2 varchar(450),
        custom_map longtext,
        owner varchar(32),
        assigned_scope varchar(32),
        action varchar(32),
        delegation varchar(32),
        bundle varchar(255),
        type varchar(255),
        sub_type varchar(255),
        bundle_assignment_id varchar(128),
        certification_entity_id varchar(32),
        needs_refresh bit,
        exception_application varchar(128),
        exception_attribute_name varchar(255),
        exception_attribute_value varchar(2048),
        exception_permission_target varchar(255),
        exception_permission_right varchar(255),
        policy_violation longtext,
        violation_summary varchar(256),
        wake_up_date bigint,
        reminders_sent integer,
        needs_continuous_flush bit,
        phase varchar(255),
        next_phase_transition bigint,
        finished_date bigint,
        recommend_value varchar(100),
        iiq_elevated_access bit,
        attributes longtext,
        extended1 varchar(450),
        extended2 varchar(450),
        extended3 varchar(450),
        extended4 varchar(450),
        extended5 varchar(450),
        exception_entitlements varchar(32),
        challenge varchar(32),
        idx integer,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_certifiers (
       certification_id varchar(32) not null,
        idx integer not null,
        certifier varchar(255),
        primary key (certification_id, idx)
    ) engine=InnoDB;

    create table identityiq.spt_cert_item_applications (
       certification_item_id varchar(32) not null,
        idx integer not null,
        application_name varchar(255),
        primary key (certification_item_id, idx)
    ) engine=InnoDB;

    create table identityiq.spt_cert_item_classifications (
       certification_item varchar(32),
        classification_name varchar(255)
    ) engine=InnoDB;

    create table identityiq.spt_child_certification_ids (
       certification_archive_id varchar(32) not null,
        idx integer not null,
        child_id varchar(255),
        primary key (certification_archive_id, idx)
    ) engine=InnoDB;

    create table identityiq.spt_classification (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        name varchar(128) not null,
        display_name varchar(128),
        displayable_name varchar(128),
        attributes longtext,
        origin varchar(128),
        type varchar(128),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_cloud_access3way (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        cloud_access_group varchar(32),
        cloud_access_role varchar(32),
        cloud_access_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_cloud_access_group (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        name varchar(450) not null,
        uri varchar(450),
        display_name varchar(450),
        cloud_type varchar(80),
        event_time_stamp bigint,
        application_id varchar(32),
        object_type varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_cloud_access_role (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        name varchar(450) not null,
        uri varchar(450),
        display_name varchar(450),
        cloud_type varchar(80),
        event_time_stamp bigint,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_cloud_access_scope (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        name varchar(450) not null,
        uri varchar(450),
        display_name varchar(450),
        cloud_type varchar(80),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_configuration (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        assigned_scope_path varchar(450),
        name varchar(128) not null,
        description varchar(1024),
        attributes longtext,
        owner varchar(32),
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_correlation_config (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        assigned_scope_path varchar(450),
        name varchar(128) not null,
        description varchar(256),
        attribute_assignments longtext,
        direct_assignments longtext,
        owner varchar(32),
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_custom (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        assigned_scope_path varchar(450),
        name varchar(128),
        description varchar(1024),
        attributes longtext,
        owner varchar(32),
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_database_version (
       name varchar(255) not null,
        system_version varchar(128),
        schema_version varchar(128),
        primary key (name)
    ) engine=InnoDB;

    create table identityiq.spt_deleted_object (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope_path varchar(450),
        uuid varchar(128),
        name varchar(128),
        native_identity varchar(322) not null,
        last_refresh bigint,
        object_type varchar(128),
        application varchar(32),
        attributes longtext,
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_dictionary (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        assigned_scope_path varchar(450),
        name varchar(128),
        owner varchar(32),
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_dictionary_term (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        assigned_scope_path varchar(450),
        value varchar(128) not null,
        dictionary_id varchar(32),
        owner varchar(32),
        assigned_scope varchar(32),
        idx integer,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_dynamic_scope (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        assigned_scope_path varchar(450),
        name varchar(128) not null,
        description varchar(1024),
        selector longtext,
        allow_all bit,
        population_request_authority longtext,
        managed_attr_request_control varchar(32),
        managed_attr_remove_control varchar(32),
        owner varchar(32),
        assigned_scope varchar(32),
        role_request_control varchar(32),
        application_request_control varchar(32),
        role_remove_control varchar(32),
        application_remove_control varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_dynamic_scope_exclusions (
       dynamic_scope_id varchar(32) not null,
        idx integer not null,
        identity_id varchar(32) not null,
        primary key (dynamic_scope_id, idx)
    ) engine=InnoDB;

    create table identityiq.spt_dynamic_scope_inclusions (
       dynamic_scope_id varchar(32) not null,
        idx integer not null,
        identity_id varchar(32) not null,
        primary key (dynamic_scope_id, idx)
    ) engine=InnoDB;

    create table identityiq.spt_email_template (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        assigned_scope_path varchar(450),
        name varchar(128) not null,
        description varchar(1024),
        from_address varchar(255),
        to_address varchar(255),
        cc_address varchar(255),
        bcc_address varchar(255),
        subject varchar(255),
        body longtext,
        signature longtext,
        owner varchar(32),
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_email_template_properties (
       id varchar(32) not null,
        name varchar(78) not null,
        value varchar(255),
        primary key (id, name)
    ) engine=InnoDB;

    create table identityiq.spt_entitlement_group (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        assigned_scope_path varchar(450),
        name varchar(128),
        application varchar(32),
        instance varchar(128),
        native_identity varchar(322),
        display_name varchar(128),
        account_only bit not null,
        attributes longtext,
        owner varchar(32),
        assigned_scope varchar(32),
        identity_id varchar(32),
        idx integer,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_entitlement_snapshot (
       id varchar(32) not null,
        application varchar(255),
        instance varchar(128),
        native_identity varchar(322),
        display_name varchar(450),
        account_only bit not null,
        attributes longtext,
        certification_item_id varchar(32),
        idx integer,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_file_bucket (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        assigned_scope_path varchar(450),
        file_index integer,
        parent_id varchar(32),
        data longblob,
        owner varchar(32),
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_form (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        assigned_scope_path varchar(450),
        name varchar(128) not null,
        description varchar(4000),
        hidden bit,
        type varchar(255),
        application varchar(32),
        sections longtext,
        buttons longtext,
        attributes longtext,
        owner varchar(32),
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_full_text_index (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        name varchar(128) not null,
        description varchar(1024),
        iiqlock varchar(128),
        last_refresh bigint,
        attributes longtext,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_generic_constraint (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        assigned_scope_path varchar(450),
        name varchar(2000),
        description varchar(4000),
        violation_owner_type varchar(255),
        compensating_control longtext,
        disabled bit,
        weight integer,
        remediation_advice longtext,
        violation_summary longtext,
        arguments longtext,
        selectors longtext,
        owner varchar(32),
        assigned_scope varchar(32),
        policy varchar(32),
        violation_owner varchar(32),
        violation_owner_rule varchar(32),
        idx integer,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_group_definition (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        assigned_scope_path varchar(450),
        name varchar(255),
        description varchar(1024),
        filter longtext,
        last_refresh bigint,
        null_group bit,
        indexed bit,
        private bit,
        factory varchar(32),
        group_index varchar(32),
        owner varchar(32),
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_group_factory (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        assigned_scope_path varchar(450),
        name varchar(255),
        description varchar(1024),
        factory_attribute varchar(255),
        enabled bit,
        last_refresh bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        group_owner_rule varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_group_index (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        assigned_scope_path varchar(450),
        incomplete bit,
        composite_score integer,
        attributes longtext,
        items longtext,
        business_role_score integer,
        raw_business_role_score integer,
        entitlement_score integer,
        raw_entitlement_score integer,
        policy_score integer,
        raw_policy_score integer,
        certification_score integer,
        total_violations integer,
        total_remediations integer,
        total_delegations integer,
        total_mitigations integer,
        total_approvals integer,
        definition varchar(32),
        name varchar(255),
        member_count integer,
        band_count integer,
        band1 integer,
        band2 integer,
        band3 integer,
        band4 integer,
        band5 integer,
        band6 integer,
        band7 integer,
        band8 integer,
        band9 integer,
        band10 integer,
        certifications_due integer,
        certifications_on_time integer,
        owner varchar(32),
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_group_permissions (
       entitlement_group_id varchar(32) not null,
        idx integer not null,
        target varchar(255),
        annotation varchar(255),
        rights varchar(4000),
        attributes longtext,
        primary key (entitlement_group_id, idx)
    ) engine=InnoDB;

    create table identityiq.spt_identity (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        assigned_scope_path varchar(450),
        extended1 varchar(450),
        extended2 varchar(450),
        extended3 varchar(450),
        extended4 varchar(450),
        extended5 varchar(450),
        extended6 varchar(450),
        extended7 varchar(450),
        extended8 varchar(450),
        extended9 varchar(450),
        extended10 varchar(450),
        name varchar(128) not null,
        description varchar(1024),
        protected bit,
        needs_refresh bit,
        iiqlock varchar(128),
        attributes longtext,
        display_name varchar(128),
        firstname varchar(128),
        lastname varchar(128),
        email varchar(128),
        manager_status bit,
        inactive bit,
        last_login bigint,
        last_refresh bigint,
        password varchar(450),
        password_expiration bigint,
        password_history varchar(2000),
        bundle_summary varchar(2000),
        assigned_role_summary varchar(2000),
        correlated bit,
        correlated_overridden bit,
        type varchar(128),
        software_version varchar(128),
        auth_lock_start bigint,
        failed_auth_question_attempts integer,
        failed_login_attempts integer,
        controls_assigned_scope bit,
        certifications longtext,
        activity_config longtext,
        preferences longtext,
        attribute_meta_data longtext,
        workgroup bit,
        owner varchar(32),
        assigned_scope varchar(32),
        extended_identity1 varchar(32),
        extended_identity2 varchar(32),
        extended_identity3 varchar(32),
        extended_identity4 varchar(32),
        extended_identity5 varchar(32),
        manager varchar(32),
        administrator varchar(32),
        scorecard varchar(32),
        uipreferences varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_identity_archive (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128),
        source_id varchar(128),
        version integer,
        creator varchar(128),
        archive longtext,
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_identity_assigned_roles (
       identity_id varchar(32) not null,
        idx integer not null,
        bundle varchar(32) not null,
        primary key (identity_id, idx)
    ) engine=InnoDB;

    create table identityiq.spt_identity_bundles (
       identity_id varchar(32) not null,
        idx integer not null,
        bundle varchar(32) not null,
        primary key (identity_id, idx)
    ) engine=InnoDB;

    create table identityiq.spt_identity_capabilities (
       identity_id varchar(32) not null,
        idx integer not null,
        capability_id varchar(32) not null,
        primary key (identity_id, idx)
    ) engine=InnoDB;

    create table identityiq.spt_identity_controlled_scopes (
       identity_id varchar(32) not null,
        idx integer not null,
        scope_id varchar(32) not null,
        primary key (identity_id, idx)
    ) engine=InnoDB;

    create table identityiq.spt_identity_entitlement (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        start_date bigint,
        end_date bigint,
        attributes longtext,
        name varchar(255),
        value varchar(450),
        annotation varchar(450),
        display_name varchar(255),
        native_identity varchar(450),
        instance varchar(128),
        application varchar(32),
        identity_id varchar(32) not null,
        aggregation_state varchar(255),
        source varchar(64),
        assigned bit,
        allowed bit,
        granted_by_role bit,
        assigner varchar(128),
        assignment_id varchar(64),
        assignment_note varchar(1024),
        type varchar(255),
        request_item varchar(32),
        pending_request_item varchar(32),
        certification_item varchar(32),
        pending_certification_item varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_identity_external_attr (
       id varchar(32) not null,
        object_id varchar(64),
        attribute_name varchar(64),
        value varchar(322),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_identity_history_item (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        identity_id varchar(32),
        type varchar(255),
        certifiable_descriptor longtext,
        action longtext,
        certification_link longtext,
        comments longtext,
        certification_type varchar(255),
        status varchar(255),
        actor varchar(128),
        entry_date bigint,
        application varchar(128),
        instance varchar(128),
        account varchar(128),
        native_identity varchar(322),
        attribute varchar(450),
        value varchar(450),
        policy varchar(255),
        constraint_name varchar(2000),
        role varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_identity_request (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope_path varchar(450),
        name varchar(255),
        state varchar(255),
        type varchar(255),
        source varchar(255),
        target_id varchar(128),
        target_display_name varchar(255),
        target_class varchar(255),
        requester_display_name varchar(255),
        requester_id varchar(128),
        end_date bigint,
        verified bigint,
        priority varchar(128),
        completion_status varchar(128),
        execution_status varchar(128),
        has_messages bit not null,
        external_ticket_id varchar(128),
        attributes longtext,
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_identity_request_item (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        start_date bigint,
        end_date bigint,
        attributes longtext,
        name varchar(255),
        value varchar(450),
        annotation varchar(450),
        display_name varchar(255),
        native_identity varchar(450),
        instance varchar(128),
        application varchar(255),
        owner_name varchar(128),
        approver_name varchar(128),
        operation varchar(128),
        retries integer,
        provisioning_engine varchar(255),
        approval_state varchar(128),
        provisioning_state varchar(128),
        compilation_status varchar(128),
        expansion_cause varchar(128),
        identity_request_id varchar(32),
        idx integer,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_identity_role_metadata (
       identity_id varchar(32) not null,
        idx integer not null,
        role_metadata_id varchar(32) not null,
        primary key (identity_id, idx)
    ) engine=InnoDB;

    create table identityiq.spt_identity_snapshot (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128),
        identity_id varchar(255),
        identity_name varchar(255),
        summary varchar(2000),
        differences varchar(2000),
        applications varchar(2000),
        scorecard longtext,
        attributes longtext,
        bundles longtext,
        exceptions longtext,
        links longtext,
        violations longtext,
        assigned_roles longtext,
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_identity_trigger (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope_path varchar(450),
        name varchar(256),
        description varchar(1024),
        disabled bit,
        type varchar(255),
        rule_id varchar(32),
        attribute_name varchar(256),
        old_value_filter varchar(256),
        new_value_filter varchar(256),
        selector longtext,
        handler varchar(256),
        parameters longtext,
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_identity_workgroups (
       identity_id varchar(32) not null,
        idx integer not null,
        workgroup varchar(32) not null,
        primary key (identity_id, idx)
    ) engine=InnoDB;

    create table identityiq.spt_integration_config (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null,
        description varchar(4000),
        executor varchar(255),
        exec_style varchar(255),
        role_sync_style varchar(255),
        template bit,
        maintenance_expiration bigint,
        signature longtext,
        attributes longtext,
        resources longtext,
        application_id varchar(32),
        role_sync_filter longtext,
        container_id varchar(32),
        assigned_scope varchar(32),
        plan_initializer varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_jasper_files (
       result varchar(32) not null,
        idx integer not null,
        elt varchar(32) not null,
        primary key (result, idx)
    ) engine=InnoDB;

    create table identityiq.spt_jasper_page_bucket (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope_path varchar(450),
        bucket_number integer,
        handler_id varchar(128),
        xml longtext,
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_jasper_result (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope_path varchar(450),
        handler_id varchar(128),
        print_xml longtext,
        page_count integer,
        pages_per_bucket integer,
        handler_page_count integer,
        attributes longtext,
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_jasper_template (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null,
        design_xml longtext,
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_link (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope_path varchar(450),
        key1 varchar(450),
        key2 varchar(255),
        key3 varchar(255),
        key4 varchar(255),
        extended1 varchar(450),
        extended2 varchar(450),
        extended3 varchar(450),
        extended4 varchar(450),
        extended5 varchar(450),
        uuid varchar(128),
        display_name varchar(128),
        instance varchar(128),
        native_identity varchar(322) not null,
        last_refresh bigint,
        last_target_aggregation bigint,
        manually_correlated bit,
        entitlements bit not null,
        identity_id varchar(32),
        application varchar(32),
        iiq_disabled bit,
        iiq_locked bit,
        attributes longtext,
        password_history varchar(2000),
        component_ids varchar(256),
        attribute_meta_data longtext,
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_link_external_attr (
       id varchar(32) not null,
        object_id varchar(64),
        attribute_name varchar(64),
        value varchar(322),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_localized_attribute (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        name varchar(255),
        locale varchar(128),
        attribute varchar(128),
        value varchar(1024),
        target_class varchar(255),
        target_name varchar(255),
        target_id varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_managed_attribute (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope_path varchar(450),
        extended1 varchar(450),
        extended2 varchar(450),
        extended3 varchar(450),
        purview varchar(128),
        application varchar(32),
        type varchar(255),
        aggregated bit,
        attribute varchar(322),
        value varchar(450),
        hash varchar(128) not null,
        display_name varchar(450),
        displayable_name varchar(450),
        uuid varchar(128),
        attributes longtext,
        requestable bit,
        uncorrelated bit,
        last_refresh bigint,
        last_target_aggregation bigint,
        key1 varchar(128),
        key2 varchar(128),
        key3 varchar(128),
        key4 varchar(128),
        iiq_elevated_access bit not null,
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_managed_attr_inheritance (
       managedattribute varchar(32) not null,
        idx integer not null,
        inherits_from varchar(32) not null,
        primary key (managedattribute, idx)
    ) engine=InnoDB;

    create table identityiq.spt_managed_attr_perms (
       managedattribute varchar(32) not null,
        idx integer not null,
        target varchar(255),
        rights varchar(4000),
        annotation varchar(255),
        attributes longtext,
        primary key (managedattribute, idx)
    ) engine=InnoDB;

    create table identityiq.spt_managed_attr_target_perms (
       managedattribute varchar(32) not null,
        idx integer not null,
        target varchar(255),
        rights varchar(4000),
        annotation varchar(255),
        attributes longtext,
        primary key (managedattribute, idx)
    ) engine=InnoDB;

    create table identityiq.spt_message_template (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null,
        description varchar(1024),
        text longtext,
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_mining_config (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null,
        description varchar(1024),
        arguments longtext,
        app_constraints longtext,
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_mitigation_expiration (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope_path varchar(450),
        expiration bigint not null,
        mitigator varchar(32) not null,
        comments longtext,
        identity_id varchar(32),
        certification_link longtext,
        certifiable_descriptor longtext,
        action varchar(255),
        action_parameters longtext,
        last_action_date bigint,
        role_name varchar(128),
        policy varchar(128),
        constraint_name varchar(2000),
        application varchar(128),
        instance varchar(128),
        native_identity varchar(322),
        account_display_name varchar(128),
        attribute_name varchar(450),
        attribute_value varchar(450),
        permission bit,
        assigned_scope varchar(32),
        idx integer,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_module (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        name varchar(128) not null,
        description varchar(512),
        attributes longtext,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_monitoring_statistic (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null,
        display_name varchar(128),
        description varchar(1024),
        value varchar(4000),
        value_type varchar(128),
        type varchar(128),
        attributes longtext,
        template bit,
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_monitoring_statistic_tags (
       statistic_id varchar(32) not null,
        elt varchar(32) not null
    ) engine=InnoDB;

    create table identityiq.spt_native_identity_change_event (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        launched bigint,
        type varchar(255),
        identity_id varchar(255),
        link_id varchar(255),
        managed_attribute_id varchar(255),
        old_native_identity varchar(322),
        new_native_identity varchar(322),
        uuid varchar(255),
        application_id varchar(255),
        instance varchar(128),
        status varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_object_classification (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner_id varchar(32),
        owner_type varchar(128),
        source varchar(128),
        effective bit,
        classification_id varchar(32) not null,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_object_config (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null,
        object_attributes longtext,
        config_attributes longtext,
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_partition_result (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope_path varchar(450),
        stack longtext,
        attributes longtext,
        launcher varchar(255),
        host varchar(255),
        launched bigint,
        progress varchar(255),
        percent_complete integer,
        type varchar(255),
        messages longtext,
        completed bigint,
        name varchar(255) not null,
        task_terminated bit,
        completion_status varchar(255),
        assigned_scope varchar(32),
        task_result varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_password_policy (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        name varchar(128) not null,
        description varchar(512),
        password_constraints longtext,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_password_policy_holder (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        policy varchar(32),
        selector longtext,
        application varchar(32),
        idx integer,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_persisted_file (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope_path varchar(450),
        name varchar(256),
        description varchar(1024),
        content_type varchar(128),
        content_length bigint,
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_plugin (
       id varchar(32) not null,
        name varchar(255),
        created bigint,
        modified bigint,
        install_date bigint,
        display_name varchar(255),
        version varchar(255),
        disabled bit,
        right_required varchar(255),
        min_system_version varchar(255),
        max_system_version varchar(255),
        attributes longtext,
        position integer,
        certification_level varchar(255),
        file_id varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_policy (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null,
        template bit,
        type varchar(255),
        type_key varchar(255),
        executor varchar(255),
        config_page varchar(255),
        certification_actions varchar(255),
        violation_owner_type varchar(255),
        violation_owner varchar(32),
        state varchar(255),
        arguments longtext,
        signature longtext,
        alert longtext,
        assigned_scope varchar(32),
        violation_owner_rule varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_policy_violation (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope_path varchar(450),
        name varchar(2000),
        description varchar(4000),
        identity_id varchar(32),
        renderer varchar(255),
        active bit,
        policy_id varchar(255),
        policy_name varchar(255),
        constraint_id varchar(255),
        status varchar(255),
        constraint_name varchar(2000),
        left_bundles longtext,
        right_bundles longtext,
        activity_id varchar(255),
        bundles_marked_for_remediation longtext,
        entitlements_marked_for_remed longtext,
        mitigator varchar(255),
        arguments longtext,
        assigned_scope varchar(32),
        pending_workflow varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_post_commit_notification_object (
       id varchar(32) not null,
        class_name varchar(1024) not null,
        modified_id varchar(1024) not null,
        type varchar(255) not null,
        created bigint,
        modified bigint,
        consumer varchar(256),
        committed_object_string longtext,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_process_log (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope_path varchar(450),
        process_name varchar(128),
        case_id varchar(128),
        workflow_case_name varchar(450),
        launcher varchar(128),
        case_status varchar(128),
        step_name varchar(128),
        approval_name varchar(128),
        owner_name varchar(128),
        start_time bigint,
        end_time bigint,
        step_duration integer,
        escalations integer,
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_profile (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128),
        description varchar(1024),
        bundle_id varchar(32),
        disabled bit,
        account_type varchar(128),
        application varchar(32),
        attributes longtext,
        assigned_scope varchar(32),
        idx integer,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_profile_constraints (
       profile varchar(32) not null,
        idx integer not null,
        elt longtext,
        primary key (profile, idx)
    ) engine=InnoDB;

    create table identityiq.spt_profile_permissions (
       profile varchar(32) not null,
        idx integer not null,
        target varchar(255),
        rights varchar(4000),
        attributes longtext,
        primary key (profile, idx)
    ) engine=InnoDB;

    create table identityiq.spt_provisioning_request (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope_path varchar(450),
        identity_id varchar(32),
        target varchar(128),
        requester varchar(128),
        expiration bigint,
        provisioning_plan longtext,
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_provisioning_transaction (
       id varchar(32) not null,
        name varchar(255),
        created bigint,
        modified bigint,
        operation varchar(255),
        source varchar(255),
        application_name varchar(255),
        identity_name varchar(255),
        identity_display_name varchar(255),
        native_identity varchar(322),
        account_display_name varchar(322),
        attributes longtext,
        integration varchar(255),
        certification_id varchar(32),
        forced bit,
        type varchar(255),
        status varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_quick_link (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null,
        message_key varchar(128),
        description varchar(1024),
        action varchar(128),
        css_class varchar(128),
        hidden bit,
        category varchar(128),
        ordering integer,
        arguments longtext,
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_quick_link_options (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        allow_bulk bit,
        allow_other bit,
        allow_self bit,
        options longtext,
        dynamic_scope varchar(32) not null,
        quick_link varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_recommender_definition (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        name varchar(128) not null,
        attributes longtext,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_remediation_item (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope_path varchar(450),
        description varchar(1024),
        remediation_entity_type varchar(255),
        work_item_id varchar(32),
        certification_item varchar(255),
        assignee varchar(32),
        remediation_identity varchar(255),
        remediation_details longtext,
        completion_comments longtext,
        completion_date bigint,
        assimilated bit,
        comments longtext,
        attributes longtext,
        assigned_scope varchar(32),
        idx integer,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_remote_login_token (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null,
        creator varchar(128) not null,
        remote_host varchar(128),
        expiration bigint,
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_request (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope_path varchar(450),
        stack longtext,
        attributes longtext,
        launcher varchar(255),
        host varchar(255),
        launched bigint,
        progress varchar(255),
        percent_complete integer,
        type varchar(255),
        messages longtext,
        completed bigint,
        expiration bigint,
        name varchar(450),
        phase integer,
        dependent_phase integer,
        next_launch bigint,
        retry_count integer,
        retry_interval integer,
        string1 varchar(2048),
        live bit,
        completion_status varchar(255),
        notification_needed bit,
        assigned_scope varchar(32),
        definition varchar(32),
        task_result varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_request_arguments (
       signature varchar(32) not null,
        idx integer not null,
        name varchar(255),
        type varchar(255),
        filter_string varchar(255),
        description longtext,
        prompt longtext,
        multi bit,
        required bit,
        primary key (signature, idx)
    ) engine=InnoDB;

    create table identityiq.spt_request_definition (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null,
        description varchar(4000),
        executor varchar(255),
        form_path varchar(128),
        template bit,
        hidden bit,
        result_expiration integer,
        progress_interval integer,
        sub_type varchar(128),
        type varchar(255),
        progress_mode varchar(255),
        arguments longtext,
        retry_max integer,
        retry_interval integer,
        sig_description longtext,
        return_type varchar(255),
        assigned_scope varchar(32),
        parent varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_request_definition_rights (
       request_definition_id varchar(32) not null,
        idx integer not null,
        right_id varchar(32) not null,
        primary key (request_definition_id, idx)
    ) engine=InnoDB;

    create table identityiq.spt_request_returns (
       signature varchar(32) not null,
        idx integer not null,
        name varchar(255),
        type varchar(255),
        filter_string varchar(255),
        description longtext,
        prompt longtext,
        multi bit,
        primary key (signature, idx)
    ) engine=InnoDB;

    create table identityiq.spt_request_state (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        name varchar(450),
        attributes longtext,
        request_id varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_resource_event (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        application varchar(32),
        provisioning_plan longtext,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_right_config (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null,
        rights longtext,
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_role_change_event (
       id varchar(32) not null,
        created bigint,
        bundle_id varchar(128),
        bundle_name varchar(128),
        provisioning_plan longtext,
        bundle_deleted bit,
        status varchar(255),
        skipped_identity_ids longtext,
        failed_identity_ids longtext,
        affected_identity_count integer,
        run_count integer,
        failed_attempts integer,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_role_index (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope_path varchar(450),
        incomplete bit,
        composite_score integer,
        attributes longtext,
        items longtext,
        bundle varchar(32),
        assigned_count integer,
        detected_count integer,
        associated_to_role bit,
        last_certified_membership bigint,
        last_certified_composition bigint,
        last_assigned bigint,
        entitlement_count integer,
        entitlement_count_inheritance integer,
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_role_metadata (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope_path varchar(450),
        role varchar(32),
        name varchar(255),
        additional_entitlements bit,
        missing_required bit,
        assigned bit,
        detected bit,
        detected_exception bit,
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_role_mining_result (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128),
        pending bit,
        config longtext,
        roles longtext,
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_role_scorecard (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope_path varchar(450),
        role_id varchar(32),
        members integer,
        members_extra_ent integer,
        members_missing_req integer,
        detected integer,
        detected_exc integer,
        provisioned_ent integer,
        permitted_ent integer,
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_rule (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null,
        description varchar(1024),
        language varchar(255),
        source longtext,
        type varchar(255),
        attributes longtext,
        sig_description longtext,
        return_type varchar(255),
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_rule_registry_callouts (
       rule_registry_id varchar(32) not null,
        callout varchar(78) not null,
        rule_id varchar(32) not null,
        primary key (rule_registry_id, callout)
    ) engine=InnoDB;

    create table identityiq.spt_rule_dependencies (
       rule_id varchar(32) not null,
        idx integer not null,
        dependency varchar(32) not null,
        primary key (rule_id, idx)
    ) engine=InnoDB;

    create table identityiq.spt_rule_registry (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null,
        templates longtext,
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_rule_signature_arguments (
       signature varchar(32) not null,
        idx integer not null,
        name varchar(255),
        type varchar(255),
        filter_string varchar(255),
        description longtext,
        prompt longtext,
        multi bit,
        primary key (signature, idx)
    ) engine=InnoDB;

    create table identityiq.spt_rule_signature_returns (
       signature varchar(32) not null,
        idx integer not null,
        name varchar(255),
        type varchar(255),
        filter_string varchar(255),
        description longtext,
        prompt longtext,
        multi bit,
        primary key (signature, idx)
    ) engine=InnoDB;

    create table identityiq.spt_samltoken (
       id varchar(128) not null,
        expiration bigint,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_schema_attributes (
       applicationschema varchar(32) not null,
        idx integer not null,
        name varchar(255),
        type varchar(255),
        description longtext,
        required bit,
        entitlement bit,
        is_group bit,
        managed bit,
        multi_valued bit,
        minable bit,
        indexed bit,
        correlation_key integer,
        source varchar(255),
        internal_name varchar(255),
        default_value varchar(255),
        remed_mod_type varchar(255),
        schema_object_type varchar(255),
        object_mapping varchar(255),
        primary key (applicationschema, idx)
    ) engine=InnoDB;

    create table identityiq.spt_scope (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null,
        display_name varchar(128),
        parent_id varchar(32),
        manually_created bit,
        dormant bit,
        path varchar(450),
        dirty bit,
        assigned_scope varchar(32),
        idx integer,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_scorecard (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        incomplete bit,
        composite_score integer,
        attributes longtext,
        items longtext,
        business_role_score integer,
        raw_business_role_score integer,
        entitlement_score integer,
        raw_entitlement_score integer,
        policy_score integer,
        raw_policy_score integer,
        certification_score integer,
        total_violations integer,
        total_remediations integer,
        total_delegations integer,
        total_mitigations integer,
        total_approvals integer,
        identity_id varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_score_config (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null,
        maximum_score integer,
        maximum_number_of_bands integer,
        application_configs longtext,
        identity_scores longtext,
        application_scores longtext,
        bands longtext,
        right_config varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_server (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        extended1 varchar(255),
        name varchar(128) not null,
        heartbeat bigint,
        inactive bit,
        attributes longtext,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_server_statistic (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        name varchar(128) not null,
        snapshot_name varchar(128),
        value varchar(4000),
        value_type varchar(128),
        host varchar(32),
        attributes longtext,
        target varchar(128),
        target_type varchar(128),
        monitoring_statistic varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_service_definition (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        name varchar(128) not null,
        description varchar(1024),
        executor varchar(255),
        exec_interval integer,
        hosts varchar(1024),
        iiqlock varchar(128),
        attributes longtext,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_service_lock (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        host varchar(255),
        locker varchar(255),
        last_start bigint,
        last_execute bigint,
        service_definition varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_service_status (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        name varchar(128) not null,
        description varchar(1024),
        definition varchar(32),
        host varchar(255),
        last_start bigint,
        last_end bigint,
        attributes longtext,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_sign_off_history (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        sign_date bigint,
        signer_id varchar(128),
        signer_name varchar(128),
        signer_display_name varchar(128),
        application varchar(128),
        account varchar(322),
        text longtext,
        electronic_sign bit,
        certification_id varchar(32),
        idx integer,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_snapshot_permissions (
       snapshot varchar(32) not null,
        idx integer not null,
        target varchar(255),
        rights varchar(4000),
        attributes longtext,
        primary key (snapshot, idx)
    ) engine=InnoDB;

    create table identityiq.spt_sodconstraint (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(2000),
        description varchar(4000),
        policy varchar(32),
        violation_owner_type varchar(255),
        violation_owner varchar(32),
        violation_owner_rule varchar(32),
        compensating_control longtext,
        disabled bit,
        weight integer,
        remediation_advice longtext,
        violation_summary longtext,
        arguments longtext,
        idx integer,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_sodconstraint_left (
       sodconstraint varchar(32) not null,
        idx integer not null,
        businessrole varchar(32) not null,
        primary key (sodconstraint, idx)
    ) engine=InnoDB;

    create table identityiq.spt_sodconstraint_right (
       sodconstraint varchar(32) not null,
        idx integer not null,
        businessrole varchar(32) not null,
        primary key (sodconstraint, idx)
    ) engine=InnoDB;

    create table identityiq.spt_archived_cert_entity (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        assigned_scope_path varchar(450),
        entity longtext,
        reason varchar(255),
        explanation longtext,
        certification_id varchar(32),
        target_name varchar(255),
        identity_name varchar(450),
        account_group varchar(450),
        application varchar(255),
        native_identity varchar(322),
        reference_attribute varchar(255),
        schema_object_type varchar(255),
        target_id varchar(255),
        target_display_name varchar(255),
        owner varchar(32),
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_archived_cert_item (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        assigned_scope_path varchar(450),
        type varchar(255),
        sub_type varchar(255),
        item_id varchar(128),
        exception_application varchar(128),
        exception_attribute_name varchar(255),
        exception_attribute_value varchar(2048),
        exception_permission_target varchar(255),
        exception_permission_right varchar(255),
        exception_native_identity varchar(322),
        constraint_name varchar(2000),
        policy varchar(256),
        bundle varchar(255),
        violation_summary varchar(256),
        entitlements longtext,
        parent_id varchar(32),
        target_display_name varchar(255),
        target_name varchar(255),
        target_id varchar(255),
        owner varchar(32),
        assigned_scope varchar(32),
        idx integer,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_identity_req_item_attach (
       identity_request_item_id varchar(32) not null,
        idx integer not null,
        attachment_id varchar(32) not null,
        primary key (identity_request_item_id, idx)
    ) engine=InnoDB;

    create table identityiq.spt_pending_req_attach (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        item_id varchar(128) not null,
        attachment_id varchar(128),
        type varchar(128) not null,
        requester_id varchar(128) not null,
        target_id varchar(128),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_right (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        assigned_scope_path varchar(450),
        name varchar(128) not null,
        description varchar(1024),
        display_name varchar(128),
        owner varchar(32),
        assigned_scope varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_sync_roles (
       config varchar(32) not null,
        idx integer not null,
        bundle varchar(32) not null,
        primary key (config, idx)
    ) engine=InnoDB;

    create table identityiq.spt_syslog_event (
       id varchar(32) not null,
        created bigint,
        quick_key varchar(12),
        event_level varchar(6),
        classname varchar(128),
        line_number varchar(6),
        message varchar(450),
        thread varchar(128),
        server varchar(128),
        username varchar(128),
        stacktrace longtext,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_tag (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_target (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        extended1 varchar(255),
        name varchar(512),
        native_owner_id varchar(128),
        application varchar(32),
        target_host varchar(1024),
        display_name varchar(400),
        full_path longtext,
        unique_name_hash varchar(128),
        attributes longtext,
        native_object_id varchar(322),
        target_size bigint,
        last_aggregation bigint,
        target_source varchar(32),
        parent varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_target_association (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        object_id varchar(32),
        type varchar(8),
        hierarchy varchar(512),
        flattened bit,
        application_name varchar(128),
        target_type varchar(128),
        target_name varchar(255),
        target_id varchar(32),
        rights varchar(512),
        inherited bit,
        effective integer,
        deny_permission bit,
        last_aggregation bigint,
        attributes longtext,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_target_source (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128),
        description varchar(1024),
        collector varchar(255),
        last_refresh bigint,
        configuration longtext,
        correlation_rule varchar(32),
        creation_rule varchar(32),
        refresh_rule varchar(32),
        transformation_rule varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_target_sources (
       application varchar(32) not null,
        idx integer not null,
        elt varchar(32) not null,
        primary key (application, idx)
    ) engine=InnoDB;

    create table identityiq.spt_task_definition (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null,
        description varchar(4000),
        executor varchar(255),
        form_path varchar(128),
        template bit,
        hidden bit,
        result_expiration integer,
        progress_interval integer,
        sub_type varchar(128),
        type varchar(255),
        progress_mode varchar(255),
        arguments longtext,
        result_renderer varchar(255),
        concurrent bit,
        deprecated bit not null,
        result_action varchar(255),
        sig_description longtext,
        return_type varchar(255),
        parent varchar(32),
        signoff_config varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_task_definition_rights (
       task_definition_id varchar(32) not null,
        idx integer not null,
        right_id varchar(32) not null,
        primary key (task_definition_id, idx)
    ) engine=InnoDB;

    create table identityiq.spt_task_event (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        phase varchar(128),
        rule_id varchar(32),
        attributes longtext,
        task_result varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_task_result (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        stack longtext,
        attributes longtext,
        launcher varchar(255),
        host varchar(255),
        launched bigint,
        progress varchar(255),
        percent_complete integer,
        type varchar(255),
        messages longtext,
        completed bigint,
        expiration bigint,
        verified bigint,
        name varchar(255) not null,
        definition varchar(32),
        schedule varchar(255),
        pending_signoffs integer,
        signoff longtext,
        report varchar(32),
        target_class varchar(255),
        target_id varchar(255),
        target_name varchar(255),
        task_terminated bit,
        partitioned bit,
        live bit,
        completion_status varchar(255),
        run_length integer,
        run_length_average integer,
        run_length_deviation integer,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_task_signature_arguments (
       signature varchar(32) not null,
        idx integer not null,
        name varchar(255),
        type varchar(255),
        filter_string varchar(255),
        help_key varchar(255),
        input_template varchar(255),
        description longtext,
        prompt longtext,
        multi bit,
        required bit,
        default_value varchar(255),
        primary key (signature, idx)
    ) engine=InnoDB;

    create table identityiq.spt_task_signature_returns (
       signature varchar(32) not null,
        idx integer not null,
        name varchar(255),
        type varchar(255),
        filter_string varchar(255),
        description longtext,
        prompt longtext,
        multi bit,
        primary key (signature, idx)
    ) engine=InnoDB;

    create table identityiq.spt_time_period (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128),
        classifier varchar(255),
        init_parameters longtext,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_uiconfig (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null,
        attributes longtext,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_uipreferences (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        preferences longtext,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_widget (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null,
        title varchar(128),
        selector longtext,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_workflow (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null,
        description varchar(4000),
        type varchar(128),
        task_type varchar(255),
        template bit,
        explicit_transitions bit,
        monitored bit,
        result_expiration integer,
        complete bit,
        handler varchar(128),
        work_item_renderer varchar(128),
        variable_definitions longtext,
        config_form varchar(128),
        steps longtext,
        work_item_config longtext,
        variables longtext,
        libraries varchar(128),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_workflow_rule_libraries (
       rule_id varchar(32) not null,
        idx integer not null,
        dependency varchar(32) not null,
        primary key (rule_id, idx)
    ) engine=InnoDB;

    create table identityiq.spt_workflow_case (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        stack longtext,
        attributes longtext,
        launcher varchar(255),
        host varchar(255),
        launched bigint,
        progress varchar(255),
        percent_complete integer,
        type varchar(255),
        messages longtext,
        completed bigint,
        name varchar(450),
        description varchar(1024),
        complete bit,
        target_class varchar(255),
        target_id varchar(255),
        target_name varchar(255),
        workflow longtext,
        iiqlock varchar(128),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_workflow_registry (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null,
        types longtext,
        templates longtext,
        callables longtext,
        attributes longtext,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_workflow_target (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128),
        description varchar(1024),
        class_name varchar(255),
        object_id varchar(255),
        object_name varchar(255),
        workflow_case_id varchar(32) not null,
        idx integer,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_workflow_test_suite (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        name varchar(128) not null,
        description varchar(4000),
        replicated bit,
        case_name varchar(255),
        tests longtext,
        responses longtext,
        attributes longtext,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_work_item (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(255),
        description varchar(1024),
        handler varchar(255),
        renderer varchar(255),
        target_class varchar(255),
        target_id varchar(255),
        target_name varchar(255),
        type varchar(255),
        state varchar(255),
        severity varchar(255),
        requester varchar(32),
        completion_comments longtext,
        notification bigint,
        expiration bigint,
        wake_up_date bigint,
        reminders integer,
        escalation_count integer,
        notification_config longtext,
        workflow_case varchar(32),
        attributes longtext,
        owner_history longtext,
        certification varchar(255),
        certification_entity varchar(255),
        certification_item varchar(255),
        identity_request_id varchar(128),
        assignee varchar(32),
        iiqlock varchar(128),
        certification_ref_id varchar(32),
        idx integer,
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_work_item_comments (
       work_item varchar(32) not null,
        idx integer not null,
        author varchar(255),
        comments longtext,
        comment_date bigint,
        primary key (work_item, idx)
    ) engine=InnoDB;

    create table identityiq.spt_work_item_archive (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        work_item_id varchar(128),
        name varchar(255),
        owner_name varchar(255),
        identity_request_id varchar(128),
        assignee varchar(255),
        requester varchar(255),
        description varchar(1024),
        handler varchar(255),
        renderer varchar(255),
        target_class varchar(255),
        target_id varchar(255),
        target_name varchar(255),
        archived bigint,
        type varchar(255),
        state varchar(255),
        severity varchar(255),
        attributes longtext,
        system_attributes longtext,
        immutable bit,
        signed bit,
        completer varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_work_item_config (
       id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128),
        description_template varchar(1024),
        disabled bit,
        no_work_item bit,
        owner_rule varchar(32),
        hours_till_escalation integer,
        hours_between_reminders integer,
        max_reminders integer,
        notification_email varchar(32),
        reminder_email varchar(32),
        escalation_email varchar(32),
        escalation_rule varchar(32),
        parent varchar(32),
        primary key (id)
    ) engine=InnoDB;

    create table identityiq.spt_work_item_owners (
       config varchar(32) not null,
        idx integer not null,
        elt varchar(32) not null,
        primary key (config, idx)
    ) engine=InnoDB;
create index spt_actgroup_name_csi on identityiq.spt_account_group (name);
create index spt_actgroup_native_ci on identityiq.spt_account_group (native_identity(255));
create index spt_actgroup_attr on identityiq.spt_account_group (reference_attribute);
create index spt_actgroup_lastAggregation on identityiq.spt_account_group (last_target_aggregation);
create index spt_actgroup_key1_ci on identityiq.spt_account_group (key1);
create index spt_actgroup_key2_ci on identityiq.spt_account_group (key2);
create index spt_actgroup_key3_ci on identityiq.spt_account_group (key3);
create index spt_actgroup_key4_ci on identityiq.spt_account_group (key4);
create index spt_alert_extended1_ci on identityiq.spt_alert (extended1);
create index spt_alert_last_processed on identityiq.spt_alert (last_processed);
create index spt_alert_name on identityiq.spt_alert (name);

    alter table identityiq.spt_alert_definition 
       add constraint UK_p9a15ie5pfscgm3hb745wwnsm unique (name);
create index spt_app_extended1_ci on identityiq.spt_application (extended1(255));
create index spt_app_proxied_name on identityiq.spt_application (proxied_name);
create index spt_application_cluster on identityiq.spt_application (app_cluster);
create index spt_application_authoritative on identityiq.spt_application (authoritative);
create index spt_application_logical on identityiq.spt_application (logical);
create index spt_application_provisioning on identityiq.spt_application (supports_provisioning);
create index spt_application_authenticate on identityiq.spt_application (supports_authenticate);
create index spt_application_acct_only on identityiq.spt_application (supports_account_only);
create index spt_application_addt_acct on identityiq.spt_application (supports_additional_accounts);
create index spt_application_no_agg on identityiq.spt_application (no_aggregation);
create index spt_app_sync_provisioning on identityiq.spt_application (sync_provisioning);
create index spt_application_mgd_apps on identityiq.spt_application (manages_other_apps);

    alter table identityiq.spt_application 
       add constraint UK_ol1192j17pnj5syamkr9ecb28 unique (name);
create index app_scorecard_cscore on identityiq.spt_application_scorecard (composite_score);

    alter table identityiq.spt_audit_config 
       add constraint UK_g3dye1egpdn4t6ikmfqeohyfa unique (name);
create index spt_audit_interface_ci on identityiq.spt_audit_event (interface);
create index spt_audit_source_ci on identityiq.spt_audit_event (source);
create index spt_audit_action_ci on identityiq.spt_audit_event (action);
create index spt_audit_target_ci on identityiq.spt_audit_event (target);
create index spt_audit_application_ci on identityiq.spt_audit_event (application);
create index spt_audit_accountname_ci on identityiq.spt_audit_event (account_name(255));
create index spt_audit_instance_ci on identityiq.spt_audit_event (instance);
create index spt_audit_attr_ci on identityiq.spt_audit_event (attribute_name);
create index spt_audit_attrVal_ci on identityiq.spt_audit_event (attribute_value(255));
create index spt_audit_trackingid_ci on identityiq.spt_audit_event (tracking_id);
create index spt_bulkidjoin_id_ci on identityiq.spt_bulk_id_join (join_id);
create index spt_bulkidjoin_prop_ci on identityiq.spt_bulk_id_join (join_property);
create index spt_bulkidjoin_user_ci on identityiq.spt_bulk_id_join (user_id);
create index spt_bundle_extended1_ci on identityiq.spt_bundle (extended1(255));
create index spt_bundle_dispname_ci on identityiq.spt_bundle (displayable_name);
create index spt_bundle_disabled on identityiq.spt_bundle (disabled);
create index spt_bundle_type on identityiq.spt_bundle (type);

    alter table identityiq.spt_bundle 
       add constraint UK_smf7ppq8j0o6ijtrhh7ga9ck3 unique (name);
create index spt_bundle_archive_source on identityiq.spt_bundle_archive (source_id);
create index spt_bpr_bundle_id_hash_code on identityiq.spt_bundle_profile_relation (bundle_id, hash_code);
create index spt_bpr_type on identityiq.spt_bundle_profile_relation (type);
create index spt_bpr_attr_ci on identityiq.spt_bundle_profile_relation (attribute);
create index spt_bpr_value_ci on identityiq.spt_bundle_profile_relation (value);
create index spt_bpr_display_value_ci on identityiq.spt_bundle_profile_relation (display_value);
create index spt_bpr_app_status on identityiq.spt_bundle_profile_relation (app_status);
create index spt_bprs_bundle_id on identityiq.spt_bundle_profile_relation_step (bundle_id);

    alter table identityiq.spt_capability 
       add constraint UK_icigo0rpdnfxkqv03375j2mnv unique (name);

    alter table identityiq.spt_category 
       add constraint UK_r4nfd0896ly42tur7agn58fl6 unique (name);
create index spt_certification_name_ci on identityiq.spt_certification (name(255));
create index spt_cert_short_name_ci on identityiq.spt_certification (short_name);
create index spt_certification_signed on identityiq.spt_certification (signed);
create index spt_certification_finished on identityiq.spt_certification (finished);
create index spt_cert_auto_close_date on identityiq.spt_certification (automatic_closing_date);
create index spt_cert_application_ci on identityiq.spt_certification (application_id);
create index spt_cert_manager_ci on identityiq.spt_certification (manager);
create index spt_cert_group_id_ci on identityiq.spt_certification (group_definition_id);
create index spt_cert_group_name_ci on identityiq.spt_certification (group_definition_name);
create index spt_cert_percent_complete on identityiq.spt_certification (percent_complete);
create index spt_cert_type_ci on identityiq.spt_certification (type);
create index spt_cert_task_sched_id_ci on identityiq.spt_certification (task_schedule_id);
create index spt_cert_trigger_id_ci on identityiq.spt_certification (trigger_id);
create index spt_cert_cert_def_id_ci on identityiq.spt_certification (certification_definition_id);
create index spt_cert_phase_ci on identityiq.spt_certification (phase);
create index spt_cert_nxt_phs_tran on identityiq.spt_certification (next_phase_transition);
create index spt_cert_nextRemediationScan on identityiq.spt_certification (next_remediation_scan);
create index nxt_cert_req_scan on identityiq.spt_certification (next_cert_required_scan);
create index nxt_overdue_scan on identityiq.spt_certification (next_overdue_scan);
create index spt_cert_exclude_inactive on identityiq.spt_certification (exclude_inactive);
create index spt_cert_electronic_signed on identityiq.spt_certification (electronically_signed);
create index spt_item_ready_for_remed on identityiq.spt_certification_action (ready_for_remediation);
create index spt_cert_archive_id on identityiq.spt_certification_archive (certification_id);
create index spt_cert_archive_grp_id on identityiq.spt_certification_archive (certification_group_id);
create index spt_cert_archive_creator on identityiq.spt_certification_archive (creator);

    alter table identityiq.spt_certification_definition 
       add constraint UK_kayn5nry9qy90kk9e9f2e2vut unique (name);
create index spt_certification_entity_stat on identityiq.spt_certification_entity (summary_status);
create index spt_certification_entity_state on identityiq.spt_certification_entity (continuous_state);
create index spt_certification_entity_ld on identityiq.spt_certification_entity (last_decision);
create index spt_certification_entity_nsc on identityiq.spt_certification_entity (next_continuous_state_change);
create index spt_certification_entity_due on identityiq.spt_certification_entity (overdue_date);
create index spt_certification_entity_diffs on identityiq.spt_certification_entity (has_differences);
create index spt_certification_entity_tn on identityiq.spt_certification_entity (target_name);
create index spt_cert_entity_identity on identityiq.spt_certification_entity (identity_id(255));
create index spt_cert_entity_firstname_ci on identityiq.spt_certification_entity (firstname);
create index spt_cert_entity_lastname_ci on identityiq.spt_certification_entity (lastname);
create index spt_cert_entity_cscore on identityiq.spt_certification_entity (composite_score);
create index spt_cert_entity_new_user on identityiq.spt_certification_entity (new_user);
create index spt_cert_entity_pending on identityiq.spt_certification_entity (pending_certification);
create index spt_cert_group_type on identityiq.spt_certification_group (type);
create index spt_cert_group_status on identityiq.spt_certification_group (status);
create index spt_cert_grp_perc_comp on identityiq.spt_certification_group (percent_complete);
create index spt_certification_item_stat on identityiq.spt_certification_item (summary_status);
create index spt_certification_item_state on identityiq.spt_certification_item (continuous_state);
create index spt_certification_item_ld on identityiq.spt_certification_item (last_decision);
create index spt_certification_item_nsc on identityiq.spt_certification_item (next_continuous_state_change);
create index spt_certification_item_due on identityiq.spt_certification_item (overdue_date);
create index spt_certification_item_diffs on identityiq.spt_certification_item (has_differences);
create index spt_certification_item_tn on identityiq.spt_certification_item (target_name);
create index spt_cert_item_bundle on identityiq.spt_certification_item (bundle);
create index spt_cert_item_type on identityiq.spt_certification_item (type);
create index spt_needs_refresh on identityiq.spt_certification_item (needs_refresh);
create index spt_cert_item_exception_app on identityiq.spt_certification_item (exception_application);
create index spt_cert_item_perm_target on identityiq.spt_certification_item (exception_permission_target);
create index spt_cert_item_perm_right on identityiq.spt_certification_item (exception_permission_right);
create index spt_cert_item_wk_up on identityiq.spt_certification_item (wake_up_date);
create index spt_cert_item_phase on identityiq.spt_certification_item (phase);
create index spt_cert_item_nxt_phs_tran on identityiq.spt_certification_item (next_phase_transition);
create index spt_certitem_extended1_ci on identityiq.spt_certification_item (extended1(255));
create index spt_classif_dispname_ci on identityiq.spt_classification (displayable_name);

    alter table identityiq.spt_classification 
       add constraint UK_eqb3e1wxju8yopo50ljal8lpg unique (name);

    alter table identityiq.spt_cloud_access_group 
       add constraint UK_dfcupn1yjhukxrl4hs7rf4046 unique (name);

    alter table identityiq.spt_cloud_access_role 
       add constraint UK_ntejuomvc5awi8b6apshil7q3 unique (name);

    alter table identityiq.spt_cloud_access_scope 
       add constraint UK_rj2onrkbufpyxss96wu2i8nt8 unique (name);

    alter table identityiq.spt_configuration 
       add constraint UK_dkxlp7fgtfipuokv9qxaj735g unique (name);

    alter table identityiq.spt_correlation_config 
       add constraint UK_rwy1ty2x8aht5691cdygbjv3l unique (name);
create index spt_custom_name_csi on identityiq.spt_custom (name);
create index spt_delObj_name_ci on identityiq.spt_deleted_object (name);
create index spt_delObj_nativeIdentity_ci on identityiq.spt_deleted_object (native_identity(255));
create index spt_delObj_lastRefresh on identityiq.spt_deleted_object (last_refresh);
create index spt_delObj_objectType_ci on identityiq.spt_deleted_object (object_type);

    alter table identityiq.spt_dictionary_term 
       add constraint UK_js3ank2u9ao5bytbttnd249bj unique (value);

    alter table identityiq.spt_dynamic_scope 
       add constraint UK_jamxxk00xqxkiw6nsww52xr2f unique (name);

    alter table identityiq.spt_email_template 
       add constraint UK_op3ic1cyo2k1owya8j156itp0 unique (name);
create index spt_ent_snap_application_ci on identityiq.spt_entitlement_snapshot (application);
create index spt_ent_snap_nativeIdentity_ci on identityiq.spt_entitlement_snapshot (native_identity(255));
create index spt_ent_snap_displayName_ci on identityiq.spt_entitlement_snapshot (display_name(255));
create index file_bucketNumber on identityiq.spt_file_bucket (file_index);

    alter table identityiq.spt_form 
       add constraint UK_8xrdket8a5q8r8c1ab5lmbarr unique (name);

    alter table identityiq.spt_full_text_index 
       add constraint UK_jc9qh3jumoqe46w0ibonmvipk unique (name);
create index group_index_cscore on identityiq.spt_group_index (composite_score);
create index spt_identity_extended1_ci on identityiq.spt_identity (extended1(255));
create index spt_identity_extended2_ci on identityiq.spt_identity (extended2(255));
create index spt_identity_extended3_ci on identityiq.spt_identity (extended3(255));
create index spt_identity_extended4_ci on identityiq.spt_identity (extended4(255));
create index spt_identity_extended5_ci on identityiq.spt_identity (extended5(255));
create index spt_identity_needs_refresh on identityiq.spt_identity (needs_refresh);
create index spt_identity_displayName_ci on identityiq.spt_identity (display_name);
create index spt_identity_firstname_ci on identityiq.spt_identity (firstname);
create index spt_identity_lastname_ci on identityiq.spt_identity (lastname);
create index spt_identity_email_ci on identityiq.spt_identity (email);
create index spt_identity_manager_status on identityiq.spt_identity (manager_status);
create index spt_identity_inactive on identityiq.spt_identity (inactive);
create index spt_identity_lastRefresh on identityiq.spt_identity (last_refresh);
create index spt_identity_correlated on identityiq.spt_identity (correlated);
create index spt_identity_type_ci on identityiq.spt_identity (type);
create index spt_identity_sw_version_ci on identityiq.spt_identity (software_version);
create index spt_identity_isworkgroup on identityiq.spt_identity (workgroup);

    alter table identityiq.spt_identity 
       add constraint UK_afdtg40pi16y2smshwjgj2g6h unique (name);
create index spt_identity_archive_source on identityiq.spt_identity_archive (source_id);
create index spt_identity_ent_name_ci on identityiq.spt_identity_entitlement (name);
create index spt_identity_ent_value_ci on identityiq.spt_identity_entitlement (value(255));
create index spt_identity_ent_nativeid_ci on identityiq.spt_identity_entitlement (native_identity(255));
create index spt_identity_ent_instance_ci on identityiq.spt_identity_entitlement (instance);
create index spt_identity_ent_ag_state on identityiq.spt_identity_entitlement (aggregation_state);
create index spt_identity_ent_source_ci on identityiq.spt_identity_entitlement (source);
create index spt_identity_ent_assigned on identityiq.spt_identity_entitlement (assigned);
create index spt_identity_ent_allowed on identityiq.spt_identity_entitlement (allowed);
create index spt_identity_ent_role_granted on identityiq.spt_identity_entitlement (granted_by_role);
create index spt_identity_ent_assgnid on identityiq.spt_identity_entitlement (assignment_id);
create index spt_identity_ent_type on identityiq.spt_identity_entitlement (type);
create index spt_id_hist_item_cert_type on identityiq.spt_identity_history_item (certification_type);
create index spt_id_hist_item_status on identityiq.spt_identity_history_item (status);
create index spt_id_hist_item_actor on identityiq.spt_identity_history_item (actor);
create index spt_id_hist_item_entry_date on identityiq.spt_identity_history_item (entry_date);
create index spt_id_hist_item_application on identityiq.spt_identity_history_item (application);
create index spt_id_hist_item_instance on identityiq.spt_identity_history_item (instance);
create index spt_id_hist_item_account_ci on identityiq.spt_identity_history_item (account);
create index spt_id_hist_item_ntv_id_ci on identityiq.spt_identity_history_item (native_identity(255));
create index spt_id_hist_item_attribute_ci on identityiq.spt_identity_history_item (attribute(255));
create index spt_id_hist_item_value_ci on identityiq.spt_identity_history_item (value(255));
create index spt_id_hist_item_policy on identityiq.spt_identity_history_item (policy);
create index spt_id_hist_item_role on identityiq.spt_identity_history_item (role);
create index spt_idrequest_name on identityiq.spt_identity_request (name);
create index spt_idrequest_state on identityiq.spt_identity_request (state);
create index spt_idrequest_type on identityiq.spt_identity_request (type);
create index spt_idrequest_target_id on identityiq.spt_identity_request (target_id);
create index spt_idrequest_target_ci on identityiq.spt_identity_request (target_display_name);
create index spt_idrequest_requestor_ci on identityiq.spt_identity_request (requester_display_name);
create index spt_idrequest_requestor_id on identityiq.spt_identity_request (requester_id);
create index spt_idrequest_endDate on identityiq.spt_identity_request (end_date);
create index spt_idrequest_verified on identityiq.spt_identity_request (verified);
create index spt_idrequest_priority on identityiq.spt_identity_request (priority);
create index spt_idrequest_compl_status on identityiq.spt_identity_request (completion_status);
create index spt_idrequest_exec_status on identityiq.spt_identity_request (execution_status);
create index spt_idrequest_has_messages on identityiq.spt_identity_request (has_messages);
create index spt_idrequest_ext_ticket_ci on identityiq.spt_identity_request (external_ticket_id);
create index spt_reqitem_name_ci on identityiq.spt_identity_request_item (name);
create index spt_reqitem_value_ci on identityiq.spt_identity_request_item (value(255));
create index spt_reqitem_nativeid_ci on identityiq.spt_identity_request_item (native_identity(255));
create index spt_reqitem_instance_ci on identityiq.spt_identity_request_item (instance);
create index spt_reqitem_ownername on identityiq.spt_identity_request_item (owner_name);
create index spt_reqitem_approvername on identityiq.spt_identity_request_item (approver_name);
create index spt_reqitem_approval_state on identityiq.spt_identity_request_item (approval_state);
create index spt_reqitem_provisioning_state on identityiq.spt_identity_request_item (provisioning_state);
create index spt_reqitem_comp_status on identityiq.spt_identity_request_item (compilation_status);
create index spt_reqitem_exp_cause on identityiq.spt_identity_request_item (expansion_cause);
create index spt_identity_id on identityiq.spt_identity_snapshot (identity_id);
create index spt_idsnap_id_name on identityiq.spt_identity_snapshot (identity_name);

    alter table identityiq.spt_integration_config 
       add constraint UK_ktnweagpbwlxvsst5icni3epm unique (name);
create index bucketNumber on identityiq.spt_jasper_page_bucket (bucket_number);
create index handlerId on identityiq.spt_jasper_page_bucket (handler_id);

    alter table identityiq.spt_jasper_template 
       add constraint UK_4sukasjpluq6bcpu1vybgn6o3 unique (name);
create index spt_link_key1_ci on identityiq.spt_link (key1(255));
create index spt_link_extended1_ci on identityiq.spt_link (extended1(255));
create index spt_link_dispname_ci on identityiq.spt_link (display_name);
create index spt_link_nativeIdentity_ci on identityiq.spt_link (native_identity(255));
create index spt_link_lastRefresh on identityiq.spt_link (last_refresh);
create index spt_link_lastAggregation on identityiq.spt_link (last_target_aggregation);
create index spt_link_entitlements on identityiq.spt_link (entitlements);
create index spt_link_iiq_disabled on identityiq.spt_link (iiq_disabled);
create index spt_link_iiq_locked on identityiq.spt_link (iiq_locked);
create index spt_localized_attr_name on identityiq.spt_localized_attribute (name);
create index spt_localized_attr_locale on identityiq.spt_localized_attribute (locale);
create index spt_localized_attr_attr on identityiq.spt_localized_attribute (attribute);
create index spt_localized_attr_targetname on identityiq.spt_localized_attribute (target_name);
create index spt_localized_attr_targetid on identityiq.spt_localized_attribute (target_id);
create index spt_managed_attr_extended1_ci on identityiq.spt_managed_attribute (extended1(255));
create index spt_managed_attr_extended2_ci on identityiq.spt_managed_attribute (extended2(255));
create index spt_managed_attr_extended3_ci on identityiq.spt_managed_attribute (extended3(255));
create index spt_managed_attr_type on identityiq.spt_managed_attribute (type);
create index spt_managed_attr_aggregated on identityiq.spt_managed_attribute (aggregated);
create index spt_managed_attr_attr_ci on identityiq.spt_managed_attribute (attribute(255));
create index spt_managed_attr_value_ci on identityiq.spt_managed_attribute (value(255));
create index spt_managed_attr_dispname_ci on identityiq.spt_managed_attribute (displayable_name(255));
create index spt_managed_attr_uuid_ci on identityiq.spt_managed_attribute (uuid);
create index spt_managed_attr_requestable on identityiq.spt_managed_attribute (requestable);
create index spt_managed_attr_last_tgt_agg on identityiq.spt_managed_attribute (last_target_aggregation);
create index spt_ma_key1_ci on identityiq.spt_managed_attribute (key1);
create index spt_ma_key2_ci on identityiq.spt_managed_attribute (key2);
create index spt_ma_key3_ci on identityiq.spt_managed_attribute (key3);
create index spt_ma_key4_ci on identityiq.spt_managed_attribute (key4);

    alter table identityiq.spt_managed_attribute 
       add constraint UK_prmbsvo2fb4pei4ff9a5m2kso unique (hash);

    alter table identityiq.spt_message_template 
       add constraint UK_husdj437loithtt5rgxwx3oqv unique (name);

    alter table identityiq.spt_mining_config 
       add constraint UK_t2qyp373evmrsowd6svdi6ljk unique (name);
create index spt_mitigation_role on identityiq.spt_mitigation_expiration (role_name);
create index spt_mitigation_policy on identityiq.spt_mitigation_expiration (policy);
create index spt_mitigation_app on identityiq.spt_mitigation_expiration (application);
create index spt_mitigation_instance on identityiq.spt_mitigation_expiration (instance);
create index spt_mitigation_account_ci on identityiq.spt_mitigation_expiration (native_identity(255));
create index spt_mitigation_attr_name_ci on identityiq.spt_mitigation_expiration (attribute_name(255));
create index spt_mitigation_attr_val_ci on identityiq.spt_mitigation_expiration (attribute_value(255));
create index spt_mitigation_permission on identityiq.spt_mitigation_expiration (permission);

    alter table identityiq.spt_module 
       add constraint UK_bebq8nsflsucu90sph68pf43r unique (name);

    alter table identityiq.spt_monitoring_statistic 
       add constraint UK_k7skupvvbqf88k94pd6ukh49c unique (name);
create index spt_nativeidchange_identity_ci on identityiq.spt_native_identity_change_event (identity_id);
create index spt_nativeidchange_link_ci on identityiq.spt_native_identity_change_event (link_id);
create index spt_nativeidchange_ma_ci on identityiq.spt_native_identity_change_event (managed_attribute_id);
create index spt_nativeidchange_oldni_ci on identityiq.spt_native_identity_change_event (old_native_identity);
create index spt_nativeidchange_uuid_ci on identityiq.spt_native_identity_change_event (uuid);
create index spt_classification_owner_id on identityiq.spt_object_classification (owner_id);
create index spt_class_owner_type on identityiq.spt_object_classification (owner_type);

    alter table identityiq.spt_object_config 
       add constraint UK_thw4nv9d2kok4jrqbcg7ume8h unique (name);
create index spt_partition_status on identityiq.spt_partition_result (completion_status);

    alter table identityiq.spt_partition_result 
       add constraint UK_9hkfjsotujyf84i2ilkevu3no unique (name);

    alter table identityiq.spt_password_policy 
       add constraint UK_ousim2j29ecrtdoppi5diwmxr unique (name);
create index spt_plugin_name_ci on identityiq.spt_plugin (name);
create index spt_plugin_dn_ci on identityiq.spt_plugin (display_name);

    alter table identityiq.spt_plugin 
       add constraint UK_c7ccr73vpnee48igqv6w9spmp unique (file_id);

    alter table identityiq.spt_policy 
       add constraint UK_lgdxftlbfwbn2c2jtptk4tkt4 unique (name);
create index spt_policy_violation_active on identityiq.spt_policy_violation (active);
create index spt_process_log_process_name on identityiq.spt_process_log (process_name);
create index spt_process_log_case_id on identityiq.spt_process_log (case_id);
create index spt_process_log_wf_case_name on identityiq.spt_process_log (workflow_case_name(255));
create index spt_process_log_case_status on identityiq.spt_process_log (case_status);
create index spt_process_log_step_name on identityiq.spt_process_log (step_name);
create index spt_process_log_approval_name on identityiq.spt_process_log (approval_name);
create index spt_process_log_owner_name on identityiq.spt_process_log (owner_name);
create index spt_provreq_expiration on identityiq.spt_provisioning_request (expiration);
create index spt_prvtrans_name on identityiq.spt_provisioning_transaction (name);
create index spt_prvtrans_created on identityiq.spt_provisioning_transaction (created);
create index spt_prvtrans_op on identityiq.spt_provisioning_transaction (operation);
create index spt_prvtrans_src on identityiq.spt_provisioning_transaction (source);
create index spt_prvtrans_app_ci on identityiq.spt_provisioning_transaction (application_name);
create index spt_prvtrans_idn_ci on identityiq.spt_provisioning_transaction (identity_name);
create index spt_prvtrans_iddn_ci on identityiq.spt_provisioning_transaction (identity_display_name);
create index spt_prvtrans_nid_ci on identityiq.spt_provisioning_transaction (native_identity(255));
create index spt_prvtrans_adn_ci on identityiq.spt_provisioning_transaction (account_display_name(255));
create index spt_prvtrans_integ_ci on identityiq.spt_provisioning_transaction (integration);
create index spt_prvtrans_forced on identityiq.spt_provisioning_transaction (forced);
create index spt_prvtrans_type on identityiq.spt_provisioning_transaction (type);
create index spt_prvtrans_status on identityiq.spt_provisioning_transaction (status);

    alter table identityiq.spt_quick_link 
       add constraint UK_merms3cmmi5yrruxr338mbh7d unique (name);

    alter table identityiq.spt_recommender_definition 
       add constraint UK_ekuvq6a1uhwkxb7fofir077xv unique (name);
create index spt_remote_login_expiration on identityiq.spt_remote_login_token (expiration);
create index spt_request_expiration on identityiq.spt_request (expiration);
create index spt_request_name on identityiq.spt_request (name(255));
create index spt_request_phase on identityiq.spt_request (phase);
create index spt_request_depPhase on identityiq.spt_request (dependent_phase);
create index spt_request_nextLaunch on identityiq.spt_request (next_launch);
create index spt_request_compl_status on identityiq.spt_request (completion_status);
create index spt_request_notif_needed on identityiq.spt_request (notification_needed);

    alter table identityiq.spt_request_definition 
       add constraint UK_3nt4yuuvbl2byvkendp3j4agv unique (name);

    alter table identityiq.spt_right_config 
       add constraint UK_kcvm6fgx3ncfka1e91frbq594 unique (name);
create index spt_rce_status on identityiq.spt_role_change_event (status);
create index role_index_cscore on identityiq.spt_role_index (composite_score);

    alter table identityiq.spt_rule 
       add constraint UK_sy7p5bybnsqmi3odg5twi35al unique (name);

    alter table identityiq.spt_rule_registry 
       add constraint UK_rhm4bwwsb05g3kcpdyy0gajev unique (name);
create index spt_app_attr_mod on identityiq.spt_schema_attributes (remed_mod_type);
create index scope_name_ci on identityiq.spt_scope (name);
create index scope_disp_name_ci on identityiq.spt_scope (display_name);
create index scope_path on identityiq.spt_scope (path(255));
create index scope_dirty on identityiq.spt_scope (dirty);
create index identity_scorecard_cscore on identityiq.spt_scorecard (composite_score);

    alter table identityiq.spt_score_config 
       add constraint UK_dmwfxhf88xip0d78xe5yebuuc unique (name);
create index spt_server_extended1_ci on identityiq.spt_server (extended1);

    alter table identityiq.spt_server 
       add constraint UK_kf14wilyojkxlsph6yo46nhf8 unique (name);
create index server_stat_snapshot on identityiq.spt_server_statistic (snapshot_name);

    alter table identityiq.spt_service_definition 
       add constraint UK_62qdarwripq8h3mmibl1pg8or unique (name);

    alter table identityiq.spt_service_lock 
       add constraint UK_su52ugaros4i67n6s56beyyby unique (service_definition);

    alter table identityiq.spt_service_status 
       add constraint UK_3xrmomphbxmv4wc27d9nyk654 unique (name);
create index sign_off_history_signer_id on identityiq.spt_sign_off_history (signer_id);
create index spt_sign_off_history_esig on identityiq.spt_sign_off_history (electronic_sign);
create index spt_arch_entity_tgt_name_csi on identityiq.spt_archived_cert_entity (target_name);
create index spt_arch_entity_identity_csi on identityiq.spt_archived_cert_entity (identity_name(255));
create index spt_arch_entity_acct_grp_csi on identityiq.spt_archived_cert_entity (account_group(255));
create index spt_arch_entity_app on identityiq.spt_archived_cert_entity (application);
create index spt_arch_entity_native_id on identityiq.spt_archived_cert_entity (native_identity(255));
create index spt_arch_entity_ref_attr on identityiq.spt_archived_cert_entity (reference_attribute);
create index spt_arch_entity_target_id on identityiq.spt_archived_cert_entity (target_id);
create index spt_arch_entity_tgt_display on identityiq.spt_archived_cert_entity (target_display_name);
create index spt_arch_cert_item_type on identityiq.spt_archived_cert_item (type);
create index spt_arch_item_app on identityiq.spt_archived_cert_item (exception_application);
create index spt_arch_item_native_id on identityiq.spt_archived_cert_item (exception_native_identity(255));
create index spt_arch_item_policy on identityiq.spt_archived_cert_item (policy(255));
create index spt_arch_item_bundle on identityiq.spt_archived_cert_item (bundle);
create index spt_arch_cert_item_tdisplay on identityiq.spt_archived_cert_item (target_display_name);
create index spt_arch_cert_item_tname on identityiq.spt_archived_cert_item (target_name);
create index spt_pend_attach_item on identityiq.spt_pending_req_attach (item_id);
create index spt_pend_attach_req on identityiq.spt_pending_req_attach (requester_id);

    alter table identityiq.spt_right 
       add constraint UK_jral3yg4vxqqx5cd3ef43p2pl unique (name);
create index spt_syslog_created on identityiq.spt_syslog_event (created);
create index spt_syslog_quickKey on identityiq.spt_syslog_event (quick_key);
create index spt_syslog_event_level on identityiq.spt_syslog_event (event_level);
create index spt_syslog_classname on identityiq.spt_syslog_event (classname);
create index spt_syslog_message on identityiq.spt_syslog_event (message(255));
create index spt_syslog_server on identityiq.spt_syslog_event (server);
create index spt_syslog_username on identityiq.spt_syslog_event (username);

    alter table identityiq.spt_tag 
       add constraint UK_ky9sm7nb1boucsf89s7a854p8 unique (name);
create index spt_target_extended1_ci on identityiq.spt_target (extended1);
create index spt_target_unique_name_hash on identityiq.spt_target (unique_name_hash);
create index spt_target_native_obj_id on identityiq.spt_target(native_object_id(255));
create index spt_target_last_agg on identityiq.spt_target (last_aggregation);
create index spt_target_assoc_id on identityiq.spt_target_association (object_id);
create index spt_target_assoc_targ_name_ci on identityiq.spt_target_association (target_name);
create index spt_target_assoc_last_agg on identityiq.spt_target_association (last_aggregation);
create index spt_task_deprecated on identityiq.spt_task_definition (deprecated);

    alter table identityiq.spt_task_definition 
       add constraint UK_ngpdc5e2vfx0bgg3onr5wwi8h unique (name);
create index spt_task_event_phase on identityiq.spt_task_event (phase);
create index spt_taskres_completed on identityiq.spt_task_result (completed);
create index spt_taskres_expiration on identityiq.spt_task_result (expiration);
create index spt_taskres_verified on identityiq.spt_task_result (verified);
create index spt_taskresult_schedule on identityiq.spt_task_result (schedule);
create index spt_taskresult_target on identityiq.spt_task_result (target_id);
create index spt_taskresult_targetname_ci on identityiq.spt_task_result (target_name);
create index spt_task_compl_status on identityiq.spt_task_result (completion_status);

    alter table identityiq.spt_task_result 
       add constraint UK_6p0er3vv16g3lmh9xw3iysskw unique (name);

    alter table identityiq.spt_uiconfig 
       add constraint UK_k68d5hs1pn9mtga8t5ff62j2b unique (name);

    alter table identityiq.spt_widget 
       add constraint UK_4by84g4xwhbk5n949cqe1f4p7 unique (name);

    alter table identityiq.spt_workflow 
       add constraint UK_1364j5ejd8rifs8f4shf0avak unique (name);
create index spt_workflowcase_target on identityiq.spt_workflow_case (target_id);

    alter table identityiq.spt_workflow_registry 
       add constraint UK_f4aqigwy74tvdfhs90l2e8mmf unique (name);

    alter table identityiq.spt_workflow_test_suite 
       add constraint UK_9db88vtedq9ehu425aarf6jxt unique (name);
create index spt_work_item_name on identityiq.spt_work_item (name);
create index spt_work_item_target on identityiq.spt_work_item (target_id);
create index spt_work_item_type on identityiq.spt_work_item (type);
create index spt_work_item_ident_req_id on identityiq.spt_work_item (identity_request_id);
create index spt_item_archive_workItemId on identityiq.spt_work_item_archive (work_item_id);
create index spt_item_archive_name on identityiq.spt_work_item_archive (name);
create index spt_item_archive_owner_ci on identityiq.spt_work_item_archive (owner_name);
create index spt_item_archive_ident_req on identityiq.spt_work_item_archive (identity_request_id);
create index spt_item_archive_assignee_ci on identityiq.spt_work_item_archive (assignee);
create index spt_item_archive_requester_ci on identityiq.spt_work_item_archive (requester);
create index spt_item_archive_target on identityiq.spt_work_item_archive (target_id);
create index spt_item_archive_type on identityiq.spt_work_item_archive (type);
create index spt_item_archive_severity on identityiq.spt_work_item_archive (severity);
create index spt_item_archive_completer on identityiq.spt_work_item_archive (completer);

    alter table identityiq.spt_account_group 
       add constraint FK81npondqko61p2jbiurtiyjjh 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_account_group 
       add constraint FK34oc5rgrwidh1xfn80u7hw6ty 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_account_group 
       add constraint FKr2yvl55h4eygmk9g025u7knhg 
       foreign key (application) 
       references identityiq.spt_application (id);

    alter table identityiq.spt_account_group_inheritance 
       add constraint FK37nc4s7oaae0og1ks6qawxw5v 
       foreign key (inherits_from) 
       references identityiq.spt_account_group (id);

    alter table identityiq.spt_account_group_inheritance 
       add constraint FKmapn2o892qhdmaa1r4lemvgax 
       foreign key (account_group) 
       references identityiq.spt_account_group (id);

    alter table identityiq.spt_account_group_perms 
       add constraint FKiapqdfk3kcuq5jv68yxi5x7tx 
       foreign key (accountgroup) 
       references identityiq.spt_account_group (id);

    alter table identityiq.spt_account_group_target_perms 
       add constraint FK13f1jdxrqvk98rjhyw2nsywcj 
       foreign key (accountgroup) 
       references identityiq.spt_account_group (id);

    alter table identityiq.spt_activity_constraint 
       add constraint FKh07lkkaqonsf23oaqaiiowgxa 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_activity_constraint 
       add constraint FK84atg8et8jhm2q2xrbc8y3mmg 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_activity_constraint 
       add constraint FK54edcjc3jxlcm0n4x49vwmqbr 
       foreign key (policy) 
       references identityiq.spt_policy (id);

    alter table identityiq.spt_activity_constraint 
       add constraint FKi1i3q8kvh4ed7e734iwrmbkqp 
       foreign key (violation_owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_activity_constraint 
       add constraint FKe1iukekxihoxdeji16gk4540c 
       foreign key (violation_owner_rule) 
       references identityiq.spt_rule (id);

    alter table identityiq.spt_activity_data_source 
       add constraint FK4nyoyf6fj2n0iqv4x6hy3p5a0 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_activity_data_source 
       add constraint FK9xs1b8n9mbigik443n155ils7 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_activity_data_source 
       add constraint FKa7oof6hhnyj73cgy991qj4159 
       foreign key (correlation_rule) 
       references identityiq.spt_rule (id);

    alter table identityiq.spt_activity_data_source 
       add constraint FK4t11m9gcjjxe4uhtlkab3mkh4 
       foreign key (transformation_rule) 
       references identityiq.spt_rule (id);

    alter table identityiq.spt_activity_data_source 
       add constraint FKqh1mk9ywu09wfephle51xm9j 
       foreign key (application) 
       references identityiq.spt_application (id);

    alter table identityiq.spt_activity_time_periods 
       add constraint FKdf7oxva0h2xktfgb8ro54gd5 
       foreign key (time_period) 
       references identityiq.spt_time_period (id);

    alter table identityiq.spt_activity_time_periods 
       add constraint FKbxg0qs6lvogays6vb2niyqgjk 
       foreign key (application_activity) 
       references identityiq.spt_application_activity (id);

    alter table identityiq.spt_alert 
       add constraint FKjpmc8vdbv8mso3deakv8qi5dd 
       foreign key (source) 
       references identityiq.spt_application (id);

    alter table identityiq.spt_alert_action 
       add constraint FK4kt6nnjdocmdkgcv3wgdfvfyg 
       foreign key (alert) 
       references identityiq.spt_alert (id);

    alter table identityiq.spt_alert_definition 
       add constraint FKm2f36vhlf1u9vnf5w1rm21i0q 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_alert_definition 
       add constraint FK7nrecpxk2mr7mwgli5tk5kiq9 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_app_dependencies 
       add constraint FKg99wvor3c1wxfmvd1j1vekrk1 
       foreign key (dependency) 
       references identityiq.spt_application (id);

    alter table identityiq.spt_app_dependencies 
       add constraint FKfimmxii9xcyjfmgd0489d2q61 
       foreign key (application) 
       references identityiq.spt_application (id);

    alter table identityiq.spt_application 
       add constraint FKo50q3ykyumpddcaaokonvivah 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_application 
       add constraint FKjrqhmrsoaxkmetjcd0y3vo09r 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_application 
       add constraint FKr6orbi6gkpkds9hrhowsym3yy 
       foreign key (proxy) 
       references identityiq.spt_application (id);

    alter table identityiq.spt_application 
       add constraint FKo2741mu93ute68xlirxg7ysja 
       foreign key (correlation_rule) 
       references identityiq.spt_rule (id);

    alter table identityiq.spt_application 
       add constraint FKam9m6cw3jgye54ltd2xrnk818 
       foreign key (creation_rule) 
       references identityiq.spt_rule (id);

    alter table identityiq.spt_application 
       add constraint FK27agl8inv18vxa370rnhbss30 
       foreign key (manager_correlation_rule) 
       references identityiq.spt_rule (id);

    alter table identityiq.spt_application 
       add constraint FKntlbgo69p5yhm3litlje9798g 
       foreign key (customization_rule) 
       references identityiq.spt_rule (id);

    alter table identityiq.spt_application 
       add constraint FKinlcagndni6i9xdctdivcl2ne 
       foreign key (managed_attr_customize_rule) 
       references identityiq.spt_rule (id);

    alter table identityiq.spt_application 
       add constraint FKhwhrrykvnnguijemwxxd5sn8t 
       foreign key (account_correlation_config) 
       references identityiq.spt_correlation_config (id);

    alter table identityiq.spt_application 
       add constraint FKpen32pdmnkn8icwjkusye7uul 
       foreign key (scorecard) 
       references identityiq.spt_application_scorecard (id);

    alter table identityiq.spt_application 
       add constraint FKbdx986tnctokxdrqw8q77s5rm 
       foreign key (target_source) 
       references identityiq.spt_target_source (id);

    alter table identityiq.spt_application_remediators 
       add constraint FK362oq0bg8kyjh8a8x6b870jkx 
       foreign key (elt) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_application_remediators 
       add constraint FK8csqgw7ff1rb2f1y0gtl4nbcc 
       foreign key (application) 
       references identityiq.spt_application (id);

    alter table identityiq.spt_application_activity 
       add constraint FKp0r4scrot0prnyokpjxt2649j 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_application_schema 
       add constraint FKkd8l977v65omox0wln8f6j20u 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_application_schema 
       add constraint FKl0g1ud8tainvo5qqgw0vsyum6 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_application_schema 
       add constraint FK4sj1w1c5l3xn6dl2mbfmcgq95 
       foreign key (creation_rule) 
       references identityiq.spt_rule (id);

    alter table identityiq.spt_application_schema 
       add constraint FKcm5n6jy4gyawyrrv3ge1e7fqc 
       foreign key (customization_rule) 
       references identityiq.spt_rule (id);

    alter table identityiq.spt_application_schema 
       add constraint FKov3msut61m895vk42fljyh68i 
       foreign key (correlation_rule) 
       references identityiq.spt_rule (id);

    alter table identityiq.spt_application_schema 
       add constraint FK78hblkspg3qrgy9uy4yh6amt2 
       foreign key (refresh_rule) 
       references identityiq.spt_rule (id);

    alter table identityiq.spt_application_schema 
       add constraint FKd3sov5jd5q1tvg43bervh4isw 
       foreign key (application) 
       references identityiq.spt_application (id);

    alter table identityiq.spt_application_scorecard 
       add constraint FKgq6j2537q2t6enu2ots2gwlug 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_application_scorecard 
       add constraint FKd25itmjnbgivvbvknkbs4dko2 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_application_scorecard 
       add constraint FKncvny5il4loprlf8ed4vkkm5o 
       foreign key (application_id) 
       references identityiq.spt_application (id);

    alter table identityiq.spt_app_secondary_owners 
       add constraint FKre2f8vro021ipil4lgflrrx9p 
       foreign key (elt) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_app_secondary_owners 
       add constraint FK5paly2u3hu7s3cnlx9er1tcfg 
       foreign key (application) 
       references identityiq.spt_application (id);

    alter table identityiq.spt_arch_cert_item_apps 
       add constraint FKjsbh6q9006l09jd5qso3kyn33 
       foreign key (arch_cert_item_id) 
       references identityiq.spt_archived_cert_item (id);

    alter table identityiq.spt_attachment 
       add constraint FKbyb94bn214vosuh3a9cr6ydi3 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_attachment 
       add constraint FKn1iv5d2bgun4hh7gmnyqyl0u7 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_audit_config 
       add constraint FKn99ngjtt90uu0e6osp4ben0k0 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_audit_config 
       add constraint FKnbd331q7w6aqq9xs5d2wmi63u 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_audit_event 
       add constraint FKhhxtrj41bo44qrvg1d0m5ytsy 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_audit_event 
       add constraint FK98m5i7uik1q162vtvklx4uwxy 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_authentication_answer 
       add constraint FKg7ahr1e8ce0qnpwy5ukybfdlc 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_authentication_answer 
       add constraint FKeadtkbftr4xwev6djc6bt0crh 
       foreign key (identity_id) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_authentication_answer 
       add constraint FKt1ogpk91rvbm8w1e532nocdif 
       foreign key (question_id) 
       references identityiq.spt_authentication_question (id);

    alter table identityiq.spt_authentication_question 
       add constraint FKo1do8f67g11idf1a7147kjvvi 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_authentication_question 
       add constraint FKhwy7jvglm1yvvhjej8npruff2 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_batch_request 
       add constraint FKkv0v31yspj4ga5o9x6pigtmbk 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_batch_request 
       add constraint FKmi63tgq6kqghkrypoin7pqh5a 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_batch_request_item 
       add constraint FK4uxgxj681uaiqpw0qku9fu49p 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_batch_request_item 
       add constraint FK8utyq880cffo95ui7mxr5tok8 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_batch_request_item 
       add constraint FKocx3j2y8pqextntj6l74qvlcj 
       foreign key (batch_request_id) 
       references identityiq.spt_batch_request (id);

    alter table identityiq.spt_bundle 
       add constraint FKo1g4dgf57gojmopj8cmavgxjk 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_bundle 
       add constraint FKbke0asxsp6fxyv9i8ax4dfis0 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_bundle 
       add constraint FKimfl4xyw45yyv2wvsq9ymploe 
       foreign key (join_rule) 
       references identityiq.spt_rule (id);

    alter table identityiq.spt_bundle 
       add constraint FKg6aah205ahbj6cdnu067npuqn 
       foreign key (pending_workflow) 
       references identityiq.spt_workflow_case (id);

    alter table identityiq.spt_bundle 
       add constraint FKouwy1vyabs54byfgq0md6xg98 
       foreign key (role_index) 
       references identityiq.spt_role_index (id);

    alter table identityiq.spt_bundle 
       add constraint FK8q7rqxa31n8e4byky2su1aul7 
       foreign key (scorecard) 
       references identityiq.spt_role_scorecard (id);

    alter table identityiq.spt_bundle_archive 
       add constraint FK9ikprcio0wk332m95ja8i99nm 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_bundle_archive 
       add constraint FKsoj8lev1leryowpm7imnqq2g1 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_bundle_children 
       add constraint FKb47g0894bupcgkm3ram9lepgi 
       foreign key (child) 
       references identityiq.spt_bundle (id);

    alter table identityiq.spt_bundle_children 
       add constraint FKsislghstl6iawguwrnvx76rpk 
       foreign key (bundle) 
       references identityiq.spt_bundle (id);

    alter table identityiq.spt_bundle_permits 
       add constraint FKi5wtu493fivl2kxblg9ei0f51 
       foreign key (child) 
       references identityiq.spt_bundle (id);

    alter table identityiq.spt_bundle_permits 
       add constraint FKcclfiby5ny4jprvjkhd2wyy14 
       foreign key (bundle) 
       references identityiq.spt_bundle (id);

    alter table identityiq.spt_bundle_profile_relation 
       add constraint FKmagmq7lgmic1artsln48lpcaw 
       foreign key (source_application) 
       references identityiq.spt_application (id);

    alter table identityiq.spt_bundle_profile_relation_step 
       add constraint FK9ge6smvhp8n0fcl408e86tvia 
       foreign key (bundle_profile_relation_id) 
       references identityiq.spt_bundle_profile_relation (id);

    alter table identityiq.spt_bundle_requirements 
       add constraint FKf5ff4s6ac2kr4tdan3hoxpogn 
       foreign key (child) 
       references identityiq.spt_bundle (id);

    alter table identityiq.spt_bundle_requirements 
       add constraint FKmwhuhsy3pxr2qfitnua7s12rf 
       foreign key (bundle) 
       references identityiq.spt_bundle (id);

    alter table identityiq.spt_capability 
       add constraint FKfc37j2eq2ue3bkwjujokswgwv 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_capability 
       add constraint FKhw853kl2ued70sd1fofo2fo2f 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_capability_children 
       add constraint FKcustr3gvq1r7v2dsv0635gyal 
       foreign key (child_id) 
       references identityiq.spt_capability (id);

    alter table identityiq.spt_capability_children 
       add constraint FKj5rdhd8hf7vrwg06pvvnewevy 
       foreign key (capability_id) 
       references identityiq.spt_capability (id);

    alter table identityiq.spt_capability_rights 
       add constraint FK2ly05h392vp6y87sw157to4if 
       foreign key (right_id) 
       references identityiq.spt_right (id);

    alter table identityiq.spt_capability_rights 
       add constraint FK5hked97sfwstl920p4xpbj7d9 
       foreign key (capability_id) 
       references identityiq.spt_capability (id);

    alter table identityiq.spt_category 
       add constraint FK6ly2lvlw1x3co3kllh32w9it 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_category 
       add constraint FKh9mqo4to3wcj85auwfd1v0vuq 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_cert_action_assoc 
       add constraint FK7lf26b9a79fiq8ra40n6c9jox 
       foreign key (child_id) 
       references identityiq.spt_certification_action (id);

    alter table identityiq.spt_cert_action_assoc 
       add constraint FKimetcxjfnxeb3uxisl0re6h7c 
       foreign key (parent_id) 
       references identityiq.spt_certification_action (id);

    alter table identityiq.spt_certification 
       add constraint FKkam40wtg536xdls5oxfov4o42 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_certification 
       add constraint FKnqhv931l5n1bu20lpcqwplr6x 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_certification 
       add constraint FKawqph0q6n3ikiqhhytcm8dnbe 
       foreign key (parent) 
       references identityiq.spt_certification (id);

    alter table identityiq.spt_certification_def_tags 
       add constraint FKiqp17o6qbtywuq5xa0i7ftbdq 
       foreign key (elt) 
       references identityiq.spt_tag (id);

    alter table identityiq.spt_certification_def_tags 
       add constraint FK874kcq4p7hyw2ai9h2ctm1olh 
       foreign key (cert_def_id) 
       references identityiq.spt_certification_definition (id);

    alter table identityiq.spt_certification_groups 
       add constraint FKex7xpxslou4ye7adrputklihy 
       foreign key (group_id) 
       references identityiq.spt_certification_group (id);

    alter table identityiq.spt_certification_groups 
       add constraint FKil0cc1sbmueu7oiptxr3j62px 
       foreign key (certification_id) 
       references identityiq.spt_certification (id);

    alter table identityiq.spt_certification_tags 
       add constraint FK841eyy68p6495npv6dwpi04j0 
       foreign key (elt) 
       references identityiq.spt_tag (id);

    alter table identityiq.spt_certification_tags 
       add constraint FKgpbsjaoc1wocq3euppijv9p15 
       foreign key (certification_id) 
       references identityiq.spt_certification (id);

    alter table identityiq.spt_certification_action 
       add constraint FKi48dvgroqefpxtfa7pweh6o8b 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_certification_action 
       add constraint FK6vi46tjqxbjj146o4o2g4nyfs 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_certification_action 
       add constraint FKqfesh5gjixog7vmn3smfijoij 
       foreign key (source_action) 
       references identityiq.spt_certification_action (id);

    alter table identityiq.spt_certification_archive 
       add constraint FK1hkx6vis9eb73wy7c4pc1b8vf 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_certification_archive 
       add constraint FK7mfm8h2b8nn9atr7qh5qly4l5 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_certification_challenge 
       add constraint FKf7hyeykya823607fv2qvgdloe 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_certification_challenge 
       add constraint FK22gq5pf504r23jw4knwce7xs5 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_certification_definition 
       add constraint FKcr18syune0mkqk7ixr4jth5le 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_certification_definition 
       add constraint FKgd080tua8dkp274bq1wapbb1a 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_certification_delegation 
       add constraint FK23qqsi30cp25uv1am5yurcq0j 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_certification_delegation 
       add constraint FKgxejqcvofo95foucj5vg4u3qs 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_certification_entity 
       add constraint FKip367cn9lac3qe96fw0ccljd1 
       foreign key (certification_id) 
       references identityiq.spt_certification (id);

    alter table identityiq.spt_certification_entity 
       add constraint FK_8ldyhh9o0vcq3n294rbfjs415 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_certification_entity 
       add constraint FK_94kwlqdf1rlbuj6l25e71dg6c 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_certification_entity 
       add constraint FK_4kgyc7xxjq27248f3cpe2hhu 
       foreign key (action) 
       references identityiq.spt_certification_action (id);

    alter table identityiq.spt_certification_entity 
       add constraint FK_hyixy5s22roljj5pk6ir6xd2p 
       foreign key (delegation) 
       references identityiq.spt_certification_delegation (id);

    alter table identityiq.spt_certification_group 
       add constraint FKlhja2iwhg5a62sq6f1buj2axo 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_certification_group 
       add constraint FKqkcuv3m20nm9bgj5lp1f0pvae 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_certification_group 
       add constraint FKkekr0ucddvo7a8l6gcrccuudg 
       foreign key (certification_definition) 
       references identityiq.spt_certification_definition (id);

    alter table identityiq.spt_certification_item 
       add constraint FKlge6i5dbsbcsnxg6elephhq18 
       foreign key (certification_entity_id) 
       references identityiq.spt_certification_entity (id);

    alter table identityiq.spt_certification_item 
       add constraint FKnwb5vj6hwftfgtl9f283rvsfg 
       foreign key (exception_entitlements) 
       references identityiq.spt_entitlement_snapshot (id);

    alter table identityiq.spt_certification_item 
       add constraint FKns942qq8bd2upr6b66wbaiekj 
       foreign key (challenge) 
       references identityiq.spt_certification_challenge (id);

    alter table identityiq.spt_certification_item 
       add constraint FK_2bwhd2rbxp1nvs39jxf4dothm 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_certification_item 
       add constraint FK_183ktprgvdwfefivf1699hd02 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_certification_item 
       add constraint FK_sqwuid379j4nfp6ykmbacjrk 
       foreign key (action) 
       references identityiq.spt_certification_action (id);

    alter table identityiq.spt_certification_item 
       add constraint FK_1w71laay1l62qeujievv5l3gg 
       foreign key (delegation) 
       references identityiq.spt_certification_delegation (id);

    alter table identityiq.spt_certifiers 
       add constraint FKq2kybcv1awb6cte2q45gkupei 
       foreign key (certification_id) 
       references identityiq.spt_certification (id);

    alter table identityiq.spt_cert_item_applications 
       add constraint FKmgki0koeep17cgfpir44de6mj 
       foreign key (certification_item_id) 
       references identityiq.spt_certification_item (id);

    alter table identityiq.spt_cert_item_classifications 
       add constraint FK9dehgtst8bbi31palx2ygp8hi 
       foreign key (certification_item) 
       references identityiq.spt_certification_item (id);

    alter table identityiq.spt_child_certification_ids 
       add constraint FK9syrav59593wgi39hrnt8kgk5 
       foreign key (certification_archive_id) 
       references identityiq.spt_certification_archive (id);

    alter table identityiq.spt_cloud_access3way 
       add constraint FK25ss4xxt4e2nvwcd8ne1iw3b4 
       foreign key (cloud_access_group) 
       references identityiq.spt_cloud_access_group (id);

    alter table identityiq.spt_cloud_access3way 
       add constraint FK6o7a9k31y9pc0xy7bd24uoqu5 
       foreign key (cloud_access_role) 
       references identityiq.spt_cloud_access_role (id);

    alter table identityiq.spt_cloud_access3way 
       add constraint FKe65krw4kpvcduwmsp1mggynbg 
       foreign key (cloud_access_scope) 
       references identityiq.spt_cloud_access_scope (id);

    alter table identityiq.spt_configuration 
       add constraint FKhjkwvbp3m63yllk6lbo4bqro7 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_configuration 
       add constraint FKp90cf11ijtygd9hxlgyo0psaa 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_correlation_config 
       add constraint FK8e7jfdj8slsjmmtl9saxefuep 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_correlation_config 
       add constraint FKrguogs2r8ljaxdto8u4h3e9tk 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_custom 
       add constraint FKn2tjdgfk4rvy3vosf1v3kac2t 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_custom 
       add constraint FKlkx2x8fdy1rwhtnntacydwmek 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_deleted_object 
       add constraint FK18xcbn9moxo06bcfyg6l7ggcy 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_deleted_object 
       add constraint FK187408eyxdoomujowu44neqde 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_deleted_object 
       add constraint FKe7dmgcmhkb13omi8dkh2ig89f 
       foreign key (application) 
       references identityiq.spt_application (id);

    alter table identityiq.spt_dictionary 
       add constraint FKauca1novn79fd19aug3bjsqya 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_dictionary 
       add constraint FK7kdy9g1knlowpv3v4rtn7w1py 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_dictionary_term 
       add constraint FKcyplq38o2e3ajj515xs3vfrf3 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_dictionary_term 
       add constraint FK1lnmjjwf7i80cupehvm066hdf 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_dictionary_term 
       add constraint FKrtfr7u5wa0hngye2pixfgfjtq 
       foreign key (dictionary_id) 
       references identityiq.spt_dictionary (id);

    alter table identityiq.spt_dynamic_scope 
       add constraint FKibw7yhehyvo75yf2gqp4nj5iq 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_dynamic_scope 
       add constraint FKpygxoi3poo3klc46c5o72qe48 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_dynamic_scope 
       add constraint FK1v3xd4m55jijgosuof9e6glj8 
       foreign key (role_request_control) 
       references identityiq.spt_rule (id);

    alter table identityiq.spt_dynamic_scope 
       add constraint FKcv5id4r7gnsso13xjubxaqnkp 
       foreign key (application_request_control) 
       references identityiq.spt_rule (id);

    alter table identityiq.spt_dynamic_scope 
       add constraint FKktwyfv8gvs56q5ilfuguki5l5 
       foreign key (managed_attr_request_control) 
       references identityiq.spt_rule (id);

    alter table identityiq.spt_dynamic_scope 
       add constraint FKtktdhh12wn2ah31yrges9oiu1 
       foreign key (role_remove_control) 
       references identityiq.spt_rule (id);

    alter table identityiq.spt_dynamic_scope 
       add constraint FKexhlawv29rux6bct75f19h91v 
       foreign key (application_remove_control) 
       references identityiq.spt_rule (id);

    alter table identityiq.spt_dynamic_scope 
       add constraint FK5qib64c7xdiovhut2k81054iu 
       foreign key (managed_attr_remove_control) 
       references identityiq.spt_rule (id);

    alter table identityiq.spt_dynamic_scope_exclusions 
       add constraint FKrmu2wy5qkgpggwyvtlssi5ehk 
       foreign key (identity_id) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_dynamic_scope_exclusions 
       add constraint FK6y9ox5g2qxpgjp2jp69qqsj1g 
       foreign key (dynamic_scope_id) 
       references identityiq.spt_dynamic_scope (id);

    alter table identityiq.spt_dynamic_scope_inclusions 
       add constraint FK3ggbccvk2ambqjdw8iynyt965 
       foreign key (identity_id) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_dynamic_scope_inclusions 
       add constraint FKol4cq5u3jcqik19amte10slgr 
       foreign key (dynamic_scope_id) 
       references identityiq.spt_dynamic_scope (id);

    alter table identityiq.spt_email_template 
       add constraint FKbgbd2hiyxohe6mp0wks9w7i6m 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_email_template 
       add constraint FKnn3hbn1pd7e492186rskdwd3c 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_email_template_properties 
       add constraint emailtemplateproperties 
       foreign key (id) 
       references identityiq.spt_email_template (id);

    alter table identityiq.spt_entitlement_group 
       add constraint FKhejppx2y8jb7gn2f5kow3rd4s 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_entitlement_group 
       add constraint FKtckmuosehsos4esc6e7aw96x2 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_entitlement_group 
       add constraint FKkgvp9pnx75witsnhfhmi2j3e 
       foreign key (application) 
       references identityiq.spt_application (id);

    alter table identityiq.spt_entitlement_group 
       add constraint FK2r4pe9yr6ieul6o7j3gbh4ek4 
       foreign key (identity_id) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_entitlement_snapshot 
       add constraint FKg28gich6xc717ufitfs9b7ho8 
       foreign key (certification_item_id) 
       references identityiq.spt_certification_item (id);

    alter table identityiq.spt_file_bucket 
       add constraint FK4j1imfpmt238fhglhfh95rrs8 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_file_bucket 
       add constraint FKaw7g3a6la8gky8coehtta2u32 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_file_bucket 
       add constraint FK59ymu1g5ld3l6j97mx7uq0jfb 
       foreign key (parent_id) 
       references identityiq.spt_persisted_file (id);

    alter table identityiq.spt_form 
       add constraint FKblc1wv6n85ie3ajioskbhtb87 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_form 
       add constraint FK7j84f82idyeb2pu1giatg6b00 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_form 
       add constraint FKrwbs6jyeoe0f24q9u878kktna 
       foreign key (application) 
       references identityiq.spt_application (id);

    alter table identityiq.spt_generic_constraint 
       add constraint FK2vhfe3qafdd3ok28mm1h90om9 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_generic_constraint 
       add constraint FKi7nk6nu4vkvasene3f14mnykm 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_generic_constraint 
       add constraint FKkthxi9af57y8xjm6pps9h8lr4 
       foreign key (policy) 
       references identityiq.spt_policy (id);

    alter table identityiq.spt_generic_constraint 
       add constraint FKedawydx5t9h0xmnps51w6krpb 
       foreign key (violation_owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_generic_constraint 
       add constraint FK6oqb9qqui7wajajasxflcfcnb 
       foreign key (violation_owner_rule) 
       references identityiq.spt_rule (id);

    alter table identityiq.spt_group_definition 
       add constraint FKku7t8vcce9maxmpgh025h8rpm 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_group_definition 
       add constraint FKgpkyterj8orw9ue1ecnaxcxac 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_group_definition 
       add constraint FKsswaiwl9wgq1x7x66w7dw73sr 
       foreign key (factory) 
       references identityiq.spt_group_factory (id);

    alter table identityiq.spt_group_definition 
       add constraint FKhxm0nnx7gf472ykocqgl9yxne 
       foreign key (group_index) 
       references identityiq.spt_group_index (id);

    alter table identityiq.spt_group_factory 
       add constraint FKh274opn41khwnbi0yj2n37ftm 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_group_factory 
       add constraint FK4l56xl5r807s9o9clecfa83sp 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_group_factory 
       add constraint FKhbdh4oyxsx9mqfsnvk57vqotk 
       foreign key (group_owner_rule) 
       references identityiq.spt_rule (id);

    alter table identityiq.spt_group_index 
       add constraint FKf94ksv2vpcmefy7dtedsr4d8i 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_group_index 
       add constraint FKqvs2uruibvlbl9he3319jiy67 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_group_index 
       add constraint FKk8c1wd9ht5mtgdkgr6w2pwx07 
       foreign key (definition) 
       references identityiq.spt_group_definition (id);

    alter table identityiq.spt_group_permissions 
       add constraint FKcratih77tg9y9028xrpsiy0x5 
       foreign key (entitlement_group_id) 
       references identityiq.spt_entitlement_group (id);

    alter table identityiq.spt_identity 
       add constraint FKdco8at7cn3mnhjf6xaahalooj 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_identity 
       add constraint FKikbm1x7vdijclac4vu15u5ovv 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_identity 
       add constraint FKoq0aevty64ohgu1m3y5n2odfb 
       foreign key (extended_identity1) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_identity 
       add constraint FKkpuohy1m4u7hhicokkoixnh3v 
       foreign key (extended_identity2) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_identity 
       add constraint FK6yjqfgtb1teavu30xemwke50h 
       foreign key (extended_identity3) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_identity 
       add constraint FK996is5ceoc7ssc7n0cfgavp1n 
       foreign key (extended_identity4) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_identity 
       add constraint FKl62tfosnxhkn8al4i5m098g6l 
       foreign key (extended_identity5) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_identity 
       add constraint FK7l1j3c1e9yne2d7ercls5w169 
       foreign key (manager) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_identity 
       add constraint FK6erec9yefdkhc6gj4g6wpufv9 
       foreign key (administrator) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_identity 
       add constraint FK8ro3qhcvypwaofa3yrnal3fsi 
       foreign key (scorecard) 
       references identityiq.spt_scorecard (id);

    alter table identityiq.spt_identity 
       add constraint FKaw4ye4m198dibbj2atxjg85m7 
       foreign key (uipreferences) 
       references identityiq.spt_uipreferences (id);

    alter table identityiq.spt_identity_archive 
       add constraint FKp8j75f2pk9xvqyimweu32w6f8 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_identity_archive 
       add constraint FKmridtwmjtph1265lllya9w2mn 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_identity_assigned_roles 
       add constraint FKheohgr0xuxklx9sfhjde58ig9 
       foreign key (bundle) 
       references identityiq.spt_bundle (id);

    alter table identityiq.spt_identity_assigned_roles 
       add constraint FKf367abg77497pwgtr61co5mc 
       foreign key (identity_id) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_identity_bundles 
       add constraint FKmr5pwrd4ysq4uiy970s0gpija 
       foreign key (bundle) 
       references identityiq.spt_bundle (id);

    alter table identityiq.spt_identity_bundles 
       add constraint FKcuq8yi3rh1dxbbr7nt33io0h4 
       foreign key (identity_id) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_identity_capabilities 
       add constraint FK8rvftn57xdt7vtg3oe2i3bn7i 
       foreign key (capability_id) 
       references identityiq.spt_capability (id);

    alter table identityiq.spt_identity_capabilities 
       add constraint FKe9bo37xbckkaq2k85omvmo9ld 
       foreign key (identity_id) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_identity_controlled_scopes 
       add constraint FKoahj6hw5kk9163bfes49lvasv 
       foreign key (scope_id) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_identity_controlled_scopes 
       add constraint FKqjnmhlsld4pvlix9kbrvlmsb1 
       foreign key (identity_id) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_identity_entitlement 
       add constraint FKlnoli5e2k3cofry0kh5lqwvk2 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_identity_entitlement 
       add constraint FKqy3hyiptyuoo0ik8nfewymdio 
       foreign key (application) 
       references identityiq.spt_application (id);

    alter table identityiq.spt_identity_entitlement 
       add constraint FKjief1jwgixlilqiqsvkpx0k9e 
       foreign key (identity_id) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_identity_entitlement 
       add constraint FK9p3id5o2as2stlq47md58fm3b 
       foreign key (request_item) 
       references identityiq.spt_identity_request_item (id);

    alter table identityiq.spt_identity_entitlement 
       add constraint FKcn0l4kl1lpjkg7usf4okua4d8 
       foreign key (pending_request_item) 
       references identityiq.spt_identity_request_item (id);

    alter table identityiq.spt_identity_entitlement 
       add constraint FKbpm8wgk9stf16g8w9ujx10qw3 
       foreign key (certification_item) 
       references identityiq.spt_certification_item (id);

    alter table identityiq.spt_identity_entitlement 
       add constraint FK6cwcsuwgv6ydwqpnm6jto062q 
       foreign key (pending_certification_item) 
       references identityiq.spt_certification_item (id);

    alter table identityiq.spt_identity_history_item 
       add constraint FKji55d6komkmaodbat8ykt27ut 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_identity_history_item 
       add constraint FKa9cu5shr2oefnkrrew96b98nc 
       foreign key (identity_id) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_identity_request 
       add constraint FKrnecq87gn8rjrj2vbn9koxwc1 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_identity_request 
       add constraint FKpstoy7u3dse9pl2h5ryub6h0w 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_identity_request_item 
       add constraint FKdrgm0omo927u9hkgtx0m4rbmb 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_identity_request_item 
       add constraint FKfax65ddwd2dwvkt9rsdqthshd 
       foreign key (identity_request_id) 
       references identityiq.spt_identity_request (id);

    alter table identityiq.spt_identity_role_metadata 
       add constraint FKlbwupgie8o3gpjt857djjipg9 
       foreign key (role_metadata_id) 
       references identityiq.spt_role_metadata (id);

    alter table identityiq.spt_identity_role_metadata 
       add constraint FKptvypo1q0ekqnlnt7tkl1u2na 
       foreign key (identity_id) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_identity_snapshot 
       add constraint FKh03yxqsq7ebvwlwcthihtym07 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_identity_snapshot 
       add constraint FKj24y3i8my2r0c3il58dlww3fa 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_identity_trigger 
       add constraint FKaoupv62m0yus73314iwn0fclq 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_identity_trigger 
       add constraint FK6est6a8xpuhjgqv7b0d8yvmal 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_identity_trigger 
       add constraint FK4yqufhetuoj6wig3t5n5rw7xh 
       foreign key (rule_id) 
       references identityiq.spt_rule (id);

    alter table identityiq.spt_identity_workgroups 
       add constraint FKew5309x0hinshtjed2o9p4lu8 
       foreign key (workgroup) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_identity_workgroups 
       add constraint FKdubcl4txlwq72y89p09vsokp3 
       foreign key (identity_id) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_integration_config 
       add constraint FK9i40hwin9s24k40gf9jbcjmyg 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_integration_config 
       add constraint FKkra0w53mfbawmb7tun0thw07j 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_integration_config 
       add constraint FK4m8ag5j3ca0w07n396xv4ovlx 
       foreign key (plan_initializer) 
       references identityiq.spt_rule (id);

    alter table identityiq.spt_integration_config 
       add constraint FKnn9f0lgf5ewip65a8t2mhi97u 
       foreign key (application_id) 
       references identityiq.spt_application (id);

    alter table identityiq.spt_integration_config 
       add constraint FK7dcjq7gk21x6gl2w55r9rgnnq 
       foreign key (container_id) 
       references identityiq.spt_bundle (id);

    alter table identityiq.spt_jasper_files 
       add constraint FKarvo68602qubbljqm974ejrao 
       foreign key (elt) 
       references identityiq.spt_persisted_file (id);

    alter table identityiq.spt_jasper_files 
       add constraint FK38q00anepn1enkf14vh5kt0p0 
       foreign key (result) 
       references identityiq.spt_jasper_result (id);

    alter table identityiq.spt_jasper_page_bucket 
       add constraint FK7ajqlhkio1lj6deitro8rufr4 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_jasper_page_bucket 
       add constraint FKebcpjeggovthx5rfslffvm06l 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_jasper_result 
       add constraint FKaov2d8748uea72k8riblr9iw 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_jasper_result 
       add constraint FK48lfhuwg00rdb7lu24q8iqemj 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_jasper_template 
       add constraint FK9gqhh1f6h8uvb0ijwd2x8d3xd 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_jasper_template 
       add constraint FKd7fy4u4sv1o5q0oen7ip2trng 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_link 
       add constraint FKlt4unsy5cp7psyl716sjq527e 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_link 
       add constraint FKg0l571s3kkovl1l5q24wsn5h2 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_link 
       add constraint FK7do4oyl8j399aynq34dosvk6o 
       foreign key (identity_id) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_link 
       add constraint FKsc0du71d7t0p5jx4sqbwlrtc7 
       foreign key (application) 
       references identityiq.spt_application (id);

    alter table identityiq.spt_localized_attribute 
       add constraint FK4ahm8gyl5gwhj8d4qgbwyynv 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_managed_attribute 
       add constraint FK3gb72xtjki5mp7uosqt8y4pvn 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_managed_attribute 
       add constraint FKp22ur089e238refu7d4ey3vad 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_managed_attribute 
       add constraint FKh34qiq4aglfffr9xwpik781vj 
       foreign key (application) 
       references identityiq.spt_application (id);

    alter table identityiq.spt_managed_attr_inheritance 
       add constraint FK4ioitymnwqibnmecupdfuo3ri 
       foreign key (inherits_from) 
       references identityiq.spt_managed_attribute (id);

    alter table identityiq.spt_managed_attr_inheritance 
       add constraint FK5w1va2uar8ndocw86uxw22fyx 
       foreign key (managedattribute) 
       references identityiq.spt_managed_attribute (id);

    alter table identityiq.spt_managed_attr_perms 
       add constraint FKgb5h5u8b3v7q8thhsyw3a3x2d 
       foreign key (managedattribute) 
       references identityiq.spt_managed_attribute (id);

    alter table identityiq.spt_managed_attr_target_perms 
       add constraint FKgxeh9kjs3fstpnq4tp0cch0h7 
       foreign key (managedattribute) 
       references identityiq.spt_managed_attribute (id);

    alter table identityiq.spt_message_template 
       add constraint FKbhf643rsydyey69y4clalwes3 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_message_template 
       add constraint FK93cucj6fysk1u4s1mggidhsjw 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_mining_config 
       add constraint FKe2p3b82e1gpt5n75cfkj19573 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_mining_config 
       add constraint FKo5ji502vpitlcnl4ie54trv3a 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_mitigation_expiration 
       add constraint FKpym4olxxt5hvtw2h6h5qehsg5 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_mitigation_expiration 
       add constraint FKnq1a0dvm762fk9tcucs5ro4h3 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_mitigation_expiration 
       add constraint FKrp62md93f75jd1i1hof0pdr01 
       foreign key (mitigator) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_mitigation_expiration 
       add constraint FKdk2mv4vumkj87erjys2ecjjqy 
       foreign key (identity_id) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_monitoring_statistic 
       add constraint FK1oylxmpnab6ukcexs91d4d3ps 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_monitoring_statistic 
       add constraint FK66fxpvt139gb5aghd369t0q1s 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_monitoring_statistic_tags 
       add constraint FKa6efhhukixvrd4fucp8n3hrlm 
       foreign key (elt) 
       references identityiq.spt_tag (id);

    alter table identityiq.spt_monitoring_statistic_tags 
       add constraint FKk900lsdj83sd0cp9o59evn9nj 
       foreign key (statistic_id) 
       references identityiq.spt_monitoring_statistic (id);

    alter table identityiq.spt_object_classification 
       add constraint FK4hfvqf5hc3a6rl944f4h171tn 
       foreign key (classification_id) 
       references identityiq.spt_classification (id);

    alter table identityiq.spt_object_config 
       add constraint FKtcjesncjqdcd4inr41kpgpwaj 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_object_config 
       add constraint FK1w6x1owivjjlgw0ojfk6aatm5 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_partition_result 
       add constraint FK9fa80qf6up4eunpumew96wmxr 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_partition_result 
       add constraint FKguaao9nkvy8wtshwdjls9qe17 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_partition_result 
       add constraint FK9svig87lf8npttavcvalbuipb 
       foreign key (task_result) 
       references identityiq.spt_task_result (id);

    alter table identityiq.spt_password_policy 
       add constraint FK15k2353b0bf4swvqkteyjutb8 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_password_policy_holder 
       add constraint FK47skxwy6vwmh6qdkoo76gao8c 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_password_policy_holder 
       add constraint FK4flfb6aud9uvwfhrdt228g7b7 
       foreign key (policy) 
       references identityiq.spt_password_policy (id);

    alter table identityiq.spt_password_policy_holder 
       add constraint FKsa0togid3d2ers5l0u8p0xxcp 
       foreign key (application) 
       references identityiq.spt_application (id);

    alter table identityiq.spt_persisted_file 
       add constraint FKay7i45q2li8p1lnvdybls0t3t 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_persisted_file 
       add constraint FKlj0anhv8hg741lmn738bahrek 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_plugin 
       add constraint FKr3gksq71itxj5f837unefrg31 
       foreign key (file_id) 
       references identityiq.spt_persisted_file (id);

    alter table identityiq.spt_policy 
       add constraint FKij2xlldhccmq534sl8n6587od 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_policy 
       add constraint FKoebw2yqhc4j26mx83v49qyw1n 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_policy 
       add constraint FK3cfyso96b28h21yaml8hbc3xi 
       foreign key (violation_owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_policy 
       add constraint FKgsvi652nk5hayfr8kc7p5ydy 
       foreign key (violation_owner_rule) 
       references identityiq.spt_rule (id);

    alter table identityiq.spt_policy_violation 
       add constraint FKgxlmr2yos1bq05bqb3kxjyhdy 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_policy_violation 
       add constraint FKlfnu8q3fgqq6w8l9t0v15gsjb 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_policy_violation 
       add constraint FKphiamrjv42wu7uw5tcsbexjyw 
       foreign key (identity_id) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_policy_violation 
       add constraint FKcfjl95jng7hghpw478qqgajyn 
       foreign key (pending_workflow) 
       references identityiq.spt_workflow_case (id);

    alter table identityiq.spt_process_log 
       add constraint FK7ll5fatw1p90l1quxoovyijej 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_process_log 
       add constraint FKtgm6rfk5nrdbjswf140ad6jir 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_profile 
       add constraint FKm77hrlacp3ynlthagggqmq8mn 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_profile 
       add constraint FKdpexklt6enpa3qq3tg34t2i72 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_profile 
       add constraint FKb6xsupwlh8e9b6sxrsojaq107 
       foreign key (bundle_id) 
       references identityiq.spt_bundle (id);

    alter table identityiq.spt_profile 
       add constraint FKh7gmx9te7hdnjh138f0ys70bb 
       foreign key (application) 
       references identityiq.spt_application (id);

    alter table identityiq.spt_profile_constraints 
       add constraint FKfnwocslrb1d7i22e0eyyonvu6 
       foreign key (profile) 
       references identityiq.spt_profile (id);

    alter table identityiq.spt_profile_permissions 
       add constraint FK9wkru2lsxssnhaus718md3f2o 
       foreign key (profile) 
       references identityiq.spt_profile (id);

    alter table identityiq.spt_provisioning_request 
       add constraint FKb0jveyf9sv2e042bjarn190pq 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_provisioning_request 
       add constraint FKgtk4uysamt32hwwqxrdnceodg 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_provisioning_request 
       add constraint FKe06usqanbltc3jw079m568c9d 
       foreign key (identity_id) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_quick_link 
       add constraint FKr34ji3ugpva0sp95usrgaooih 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_quick_link 
       add constraint FK8ircuuuw7sidwf8xmatked859 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_quick_link_options 
       add constraint FKr2janfsixof6pqahju9ab112u 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_quick_link_options 
       add constraint FK159pqn1fd0ubpapm62cy37akd 
       foreign key (dynamic_scope) 
       references identityiq.spt_dynamic_scope (id);

    alter table identityiq.spt_quick_link_options 
       add constraint FKihngfm8iqb21en8gyeebmpj7h 
       foreign key (quick_link) 
       references identityiq.spt_quick_link (id);

    alter table identityiq.spt_remediation_item 
       add constraint FKfd9yg9q55msovcqueyjodr6ui 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_remediation_item 
       add constraint FKhlirh9cempdr7546c4oegeska 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_remediation_item 
       add constraint FK6bb5fufbeok63cycwmdv1h0b3 
       foreign key (work_item_id) 
       references identityiq.spt_work_item (id);

    alter table identityiq.spt_remediation_item 
       add constraint FK1vhqs5ybkgm91lv51hdyj68va 
       foreign key (assignee) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_remote_login_token 
       add constraint FKe2ofoif1sjdi94r0rhwsc6aqg 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_remote_login_token 
       add constraint FK57qeahvi3aybfwrgf2mft28b0 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_request 
       add constraint FK4wuia2w4ylm95aja22jnw6upf 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_request 
       add constraint FK1st2f3b62703t2anet5iykocf 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_request 
       add constraint FK2oj2nqukawo2p60yiloa72li9 
       foreign key (definition) 
       references identityiq.spt_request_definition (id);

    alter table identityiq.spt_request 
       add constraint FKgwavtgcmunyt6bx3fvka2a5t2 
       foreign key (task_result) 
       references identityiq.spt_task_result (id);

    alter table identityiq.spt_request_arguments 
       add constraint FK113ggg7785j6vdwb9xham03dc 
       foreign key (signature) 
       references identityiq.spt_request_definition (id);

    alter table identityiq.spt_request_definition 
       add constraint FKgao87b86v1y7mrylu96ow04en 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_request_definition 
       add constraint FKhe297ysa9fn4dmdljoq54njbs 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_request_definition 
       add constraint FK2ttetyvbubn1jvp2n9urb6m5v 
       foreign key (parent) 
       references identityiq.spt_request_definition (id);

    alter table identityiq.spt_request_definition_rights 
       add constraint FKp94t40blskwg0fuh854lfml1s 
       foreign key (right_id) 
       references identityiq.spt_right (id);

    alter table identityiq.spt_request_definition_rights 
       add constraint FK3drvcyrlgw6waricqagimmd8e 
       foreign key (request_definition_id) 
       references identityiq.spt_request_definition (id);

    alter table identityiq.spt_request_returns 
       add constraint FKpbhfh39gtywh48gc1hlfgngox 
       foreign key (signature) 
       references identityiq.spt_request_definition (id);

    alter table identityiq.spt_request_state 
       add constraint FKqqjbvp3qvso1sb1ca6ombgter 
       foreign key (request_id) 
       references identityiq.spt_request (id);

    alter table identityiq.spt_resource_event 
       add constraint FKt1snjotqsqvmoubnwv5vtpri6 
       foreign key (application) 
       references identityiq.spt_application (id);

    alter table identityiq.spt_right_config 
       add constraint FKt1r57dhmuc884wt2ymu101hde 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_right_config 
       add constraint FKdx0b0oat38fxsye0jgg5ulu9k 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_role_index 
       add constraint FKo7ho4tlthd9rr80looh1ooito 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_role_index 
       add constraint FKf0j6gmnubunnb5h7kfe33awf9 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_role_index 
       add constraint FKl988ko9bkq0epm8ktn25tqpru 
       foreign key (bundle) 
       references identityiq.spt_bundle (id);

    alter table identityiq.spt_role_metadata 
       add constraint FKaa82j55vly3sm9ftky9obxd38 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_role_metadata 
       add constraint FKt5qt571k5ftna1xswfi723tat 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_role_metadata 
       add constraint FK78iwr88o7i8dt8ibvi3vusjq8 
       foreign key (role) 
       references identityiq.spt_bundle (id);

    alter table identityiq.spt_role_mining_result 
       add constraint FKjpslqep9tigfo52crhjg3hf5v 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_role_mining_result 
       add constraint FKtok5e8qk7b61q9h76g7h7pr86 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_role_scorecard 
       add constraint FKt6yfcgq98ed4bfi5ky81wjwdf 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_role_scorecard 
       add constraint FKqrtue6hcnlf6qyr5qm0vfpwfn 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_role_scorecard 
       add constraint FK4uodpdnn6r77dbqqa4ifdqja3 
       foreign key (role_id) 
       references identityiq.spt_bundle (id);

    alter table identityiq.spt_rule 
       add constraint FKebikrnbibarckvm36915k8dc7 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_rule 
       add constraint FKe7tgffr3v5sd2q739bndc72wr 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_rule_registry_callouts 
       add constraint FKiescqm7tqapb2r71sgdcy20jk 
       foreign key (rule_id) 
       references identityiq.spt_rule (id);

    alter table identityiq.spt_rule_registry_callouts 
       add constraint FK8csco7epf6euipthxuj0awqjp 
       foreign key (rule_registry_id) 
       references identityiq.spt_rule_registry (id);

    alter table identityiq.spt_rule_dependencies 
       add constraint FKbju0wunboll2jdihl7c4xa0no 
       foreign key (dependency) 
       references identityiq.spt_rule (id);

    alter table identityiq.spt_rule_dependencies 
       add constraint FKgvxim0ew7xui4cfpk0gibucxa 
       foreign key (rule_id) 
       references identityiq.spt_rule (id);

    alter table identityiq.spt_rule_registry 
       add constraint FKlswclannoqopuaet63sct4p74 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_rule_registry 
       add constraint FKthpyc5ikucmt8mbhdcr980ucg 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_rule_signature_arguments 
       add constraint FKdys6el89un39n7cyqey0sbdtt 
       foreign key (signature) 
       references identityiq.spt_rule (id);

    alter table identityiq.spt_rule_signature_returns 
       add constraint FKrbsto8otv99kfe9kgyij37iml 
       foreign key (signature) 
       references identityiq.spt_rule (id);

    alter table identityiq.spt_schema_attributes 
       add constraint FKhl9i3n7y97lpqq98etsp4urds 
       foreign key (applicationschema) 
       references identityiq.spt_application_schema (id);

    alter table identityiq.spt_scope 
       add constraint FKht5d7wfgqvify7p0nag6egr2 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_scope 
       add constraint FK984w9lkkhtcrm8ib3y6b2qj8 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_scope 
       add constraint FKpmmdhx9itj086j9dnu8ydh6gx 
       foreign key (parent_id) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_scorecard 
       add constraint FK4cgtntcjhmqgrb6fcgion7psd 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_scorecard 
       add constraint FKjlaay4af9d847oiooq03nwrkb 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_scorecard 
       add constraint FKhwgs2272xcw9kr4uobastkiqj 
       foreign key (identity_id) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_score_config 
       add constraint FK58s5g8wnl1pd9ckev17xhlfif 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_score_config 
       add constraint FKj2ff5smsk1haaiyo1w7q7pj99 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_score_config 
       add constraint FKdct987qb7na0fe12fov9gtp90 
       foreign key (right_config) 
       references identityiq.spt_right_config (id);

    alter table identityiq.spt_server_statistic 
       add constraint FKo4ubx9xkjeqxgnsil2kq8863b 
       foreign key (host) 
       references identityiq.spt_server (id);

    alter table identityiq.spt_server_statistic 
       add constraint FK5q7ultbynm7wn0wki1a0vhse7 
       foreign key (monitoring_statistic) 
       references identityiq.spt_monitoring_statistic (id);

    alter table identityiq.spt_service_lock 
       add constraint FKiq6v3rrxwrku71j0ghepn66p5 
       foreign key (service_definition) 
       references identityiq.spt_service_definition (id);

    alter table identityiq.spt_service_status 
       add constraint FKanvkx3ughno0yc6s33p8px5cu 
       foreign key (definition) 
       references identityiq.spt_service_definition (id);

    alter table identityiq.spt_sign_off_history 
       add constraint FKgltduyt883x1og6dkgpt9n0uj 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_sign_off_history 
       add constraint FK2ipk68cdtj3e4p6u5cp3y3ojc 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_sign_off_history 
       add constraint FKoqlo63ls25h06ufiwokvd8l9g 
       foreign key (certification_id) 
       references identityiq.spt_certification (id);

    alter table identityiq.spt_snapshot_permissions 
       add constraint FKd1pddppbj51lje4diqtw7ycs0 
       foreign key (snapshot) 
       references identityiq.spt_entitlement_snapshot (id);

    alter table identityiq.spt_sodconstraint 
       add constraint FKl4mjpujrolswau1wcu0mhn5yr 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_sodconstraint 
       add constraint FKkdcp13gq48ggdtye8pas782pb 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_sodconstraint 
       add constraint FKaoh6dc5hnbdth3l5s5el0ysg1 
       foreign key (policy) 
       references identityiq.spt_policy (id);

    alter table identityiq.spt_sodconstraint 
       add constraint FK4o50l0rmgaju9n8exvb3pdf5b 
       foreign key (violation_owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_sodconstraint 
       add constraint FKsb73wu7qhwhp6dsypgpor8dsi 
       foreign key (violation_owner_rule) 
       references identityiq.spt_rule (id);

    alter table identityiq.spt_sodconstraint_left 
       add constraint FKiaye28ptj6gmsp4tflo13r0qy 
       foreign key (businessrole) 
       references identityiq.spt_bundle (id);

    alter table identityiq.spt_sodconstraint_left 
       add constraint FKihnxab3mjkx483ftgngk6g0h1 
       foreign key (sodconstraint) 
       references identityiq.spt_sodconstraint (id);

    alter table identityiq.spt_sodconstraint_right 
       add constraint FK1k33mlfft6ir3ao0scmod2y0i 
       foreign key (businessrole) 
       references identityiq.spt_bundle (id);

    alter table identityiq.spt_sodconstraint_right 
       add constraint FKi4p81605xg3ojoycpm4lyfa85 
       foreign key (sodconstraint) 
       references identityiq.spt_sodconstraint (id);

    alter table identityiq.spt_archived_cert_entity 
       add constraint FKt3lg6vlrrdfqy5xo76lb5p06x 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_archived_cert_entity 
       add constraint FKo4mknf6x4lxygjwvgyoxu3me3 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_archived_cert_entity 
       add constraint FK8salwd54pmcixneotwbg1e8t1 
       foreign key (certification_id) 
       references identityiq.spt_certification (id);

    alter table identityiq.spt_archived_cert_item 
       add constraint FK877k5d95c04j14sdw91fyrnth 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_archived_cert_item 
       add constraint FKhoc03daa5guh1iq2isa67wnrg 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_archived_cert_item 
       add constraint FKhsl975h3fmcssmrsnav0xp0be 
       foreign key (parent_id) 
       references identityiq.spt_archived_cert_entity (id);

    alter table identityiq.spt_identity_req_item_attach 
       add constraint FK9j07eg4emep4vaseaa779fatl 
       foreign key (attachment_id) 
       references identityiq.spt_attachment (id);

    alter table identityiq.spt_identity_req_item_attach 
       add constraint FK32c6p6xsumvu31gciybgj93f8 
       foreign key (identity_request_item_id) 
       references identityiq.spt_identity_request_item (id);

    alter table identityiq.spt_right 
       add constraint FKloubwfokw065ojaeb71h1oa3t 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_right 
       add constraint FK7xk9w0l2a9p6c0nk9vfdlgyty 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_sync_roles 
       add constraint FKh7gqwjigw9iepfoix8tu2u0s1 
       foreign key (bundle) 
       references identityiq.spt_bundle (id);

    alter table identityiq.spt_sync_roles 
       add constraint FKda7requ6nyli1ya6k205cvd9o 
       foreign key (config) 
       references identityiq.spt_integration_config (id);

    alter table identityiq.spt_tag 
       add constraint FKmgrthcu01wv36q32tftwjeqhl 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_tag 
       add constraint FK12ckbtpjb7t24wtg5p8mfjcks 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_target 
       add constraint FKey1ldelkwgfnih0bfqsxdy54w 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_target 
       add constraint FKpod5pba81d9huchum3nsgmpta 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_target 
       add constraint FKai0hmu3219oowiyrjm6ejvh9n 
       foreign key (target_source) 
       references identityiq.spt_target_source (id);

    alter table identityiq.spt_target 
       add constraint FKb3tg6yji6uf5blcn269udqlc7 
       foreign key (application) 
       references identityiq.spt_application (id);

    alter table identityiq.spt_target 
       add constraint FKn6mv8xwf0vmk1boohfqq13gyy 
       foreign key (parent) 
       references identityiq.spt_target (id);

    alter table identityiq.spt_target_association 
       add constraint FKqxsb4h4ti40gf0t8ljtscryya 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_target_association 
       add constraint FKacuykan45qff45db9sj11osbl 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_target_association 
       add constraint FKhb5il4oxcsn64hbdebuinih52 
       foreign key (target_id) 
       references identityiq.spt_target (id);

    alter table identityiq.spt_target_source 
       add constraint FKj89r4te5s353ptcfnd2d7q5u8 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_target_source 
       add constraint FKrnt6pd9p8kkfv61w0330xhib6 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_target_source 
       add constraint FK2j9mi5mcplk3qdb3j0fs4id0t 
       foreign key (correlation_rule) 
       references identityiq.spt_rule (id);

    alter table identityiq.spt_target_source 
       add constraint FKiu2mtbwoueit24pmdr3lhjrk6 
       foreign key (creation_rule) 
       references identityiq.spt_rule (id);

    alter table identityiq.spt_target_source 
       add constraint FK777oa2vyijp2mq02nuosr81rj 
       foreign key (refresh_rule) 
       references identityiq.spt_rule (id);

    alter table identityiq.spt_target_source 
       add constraint FKrtx5xfiieasobegbhbn9i6f2q 
       foreign key (transformation_rule) 
       references identityiq.spt_rule (id);

    alter table identityiq.spt_target_sources 
       add constraint FKeoqgr9sni7dx3wv0jo0kurppy 
       foreign key (elt) 
       references identityiq.spt_target_source (id);

    alter table identityiq.spt_target_sources 
       add constraint FK40hwxe8hphgbyoudtsmolx954 
       foreign key (application) 
       references identityiq.spt_application (id);

    alter table identityiq.spt_task_definition 
       add constraint FKj73ffat8whj2sjle6vcnmit5s 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_task_definition 
       add constraint FKijib486kukyyjtf2i4jl4r8x7 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_task_definition 
       add constraint FK186b24jneods52l19ovut3k25 
       foreign key (parent) 
       references identityiq.spt_task_definition (id);

    alter table identityiq.spt_task_definition 
       add constraint FKq967ll6qee151kju0h7uwn0sj 
       foreign key (signoff_config) 
       references identityiq.spt_work_item_config (id);

    alter table identityiq.spt_task_definition_rights 
       add constraint FK9ah4pq0yle4556apcis8agx3w 
       foreign key (right_id) 
       references identityiq.spt_right (id);

    alter table identityiq.spt_task_definition_rights 
       add constraint FKf7c9o0fl64otsf323bw9lmq3l 
       foreign key (task_definition_id) 
       references identityiq.spt_task_definition (id);

    alter table identityiq.spt_task_event 
       add constraint FKdr9qfdwq639526kr0s8sn7bsv 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_task_event 
       add constraint FK37pe16gm4jk5rq0iqhoxu1flp 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_task_event 
       add constraint FKjbek8dno75kki81omnix1vn8e 
       foreign key (task_result) 
       references identityiq.spt_task_result (id);

    alter table identityiq.spt_task_event 
       add constraint FKsvucgoph5pot9sayepcakum3t 
       foreign key (rule_id) 
       references identityiq.spt_rule (id);

    alter table identityiq.spt_task_result 
       add constraint FK92o7l61ctqgwtb3hnpk8m6nsi 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_task_result 
       add constraint FKc3i98bcpobratwtdvynrb0d8p 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_task_result 
       add constraint FKgv5931h4qht8l60ds42fhay5n 
       foreign key (definition) 
       references identityiq.spt_task_definition (id);

    alter table identityiq.spt_task_result 
       add constraint FKhmia6kghdf1stidg0tjawwrqh 
       foreign key (report) 
       references identityiq.spt_jasper_result (id);

    alter table identityiq.spt_task_signature_arguments 
       add constraint FK6lxnqcijv324bs8sgqjaclh84 
       foreign key (signature) 
       references identityiq.spt_task_definition (id);

    alter table identityiq.spt_task_signature_returns 
       add constraint FKo0dpi7g348h1boy75cfec0khg 
       foreign key (signature) 
       references identityiq.spt_task_definition (id);

    alter table identityiq.spt_time_period 
       add constraint FKm868jhewgm53i6bl4y59nbefl 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_time_period 
       add constraint FKgrcbpbx476sf3yc5jq81wh0se 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_uiconfig 
       add constraint FK16y8ue1ela4vu4nww3kswhtji 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_uiconfig 
       add constraint FKqj3gj76e5girakxi3nejkch3s 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_uipreferences 
       add constraint FK5rj3vu68py43jjx519hqwnh3t 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_widget 
       add constraint FKi51uo1quso8fdclqgeoj1q5hq 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_widget 
       add constraint FK7tc8b6i3k86o36mru85lyhw3p 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_workflow 
       add constraint FKyvogiw1fu3oegof5fxs2vku8 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_workflow 
       add constraint FK1i4qorrnciecvgdvblwrp125e 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_workflow_rule_libraries 
       add constraint FKc3ft08r09xw4cwx2tqqnevcxp 
       foreign key (dependency) 
       references identityiq.spt_rule (id);

    alter table identityiq.spt_workflow_rule_libraries 
       add constraint FKec9mwyk8lv87b7fknm22ax1by 
       foreign key (rule_id) 
       references identityiq.spt_workflow (id);

    alter table identityiq.spt_workflow_case 
       add constraint FK3u37v00ff74e4vm5plubtlqx1 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_workflow_case 
       add constraint FKklde6fd36kr42tbcep5f16dj9 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_workflow_registry 
       add constraint FK46n0i40i7596wrm4r19mkf95o 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_workflow_registry 
       add constraint FKg1y46rf6jkacnl8vtiie6wp5i 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_workflow_target 
       add constraint FKnhcve6g96fyukhtjqu5utjf16 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_workflow_target 
       add constraint FKjngjkgjmpbwwn9utpq60r7lid 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_workflow_target 
       add constraint FKj7uvhprilx2f9fb2u5bcoixwj 
       foreign key (workflow_case_id) 
       references identityiq.spt_workflow_case (id);

    alter table identityiq.spt_work_item 
       add constraint FK2arasbenw5pc3vrsnwvxqmc1n 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_work_item 
       add constraint FKaqhklr6jna0canhsmjv6q3ttv 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_work_item 
       add constraint FKgkr4i2su940s244kebgc1f4ak 
       foreign key (requester) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_work_item 
       add constraint FKb5kty2abf9yebckhbo6vqjv2l 
       foreign key (workflow_case) 
       references identityiq.spt_workflow_case (id);

    alter table identityiq.spt_work_item 
       add constraint FKnq8ngnioi09kpss4md9jkr4dq 
       foreign key (assignee) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_work_item 
       add constraint FK77ut3s987e5m9gcoj1yi7ifvo 
       foreign key (certification_ref_id) 
       references identityiq.spt_certification (id);

    alter table identityiq.spt_work_item_comments 
       add constraint FKrcoqbshrurwy6exnqljnk9147 
       foreign key (work_item) 
       references identityiq.spt_work_item (id);

    alter table identityiq.spt_work_item_archive 
       add constraint FKi7l692hi3ind4q445liu4vnjt 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_work_item_archive 
       add constraint FKr1av5cjgksel3fq0cop2449dm 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_work_item_config 
       add constraint FKsaklnun9f7m1ur66reimsj0uh 
       foreign key (owner) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_work_item_config 
       add constraint FKainfds5d2eyh6kt0nudndtjhq 
       foreign key (assigned_scope) 
       references identityiq.spt_scope (id);

    alter table identityiq.spt_work_item_config 
       add constraint FK9fsd71n6x6rgg14g3ipecbei7 
       foreign key (parent) 
       references identityiq.spt_work_item_config (id);

    alter table identityiq.spt_work_item_config 
       add constraint FKml61l0hu4ipdc0uyusn0u0s4q 
       foreign key (owner_rule) 
       references identityiq.spt_rule (id);

    alter table identityiq.spt_work_item_config 
       add constraint FKlmrrs1xltdogce59jno83xvqv 
       foreign key (notification_email) 
       references identityiq.spt_email_template (id);

    alter table identityiq.spt_work_item_config 
       add constraint FK2p700iypxpxmrijecptg3bfc9 
       foreign key (reminder_email) 
       references identityiq.spt_email_template (id);

    alter table identityiq.spt_work_item_config 
       add constraint FKobeui00a317gyix189atb3dt8 
       foreign key (escalation_email) 
       references identityiq.spt_email_template (id);

    alter table identityiq.spt_work_item_config 
       add constraint FK8ya24kn74wr4rmd8ukl7vuv9d 
       foreign key (escalation_rule) 
       references identityiq.spt_rule (id);

    alter table identityiq.spt_work_item_owners 
       add constraint FK4m6v8uagrglqptlephg9ecbm5 
       foreign key (elt) 
       references identityiq.spt_identity (id);

    alter table identityiq.spt_work_item_owners 
       add constraint FKjpvcxuqhodero8m8cyucavel9 
       foreign key (config) 
       references identityiq.spt_work_item_config (id);

    create index spt_managed_modified on identityiq.spt_managed_attribute (modified);

    create index spt_managed_created on identityiq.spt_managed_attribute (created);

    create index spt_managed_comp on identityiq.spt_managed_attribute (application(32), type(32), attribute(50), value(141));

    create index spt_application_created on identityiq.spt_application (created);

    create index spt_application_modified on identityiq.spt_application (modified);

    create index spt_request_completed on identityiq.spt_request (completed);

    create index spt_request_host on identityiq.spt_request (host);

    create index spt_request_launched on identityiq.spt_request (launched);

    create index spt_request_id_composite on identityiq.spt_request (completed, next_launch, launched);

    create index spt_workitem_owner_type on identityiq.spt_work_item (owner, type);

    create index spt_role_change_event_created on identityiq.spt_role_change_event (created);

    create index spt_audit_event_created on identityiq.spt_audit_event (created);

    create index spt_audit_event_targ_act_comp on identityiq.spt_audit_event (target, action);

    create index spt_ident_entit_comp_name on identityiq.spt_identity_entitlement (identity_id(32), name(223));

    create index spt_identity_entitlement_comp on identityiq.spt_identity_entitlement (identity_id(32), application(32), native_identity(175), instance(16));

    create index spt_idrequest_created on identityiq.spt_identity_request (created);

    create index spt_arch_cert_item_apps_name on identityiq.spt_arch_cert_item_apps (application_name);

    create index spt_appidcomposite on identityiq.spt_link (application(32), native_identity(223));

    create index spt_uuidcomposite on identityiq.spt_link (application, uuid);

    create index spt_task_result_host on identityiq.spt_task_result (host);

    create index spt_task_result_launcher on identityiq.spt_task_result (launcher);

    create index spt_task_result_created on identityiq.spt_task_result (created);

    create index spt_cert_item_apps_name on identityiq.spt_cert_item_applications (application_name);

    create index spt_cert_item_att_name_ci on identityiq.spt_certification_item (exception_attribute_name);

    create index spt_certification_item_tdn_ci on identityiq.spt_certification_item (target_display_name);

    create index spt_appidcompositedelobj on identityiq.spt_deleted_object (application(32), native_identity(223));

    create index spt_uuidcompositedelobj on identityiq.spt_deleted_object (application, uuid);

    create index spt_cert_entity_tdn_ci on identityiq.spt_certification_entity (target_display_name);

    create index spt_integration_conf_modified on identityiq.spt_integration_config (modified);

    create index spt_integration_conf_created on identityiq.spt_integration_config (created);

    create index spt_bundle_modified on identityiq.spt_bundle (modified);

    create index spt_bundle_created on identityiq.spt_bundle (created);

    create index SPT_IDXE5D0EE5E14FE3C13 on identityiq.spt_certification_archive (created);

    create index spt_identity_snapshot_created on identityiq.spt_identity_snapshot (created);

    create index spt_certification_certifiers on identityiq.spt_certifiers (certifier);

    create index spt_identity_modified on identityiq.spt_identity (modified);

    create index spt_identity_created on identityiq.spt_identity (created);

    create index spt_externaloidnamecomposite on identityiq.spt_identity_external_attr (object_id, attribute_name);

    create index SPT_IDX5B44307DE376B265 on identityiq.spt_link_external_attr (object_id, attribute_name);

    create index spt_externalobjectid on identityiq.spt_identity_external_attr (object_id);

    create index SPT_IDX1CE9A5A5A51C278D on identityiq.spt_link_external_attr (object_id);

    create index spt_externalnamevalcomposite on identityiq.spt_identity_external_attr (attribute_name(55), value(200));

    create index SPT_IDX6810487CF042CA64 on identityiq.spt_link_external_attr (attribute_name(55), value(200));

    create index SPT_IDXC8BAE6DCF83839CC on identityiq.spt_jasper_template (assigned_scope_path(255));

    create index spt_custom_assignedscopepath on identityiq.spt_custom (assigned_scope_path(255));

    create index SPT_IDX52403791F605046 on identityiq.spt_generic_constraint (assigned_scope_path(255));

    create index SPT_IDX352BB37529C8F73E on identityiq.spt_identity_archive (assigned_scope_path(255));

    create index SPT_IDXD9728B9EEB248FD0 on identityiq.spt_certification_group (assigned_scope_path(255));

    create index SPT_IDXECB4C9F64AB87280 on identityiq.spt_group_index (assigned_scope_path(255));

    create index spt_category_assignedscopepath on identityiq.spt_category (assigned_scope_path(255));

    create index SPT_IDXCA5C5C012C739356 on identityiq.spt_certification_delegation (assigned_scope_path(255));

    create index SPT_IDX892D67C7AB213062 on identityiq.spt_group_definition (assigned_scope_path(255));

    create index spt_right_assignedscopepath on identityiq.spt_right (assigned_scope_path(255));

    create index SPT_IDX6B29BC60611AFDD4 on identityiq.spt_managed_attribute (assigned_scope_path(255));

    create index SPT_IDXA6D194B42059DB7C on identityiq.spt_application (assigned_scope_path(255));

    create index SPT_IDXE2B6FD83726D2C4 on identityiq.spt_process_log (assigned_scope_path(255));

    create index spt_request_assignedscopepath on identityiq.spt_request (assigned_scope_path(255));

    create index SPT_IDX6BA77F433361865A on identityiq.spt_score_config (assigned_scope_path(255));

    create index SPT_IDX1647668E11063E4 on identityiq.spt_work_item_archive (assigned_scope_path(255));

    create index SPT_IDX2AE3D4A6385CD3E0 on identityiq.spt_message_template (assigned_scope_path(255));

    create index SPT_IDX749C6E992BBAE86 on identityiq.spt_dictionary_term (assigned_scope_path(255));

    create index SPT_IDX836C2831FD8ED7B6 on identityiq.spt_file_bucket (assigned_scope_path(255));

    create index SPT_IDX45D72A5E6CEE19E on identityiq.spt_work_item (assigned_scope_path(255));

    create index SPT_IDX9542C8399A0989C6 on identityiq.spt_bundle_archive (assigned_scope_path(255));

    create index SPT_IDX5BFDE38499178D1C on identityiq.spt_rule_registry (assigned_scope_path(255));

    create index SPT_IDXBB0D4BCC29515FAC on identityiq.spt_policy_violation (assigned_scope_path(255));

    create index SPT_IDXC1811197B7DE5802 on identityiq.spt_role_mining_result (assigned_scope_path(255));

    create index SPT_IDX5165831AA4CEA5C8 on identityiq.spt_audit_event (assigned_scope_path(255));

    create index spt_tag_assignedscopepath on identityiq.spt_tag (assigned_scope_path(255));

    create index spt_uiconfig_assignedscopepath on identityiq.spt_uiconfig (assigned_scope_path(255));

    create index SPT_IDX8F4ABD86AFAD1DA0 on identityiq.spt_scorecard (assigned_scope_path(255));

    create index SPT_IDX8DFD31878D3B3E2 on identityiq.spt_target_association (assigned_scope_path(255));

    create index SPT_IDX686990949D3B0B3C on identityiq.spt_activity_data_source (assigned_scope_path(255));

    create index SPT_IDX59D4F6CD8690EEC on identityiq.spt_certification_definition (assigned_scope_path(255));

    create index SPT_IDX377FCC029A032198 on identityiq.spt_identity_request (assigned_scope_path(255));

    create index SPT_IDXA6919D21F9F21D96 on identityiq.spt_remediation_item (assigned_scope_path(255));

    create index SPT_IDX608761A1BFB4BC8 on identityiq.spt_audit_config (assigned_scope_path(255));

    create index spt_target_assignedscopepath on identityiq.spt_target (assigned_scope_path(255));

    create index SPT_IDX99FA48D474C60BBC on identityiq.spt_task_event (assigned_scope_path(255));

    create index SPT_IDXB52E1053EF6BCC7A on identityiq.spt_correlation_config (assigned_scope_path(255));

    create index SPT_IDX7590C4E191BEDD16 on identityiq.spt_workflow_registry (assigned_scope_path(255));

    create index SPT_IDX99763E0AD76DF7A8 on identityiq.spt_alert_definition (assigned_scope_path(255));

    create index SPT_IDXE4B09B655AF1E31E on identityiq.spt_archived_cert_item (assigned_scope_path(255));

    create index SPT_IDX321B16EB1422CFAA on identityiq.spt_identity_trigger (assigned_scope_path(255));

    create index SPT_IDX660B15141EEE343C on identityiq.spt_workflow_case (assigned_scope_path(255));

    create index spt_rule_assignedscopepath on identityiq.spt_rule (assigned_scope_path(255));

    create index SPT_IDXECBE5C8C4B5A312C on identityiq.spt_capability (assigned_scope_path(255));

    create index SPT_IDXD6F31180C85EB014 on identityiq.spt_quick_link (assigned_scope_path(255));

    create index SPT_IDX4875A7F12BD64736 on identityiq.spt_authentication_question (assigned_scope_path(255));

    create index spt_link_assignedscopepath on identityiq.spt_link (assigned_scope_path(255));

    create index SPT_IDX8CEA0D6E33EF6770 on identityiq.spt_batch_request (assigned_scope_path(255));

    create index SPT_IDX34534BBBC845CD4A on identityiq.spt_task_result (assigned_scope_path(255));

    create index SPT_IDXDCCC1AEC8ACA85EC on identityiq.spt_certification_item (assigned_scope_path(255));

    create index SPT_IDXBED7A8DAA6E4E148 on identityiq.spt_configuration (assigned_scope_path(255));

    create index SPT_IDX5DA4B31DDBDDDB6 on identityiq.spt_activity_constraint (assigned_scope_path(255));

    create index SPT_IDX11035135399822BE on identityiq.spt_mining_config (assigned_scope_path(255));

    create index spt_scope_assignedscopepath on identityiq.spt_scope (assigned_scope_path(255));

    create index SPT_IDX719553AD788A55AE on identityiq.spt_target_source (assigned_scope_path(255));

    create index SPT_IDX1DB04E7170203436 on identityiq.spt_task_definition (assigned_scope_path(255));

    create index SPT_IDXCE071F89DBC06C66 on identityiq.spt_sodconstraint (assigned_scope_path(255));

    create index SPT_IDXC71C52111BEFE376 on identityiq.spt_account_group (assigned_scope_path(255));

    create index SPT_IDX593FB9116D127176 on identityiq.spt_entitlement_group (assigned_scope_path(255));

    create index SPT_IDX7F55103C9C96248C on identityiq.spt_role_metadata (assigned_scope_path(255));

    create index SPT_IDXCEBEA62E59148F0 on identityiq.spt_group_factory (assigned_scope_path(255));

    create index SPT_IDX7EDDBC591F6A3A06 on identityiq.spt_deleted_object (assigned_scope_path(255));

    create index SPT_IDX1A2CF87C3B1B850C on identityiq.spt_certification_entity (assigned_scope_path(255));

    create index SPT_IDXFB512F02CB48A798 on identityiq.spt_certification_challenge (assigned_scope_path(255));

    create index SPT_IDXABF0D041BEBD0BD6 on identityiq.spt_integration_config (assigned_scope_path(255));

    create index SPT_IDXAEACA8FDA84AB44E on identityiq.spt_role_index (assigned_scope_path(255));

    create index SPT_IDXF70D54D58BC80EE on identityiq.spt_role_scorecard (assigned_scope_path(255));

    create index spt_widget_assignedscopepath on identityiq.spt_widget (assigned_scope_path(255));

    create index SPT_IDXCB6BC61E1128A4D0 on identityiq.spt_remote_login_token (assigned_scope_path(255));

    create index spt_form_assignedscopepath on identityiq.spt_form (assigned_scope_path(255));

    create index SPT_IDXA367F317D4A97B02 on identityiq.spt_application_scorecard (assigned_scope_path(255));

    create index SPT_IDX54AF7352EE4EEBE on identityiq.spt_workflow_target (assigned_scope_path(255));

    create index SPT_IDXA5EE253FB5399952 on identityiq.spt_jasper_result (assigned_scope_path(255));

    create index SPT_IDXC439D3638206900 on identityiq.spt_sign_off_history (assigned_scope_path(255));

    create index SPT_IDX6200CF1CF3199A4C on identityiq.spt_batch_request_item (assigned_scope_path(255));

    create index SPT_IDXDD339B534953A27A on identityiq.spt_mitigation_expiration (assigned_scope_path(255));

    create index SPT_IDX9D89C40FB709EAF2 on identityiq.spt_certification_action (assigned_scope_path(255));

    create index SPT_IDXBAE32AF9A1817F46 on identityiq.spt_right_config (assigned_scope_path(255));

    create index spt_workflow_assignedscopepath on identityiq.spt_workflow (assigned_scope_path(255));

    create index SPT_IDXF89E6D4D93CDB0EE on identityiq.spt_monitoring_statistic (assigned_scope_path(255));

    create index spt_profile_assignedscopepath on identityiq.spt_profile (assigned_scope_path(255));

    create index spt_bundle_assignedscopepath on identityiq.spt_bundle (assigned_scope_path(255));

    create index SPT_IDX823D9A61B16AE816 on identityiq.spt_certification_archive (assigned_scope_path(255));

    create index SPT_IDXB1547649C7A749E6 on identityiq.spt_identity_snapshot (assigned_scope_path(255));

    create index SPT_IDXBAF33EB59EE05DBE on identityiq.spt_archived_cert_entity (assigned_scope_path(255));

    create index SPT_IDXFF9A9E0694DBFEA0 on identityiq.spt_partition_result (assigned_scope_path(255));

    create index SPT_IDX133BD716174D236 on identityiq.spt_provisioning_request (assigned_scope_path(255));

    create index SPT_IDX50B36EB8F7F2C884 on identityiq.spt_dynamic_scope (assigned_scope_path(255));

    create index SPT_IDX95FDCE46C5917DC on identityiq.spt_application_schema (assigned_scope_path(255));

    create index SPT_IDXE758C3D7FFA1CC82 on identityiq.spt_attachment (assigned_scope_path(255));

    create index SPT_IDX52AF250AB5405B4 on identityiq.spt_jasper_page_bucket (assigned_scope_path(255));

    create index SPT_IDX1E683C17685A4D02 on identityiq.spt_time_period (assigned_scope_path(255));

    create index SPT_IDX90929F9EDF01B7D0 on identityiq.spt_certification (assigned_scope_path(255));

    create index SPT_IDXEA8F35F17CF0E336 on identityiq.spt_email_template (assigned_scope_path(255));

    create index spt_identity_assignedscopepath on identityiq.spt_identity (assigned_scope_path(255));

    create index SPT_IDXA511A43C73CC4C8C on identityiq.spt_persisted_file (assigned_scope_path(255));

    create index SPT_IDX9393E3B78D0A4442 on identityiq.spt_request_definition (assigned_scope_path(255));

    create index SPT_IDXB999253482041C7C on identityiq.spt_work_item_config (assigned_scope_path(255));

    create index SPT_IDXD9D9048A81D024A8 on identityiq.spt_dictionary (assigned_scope_path(255));

    create index SPT_IDX6F2601261AB4CE0 on identityiq.spt_object_config (assigned_scope_path(255));

    create index spt_policy_assignedscopepath on identityiq.spt_policy (assigned_scope_path(255));

    create table identityiq.spt_identity_request_sequence ( next_val bigint );

    insert into identityiq.spt_identity_request_sequence values ( 1 );

    create table identityiq.spt_work_item_sequence ( next_val bigint );

    insert into identityiq.spt_work_item_sequence values ( 1 );

    create table identityiq.spt_syslog_event_sequence ( next_val bigint );

    insert into identityiq.spt_syslog_event_sequence values ( 1 );

    create table identityiq.spt_prv_trans_sequence ( next_val bigint );

    insert into identityiq.spt_prv_trans_sequence values ( 1 );

    create table identityiq.spt_alert_sequence ( next_val bigint );

    insert into identityiq.spt_alert_sequence values ( 1 );
