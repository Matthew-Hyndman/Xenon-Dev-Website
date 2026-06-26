--
-- PostgreSQL database dump
--

--\restrict n3Z0tA83MXV9bWUYuwRd9ezH2uudUeZfcCcy4mEsmFavQexHhoOZwoVFA5rG60n

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: Xenon-Dev-Admin
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO "Xenon-Dev-Admin";

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: Xenon-Dev-Admin
--

COMMENT ON SCHEMA public IS '';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: player_profile; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.player_profile (
    player_id bigint NOT NULL,
    losses integer,
    pot integer,
    wins integer
);


ALTER TABLE public.player_profile OWNER TO "Xenon-Dev-Admin";

--
-- Name: user_entity; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.user_entity (
    id character varying(36) NOT NULL,
    email character varying(255),
    email_constraint character varying(255),
    email_verified boolean DEFAULT false NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    federation_link character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    realm_id character varying(255),
    username character varying(255),
    created_timestamp bigint,
    service_account_client_link character varying(255),
    not_before bigint DEFAULT 0 NOT NULL,
    last_modified_timestamp bigint,
    player_profile_id bigint
);


ALTER TABLE public.user_entity OWNER TO "Xenon-Dev-Admin";

--
-- Name: accounts_with_player_profiles_view; Type: VIEW; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE VIEW public.accounts_with_player_profiles_view AS
 SELECT ue.username,
    pp.wins,
    pp.losses,
    pp.pot
   FROM (public.user_entity ue
     JOIN public.player_profile pp ON ((ue.player_profile_id = pp.player_id)));


ALTER VIEW public.accounts_with_player_profiles_view OWNER TO "Xenon-Dev-Admin";

--
-- Name: admin_event_entity; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.admin_event_entity (
    id character varying(36) NOT NULL,
    admin_event_time bigint,
    realm_id character varying(255),
    operation_type character varying(255),
    auth_realm_id character varying(255),
    auth_client_id character varying(255),
    auth_user_id character varying(255),
    ip_address character varying(255),
    resource_path character varying(2550),
    representation text,
    error character varying(255),
    resource_type character varying(64),
    details_json text
);


ALTER TABLE public.admin_event_entity OWNER TO "Xenon-Dev-Admin";

--
-- Name: associated_policy; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.associated_policy (
    policy_id character varying(36) NOT NULL,
    associated_policy_id character varying(36) NOT NULL
);


ALTER TABLE public.associated_policy OWNER TO "Xenon-Dev-Admin";

--
-- Name: authentication_execution; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.authentication_execution (
    id character varying(36) NOT NULL,
    alias character varying(255),
    authenticator character varying(36),
    realm_id character varying(36),
    flow_id character varying(36),
    requirement integer,
    priority integer,
    authenticator_flow boolean DEFAULT false NOT NULL,
    auth_flow_id character varying(36),
    auth_config character varying(36)
);


ALTER TABLE public.authentication_execution OWNER TO "Xenon-Dev-Admin";

--
-- Name: authentication_flow; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.authentication_flow (
    id character varying(36) NOT NULL,
    alias character varying(255),
    description character varying(255),
    realm_id character varying(36),
    provider_id character varying(36) DEFAULT 'basic-flow'::character varying NOT NULL,
    top_level boolean DEFAULT false NOT NULL,
    built_in boolean DEFAULT false NOT NULL
);


ALTER TABLE public.authentication_flow OWNER TO "Xenon-Dev-Admin";

--
-- Name: authenticator_config; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.authenticator_config (
    id character varying(36) CONSTRAINT authenticator_id_not_null NOT NULL,
    alias character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.authenticator_config OWNER TO "Xenon-Dev-Admin";

--
-- Name: authenticator_config_entry; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.authenticator_config_entry (
    authenticator_id character varying(36) CONSTRAINT authenticator_config_authenticator_id_not_null NOT NULL,
    value text,
    name character varying(255) CONSTRAINT authenticator_config_name_not_null NOT NULL
);


ALTER TABLE public.authenticator_config_entry OWNER TO "Xenon-Dev-Admin";

--
-- Name: broker_link; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.broker_link (
    identity_provider character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL,
    broker_user_id character varying(255),
    broker_username character varying(255),
    token text,
    user_id character varying(255) NOT NULL
);


ALTER TABLE public.broker_link OWNER TO "Xenon-Dev-Admin";

--
-- Name: client; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.client (
    id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    full_scope_allowed boolean DEFAULT false NOT NULL,
    client_id character varying(255),
    not_before integer,
    public_client boolean DEFAULT false NOT NULL,
    secret character varying(255),
    base_url character varying(255),
    bearer_only boolean DEFAULT false NOT NULL,
    management_url character varying(255),
    surrogate_auth_required boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    protocol character varying(255),
    node_rereg_timeout integer DEFAULT 0,
    frontchannel_logout boolean DEFAULT false NOT NULL,
    consent_required boolean DEFAULT false NOT NULL,
    name character varying(255),
    service_accounts_enabled boolean DEFAULT false NOT NULL,
    client_authenticator_type character varying(255),
    root_url character varying(255),
    description character varying(255),
    registration_token character varying(255),
    standard_flow_enabled boolean DEFAULT true NOT NULL,
    implicit_flow_enabled boolean DEFAULT false NOT NULL,
    direct_access_grants_enabled boolean DEFAULT false NOT NULL,
    always_display_in_console boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client OWNER TO "Xenon-Dev-Admin";

--
-- Name: client_attributes; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.client_attributes (
    client_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.client_attributes OWNER TO "Xenon-Dev-Admin";

--
-- Name: client_auth_flow_bindings; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.client_auth_flow_bindings (
    client_id character varying(36) NOT NULL,
    flow_id character varying(36),
    binding_name character varying(255) NOT NULL
);


ALTER TABLE public.client_auth_flow_bindings OWNER TO "Xenon-Dev-Admin";

--
-- Name: client_initial_access; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.client_initial_access (
    id character varying(36) NOT NULL,
    realm_id character varying(36) NOT NULL,
    "timestamp" integer,
    expiration integer,
    count integer,
    remaining_count integer
);


ALTER TABLE public.client_initial_access OWNER TO "Xenon-Dev-Admin";

--
-- Name: client_node_registrations; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.client_node_registrations (
    client_id character varying(36) CONSTRAINT app_node_registrations_application_id_not_null NOT NULL,
    value integer,
    name character varying(255) CONSTRAINT app_node_registrations_name_not_null NOT NULL
);


ALTER TABLE public.client_node_registrations OWNER TO "Xenon-Dev-Admin";

--
-- Name: client_scope; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.client_scope (
    id character varying(36) CONSTRAINT client_template_id_not_null NOT NULL,
    name character varying(255),
    realm_id character varying(36),
    description character varying(255),
    protocol character varying(255)
);


ALTER TABLE public.client_scope OWNER TO "Xenon-Dev-Admin";

--
-- Name: client_scope_attributes; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.client_scope_attributes (
    scope_id character varying(36) CONSTRAINT client_template_attributes_template_id_not_null NOT NULL,
    value character varying(2048),
    name character varying(255) CONSTRAINT client_template_attributes_name_not_null NOT NULL
);


ALTER TABLE public.client_scope_attributes OWNER TO "Xenon-Dev-Admin";

--
-- Name: client_scope_client; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.client_scope_client (
    client_id character varying(255) NOT NULL,
    scope_id character varying(255) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client_scope_client OWNER TO "Xenon-Dev-Admin";

--
-- Name: client_scope_role_mapping; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.client_scope_role_mapping (
    scope_id character varying(36) CONSTRAINT template_scope_mapping_template_id_not_null NOT NULL,
    role_id character varying(36) CONSTRAINT template_scope_mapping_role_id_not_null NOT NULL
);


ALTER TABLE public.client_scope_role_mapping OWNER TO "Xenon-Dev-Admin";

--
-- Name: component; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.component (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_id character varying(36),
    provider_id character varying(36),
    provider_type character varying(255),
    realm_id character varying(36),
    sub_type character varying(255)
);


ALTER TABLE public.component OWNER TO "Xenon-Dev-Admin";

--
-- Name: component_config; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.component_config (
    id character varying(36) NOT NULL,
    component_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.component_config OWNER TO "Xenon-Dev-Admin";

--
-- Name: composite_role; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.composite_role (
    composite character varying(36) NOT NULL,
    child_role character varying(36) NOT NULL
);


ALTER TABLE public.composite_role OWNER TO "Xenon-Dev-Admin";

--
-- Name: credential; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    user_id character varying(36),
    created_date bigint,
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer,
    version integer DEFAULT 0
);


ALTER TABLE public.credential OWNER TO "Xenon-Dev-Admin";

--
-- Name: databasechangelog; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.databasechangelog (
    id character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    filename character varying(255) NOT NULL,
    dateexecuted timestamp without time zone NOT NULL,
    orderexecuted integer NOT NULL,
    exectype character varying(10) NOT NULL,
    md5sum character varying(35),
    description character varying(255),
    comments character varying(255),
    tag character varying(255),
    liquibase character varying(20),
    contexts character varying(255),
    labels character varying(255),
    deployment_id character varying(10)
);


ALTER TABLE public.databasechangelog OWNER TO "Xenon-Dev-Admin";

--
-- Name: databasechangeloglock; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.databasechangeloglock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp without time zone,
    lockedby character varying(255)
);


ALTER TABLE public.databasechangeloglock OWNER TO "Xenon-Dev-Admin";

--
-- Name: default_client_scope; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.default_client_scope (
    realm_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.default_client_scope OWNER TO "Xenon-Dev-Admin";

--
-- Name: event_entity; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.event_entity (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    details_json character varying(2550),
    error character varying(255),
    ip_address character varying(255),
    realm_id character varying(255),
    session_id character varying(255),
    event_time bigint,
    type character varying(255),
    user_id character varying(255),
    details_json_long_value text
);


ALTER TABLE public.event_entity OWNER TO "Xenon-Dev-Admin";

--
-- Name: fed_user_attribute; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.fed_user_attribute (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    value character varying(2024),
    long_value_hash bytea,
    long_value_hash_lower_case bytea,
    long_value text
);


ALTER TABLE public.fed_user_attribute OWNER TO "Xenon-Dev-Admin";

--
-- Name: fed_user_consent; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.fed_user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.fed_user_consent OWNER TO "Xenon-Dev-Admin";

--
-- Name: fed_user_consent_cl_scope; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.fed_user_consent_cl_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.fed_user_consent_cl_scope OWNER TO "Xenon-Dev-Admin";

--
-- Name: fed_user_credential; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.fed_user_credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    created_date bigint,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


ALTER TABLE public.fed_user_credential OWNER TO "Xenon-Dev-Admin";

--
-- Name: fed_user_group_membership; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.fed_user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_group_membership OWNER TO "Xenon-Dev-Admin";

--
-- Name: fed_user_required_action; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.fed_user_required_action (
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_required_action OWNER TO "Xenon-Dev-Admin";

--
-- Name: fed_user_role_mapping; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.fed_user_role_mapping (
    role_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_role_mapping OWNER TO "Xenon-Dev-Admin";

--
-- Name: federated_identity; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.federated_identity (
    identity_provider character varying(255) NOT NULL,
    realm_id character varying(36),
    federated_user_id character varying(255),
    federated_username character varying(255),
    token text,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_identity OWNER TO "Xenon-Dev-Admin";

--
-- Name: federated_user; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.federated_user (
    id character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_user OWNER TO "Xenon-Dev-Admin";

--
-- Name: group_attribute; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.group_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_attribute OWNER TO "Xenon-Dev-Admin";

--
-- Name: group_role_mapping; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.group_role_mapping (
    role_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_role_mapping OWNER TO "Xenon-Dev-Admin";

--
-- Name: identity_provider; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.identity_provider (
    internal_id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    provider_alias character varying(255),
    provider_id character varying(255),
    store_token boolean,
    authenticate_by_default boolean,
    realm_id character varying(36),
    add_token_role boolean,
    trust_email boolean,
    first_broker_login_flow_id character varying(36),
    post_broker_login_flow_id character varying(36),
    provider_display_name character varying(255),
    link_only boolean,
    organization_id character varying(255),
    hide_on_login boolean
);


ALTER TABLE public.identity_provider OWNER TO "Xenon-Dev-Admin";

--
-- Name: identity_provider_config; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.identity_provider_config (
    identity_provider_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.identity_provider_config OWNER TO "Xenon-Dev-Admin";

--
-- Name: identity_provider_mapper; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.identity_provider_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    idp_alias character varying(255) NOT NULL,
    idp_mapper_name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.identity_provider_mapper OWNER TO "Xenon-Dev-Admin";

--
-- Name: idp_mapper_config; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.idp_mapper_config (
    idp_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.idp_mapper_config OWNER TO "Xenon-Dev-Admin";

--
-- Name: jgroups_ping; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.jgroups_ping (
    address character varying(200) NOT NULL,
    name character varying(200),
    cluster_name character varying(200) NOT NULL,
    ip character varying(200) NOT NULL,
    coord boolean
);


ALTER TABLE public.jgroups_ping OWNER TO "Xenon-Dev-Admin";

--
-- Name: keycloak_group; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.keycloak_group (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_group character varying(36) NOT NULL,
    realm_id character varying(36),
    type integer DEFAULT 0 NOT NULL,
    description character varying(255),
    org_id character varying(255),
    created_timestamp bigint,
    last_modified_timestamp bigint
);


ALTER TABLE public.keycloak_group OWNER TO "Xenon-Dev-Admin";

--
-- Name: keycloak_role; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.keycloak_role (
    id character varying(36) NOT NULL,
    client_realm_constraint character varying(255),
    client_role boolean DEFAULT false CONSTRAINT keycloak_role_application_role_not_null NOT NULL,
    description character varying(255),
    name character varying(255),
    realm_id character varying(255),
    client character varying(36),
    realm character varying(36)
);


ALTER TABLE public.keycloak_role OWNER TO "Xenon-Dev-Admin";

--
-- Name: migration_model; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.migration_model (
    id character varying(36) NOT NULL,
    version character varying(36),
    update_time bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.migration_model OWNER TO "Xenon-Dev-Admin";

--
-- Name: offline_client_session; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.offline_client_session (
    user_session_id character varying(36) NOT NULL,
    client_id character varying(255) NOT NULL,
    offline_flag character varying(4) NOT NULL,
    "timestamp" integer,
    data text,
    client_storage_provider character varying(36) DEFAULT 'local'::character varying NOT NULL,
    external_client_id character varying(255) DEFAULT 'local'::character varying NOT NULL,
    version integer DEFAULT 0,
    realm_id character varying(36)
);


ALTER TABLE public.offline_client_session OWNER TO "Xenon-Dev-Admin";

--
-- Name: offline_user_session; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.offline_user_session (
    user_session_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    created_on integer NOT NULL,
    offline_flag character varying(4) NOT NULL,
    data text,
    last_session_refresh integer DEFAULT 0 NOT NULL,
    broker_session_id character varying(1024),
    version integer DEFAULT 0,
    remember_me boolean
);


ALTER TABLE public.offline_user_session OWNER TO "Xenon-Dev-Admin";

--
-- Name: org; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.org (
    id character varying(255) NOT NULL,
    enabled boolean NOT NULL,
    realm_id character varying(255) NOT NULL,
    group_id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4000),
    alias character varying(255) NOT NULL,
    redirect_url character varying(2048)
);


ALTER TABLE public.org OWNER TO "Xenon-Dev-Admin";

--
-- Name: org_domain; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.org_domain (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    verified boolean NOT NULL,
    org_id character varying(255) NOT NULL
);


ALTER TABLE public.org_domain OWNER TO "Xenon-Dev-Admin";

--
-- Name: org_invitation; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.org_invitation (
    id character varying(36) NOT NULL,
    organization_id character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    first_name character varying(255),
    last_name character varying(255),
    created_at integer NOT NULL,
    expires_at integer,
    invite_link character varying(2048)
);


ALTER TABLE public.org_invitation OWNER TO "Xenon-Dev-Admin";

--
-- Name: player_profile_player_id_seq; Type: SEQUENCE; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE public.player_profile ALTER COLUMN player_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.player_profile_player_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: policy_config; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.policy_config (
    policy_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.policy_config OWNER TO "Xenon-Dev-Admin";

--
-- Name: protocol_mapper; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.protocol_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    protocol character varying(255) NOT NULL,
    protocol_mapper_name character varying(255) NOT NULL,
    client_id character varying(36),
    client_scope_id character varying(36)
);


ALTER TABLE public.protocol_mapper OWNER TO "Xenon-Dev-Admin";

--
-- Name: protocol_mapper_config; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.protocol_mapper_config (
    protocol_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.protocol_mapper_config OWNER TO "Xenon-Dev-Admin";

--
-- Name: realm; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.realm (
    id character varying(36) NOT NULL,
    access_code_lifespan integer,
    user_action_lifespan integer,
    access_token_lifespan integer,
    account_theme character varying(255),
    admin_theme character varying(255),
    email_theme character varying(255),
    enabled boolean DEFAULT false NOT NULL,
    events_enabled boolean DEFAULT false NOT NULL,
    events_expiration bigint,
    login_theme character varying(255),
    name character varying(255),
    not_before integer,
    password_policy character varying(2550),
    registration_allowed boolean DEFAULT false NOT NULL,
    remember_me boolean DEFAULT false NOT NULL,
    reset_password_allowed boolean DEFAULT false NOT NULL,
    social boolean DEFAULT false NOT NULL,
    ssl_required character varying(255),
    sso_idle_timeout integer,
    sso_max_lifespan integer,
    update_profile_on_soc_login boolean DEFAULT false NOT NULL,
    verify_email boolean DEFAULT false NOT NULL,
    master_admin_client character varying(36),
    login_lifespan integer,
    internationalization_enabled boolean DEFAULT false NOT NULL,
    default_locale character varying(255),
    reg_email_as_username boolean DEFAULT false NOT NULL,
    admin_events_enabled boolean DEFAULT false NOT NULL,
    admin_events_details_enabled boolean DEFAULT false NOT NULL,
    edit_username_allowed boolean DEFAULT false NOT NULL,
    otp_policy_counter integer DEFAULT 0,
    otp_policy_window integer DEFAULT 1,
    otp_policy_period integer DEFAULT 30,
    otp_policy_digits integer DEFAULT 6,
    otp_policy_alg character varying(36) DEFAULT 'HmacSHA1'::character varying,
    otp_policy_type character varying(36) DEFAULT 'totp'::character varying,
    browser_flow character varying(36),
    registration_flow character varying(36),
    direct_grant_flow character varying(36),
    reset_credentials_flow character varying(36),
    client_auth_flow character varying(36),
    offline_session_idle_timeout integer DEFAULT 0,
    revoke_refresh_token boolean DEFAULT false NOT NULL,
    access_token_life_implicit integer DEFAULT 0,
    login_with_email_allowed boolean DEFAULT true NOT NULL,
    duplicate_emails_allowed boolean DEFAULT false NOT NULL,
    docker_auth_flow character varying(36),
    refresh_token_max_reuse integer DEFAULT 0,
    allow_user_managed_access boolean DEFAULT false NOT NULL,
    sso_max_lifespan_remember_me integer DEFAULT 0 NOT NULL,
    sso_idle_timeout_remember_me integer DEFAULT 0 NOT NULL,
    default_role character varying(255)
);


ALTER TABLE public.realm OWNER TO "Xenon-Dev-Admin";

--
-- Name: realm_attribute; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.realm_attribute (
    name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    value text
);


ALTER TABLE public.realm_attribute OWNER TO "Xenon-Dev-Admin";

--
-- Name: realm_default_groups; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.realm_default_groups (
    realm_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_default_groups OWNER TO "Xenon-Dev-Admin";

--
-- Name: realm_enabled_event_types; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.realm_enabled_event_types (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_enabled_event_types OWNER TO "Xenon-Dev-Admin";

--
-- Name: realm_events_listeners; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.realm_events_listeners (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_events_listeners OWNER TO "Xenon-Dev-Admin";

--
-- Name: realm_localizations; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.realm_localizations (
    realm_id character varying(255) NOT NULL,
    locale character varying(255) NOT NULL,
    texts text NOT NULL
);


ALTER TABLE public.realm_localizations OWNER TO "Xenon-Dev-Admin";

--
-- Name: realm_required_credential; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.realm_required_credential (
    type character varying(255) NOT NULL,
    form_label character varying(255),
    input boolean DEFAULT false NOT NULL,
    secret boolean DEFAULT false NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_required_credential OWNER TO "Xenon-Dev-Admin";

--
-- Name: realm_smtp_config; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.realm_smtp_config (
    realm_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.realm_smtp_config OWNER TO "Xenon-Dev-Admin";

--
-- Name: realm_supported_locales; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.realm_supported_locales (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_supported_locales OWNER TO "Xenon-Dev-Admin";

--
-- Name: redirect_uris; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.redirect_uris (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.redirect_uris OWNER TO "Xenon-Dev-Admin";

--
-- Name: required_action_config; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.required_action_config (
    required_action_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.required_action_config OWNER TO "Xenon-Dev-Admin";

--
-- Name: required_action_provider; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.required_action_provider (
    id character varying(36) NOT NULL,
    alias character varying(255),
    name character varying(255),
    realm_id character varying(36),
    enabled boolean DEFAULT false NOT NULL,
    default_action boolean DEFAULT false NOT NULL,
    provider_id character varying(255),
    priority integer
);


ALTER TABLE public.required_action_provider OWNER TO "Xenon-Dev-Admin";

--
-- Name: resource_attribute; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.resource_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    resource_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_attribute OWNER TO "Xenon-Dev-Admin";

--
-- Name: resource_policy; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.resource_policy (
    resource_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_policy OWNER TO "Xenon-Dev-Admin";

--
-- Name: resource_scope; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.resource_scope (
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_scope OWNER TO "Xenon-Dev-Admin";

--
-- Name: resource_server; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.resource_server (
    id character varying(36) CONSTRAINT resource_server_client_id_not_null NOT NULL,
    allow_rs_remote_mgmt boolean DEFAULT false NOT NULL,
    policy_enforce_mode smallint NOT NULL,
    decision_strategy smallint DEFAULT 1 NOT NULL
);


ALTER TABLE public.resource_server OWNER TO "Xenon-Dev-Admin";

--
-- Name: resource_server_perm_ticket; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.resource_server_perm_ticket (
    id character varying(36) NOT NULL,
    owner character varying(255) NOT NULL,
    requester character varying(255) NOT NULL,
    created_timestamp bigint NOT NULL,
    granted_timestamp bigint,
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36),
    resource_server_id character varying(36) NOT NULL,
    policy_id character varying(36)
);


ALTER TABLE public.resource_server_perm_ticket OWNER TO "Xenon-Dev-Admin";

--
-- Name: resource_server_policy; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.resource_server_policy (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    type character varying(255) NOT NULL,
    decision_strategy smallint,
    logic smallint,
    resource_server_id character varying(36) CONSTRAINT resource_server_policy_resource_server_client_id_not_null NOT NULL,
    owner character varying(255)
);


ALTER TABLE public.resource_server_policy OWNER TO "Xenon-Dev-Admin";

--
-- Name: resource_server_resource; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.resource_server_resource (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(255),
    icon_uri character varying(255),
    owner character varying(255) NOT NULL,
    resource_server_id character varying(36) CONSTRAINT resource_server_resource_resource_server_client_id_not_null NOT NULL,
    owner_managed_access boolean DEFAULT false NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_resource OWNER TO "Xenon-Dev-Admin";

--
-- Name: resource_server_scope; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.resource_server_scope (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    icon_uri character varying(255),
    resource_server_id character varying(36) CONSTRAINT resource_server_scope_resource_server_client_id_not_null NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_scope OWNER TO "Xenon-Dev-Admin";

--
-- Name: resource_uris; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.resource_uris (
    resource_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.resource_uris OWNER TO "Xenon-Dev-Admin";

--
-- Name: revoked_token; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.revoked_token (
    id character varying(255) NOT NULL,
    expire bigint NOT NULL
);


ALTER TABLE public.revoked_token OWNER TO "Xenon-Dev-Admin";

--
-- Name: role_attribute; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.role_attribute (
    id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255)
);


ALTER TABLE public.role_attribute OWNER TO "Xenon-Dev-Admin";

--
-- Name: scope_mapping; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.scope_mapping (
    client_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_mapping OWNER TO "Xenon-Dev-Admin";

--
-- Name: scope_policy; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.scope_policy (
    scope_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_policy OWNER TO "Xenon-Dev-Admin";

--
-- Name: server_config; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.server_config (
    server_config_key character varying(255) NOT NULL,
    value text NOT NULL,
    version integer DEFAULT 0
);


ALTER TABLE public.server_config OWNER TO "Xenon-Dev-Admin";

--
-- Name: user_attribute; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.user_attribute (
    name character varying(255) NOT NULL,
    value character varying(255),
    user_id character varying(36) NOT NULL,
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    long_value_hash bytea,
    long_value_hash_lower_case bytea,
    long_value text
);


ALTER TABLE public.user_attribute OWNER TO "Xenon-Dev-Admin";

--
-- Name: user_consent; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(36) NOT NULL,
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.user_consent OWNER TO "Xenon-Dev-Admin";

--
-- Name: user_consent_client_scope; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.user_consent_client_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.user_consent_client_scope OWNER TO "Xenon-Dev-Admin";

--
-- Name: user_federation_config; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.user_federation_config (
    user_federation_provider_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_config OWNER TO "Xenon-Dev-Admin";

--
-- Name: user_federation_mapper; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.user_federation_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    federation_provider_id character varying(36) NOT NULL,
    federation_mapper_type character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.user_federation_mapper OWNER TO "Xenon-Dev-Admin";

--
-- Name: user_federation_mapper_config; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.user_federation_mapper_config (
    user_federation_mapper_id character varying(36) CONSTRAINT user_federation_mapper_confi_user_federation_mapper_id_not_null NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_mapper_config OWNER TO "Xenon-Dev-Admin";

--
-- Name: user_federation_provider; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.user_federation_provider (
    id character varying(36) NOT NULL,
    changed_sync_period integer,
    display_name character varying(255),
    full_sync_period integer,
    last_sync integer,
    priority integer,
    provider_name character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.user_federation_provider OWNER TO "Xenon-Dev-Admin";

--
-- Name: user_group_membership; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(36) NOT NULL,
    membership_type character varying(255) NOT NULL
);


ALTER TABLE public.user_group_membership OWNER TO "Xenon-Dev-Admin";

--
-- Name: user_required_action; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.user_required_action (
    user_id character varying(36) NOT NULL,
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL
);


ALTER TABLE public.user_required_action OWNER TO "Xenon-Dev-Admin";

--
-- Name: user_role_mapping; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.user_role_mapping (
    role_id character varying(255) NOT NULL,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.user_role_mapping OWNER TO "Xenon-Dev-Admin";

--
-- Name: web_origins; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.web_origins (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.web_origins OWNER TO "Xenon-Dev-Admin";

--
-- Name: workflow_state; Type: TABLE; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE TABLE public.workflow_state (
    execution_id character varying(255) NOT NULL,
    resource_id character varying(255) NOT NULL,
    workflow_id character varying(255) NOT NULL,
    resource_type character varying(255),
    scheduled_step_id character varying(255),
    scheduled_step_timestamp bigint
);


ALTER TABLE public.workflow_state OWNER TO "Xenon-Dev-Admin";