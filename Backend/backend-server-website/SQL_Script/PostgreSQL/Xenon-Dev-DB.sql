--
-- PostgreSQL database dump
--

\restrict n3Z0tA83MXV9bWUYuwRd9ezH2uudUeZfcCcy4mEsmFavQexHhoOZwoVFA5rG60n

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



--
-- Data for Name: admin_event_entity; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.admin_event_entity (id, admin_event_time, realm_id, operation_type, auth_realm_id, auth_client_id, auth_user_id, ip_address, resource_path, representation, error, resource_type, details_json) FROM stdin;
\.


--
-- Data for Name: associated_policy; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.associated_policy (policy_id, associated_policy_id) FROM stdin;
\.


--
-- Data for Name: authentication_execution; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.authentication_execution (id, alias, authenticator, realm_id, flow_id, requirement, priority, authenticator_flow, auth_flow_id, auth_config) FROM stdin;
bccca495-ee9d-4357-a301-8715e5048b11    \N      auth-cookie     476d693d-9abf-4f63-a268-5002ea64c060    040fef41-5f2f-494c-978d-5a036fd5cc3d    2       10      f       \N      \N
fe48977c-7c40-4fc5-b0a2-40a0e9b192b4    \N      auth-spnego     476d693d-9abf-4f63-a268-5002ea64c060    040fef41-5f2f-494c-978d-5a036fd5cc3d    3       20      f       \N      \N
f0bd2961-0b64-46d9-b730-739e14cb6e9c    \N      identity-provider-redirector    476d693d-9abf-4f63-a268-5002ea64c060   040fef41-5f2f-494c-978d-5a036fd5cc3d     2       25      f       \N      \N
c33ea563-1a89-4b0d-a55e-edd444bc3ed8    \N      \N      476d693d-9abf-4f63-a268-5002ea64c060    040fef41-5f2f-494c-978d-5a036fd5cc3d    2       30      t       0172c8aa-8066-45cd-b0eb-da626f92a334    \N
50ccee5a-c016-4bc5-ac91-0848b6186feb    \N      auth-username-password-form     476d693d-9abf-4f63-a268-5002ea64c060   0172c8aa-8066-45cd-b0eb-da626f92a334     0       10      f       \N      \N
626041f5-b7f4-4596-b70e-da29d9a7c4fe    \N      \N      476d693d-9abf-4f63-a268-5002ea64c060    0172c8aa-8066-45cd-b0eb-da626f92a334    1       20      t       30abda34-04fe-4481-977e-f8807c8ec45e    \N
d9e8be93-754f-4003-8916-a7c0644129b8    \N      conditional-user-configured     476d693d-9abf-4f63-a268-5002ea64c060   30abda34-04fe-4481-977e-f8807c8ec45e     0       10      f       \N      \N
78f03f7b-ff0d-41e0-831b-a0b7adc4765e    \N      conditional-credential  476d693d-9abf-4f63-a268-5002ea64c060    30abda34-04fe-4481-977e-f8807c8ec45e    0       20      f       \N      2c3f8e2b-e275-473e-a820-627cf65c880d
449477ac-3c2c-4b39-a9b6-415f2590b7b0    \N      auth-otp-form   476d693d-9abf-4f63-a268-5002ea64c060    30abda34-04fe-4481-977e-f8807c8ec45e    2       30      f       \N      \N
4d3f8624-f097-4c8a-8bc1-4130afd06f5a    \N      webauthn-authenticator  476d693d-9abf-4f63-a268-5002ea64c060    30abda34-04fe-4481-977e-f8807c8ec45e    3       40      f       \N      \N
bd110c5a-e219-4aed-9c19-a3a5492f6c04    \N      auth-recovery-authn-code-form   476d693d-9abf-4f63-a268-5002ea64c060   30abda34-04fe-4481-977e-f8807c8ec45e     3       50      f       \N      \N
b659576a-c72d-4772-800a-d7f915a86fbd    \N      direct-grant-validate-username  476d693d-9abf-4f63-a268-5002ea64c060   a57bd553-7815-4191-b0e0-451ca19642b6     0       10      f       \N      \N
9139ea56-8902-4367-9850-92d8137357bb    \N      direct-grant-validate-password  476d693d-9abf-4f63-a268-5002ea64c060   a57bd553-7815-4191-b0e0-451ca19642b6     0       20      f       \N      \N
8b62dd11-ed1c-43b0-a499-ecffab4b8361    \N      \N      476d693d-9abf-4f63-a268-5002ea64c060    a57bd553-7815-4191-b0e0-451ca19642b6    1       30      t       cfe664f4-e374-4b83-b8a3-80f1c95062a9    \N
ddc761cd-616b-4876-a8e8-fffa26de112a    \N      conditional-user-configured     476d693d-9abf-4f63-a268-5002ea64c060   cfe664f4-e374-4b83-b8a3-80f1c95062a9     0       10      f       \N      \N
f7525309-e33e-4c60-b94f-d91094bd3959    \N      direct-grant-validate-otp       476d693d-9abf-4f63-a268-5002ea64c060   cfe664f4-e374-4b83-b8a3-80f1c95062a9     0       20      f       \N      \N
086b4b1c-406a-409c-b275-6d9d31eb1882    \N      registration-page-form  476d693d-9abf-4f63-a268-5002ea64c060    c04df8d7-905a-4cc7-a1cd-315fa9f34fdd    0       10      t       73a557e8-53d2-4e97-bf3f-642b11620030    \N
22350378-9b04-47fb-a317-ae3c4067be58    \N      registration-user-creation      476d693d-9abf-4f63-a268-5002ea64c060   73a557e8-53d2-4e97-bf3f-642b11620030     0       20      f       \N      \N
b20c0c39-ac05-4f3d-a568-0113f1db5871    \N      registration-password-action    476d693d-9abf-4f63-a268-5002ea64c060   73a557e8-53d2-4e97-bf3f-642b11620030     0       50      f       \N      \N
c3a79a15-5256-43cc-aa44-85aa4a4a600e    \N      registration-recaptcha-action   476d693d-9abf-4f63-a268-5002ea64c060   73a557e8-53d2-4e97-bf3f-642b11620030     3       60      f       \N      \N
dafc8bea-d4d5-466c-b5be-be30b1194a1e    \N      registration-terms-and-conditions       476d693d-9abf-4f63-a268-5002ea64c060    73a557e8-53d2-4e97-bf3f-642b11620030    3       70      f       \N      \N
9d8b35bf-e845-4c98-84b9-5b6c25b02c5f    \N      reset-credentials-choose-user   476d693d-9abf-4f63-a268-5002ea64c060   01dfb2dc-65c5-490e-9e21-ab029f8544e0     0       10      f       \N      \N
3f76e9f7-6835-438d-b48a-f5d12b4187d1    \N      reset-credential-email  476d693d-9abf-4f63-a268-5002ea64c060    01dfb2dc-65c5-490e-9e21-ab029f8544e0    0       20      f       \N      \N
a37da38a-99ef-4bd1-a163-f65c7f122ddc    \N      reset-password  476d693d-9abf-4f63-a268-5002ea64c060    01dfb2dc-65c5-490e-9e21-ab029f8544e0    0       30      f       \N      \N
47234460-31de-4264-b780-e446d753e675    \N      \N      476d693d-9abf-4f63-a268-5002ea64c060    01dfb2dc-65c5-490e-9e21-ab029f8544e0    1       40      t       27a5fd0e-f696-43dd-8439-6bd39eb56e28    \N
db93b914-72f0-49ac-bf45-d82c8a04086d    \N      conditional-user-configured     476d693d-9abf-4f63-a268-5002ea64c060   27a5fd0e-f696-43dd-8439-6bd39eb56e28     0       10      f       \N      \N
5db46773-9db1-475e-9677-9d452791f296    \N      reset-otp       476d693d-9abf-4f63-a268-5002ea64c060    27a5fd0e-f696-43dd-8439-6bd39eb56e28    0       20      f       \N      \N
b694aadb-dda8-4e09-abb0-c2f0eb7a9c82    \N      client-secret   476d693d-9abf-4f63-a268-5002ea64c060    bd273089-9d5a-4070-bba7-c2cd0b89afa4    2       10      f       \N      \N
0593193a-71d4-48a9-828d-14d589567cf3    \N      client-jwt      476d693d-9abf-4f63-a268-5002ea64c060    bd273089-9d5a-4070-bba7-c2cd0b89afa4    2       20      f       \N      \N
1766cf20-a454-4d56-9b47-0aa53e96d750    \N      client-secret-jwt       476d693d-9abf-4f63-a268-5002ea64c060    bd273089-9d5a-4070-bba7-c2cd0b89afa4    2       30      f       \N      \N
127f9b7f-d28f-4543-bcbc-151d119605c7    \N      client-x509     476d693d-9abf-4f63-a268-5002ea64c060    bd273089-9d5a-4070-bba7-c2cd0b89afa4    2       40      f       \N      \N
e01eaa55-059c-4b1b-b5b0-4245d0cf31b6    \N      federated-jwt   476d693d-9abf-4f63-a268-5002ea64c060    bd273089-9d5a-4070-bba7-c2cd0b89afa4    2       50      f       \N      \N
f9c718ba-9af7-4104-839c-3faee908f30d    \N      idp-review-profile      476d693d-9abf-4f63-a268-5002ea64c060    384df362-a8a3-429b-9c82-4b29cecc147a    0       10      f       \N      90587060-4b49-40a5-a392-4306df620697
9678074d-391b-4b35-9a7d-da9e478228fe    \N      \N      476d693d-9abf-4f63-a268-5002ea64c060    384df362-a8a3-429b-9c82-4b29cecc147a    0       20      t       58d517ca-aca6-4dab-b404-90b0245152d8    \N
0192781f-6f62-4bcb-b2f8-9de150c3a94f    \N      idp-create-user-if-unique       476d693d-9abf-4f63-a268-5002ea64c060   58d517ca-aca6-4dab-b404-90b0245152d8     2       10      f       \N      06f45f67-735a-4982-942b-70f69f314d76
c87f036b-00ab-460b-9031-2da5e10f6145    \N      \N      476d693d-9abf-4f63-a268-5002ea64c060    58d517ca-aca6-4dab-b404-90b0245152d8    2       20      t       2cf7933d-667c-4539-94c1-89a7ce022f97    \N
5a224533-0dfd-42ac-adbc-feb110f15ea8    \N      idp-confirm-link        476d693d-9abf-4f63-a268-5002ea64c060    2cf7933d-667c-4539-94c1-89a7ce022f97    0       10      f       \N      \N
aafc45f6-b955-4670-ad4f-f73d1508b1b7    \N      \N      476d693d-9abf-4f63-a268-5002ea64c060    2cf7933d-667c-4539-94c1-89a7ce022f97    0       20      t       254098a2-b0a8-4fa4-bfa1-02ca390f6d9f    \N
f693fda3-3b7b-49fd-be2f-862802b97658    \N      idp-email-verification  476d693d-9abf-4f63-a268-5002ea64c060    254098a2-b0a8-4fa4-bfa1-02ca390f6d9f    2       10      f       \N      \N
ee1934bb-5220-4af9-b9e8-22c3d14bafb0    \N      \N      476d693d-9abf-4f63-a268-5002ea64c060    254098a2-b0a8-4fa4-bfa1-02ca390f6d9f    2       20      t       72f3f88c-6dce-4c47-b8d0-df2467b0357b    \N
89a2717e-5fef-42be-9f12-70a0cb9e979c    \N      idp-username-password-form      476d693d-9abf-4f63-a268-5002ea64c060   72f3f88c-6dce-4c47-b8d0-df2467b0357b     0       10      f       \N      \N
5212d669-6d6a-4fa9-9424-4614f20011eb    \N      \N      476d693d-9abf-4f63-a268-5002ea64c060    72f3f88c-6dce-4c47-b8d0-df2467b0357b    1       20      t       3ee3b82f-efdd-416c-b6b6-a5106910130f    \N
0b745dc1-4d58-4779-a7f4-3d788d499b4f    \N      conditional-user-configured     476d693d-9abf-4f63-a268-5002ea64c060   3ee3b82f-efdd-416c-b6b6-a5106910130f     0       10      f       \N      \N
99756b08-556b-4987-b134-f2a8fd8d5a33    \N      conditional-credential  476d693d-9abf-4f63-a268-5002ea64c060    3ee3b82f-efdd-416c-b6b6-a5106910130f    0       20      f       \N      17e3e97f-2d35-4cd6-87e9-4189e479abc2
702a824d-09b1-4f40-aa24-036ef556f03d    \N      auth-otp-form   476d693d-9abf-4f63-a268-5002ea64c060    3ee3b82f-efdd-416c-b6b6-a5106910130f    2       30      f       \N      \N
9c1c3a7f-b781-4fa5-b564-d6acee50df3c    \N      webauthn-authenticator  476d693d-9abf-4f63-a268-5002ea64c060    3ee3b82f-efdd-416c-b6b6-a5106910130f    3       40      f       \N      \N
43bed475-2913-4ba2-9166-7508f8ad0893    \N      auth-recovery-authn-code-form   476d693d-9abf-4f63-a268-5002ea64c060   3ee3b82f-efdd-416c-b6b6-a5106910130f     3       50      f       \N      \N
8bf0512f-56ab-45a2-92fb-bde75cf5066e    \N      http-basic-authenticator        476d693d-9abf-4f63-a268-5002ea64c060   2aba56ad-ae4d-49eb-bd46-4ce61710476f     0       10      f       \N      \N
f7ab292d-a6a0-484e-a625-aa7e1da5c2ec    \N      docker-http-basic-authenticator 476d693d-9abf-4f63-a268-5002ea64c060   96b41fed-4805-4711-9e86-649285675ae6     0       10      f       \N      \N
35bc40ed-d168-46c5-8137-3d3e25126aed    \N      idp-email-verification  f19d6621-c51d-4928-ab07-1e2d5efd6e78    9cd8b389-80ff-4d8e-95e0-626eb8f2b110    2       10      f       \N      \N
b314f890-2521-4c74-955f-2a167d390613    \N      \N      f19d6621-c51d-4928-ab07-1e2d5efd6e78    9cd8b389-80ff-4d8e-95e0-626eb8f2b110    2       20      t       e560cf6e-0e02-4c6e-afcd-23ab8e6c07a5    \N
a2a70323-f81b-4acd-be73-4f841b032caa    \N      conditional-user-configured     f19d6621-c51d-4928-ab07-1e2d5efd6e78   6ca5983b-54b9-4ca5-92ff-8cd5a316c445     0       10      f       \N      \N
0f270bf9-dee9-46bc-ab17-2740a3a9188e    \N      auth-otp-form   f19d6621-c51d-4928-ab07-1e2d5efd6e78    6ca5983b-54b9-4ca5-92ff-8cd5a316c445    2       20      f       \N      \N
0d5eb4e1-3726-4efa-b33b-35c5b20ea119    \N      webauthn-authenticator  f19d6621-c51d-4928-ab07-1e2d5efd6e78    6ca5983b-54b9-4ca5-92ff-8cd5a316c445    3       30      f       \N      \N
c5fa1cbd-c6dd-45bf-8003-6c041860df9b    \N      auth-recovery-authn-code-form   f19d6621-c51d-4928-ab07-1e2d5efd6e78   6ca5983b-54b9-4ca5-92ff-8cd5a316c445     3       40      f       \N      \N
b335459f-48be-417d-a614-7ee67127c7ad    \N      conditional-user-configured     f19d6621-c51d-4928-ab07-1e2d5efd6e78   36d37a56-048a-4b88-ab22-9ddb34c661d0     0       10      f       \N      \N
368d3e4e-3b07-4fd6-9e61-c0febd0edf81    \N      organization    f19d6621-c51d-4928-ab07-1e2d5efd6e78    36d37a56-048a-4b88-ab22-9ddb34c661d0    2       20      f       \N      \N
066a7096-bbe9-4c51-9112-622c2ddc2786    \N      conditional-user-configured     f19d6621-c51d-4928-ab07-1e2d5efd6e78   74dc2c06-f7b0-4ec8-a6f8-ab8f2ccdc9cc     0       10      f       \N      \N
054c293a-9c06-4d30-8722-2148d0756db1    \N      direct-grant-validate-otp       f19d6621-c51d-4928-ab07-1e2d5efd6e78   74dc2c06-f7b0-4ec8-a6f8-ab8f2ccdc9cc     0       20      f       \N      \N
b6392291-ad39-4884-ad26-2242721ab4a8    \N      conditional-user-configured     f19d6621-c51d-4928-ab07-1e2d5efd6e78   2a5e411b-ee99-4cfa-8f5f-62432a4e9cdd     0       10      f       \N      \N
7f42e8d7-1356-457a-9d52-479c61991af6    \N      idp-add-organization-member     f19d6621-c51d-4928-ab07-1e2d5efd6e78   2a5e411b-ee99-4cfa-8f5f-62432a4e9cdd     0       20      f       \N      \N
828082c4-3ff5-4176-b792-54cc65d83408    \N      conditional-user-configured     f19d6621-c51d-4928-ab07-1e2d5efd6e78   2e3794a6-0bc8-47c3-b121-b1b40d69baed     0       10      f       \N      \N
d6ebb4b1-4aa3-4da2-b08b-47454f3e4ba6    \N      auth-otp-form   f19d6621-c51d-4928-ab07-1e2d5efd6e78    2e3794a6-0bc8-47c3-b121-b1b40d69baed    2       20      f       \N      \N
fabe218f-38e6-46e1-b7fc-f3b4119e1439    \N      webauthn-authenticator  f19d6621-c51d-4928-ab07-1e2d5efd6e78    2e3794a6-0bc8-47c3-b121-b1b40d69baed    3       30      f       \N      \N
d840e7ec-a437-478f-aa31-68a526fe1950    \N      auth-recovery-authn-code-form   f19d6621-c51d-4928-ab07-1e2d5efd6e78   2e3794a6-0bc8-47c3-b121-b1b40d69baed     3       40      f       \N      \N
ae4e4a8e-356b-4c67-9e01-5d3351db292f    \N      idp-confirm-link        f19d6621-c51d-4928-ab07-1e2d5efd6e78    9c48fda0-ca66-4f2a-9e79-2c911059c026    0       10      f       \N      \N
7c062976-e37a-4ee9-985d-f07d9c04801b    \N      \N      f19d6621-c51d-4928-ab07-1e2d5efd6e78    9c48fda0-ca66-4f2a-9e79-2c911059c026    0       20      t       9cd8b389-80ff-4d8e-95e0-626eb8f2b110    \N
20609401-0237-48a8-a529-7b7377952899    \N      \N      f19d6621-c51d-4928-ab07-1e2d5efd6e78    f0e4e446-1328-4f6a-9fbe-51c5b7b651f7    1       10      t       36d37a56-048a-4b88-ab22-9ddb34c661d0    \N
1f8f7534-0663-489b-adc2-a562ec52546b    \N      conditional-user-configured     f19d6621-c51d-4928-ab07-1e2d5efd6e78   b970febf-3754-467d-9340-c850c2bc9dbe     0       10      f       \N      \N
0ae7ba7c-27a1-4396-b512-0cb2e8414e50    \N      reset-otp       f19d6621-c51d-4928-ab07-1e2d5efd6e78    b970febf-3754-467d-9340-c850c2bc9dbe    0       20      f       \N      \N
2dfdf796-a3a2-433f-991b-565d287b4355    \N      idp-create-user-if-unique       f19d6621-c51d-4928-ab07-1e2d5efd6e78   382b9f99-34d4-4371-9727-5c377e93a681     2       10      f       \N      4c67b567-95b1-47e9-b7f1-6620276f3a39
fa806175-eb53-4f9e-a337-6da678af44ce    \N      \N      f19d6621-c51d-4928-ab07-1e2d5efd6e78    382b9f99-34d4-4371-9727-5c377e93a681    2       20      t       9c48fda0-ca66-4f2a-9e79-2c911059c026    \N
884f9045-f259-4698-a0de-c932e5d5084f    \N      idp-username-password-form      f19d6621-c51d-4928-ab07-1e2d5efd6e78   e560cf6e-0e02-4c6e-afcd-23ab8e6c07a5     0       10      f       \N      \N
06987cff-a317-42e0-b0a9-2fa6eb63d4d7    \N      \N      f19d6621-c51d-4928-ab07-1e2d5efd6e78    e560cf6e-0e02-4c6e-afcd-23ab8e6c07a5    1       20      t       2e3794a6-0bc8-47c3-b121-b1b40d69baed    \N
e8528725-d7c6-4b76-a4d3-86efda981b04    \N      auth-cookie     f19d6621-c51d-4928-ab07-1e2d5efd6e78    d3065499-91cd-4ffc-8dfd-ff640c427933    2       10      f       \N      \N
22040d0f-5d43-49b9-9aa2-1150620f9509    \N      auth-spnego     f19d6621-c51d-4928-ab07-1e2d5efd6e78    d3065499-91cd-4ffc-8dfd-ff640c427933    3       20      f       \N      \N
df76b732-4f97-440b-b70e-f6fe33e836ed    \N      identity-provider-redirector    f19d6621-c51d-4928-ab07-1e2d5efd6e78   d3065499-91cd-4ffc-8dfd-ff640c427933     2       25      f       \N      \N
114a09a7-b71a-40ad-9ddd-247573b6a6e5    \N      \N      f19d6621-c51d-4928-ab07-1e2d5efd6e78    d3065499-91cd-4ffc-8dfd-ff640c427933    2       26      t       f0e4e446-1328-4f6a-9fbe-51c5b7b651f7    \N
a7f1ff22-668d-4696-9253-4e2d6b8bfefc    \N      \N      f19d6621-c51d-4928-ab07-1e2d5efd6e78    d3065499-91cd-4ffc-8dfd-ff640c427933    2       30      t       edee62a7-b407-4e6b-819a-6aefdc14ab36    \N
53d95b2f-a17a-4901-a113-560bcd5955f4    \N      client-secret   f19d6621-c51d-4928-ab07-1e2d5efd6e78    26d68d38-fe11-4a4b-8633-1b583f5a414f    2       10      f       \N      \N
e647ca56-1501-4e1d-9f32-4ff8be923632    \N      client-jwt      f19d6621-c51d-4928-ab07-1e2d5efd6e78    26d68d38-fe11-4a4b-8633-1b583f5a414f    2       20      f       \N      \N
65a12b53-6a93-4e75-9559-123b3d6c8eb2    \N      client-secret-jwt       f19d6621-c51d-4928-ab07-1e2d5efd6e78    26d68d38-fe11-4a4b-8633-1b583f5a414f    2       30      f       \N      \N
3bf70816-c58a-4923-891b-ecc791aaa665    \N      client-x509     f19d6621-c51d-4928-ab07-1e2d5efd6e78    26d68d38-fe11-4a4b-8633-1b583f5a414f    2       40      f       \N      \N
74865e50-af93-4862-86e3-e91676728f26    \N      direct-grant-validate-username  f19d6621-c51d-4928-ab07-1e2d5efd6e78   bcc4f0fe-9a6d-4c65-bd59-5ab6831157b3     0       10      f       \N      \N
d14bb7fe-eab4-49b3-bb81-8207a1c83d61    \N      direct-grant-validate-password  f19d6621-c51d-4928-ab07-1e2d5efd6e78   bcc4f0fe-9a6d-4c65-bd59-5ab6831157b3     0       20      f       \N      \N
34124aa4-6e9d-4f97-847e-9c9a8a3a2b61    \N      \N      f19d6621-c51d-4928-ab07-1e2d5efd6e78    bcc4f0fe-9a6d-4c65-bd59-5ab6831157b3    1       30      t       74dc2c06-f7b0-4ec8-a6f8-ab8f2ccdc9cc    \N
b2bcfda7-490e-4d92-97e1-42b7bba64516    \N      docker-http-basic-authenticator f19d6621-c51d-4928-ab07-1e2d5efd6e78   22d63ff9-27ac-49b3-8e02-01aa1591bc39     0       10      f       \N      \N
9b84e72d-0f44-4ff7-b415-c815e01ff164    \N      idp-review-profile      f19d6621-c51d-4928-ab07-1e2d5efd6e78    fa7fcc2d-669b-4e44-9245-9c9e1e7a648d    0       10      f       \N      e5fd8d9b-0ad7-44a4-918f-f780de97515a
9359b3ee-ea2a-4df0-baf8-b0e1e1b48e4e    \N      \N      f19d6621-c51d-4928-ab07-1e2d5efd6e78    fa7fcc2d-669b-4e44-9245-9c9e1e7a648d    0       20      t       382b9f99-34d4-4371-9727-5c377e93a681    \N
0fdab472-942a-4a2c-bb0f-09e42e8a9e86    \N      \N      f19d6621-c51d-4928-ab07-1e2d5efd6e78    fa7fcc2d-669b-4e44-9245-9c9e1e7a648d    1       50      t       2a5e411b-ee99-4cfa-8f5f-62432a4e9cdd    \N
e7e52bba-69f4-4a1a-bd5b-40ab750604b7    \N      auth-username-password-form     f19d6621-c51d-4928-ab07-1e2d5efd6e78   edee62a7-b407-4e6b-819a-6aefdc14ab36     0       10      f       \N      \N
a9672772-cd2d-4361-9dcc-b0371f5a7ba4    \N      \N      f19d6621-c51d-4928-ab07-1e2d5efd6e78    edee62a7-b407-4e6b-819a-6aefdc14ab36    1       20      t       6ca5983b-54b9-4ca5-92ff-8cd5a316c445    \N
973391c6-01e5-475a-80e5-a1bc4ca04c33    \N      registration-page-form  f19d6621-c51d-4928-ab07-1e2d5efd6e78    1a9e17a3-760f-4ff2-94aa-f9c03fc1639a    0       10      t       195f2234-732f-413e-9932-7c6a2ed31149    \N
03e7180a-81a9-4dc1-aff6-1696a067d83f    \N      registration-user-creation      f19d6621-c51d-4928-ab07-1e2d5efd6e78   195f2234-732f-413e-9932-7c6a2ed31149     0       20      f       \N      \N
11264628-b2a5-4ed9-a61c-33473c9be6c0    \N      registration-password-action    f19d6621-c51d-4928-ab07-1e2d5efd6e78   195f2234-732f-413e-9932-7c6a2ed31149     0       50      f       \N      \N
8624f27c-89ba-4a31-afd9-62b9b1dd07a2    \N      registration-recaptcha-action   f19d6621-c51d-4928-ab07-1e2d5efd6e78   195f2234-732f-413e-9932-7c6a2ed31149     3       60      f       \N      \N
e6bf4b56-a9ca-407d-9b57-917ae687170e    \N      registration-terms-and-conditions       f19d6621-c51d-4928-ab07-1e2d5efd6e78    195f2234-732f-413e-9932-7c6a2ed31149    3       70      f       \N      \N
6c7477c8-72fd-440a-a8fa-f7260d762624    \N      reset-credentials-choose-user   f19d6621-c51d-4928-ab07-1e2d5efd6e78   68303f1c-cdbd-41d2-be1f-581609355e3d     0       10      f       \N      \N
85dc2006-3a67-4649-a201-1b89d6c3c1c8    \N      reset-credential-email  f19d6621-c51d-4928-ab07-1e2d5efd6e78    68303f1c-cdbd-41d2-be1f-581609355e3d    0       20      f       \N      \N
48d4b384-3cb1-4177-91f0-70dddcd13c50    \N      reset-password  f19d6621-c51d-4928-ab07-1e2d5efd6e78    68303f1c-cdbd-41d2-be1f-581609355e3d    0       30      f       \N      \N
560e0fa3-9a95-436f-812f-37f4a922caf3    \N      \N      f19d6621-c51d-4928-ab07-1e2d5efd6e78    68303f1c-cdbd-41d2-be1f-581609355e3d    1       40      t       b970febf-3754-467d-9340-c850c2bc9dbe    \N
2aed94ec-ead7-4090-833f-8efa89509f44    \N      http-basic-authenticator        f19d6621-c51d-4928-ab07-1e2d5efd6e78   85594030-29f1-458d-86b3-4df1a9af5412     0       10      f       \N      \N
\.


--
-- Data for Name: authentication_flow; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.authentication_flow (id, alias, description, realm_id, provider_id, top_level, built_in) FROM stdin;
040fef41-5f2f-494c-978d-5a036fd5cc3d    browser Browser based authentication    476d693d-9abf-4f63-a268-5002ea64c060   basic-flow       t       t
0172c8aa-8066-45cd-b0eb-da626f92a334    forms   Username, password, otp and other auth forms.   476d693d-9abf-4f63-a268-5002ea64c060    basic-flow      f       t
30abda34-04fe-4481-977e-f8807c8ec45e    Browser - Conditional 2FA       Flow to determine if any 2FA is required for the authentication 476d693d-9abf-4f63-a268-5002ea64c060    basic-flow      f       t
a57bd553-7815-4191-b0e0-451ca19642b6    direct grant    OpenID Connect Resource Owner Grant     476d693d-9abf-4f63-a268-5002ea64c060    basic-flow      t       t
cfe664f4-e374-4b83-b8a3-80f1c95062a9    Direct Grant - Conditional OTP  Flow to determine if the OTP is required for the authentication 476d693d-9abf-4f63-a268-5002ea64c060    basic-flow      f       t
c04df8d7-905a-4cc7-a1cd-315fa9f34fdd    registration    Registration flow       476d693d-9abf-4f63-a268-5002ea64c060   basic-flow       t       t
73a557e8-53d2-4e97-bf3f-642b11620030    registration form       Registration form       476d693d-9abf-4f63-a268-5002ea64c060    form-flow       f       t
01dfb2dc-65c5-490e-9e21-ab029f8544e0    reset credentials       Reset credentials for a user if they forgot their password or something 476d693d-9abf-4f63-a268-5002ea64c060    basic-flow      t       t
27a5fd0e-f696-43dd-8439-6bd39eb56e28    Reset - Conditional OTP Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.  476d693d-9abf-4f63-a268-5002ea64c060    basic-flow      f       t
bd273089-9d5a-4070-bba7-c2cd0b89afa4    clients Base authentication for clients 476d693d-9abf-4f63-a268-5002ea64c060   client-flow      t       t
384df362-a8a3-429b-9c82-4b29cecc147a    first broker login      Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account  476d693d-9abf-4f63-a268-5002ea64c060    basic-flow     tt
58d517ca-aca6-4dab-b404-90b0245152d8    User creation or linking        Flow for the existing/non-existing user alternatives    476d693d-9abf-4f63-a268-5002ea64c060    basic-flow      f       t
2cf7933d-667c-4539-94c1-89a7ce022f97    Handle Existing Account Handle what to do if there is existing account with same email/username like authenticated identity provider    476d693d-9abf-4f63-a268-5002ea64c060    basic-flow      f      t
254098a2-b0a8-4fa4-bfa1-02ca390f6d9f    Account verification options    Method with which to verify the existing account476d693d-9abf-4f63-a268-5002ea64c060    basic-flow      f       t
72f3f88c-6dce-4c47-b8d0-df2467b0357b    Verify Existing Account by Re-authentication    Reauthentication of existing account    476d693d-9abf-4f63-a268-5002ea64c060    basic-flow      f       t
3ee3b82f-efdd-416c-b6b6-a5106910130f    First broker login - Conditional 2FA    Flow to determine if any 2FA is required for the authentication 476d693d-9abf-4f63-a268-5002ea64c060    basic-flow      f       t
2aba56ad-ae4d-49eb-bd46-4ce61710476f    saml ecp        SAML ECP Profile Authentication Flow    476d693d-9abf-4f63-a268-5002ea64c060    basic-flow      t       t
96b41fed-4805-4711-9e86-649285675ae6    docker auth     Used by Docker clients to authenticate against the IDP  476d693d-9abf-4f63-a268-5002ea64c060    basic-flow      t       t
9cd8b389-80ff-4d8e-95e0-626eb8f2b110    Account verification options    Method with which to verity the existing accountf19d6621-c51d-4928-ab07-1e2d5efd6e78    basic-flow      f       t
6ca5983b-54b9-4ca5-92ff-8cd5a316c445    Browser - Conditional 2FA       Flow to determine if any 2FA is required for the authentication f19d6621-c51d-4928-ab07-1e2d5efd6e78    basic-flow      f       t
36d37a56-048a-4b88-ab22-9ddb34c661d0    Browser - Conditional Organization      Flow to determine if the organization identity-first login is to be used        f19d6621-c51d-4928-ab07-1e2d5efd6e78    basic-flow      f       t
74dc2c06-f7b0-4ec8-a6f8-ab8f2ccdc9cc    Direct Grant - Conditional OTP  Flow to determine if the OTP is required for the authentication f19d6621-c51d-4928-ab07-1e2d5efd6e78    basic-flow      f       t
2a5e411b-ee99-4cfa-8f5f-62432a4e9cdd    First Broker Login - Conditional Organization   Flow to determine if the authenticator that adds organization members is to be used     f19d6621-c51d-4928-ab07-1e2d5efd6e78    basic-flow      f      t
2e3794a6-0bc8-47c3-b121-b1b40d69baed    First broker login - Conditional 2FA    Flow to determine if any 2FA is required for the authentication f19d6621-c51d-4928-ab07-1e2d5efd6e78    basic-flow      f       t
9c48fda0-ca66-4f2a-9e79-2c911059c026    Handle Existing Account Handle what to do if there is existing account with same email/username like authenticated identity provider    f19d6621-c51d-4928-ab07-1e2d5efd6e78    basic-flow      f      t
f0e4e446-1328-4f6a-9fbe-51c5b7b651f7    Organization    \N      f19d6621-c51d-4928-ab07-1e2d5efd6e78    basic-flow     ft
b970febf-3754-467d-9340-c850c2bc9dbe    Reset - Conditional OTP Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.  f19d6621-c51d-4928-ab07-1e2d5efd6e78    basic-flow      f       t
382b9f99-34d4-4371-9727-5c377e93a681    User creation or linking        Flow for the existing/non-existing user alternatives    f19d6621-c51d-4928-ab07-1e2d5efd6e78    basic-flow      f       t
e560cf6e-0e02-4c6e-afcd-23ab8e6c07a5    Verify Existing Account by Re-authentication    Reauthentication of existing account    f19d6621-c51d-4928-ab07-1e2d5efd6e78    basic-flow      f       t
d3065499-91cd-4ffc-8dfd-ff640c427933    browser Browser based authentication    f19d6621-c51d-4928-ab07-1e2d5efd6e78   basic-flow       t       t
26d68d38-fe11-4a4b-8633-1b583f5a414f    clients Base authentication for clients f19d6621-c51d-4928-ab07-1e2d5efd6e78   client-flow      t       t
bcc4f0fe-9a6d-4c65-bd59-5ab6831157b3    direct grant    OpenID Connect Resource Owner Grant     f19d6621-c51d-4928-ab07-1e2d5efd6e78    basic-flow      t       t
22d63ff9-27ac-49b3-8e02-01aa1591bc39    docker auth     Used by Docker clients to authenticate against the IDP  f19d6621-c51d-4928-ab07-1e2d5efd6e78    basic-flow      t       t
fa7fcc2d-669b-4e44-9245-9c9e1e7a648d    first broker login      Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account  f19d6621-c51d-4928-ab07-1e2d5efd6e78    basic-flow     tt
edee62a7-b407-4e6b-819a-6aefdc14ab36    forms   Username, password, otp and other auth forms.   f19d6621-c51d-4928-ab07-1e2d5efd6e78    basic-flow      f       t
1a9e17a3-760f-4ff2-94aa-f9c03fc1639a    registration    Registration flow       f19d6621-c51d-4928-ab07-1e2d5efd6e78   basic-flow       t       t
195f2234-732f-413e-9932-7c6a2ed31149    registration form       Registration form       f19d6621-c51d-4928-ab07-1e2d5efd6e78    form-flow       f       t
68303f1c-cdbd-41d2-be1f-581609355e3d    reset credentials       Reset credentials for a user if they forgot their password or something f19d6621-c51d-4928-ab07-1e2d5efd6e78    basic-flow      t       t
85594030-29f1-458d-86b3-4df1a9af5412    saml ecp        SAML ECP Profile Authentication Flow    f19d6621-c51d-4928-ab07-1e2d5efd6e78    basic-flow      t       t
\.


--
-- Data for Name: authenticator_config; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.authenticator_config (id, alias, realm_id) FROM stdin;
2c3f8e2b-e275-473e-a820-627cf65c880d    browser-conditional-credential  476d693d-9abf-4f63-a268-5002ea64c060
90587060-4b49-40a5-a392-4306df620697    review profile config   476d693d-9abf-4f63-a268-5002ea64c060
06f45f67-735a-4982-942b-70f69f314d76    create unique user config       476d693d-9abf-4f63-a268-5002ea64c060
17e3e97f-2d35-4cd6-87e9-4189e479abc2    first-broker-login-conditional-credential       476d693d-9abf-4f63-a268-5002ea64c060
4c67b567-95b1-47e9-b7f1-6620276f3a39    create unique user config       f19d6621-c51d-4928-ab07-1e2d5efd6e78
e5fd8d9b-0ad7-44a4-918f-f780de97515a    review profile config   f19d6621-c51d-4928-ab07-1e2d5efd6e78
\.


--
-- Data for Name: authenticator_config_entry; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.authenticator_config_entry (authenticator_id, value, name) FROM stdin;
06f45f67-735a-4982-942b-70f69f314d76    false   require.password.update.after.registration
17e3e97f-2d35-4cd6-87e9-4189e479abc2    webauthn-passwordless   credentials
2c3f8e2b-e275-473e-a820-627cf65c880d    webauthn-passwordless   credentials
90587060-4b49-40a5-a392-4306df620697    missing update.profile.on.first.login
4c67b567-95b1-47e9-b7f1-6620276f3a39    false   require.password.update.after.registration
e5fd8d9b-0ad7-44a4-918f-f780de97515a    missing update.profile.on.first.login
\.


--
-- Data for Name: broker_link; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.broker_link (identity_provider, storage_provider_id, realm_id, broker_user_id, broker_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.client (id, enabled, full_scope_allowed, client_id, not_before, public_client, secret, base_url, bearer_only, management_url, surrogate_auth_required, realm_id, protocol, node_rereg_timeout, frontchannel_logout, consent_required, name, service_accounts_enabled, client_authenticator_type, root_url, description, registration_token, standard_flow_enabled, implicit_flow_enabled, direct_access_grants_enabled, always_display_in_console) FROM stdin;
826781ec-e76d-47ee-8ad7-b7c764855457    t       f       master-realm    0       f       \N      \N      t       \N     f476d693d-9abf-4f63-a268-5002ea64c060    \N      0       f       f       master Realm    f       client-secret   \N     \N       \N      t       f       f       f
06a7a117-2a7e-4517-8da7-1dfe8111d9d9    t       f       account 0       t       \N      /realms/master/account/ f      \N       f       476d693d-9abf-4f63-a268-5002ea64c060    openid-connect  0       f       f       ${client_account}      fclient-secret   ${authBaseUrl}  \N      \N      t       f       f       f
3a77a9b9-f7de-421d-9ae4-744d6549ba9c    t       f       account-console 0       t       \N      /realms/master/account/
f       \N      f       476d693d-9abf-4f63-a268-5002ea64c060    openid-connect  0       f       f       ${client_account-console}       f       client-secret   ${authBaseUrl}  \N      \N      t       f       f       f
dcaf507c-7935-4e1f-afc1-f8216b0d86e9    t       f       broker  0       f       \N      \N      t       \N      f      476d693d-9abf-4f63-a268-5002ea64c060     openid-connect  0       f       f       ${client_broker}        f       client-secret   \N      \N      \N      t       f       f       f
e9211db7-c532-4a67-9aec-ab78f7f3c760    t       t       security-admin-console  0       t       \N      /admin/master/console/  f       \N      f       476d693d-9abf-4f63-a268-5002ea64c060    openid-connect  0       f       f       ${client_security-admin-console}        f       client-secret   ${authAdminUrl} \N      \N      t       f       f       f
f1990876-a12d-436e-a67f-03910e6fc403    t       t       admin-cli       0       t       \N      \N      f       \N     f476d693d-9abf-4f63-a268-5002ea64c060    openid-connect  0       f       f       ${client_admin-cli}     f       client-secret   \N      \N      \N      f       f       t       f
7130ba2d-54dd-4607-8133-abe74a3dbac8    t       f       Xenon-Dev-DEV-ENV-realm 0       f       \N      \N      t      \N       f       476d693d-9abf-4f63-a268-5002ea64c060    \N      0       f       f       Xenon-Dev-DEV-ENV Realm f      client-secret    \N      \N      \N      t       f       f       f
492d289b-e100-4f7e-b6a4-f4f81bf46618    t       f       account 0       t       \N      /realms/Xenon-Dev-DEV-ENV/account/      f       \N      f       f19d6621-c51d-4928-ab07-1e2d5efd6e78    openid-connect  0       f       f       ${client_account}       f       client-secret   ${authBaseUrl}  \N      \N      t       f       f       f
4ebb77df-7b06-4f46-b29a-4aedeec0a6bd    t       f       account-console 0       t       \N      /realms/Xenon-Dev-DEV-ENV/account/      f       \N      f       f19d6621-c51d-4928-ab07-1e2d5efd6e78    openid-connect  0       f       f      ${client_account-console}        f       client-secret   ${authBaseUrl}  \N      \N      t       f       f       f
09b4c86b-9516-4cfb-b0d9-1b775ad3b3e3    t       t       admin-cli       0       t       \N      \N      f       \N     ff19d6621-c51d-4928-ab07-1e2d5efd6e78    openid-connect  0       f       f       ${client_admin-cli}     f       client-secret   \N      \N      \N      f       f       t       f
55bec7b5-cc11-4104-8410-d018afb3dc0c    t       f       broker  0       f       \N      \N      t       \N      f      f19d6621-c51d-4928-ab07-1e2d5efd6e78     openid-connect  0       f       f       ${client_broker}        f       client-secret   \N      \N      \N      t       f       f       f
e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    t       f       realm-management        0       f       \N      \N      t      \N       f       f19d6621-c51d-4928-ab07-1e2d5efd6e78    openid-connect  0       f       f       ${client_realm-management}      f       client-secret   \N      \N      \N      t       f       f       f
53e2859c-34c6-4b00-8bee-efc443e7468d    t       t       security-admin-console  0       t       \N      /admin/Xenon-Dev-DEV-ENV/console/       f       \N      f       f19d6621-c51d-4928-ab07-1e2d5efd6e78    openid-connect  0       f      f${client_security-admin-console}        f       client-secret   ${authAdminUrl} \N      \N      t       f       f      f
79013291-edda-4ffa-8125-d87720aa6d0a    t       t       xenon-dev-oauth2-client-dev-env-id      0       t       \N
f               f       f19d6621-c51d-4928-ab07-1e2d5efd6e78    openid-connect  -1      t       f       xenon-dev-oauth2-client-dev     f       client-secret                   \N      t       f       t       f
\.


--
-- Data for Name: client_attributes; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.client_attributes (client_id, name, value) FROM stdin;
06a7a117-2a7e-4517-8da7-1dfe8111d9d9    post.logout.redirect.uris       +
3a77a9b9-f7de-421d-9ae4-744d6549ba9c    post.logout.redirect.uris       +
3a77a9b9-f7de-421d-9ae4-744d6549ba9c    pkce.code.challenge.method      S256
e9211db7-c532-4a67-9aec-ab78f7f3c760    post.logout.redirect.uris       +
e9211db7-c532-4a67-9aec-ab78f7f3c760    pkce.code.challenge.method      S256
e9211db7-c532-4a67-9aec-ab78f7f3c760    client.use.lightweight.access.token.enabled     true
f1990876-a12d-436e-a67f-03910e6fc403    client.use.lightweight.access.token.enabled     true
492d289b-e100-4f7e-b6a4-f4f81bf46618    realm_client    false
492d289b-e100-4f7e-b6a4-f4f81bf46618    post.logout.redirect.uris       +
4ebb77df-7b06-4f46-b29a-4aedeec0a6bd    realm_client    false
4ebb77df-7b06-4f46-b29a-4aedeec0a6bd    post.logout.redirect.uris       +
4ebb77df-7b06-4f46-b29a-4aedeec0a6bd    pkce.code.challenge.method      S256
09b4c86b-9516-4cfb-b0d9-1b775ad3b3e3    realm_client    false
09b4c86b-9516-4cfb-b0d9-1b775ad3b3e3    client.use.lightweight.access.token.enabled     true
09b4c86b-9516-4cfb-b0d9-1b775ad3b3e3    post.logout.redirect.uris       +
55bec7b5-cc11-4104-8410-d018afb3dc0c    realm_client    true
55bec7b5-cc11-4104-8410-d018afb3dc0c    post.logout.redirect.uris       +
e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    realm_client    true
e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    post.logout.redirect.uris       +
53e2859c-34c6-4b00-8bee-efc443e7468d    realm_client    false
53e2859c-34c6-4b00-8bee-efc443e7468d    client.use.lightweight.access.token.enabled     true
53e2859c-34c6-4b00-8bee-efc443e7468d    post.logout.redirect.uris       +
53e2859c-34c6-4b00-8bee-efc443e7468d    pkce.code.challenge.method      S256
79013291-edda-4ffa-8125-d87720aa6d0a    request.object.signature.alg    any
79013291-edda-4ffa-8125-d87720aa6d0a    frontchannel.logout.session.required    true
79013291-edda-4ffa-8125-d87720aa6d0a    post.logout.redirect.uris       http://localhost:4200/landing##http://localhost:4200/assets/silent-check-sso.html##http://localhost:4200/*
79013291-edda-4ffa-8125-d87720aa6d0a    oauth2.device.authorization.grant.enabled       false
79013291-edda-4ffa-8125-d87720aa6d0a    use.jwks.url    false
79013291-edda-4ffa-8125-d87720aa6d0a    backchannel.logout.revoke.offline.tokens        false
79013291-edda-4ffa-8125-d87720aa6d0a    use.refresh.tokens      true
79013291-edda-4ffa-8125-d87720aa6d0a    realm_client    false
79013291-edda-4ffa-8125-d87720aa6d0a    oidc.ciba.grant.enabled false
79013291-edda-4ffa-8125-d87720aa6d0a    backchannel.logout.session.required     true
79013291-edda-4ffa-8125-d87720aa6d0a    client_credentials.use_refresh_token    false
79013291-edda-4ffa-8125-d87720aa6d0a    require.pushed.authorization.requests   false
79013291-edda-4ffa-8125-d87720aa6d0a    request.object.encryption.enc   any
79013291-edda-4ffa-8125-d87720aa6d0a    pkce.code.challenge.method      S256
79013291-edda-4ffa-8125-d87720aa6d0a    client.secret.creation.time     1770048983
79013291-edda-4ffa-8125-d87720aa6d0a    request.object.encryption.alg   any
79013291-edda-4ffa-8125-d87720aa6d0a    client.introspection.response.allow.jwt.claim.enabled   false
79013291-edda-4ffa-8125-d87720aa6d0a    standard.token.exchange.enabled false
79013291-edda-4ffa-8125-d87720aa6d0a    login_theme     xenon-dev-theme
79013291-edda-4ffa-8125-d87720aa6d0a    client.use.lightweight.access.token.enabled     false
79013291-edda-4ffa-8125-d87720aa6d0a    request.object.required not required
79013291-edda-4ffa-8125-d87720aa6d0a    access.token.header.type.rfc9068        false
79013291-edda-4ffa-8125-d87720aa6d0a    acr.loa.map     {}
79013291-edda-4ffa-8125-d87720aa6d0a    tls.client.certificate.bound.access.tokens      false
79013291-edda-4ffa-8125-d87720aa6d0a    display.on.consent.screen       false
79013291-edda-4ffa-8125-d87720aa6d0a    token.response.type.bearer.lower-case   false
\.


--
-- Data for Name: client_auth_flow_bindings; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.client_auth_flow_bindings (client_id, flow_id, binding_name) FROM stdin;
\.


--
-- Data for Name: client_initial_access; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.client_initial_access (id, realm_id, "timestamp", expiration, count, remaining_count) FROM stdin;
\.


--
-- Data for Name: client_node_registrations; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.client_node_registrations (client_id, value, name) FROM stdin;
\.


--
-- Data for Name: client_scope; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.client_scope (id, name, realm_id, description, protocol) FROM stdin;
fb60191e-c2db-4bf8-b82b-700851410d93    offline_access  476d693d-9abf-4f63-a268-5002ea64c060    OpenID Connect built-in scope: offline_access   openid-connect
95a6644c-e7cc-4f7e-bb63-eec682e6a15d    role_list       476d693d-9abf-4f63-a268-5002ea64c060    SAML role list  saml
dcce2317-090a-40bc-9bfd-83f1a91a8375    saml_organization       476d693d-9abf-4f63-a268-5002ea64c060    Organization Membership saml
32e4ba85-437b-463d-b57a-2dfea4490888    profile 476d693d-9abf-4f63-a268-5002ea64c060    OpenID Connect built-in scope: profile  openid-connect
2a2e6802-80de-465c-ba0a-8f1fe4318976    email   476d693d-9abf-4f63-a268-5002ea64c060    OpenID Connect built-in scope: email    openid-connect
5df01ef7-dc49-4c68-a8e2-daad8ce010a6    address 476d693d-9abf-4f63-a268-5002ea64c060    OpenID Connect built-in scope: address  openid-connect
f6d38fda-254d-403b-8b61-672f2fd91155    phone   476d693d-9abf-4f63-a268-5002ea64c060    OpenID Connect built-in scope: phone    openid-connect
6e046e75-0771-46e2-84f8-2f52829c8709    roles   476d693d-9abf-4f63-a268-5002ea64c060    OpenID Connect scope for add user roles to the access token     openid-connect
e1cf00d5-c997-4b61-b0a6-74f3996fa248    web-origins     476d693d-9abf-4f63-a268-5002ea64c060    OpenID Connect scope for add allowed web origins to the access token    openid-connect
0cef9175-9e45-4a23-a815-b64ba5d609b3    microprofile-jwt        476d693d-9abf-4f63-a268-5002ea64c060    Microprofile - JWT built-in scope       openid-connect
56883618-b18e-4f56-b9d4-ebd662c541dd    acr     476d693d-9abf-4f63-a268-5002ea64c060    OpenID Connect scope for add acr (authentication context class reference) to the token  openid-connect
71db60b6-dbe1-4f0c-90ef-fa7071f4c75c    basic   476d693d-9abf-4f63-a268-5002ea64c060    OpenID Connect scope for add all basic claims to the token      openid-connect
35863e9d-9097-463b-9764-bf14f9f436c3    service_account 476d693d-9abf-4f63-a268-5002ea64c060    Specific scope for a client enabled for service accounts        openid-connect
d4645da9-61b7-46af-9f53-58f1c2b97c1c    organization    476d693d-9abf-4f63-a268-5002ea64c060    Additional claims about the organization a subject belongs to   openid-connect
ae690761-0ba4-482a-aa90-58fd9f0b980f    email   f19d6621-c51d-4928-ab07-1e2d5efd6e78    OpenID Connect built-in scope: email    openid-connect
94e36078-7d8b-47e8-b24e-588b57c528c4    phone   f19d6621-c51d-4928-ab07-1e2d5efd6e78    OpenID Connect built-in scope: phone    openid-connect
a1fe3b88-c0e6-4483-90e8-319019ca945d    address f19d6621-c51d-4928-ab07-1e2d5efd6e78    OpenID Connect built-in scope: address  openid-connect
a84c6860-6556-4e5a-810c-58ea2e9d3588    profile f19d6621-c51d-4928-ab07-1e2d5efd6e78    OpenID Connect built-in scope: profile  openid-connect
df4de68b-a57d-4c1f-a7d5-e49594e2b111    role_list       f19d6621-c51d-4928-ab07-1e2d5efd6e78    SAML role list  saml
8ee953da-e5cc-4363-8952-e53c9d9b72d6    basic   f19d6621-c51d-4928-ab07-1e2d5efd6e78    OpenID Connect scope for add all basic claims to the token      openid-connect
6b24f028-f6d2-422d-809f-dcab22ab87ec    service_account f19d6621-c51d-4928-ab07-1e2d5efd6e78    Specific scope for a client enabled for service accounts        openid-connect
32af8254-3084-4832-903a-03692d91adcc    acr     f19d6621-c51d-4928-ab07-1e2d5efd6e78    OpenID Connect scope for add acr (authentication context class reference) to the token  openid-connect
52fc0fac-d0e0-40fd-8334-2c06f93c6279    roles   f19d6621-c51d-4928-ab07-1e2d5efd6e78    OpenID Connect scope for add user roles to the access token     openid-connect
1f1f7c63-013f-4862-b2ef-462c2fcbb0bf    offline_access  f19d6621-c51d-4928-ab07-1e2d5efd6e78    OpenID Connect built-in scope: offline_access   openid-connect
5c131446-96fa-460a-a2f7-bad0eedd08bd    microprofile-jwt        f19d6621-c51d-4928-ab07-1e2d5efd6e78    Microprofile - JWT built-in scope       openid-connect
cc5529dc-86c2-4c2c-9454-ba6b440056af    web-origins     f19d6621-c51d-4928-ab07-1e2d5efd6e78    OpenID Connect scope for add allowed web origins to the access token    openid-connect
69274c3d-34ae-496f-97b2-2f8e839d8ade    saml_organization       f19d6621-c51d-4928-ab07-1e2d5efd6e78    Organization Membership saml
6d500c07-bb73-46a3-a562-5a27b33e4187    organization    f19d6621-c51d-4928-ab07-1e2d5efd6e78    Additional claims about the organization a subject belongs to   openid-connect
\.


--
-- Data for Name: client_scope_attributes; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.client_scope_attributes (scope_id, value, name) FROM stdin;
fb60191e-c2db-4bf8-b82b-700851410d93    true    display.on.consent.screen
fb60191e-c2db-4bf8-b82b-700851410d93    ${offlineAccessScopeConsentText}        consent.screen.text
95a6644c-e7cc-4f7e-bb63-eec682e6a15d    true    display.on.consent.screen
95a6644c-e7cc-4f7e-bb63-eec682e6a15d    ${samlRoleListScopeConsentText} consent.screen.text
dcce2317-090a-40bc-9bfd-83f1a91a8375    false   display.on.consent.screen
32e4ba85-437b-463d-b57a-2dfea4490888    true    display.on.consent.screen
32e4ba85-437b-463d-b57a-2dfea4490888    ${profileScopeConsentText}      consent.screen.text
32e4ba85-437b-463d-b57a-2dfea4490888    true    include.in.token.scope
2a2e6802-80de-465c-ba0a-8f1fe4318976    true    display.on.consent.screen
2a2e6802-80de-465c-ba0a-8f1fe4318976    ${emailScopeConsentText}        consent.screen.text
2a2e6802-80de-465c-ba0a-8f1fe4318976    true    include.in.token.scope
5df01ef7-dc49-4c68-a8e2-daad8ce010a6    true    display.on.consent.screen
5df01ef7-dc49-4c68-a8e2-daad8ce010a6    ${addressScopeConsentText}      consent.screen.text
5df01ef7-dc49-4c68-a8e2-daad8ce010a6    true    include.in.token.scope
f6d38fda-254d-403b-8b61-672f2fd91155    true    display.on.consent.screen
f6d38fda-254d-403b-8b61-672f2fd91155    ${phoneScopeConsentText}        consent.screen.text
f6d38fda-254d-403b-8b61-672f2fd91155    true    include.in.token.scope
6e046e75-0771-46e2-84f8-2f52829c8709    true    display.on.consent.screen
6e046e75-0771-46e2-84f8-2f52829c8709    ${rolesScopeConsentText}        consent.screen.text
6e046e75-0771-46e2-84f8-2f52829c8709    false   include.in.token.scope
e1cf00d5-c997-4b61-b0a6-74f3996fa248    false   display.on.consent.screen
e1cf00d5-c997-4b61-b0a6-74f3996fa248            consent.screen.text
e1cf00d5-c997-4b61-b0a6-74f3996fa248    false   include.in.token.scope
0cef9175-9e45-4a23-a815-b64ba5d609b3    false   display.on.consent.screen
0cef9175-9e45-4a23-a815-b64ba5d609b3    true    include.in.token.scope
56883618-b18e-4f56-b9d4-ebd662c541dd    false   display.on.consent.screen
56883618-b18e-4f56-b9d4-ebd662c541dd    false   include.in.token.scope
71db60b6-dbe1-4f0c-90ef-fa7071f4c75c    false   display.on.consent.screen
71db60b6-dbe1-4f0c-90ef-fa7071f4c75c    false   include.in.token.scope
35863e9d-9097-463b-9764-bf14f9f436c3    false   display.on.consent.screen
35863e9d-9097-463b-9764-bf14f9f436c3    false   include.in.token.scope
d4645da9-61b7-46af-9f53-58f1c2b97c1c    true    display.on.consent.screen
d4645da9-61b7-46af-9f53-58f1c2b97c1c    ${organizationScopeConsentText} consent.screen.text
d4645da9-61b7-46af-9f53-58f1c2b97c1c    true    include.in.token.scope
ae690761-0ba4-482a-aa90-58fd9f0b980f    true    include.in.token.scope
ae690761-0ba4-482a-aa90-58fd9f0b980f    ${emailScopeConsentText}        consent.screen.text
ae690761-0ba4-482a-aa90-58fd9f0b980f    true    display.on.consent.screen
94e36078-7d8b-47e8-b24e-588b57c528c4    true    include.in.token.scope
94e36078-7d8b-47e8-b24e-588b57c528c4    ${phoneScopeConsentText}        consent.screen.text
94e36078-7d8b-47e8-b24e-588b57c528c4    true    display.on.consent.screen
a1fe3b88-c0e6-4483-90e8-319019ca945d    true    include.in.token.scope
a1fe3b88-c0e6-4483-90e8-319019ca945d    ${addressScopeConsentText}      consent.screen.text
a1fe3b88-c0e6-4483-90e8-319019ca945d    true    display.on.consent.screen
a84c6860-6556-4e5a-810c-58ea2e9d3588    true    include.in.token.scope
a84c6860-6556-4e5a-810c-58ea2e9d3588    ${profileScopeConsentText}      consent.screen.text
a84c6860-6556-4e5a-810c-58ea2e9d3588    true    display.on.consent.screen
df4de68b-a57d-4c1f-a7d5-e49594e2b111    ${samlRoleListScopeConsentText} consent.screen.text
df4de68b-a57d-4c1f-a7d5-e49594e2b111    true    display.on.consent.screen
8ee953da-e5cc-4363-8952-e53c9d9b72d6    false   include.in.token.scope
8ee953da-e5cc-4363-8952-e53c9d9b72d6    false   display.on.consent.screen
6b24f028-f6d2-422d-809f-dcab22ab87ec    false   include.in.token.scope
6b24f028-f6d2-422d-809f-dcab22ab87ec    false   display.on.consent.screen
32af8254-3084-4832-903a-03692d91adcc    false   include.in.token.scope
32af8254-3084-4832-903a-03692d91adcc    false   display.on.consent.screen
52fc0fac-d0e0-40fd-8334-2c06f93c6279    false   include.in.token.scope
52fc0fac-d0e0-40fd-8334-2c06f93c6279    ${rolesScopeConsentText}        consent.screen.text
52fc0fac-d0e0-40fd-8334-2c06f93c6279    true    display.on.consent.screen
1f1f7c63-013f-4862-b2ef-462c2fcbb0bf    ${offlineAccessScopeConsentText}        consent.screen.text
1f1f7c63-013f-4862-b2ef-462c2fcbb0bf    true    display.on.consent.screen
5c131446-96fa-460a-a2f7-bad0eedd08bd    true    include.in.token.scope
5c131446-96fa-460a-a2f7-bad0eedd08bd    false   display.on.consent.screen
cc5529dc-86c2-4c2c-9454-ba6b440056af    false   include.in.token.scope
cc5529dc-86c2-4c2c-9454-ba6b440056af            consent.screen.text
cc5529dc-86c2-4c2c-9454-ba6b440056af    false   display.on.consent.screen
69274c3d-34ae-496f-97b2-2f8e839d8ade    false   display.on.consent.screen
6d500c07-bb73-46a3-a562-5a27b33e4187    true    include.in.token.scope
6d500c07-bb73-46a3-a562-5a27b33e4187    ${organizationScopeConsentText} consent.screen.text
6d500c07-bb73-46a3-a562-5a27b33e4187    true    display.on.consent.screen
\.


--
-- Data for Name: client_scope_client; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.client_scope_client (client_id, scope_id, default_scope) FROM stdin;
06a7a117-2a7e-4517-8da7-1dfe8111d9d9    56883618-b18e-4f56-b9d4-ebd662c541dd    t
06a7a117-2a7e-4517-8da7-1dfe8111d9d9    32e4ba85-437b-463d-b57a-2dfea4490888    t
06a7a117-2a7e-4517-8da7-1dfe8111d9d9    71db60b6-dbe1-4f0c-90ef-fa7071f4c75c    t
06a7a117-2a7e-4517-8da7-1dfe8111d9d9    6e046e75-0771-46e2-84f8-2f52829c8709    t
06a7a117-2a7e-4517-8da7-1dfe8111d9d9    e1cf00d5-c997-4b61-b0a6-74f3996fa248    t
06a7a117-2a7e-4517-8da7-1dfe8111d9d9    2a2e6802-80de-465c-ba0a-8f1fe4318976    t
06a7a117-2a7e-4517-8da7-1dfe8111d9d9    f6d38fda-254d-403b-8b61-672f2fd91155    f
06a7a117-2a7e-4517-8da7-1dfe8111d9d9    0cef9175-9e45-4a23-a815-b64ba5d609b3    f
06a7a117-2a7e-4517-8da7-1dfe8111d9d9    fb60191e-c2db-4bf8-b82b-700851410d93    f
06a7a117-2a7e-4517-8da7-1dfe8111d9d9    5df01ef7-dc49-4c68-a8e2-daad8ce010a6    f
06a7a117-2a7e-4517-8da7-1dfe8111d9d9    d4645da9-61b7-46af-9f53-58f1c2b97c1c    f
3a77a9b9-f7de-421d-9ae4-744d6549ba9c    56883618-b18e-4f56-b9d4-ebd662c541dd    t
3a77a9b9-f7de-421d-9ae4-744d6549ba9c    32e4ba85-437b-463d-b57a-2dfea4490888    t
3a77a9b9-f7de-421d-9ae4-744d6549ba9c    71db60b6-dbe1-4f0c-90ef-fa7071f4c75c    t
3a77a9b9-f7de-421d-9ae4-744d6549ba9c    6e046e75-0771-46e2-84f8-2f52829c8709    t
3a77a9b9-f7de-421d-9ae4-744d6549ba9c    e1cf00d5-c997-4b61-b0a6-74f3996fa248    t
3a77a9b9-f7de-421d-9ae4-744d6549ba9c    2a2e6802-80de-465c-ba0a-8f1fe4318976    t
3a77a9b9-f7de-421d-9ae4-744d6549ba9c    f6d38fda-254d-403b-8b61-672f2fd91155    f
3a77a9b9-f7de-421d-9ae4-744d6549ba9c    0cef9175-9e45-4a23-a815-b64ba5d609b3    f
3a77a9b9-f7de-421d-9ae4-744d6549ba9c    fb60191e-c2db-4bf8-b82b-700851410d93    f
3a77a9b9-f7de-421d-9ae4-744d6549ba9c    5df01ef7-dc49-4c68-a8e2-daad8ce010a6    f
3a77a9b9-f7de-421d-9ae4-744d6549ba9c    d4645da9-61b7-46af-9f53-58f1c2b97c1c    f
f1990876-a12d-436e-a67f-03910e6fc403    56883618-b18e-4f56-b9d4-ebd662c541dd    t
f1990876-a12d-436e-a67f-03910e6fc403    32e4ba85-437b-463d-b57a-2dfea4490888    t
f1990876-a12d-436e-a67f-03910e6fc403    71db60b6-dbe1-4f0c-90ef-fa7071f4c75c    t
f1990876-a12d-436e-a67f-03910e6fc403    6e046e75-0771-46e2-84f8-2f52829c8709    t
f1990876-a12d-436e-a67f-03910e6fc403    e1cf00d5-c997-4b61-b0a6-74f3996fa248    t
f1990876-a12d-436e-a67f-03910e6fc403    2a2e6802-80de-465c-ba0a-8f1fe4318976    t
f1990876-a12d-436e-a67f-03910e6fc403    f6d38fda-254d-403b-8b61-672f2fd91155    f
f1990876-a12d-436e-a67f-03910e6fc403    0cef9175-9e45-4a23-a815-b64ba5d609b3    f
f1990876-a12d-436e-a67f-03910e6fc403    fb60191e-c2db-4bf8-b82b-700851410d93    f
f1990876-a12d-436e-a67f-03910e6fc403    5df01ef7-dc49-4c68-a8e2-daad8ce010a6    f
f1990876-a12d-436e-a67f-03910e6fc403    d4645da9-61b7-46af-9f53-58f1c2b97c1c    f
dcaf507c-7935-4e1f-afc1-f8216b0d86e9    56883618-b18e-4f56-b9d4-ebd662c541dd    t
dcaf507c-7935-4e1f-afc1-f8216b0d86e9    32e4ba85-437b-463d-b57a-2dfea4490888    t
dcaf507c-7935-4e1f-afc1-f8216b0d86e9    71db60b6-dbe1-4f0c-90ef-fa7071f4c75c    t
dcaf507c-7935-4e1f-afc1-f8216b0d86e9    6e046e75-0771-46e2-84f8-2f52829c8709    t
dcaf507c-7935-4e1f-afc1-f8216b0d86e9    e1cf00d5-c997-4b61-b0a6-74f3996fa248    t
dcaf507c-7935-4e1f-afc1-f8216b0d86e9    2a2e6802-80de-465c-ba0a-8f1fe4318976    t
dcaf507c-7935-4e1f-afc1-f8216b0d86e9    f6d38fda-254d-403b-8b61-672f2fd91155    f
dcaf507c-7935-4e1f-afc1-f8216b0d86e9    0cef9175-9e45-4a23-a815-b64ba5d609b3    f
dcaf507c-7935-4e1f-afc1-f8216b0d86e9    fb60191e-c2db-4bf8-b82b-700851410d93    f
dcaf507c-7935-4e1f-afc1-f8216b0d86e9    5df01ef7-dc49-4c68-a8e2-daad8ce010a6    f
dcaf507c-7935-4e1f-afc1-f8216b0d86e9    d4645da9-61b7-46af-9f53-58f1c2b97c1c    f
826781ec-e76d-47ee-8ad7-b7c764855457    56883618-b18e-4f56-b9d4-ebd662c541dd    t
826781ec-e76d-47ee-8ad7-b7c764855457    32e4ba85-437b-463d-b57a-2dfea4490888    t
826781ec-e76d-47ee-8ad7-b7c764855457    71db60b6-dbe1-4f0c-90ef-fa7071f4c75c    t
826781ec-e76d-47ee-8ad7-b7c764855457    6e046e75-0771-46e2-84f8-2f52829c8709    t
826781ec-e76d-47ee-8ad7-b7c764855457    e1cf00d5-c997-4b61-b0a6-74f3996fa248    t
826781ec-e76d-47ee-8ad7-b7c764855457    2a2e6802-80de-465c-ba0a-8f1fe4318976    t
826781ec-e76d-47ee-8ad7-b7c764855457    f6d38fda-254d-403b-8b61-672f2fd91155    f
826781ec-e76d-47ee-8ad7-b7c764855457    0cef9175-9e45-4a23-a815-b64ba5d609b3    f
826781ec-e76d-47ee-8ad7-b7c764855457    fb60191e-c2db-4bf8-b82b-700851410d93    f
826781ec-e76d-47ee-8ad7-b7c764855457    5df01ef7-dc49-4c68-a8e2-daad8ce010a6    f
826781ec-e76d-47ee-8ad7-b7c764855457    d4645da9-61b7-46af-9f53-58f1c2b97c1c    f
e9211db7-c532-4a67-9aec-ab78f7f3c760    56883618-b18e-4f56-b9d4-ebd662c541dd    t
e9211db7-c532-4a67-9aec-ab78f7f3c760    32e4ba85-437b-463d-b57a-2dfea4490888    t
e9211db7-c532-4a67-9aec-ab78f7f3c760    71db60b6-dbe1-4f0c-90ef-fa7071f4c75c    t
e9211db7-c532-4a67-9aec-ab78f7f3c760    6e046e75-0771-46e2-84f8-2f52829c8709    t
e9211db7-c532-4a67-9aec-ab78f7f3c760    e1cf00d5-c997-4b61-b0a6-74f3996fa248    t
e9211db7-c532-4a67-9aec-ab78f7f3c760    2a2e6802-80de-465c-ba0a-8f1fe4318976    t
e9211db7-c532-4a67-9aec-ab78f7f3c760    f6d38fda-254d-403b-8b61-672f2fd91155    f
e9211db7-c532-4a67-9aec-ab78f7f3c760    0cef9175-9e45-4a23-a815-b64ba5d609b3    f
e9211db7-c532-4a67-9aec-ab78f7f3c760    fb60191e-c2db-4bf8-b82b-700851410d93    f
e9211db7-c532-4a67-9aec-ab78f7f3c760    5df01ef7-dc49-4c68-a8e2-daad8ce010a6    f
e9211db7-c532-4a67-9aec-ab78f7f3c760    d4645da9-61b7-46af-9f53-58f1c2b97c1c    f
492d289b-e100-4f7e-b6a4-f4f81bf46618    a84c6860-6556-4e5a-810c-58ea2e9d3588    t
492d289b-e100-4f7e-b6a4-f4f81bf46618    8ee953da-e5cc-4363-8952-e53c9d9b72d6    t
492d289b-e100-4f7e-b6a4-f4f81bf46618    ae690761-0ba4-482a-aa90-58fd9f0b980f    t
492d289b-e100-4f7e-b6a4-f4f81bf46618    32af8254-3084-4832-903a-03692d91adcc    t
492d289b-e100-4f7e-b6a4-f4f81bf46618    52fc0fac-d0e0-40fd-8334-2c06f93c6279    t
492d289b-e100-4f7e-b6a4-f4f81bf46618    cc5529dc-86c2-4c2c-9454-ba6b440056af    t
492d289b-e100-4f7e-b6a4-f4f81bf46618    1f1f7c63-013f-4862-b2ef-462c2fcbb0bf    f
492d289b-e100-4f7e-b6a4-f4f81bf46618    94e36078-7d8b-47e8-b24e-588b57c528c4    f
492d289b-e100-4f7e-b6a4-f4f81bf46618    5c131446-96fa-460a-a2f7-bad0eedd08bd    f
492d289b-e100-4f7e-b6a4-f4f81bf46618    a1fe3b88-c0e6-4483-90e8-319019ca945d    f
492d289b-e100-4f7e-b6a4-f4f81bf46618    6d500c07-bb73-46a3-a562-5a27b33e4187    f
4ebb77df-7b06-4f46-b29a-4aedeec0a6bd    a84c6860-6556-4e5a-810c-58ea2e9d3588    t
4ebb77df-7b06-4f46-b29a-4aedeec0a6bd    8ee953da-e5cc-4363-8952-e53c9d9b72d6    t
4ebb77df-7b06-4f46-b29a-4aedeec0a6bd    ae690761-0ba4-482a-aa90-58fd9f0b980f    t
4ebb77df-7b06-4f46-b29a-4aedeec0a6bd    32af8254-3084-4832-903a-03692d91adcc    t
4ebb77df-7b06-4f46-b29a-4aedeec0a6bd    52fc0fac-d0e0-40fd-8334-2c06f93c6279    t
4ebb77df-7b06-4f46-b29a-4aedeec0a6bd    cc5529dc-86c2-4c2c-9454-ba6b440056af    t
4ebb77df-7b06-4f46-b29a-4aedeec0a6bd    1f1f7c63-013f-4862-b2ef-462c2fcbb0bf    f
4ebb77df-7b06-4f46-b29a-4aedeec0a6bd    94e36078-7d8b-47e8-b24e-588b57c528c4    f
4ebb77df-7b06-4f46-b29a-4aedeec0a6bd    5c131446-96fa-460a-a2f7-bad0eedd08bd    f
4ebb77df-7b06-4f46-b29a-4aedeec0a6bd    a1fe3b88-c0e6-4483-90e8-319019ca945d    f
4ebb77df-7b06-4f46-b29a-4aedeec0a6bd    6d500c07-bb73-46a3-a562-5a27b33e4187    f
09b4c86b-9516-4cfb-b0d9-1b775ad3b3e3    a84c6860-6556-4e5a-810c-58ea2e9d3588    t
09b4c86b-9516-4cfb-b0d9-1b775ad3b3e3    8ee953da-e5cc-4363-8952-e53c9d9b72d6    t
09b4c86b-9516-4cfb-b0d9-1b775ad3b3e3    ae690761-0ba4-482a-aa90-58fd9f0b980f    t
09b4c86b-9516-4cfb-b0d9-1b775ad3b3e3    32af8254-3084-4832-903a-03692d91adcc    t
09b4c86b-9516-4cfb-b0d9-1b775ad3b3e3    52fc0fac-d0e0-40fd-8334-2c06f93c6279    t
09b4c86b-9516-4cfb-b0d9-1b775ad3b3e3    cc5529dc-86c2-4c2c-9454-ba6b440056af    t
09b4c86b-9516-4cfb-b0d9-1b775ad3b3e3    1f1f7c63-013f-4862-b2ef-462c2fcbb0bf    f
09b4c86b-9516-4cfb-b0d9-1b775ad3b3e3    94e36078-7d8b-47e8-b24e-588b57c528c4    f
09b4c86b-9516-4cfb-b0d9-1b775ad3b3e3    5c131446-96fa-460a-a2f7-bad0eedd08bd    f
09b4c86b-9516-4cfb-b0d9-1b775ad3b3e3    a1fe3b88-c0e6-4483-90e8-319019ca945d    f
09b4c86b-9516-4cfb-b0d9-1b775ad3b3e3    6d500c07-bb73-46a3-a562-5a27b33e4187    f
55bec7b5-cc11-4104-8410-d018afb3dc0c    a84c6860-6556-4e5a-810c-58ea2e9d3588    t
55bec7b5-cc11-4104-8410-d018afb3dc0c    8ee953da-e5cc-4363-8952-e53c9d9b72d6    t
55bec7b5-cc11-4104-8410-d018afb3dc0c    ae690761-0ba4-482a-aa90-58fd9f0b980f    t
55bec7b5-cc11-4104-8410-d018afb3dc0c    32af8254-3084-4832-903a-03692d91adcc    t
55bec7b5-cc11-4104-8410-d018afb3dc0c    52fc0fac-d0e0-40fd-8334-2c06f93c6279    t
55bec7b5-cc11-4104-8410-d018afb3dc0c    cc5529dc-86c2-4c2c-9454-ba6b440056af    t
55bec7b5-cc11-4104-8410-d018afb3dc0c    1f1f7c63-013f-4862-b2ef-462c2fcbb0bf    f
55bec7b5-cc11-4104-8410-d018afb3dc0c    94e36078-7d8b-47e8-b24e-588b57c528c4    f
55bec7b5-cc11-4104-8410-d018afb3dc0c    5c131446-96fa-460a-a2f7-bad0eedd08bd    f
55bec7b5-cc11-4104-8410-d018afb3dc0c    a1fe3b88-c0e6-4483-90e8-319019ca945d    f
55bec7b5-cc11-4104-8410-d018afb3dc0c    6d500c07-bb73-46a3-a562-5a27b33e4187    f
e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    a84c6860-6556-4e5a-810c-58ea2e9d3588    t
e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    8ee953da-e5cc-4363-8952-e53c9d9b72d6    t
e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    ae690761-0ba4-482a-aa90-58fd9f0b980f    t
e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    32af8254-3084-4832-903a-03692d91adcc    t
e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    52fc0fac-d0e0-40fd-8334-2c06f93c6279    t
e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    cc5529dc-86c2-4c2c-9454-ba6b440056af    t
e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    1f1f7c63-013f-4862-b2ef-462c2fcbb0bf    f
e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    94e36078-7d8b-47e8-b24e-588b57c528c4    f
e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    5c131446-96fa-460a-a2f7-bad0eedd08bd    f
e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    a1fe3b88-c0e6-4483-90e8-319019ca945d    f
e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    6d500c07-bb73-46a3-a562-5a27b33e4187    f
53e2859c-34c6-4b00-8bee-efc443e7468d    a84c6860-6556-4e5a-810c-58ea2e9d3588    t
53e2859c-34c6-4b00-8bee-efc443e7468d    8ee953da-e5cc-4363-8952-e53c9d9b72d6    t
53e2859c-34c6-4b00-8bee-efc443e7468d    ae690761-0ba4-482a-aa90-58fd9f0b980f    t
53e2859c-34c6-4b00-8bee-efc443e7468d    32af8254-3084-4832-903a-03692d91adcc    t
53e2859c-34c6-4b00-8bee-efc443e7468d    52fc0fac-d0e0-40fd-8334-2c06f93c6279    t
53e2859c-34c6-4b00-8bee-efc443e7468d    cc5529dc-86c2-4c2c-9454-ba6b440056af    t
53e2859c-34c6-4b00-8bee-efc443e7468d    1f1f7c63-013f-4862-b2ef-462c2fcbb0bf    f
53e2859c-34c6-4b00-8bee-efc443e7468d    94e36078-7d8b-47e8-b24e-588b57c528c4    f
53e2859c-34c6-4b00-8bee-efc443e7468d    5c131446-96fa-460a-a2f7-bad0eedd08bd    f
53e2859c-34c6-4b00-8bee-efc443e7468d    a1fe3b88-c0e6-4483-90e8-319019ca945d    f
53e2859c-34c6-4b00-8bee-efc443e7468d    6d500c07-bb73-46a3-a562-5a27b33e4187    f
79013291-edda-4ffa-8125-d87720aa6d0a    a84c6860-6556-4e5a-810c-58ea2e9d3588    t
79013291-edda-4ffa-8125-d87720aa6d0a    8ee953da-e5cc-4363-8952-e53c9d9b72d6    t
79013291-edda-4ffa-8125-d87720aa6d0a    ae690761-0ba4-482a-aa90-58fd9f0b980f    t
79013291-edda-4ffa-8125-d87720aa6d0a    32af8254-3084-4832-903a-03692d91adcc    t
79013291-edda-4ffa-8125-d87720aa6d0a    52fc0fac-d0e0-40fd-8334-2c06f93c6279    t
79013291-edda-4ffa-8125-d87720aa6d0a    cc5529dc-86c2-4c2c-9454-ba6b440056af    t
79013291-edda-4ffa-8125-d87720aa6d0a    1f1f7c63-013f-4862-b2ef-462c2fcbb0bf    f
79013291-edda-4ffa-8125-d87720aa6d0a    94e36078-7d8b-47e8-b24e-588b57c528c4    f
79013291-edda-4ffa-8125-d87720aa6d0a    5c131446-96fa-460a-a2f7-bad0eedd08bd    f
79013291-edda-4ffa-8125-d87720aa6d0a    a1fe3b88-c0e6-4483-90e8-319019ca945d    f
79013291-edda-4ffa-8125-d87720aa6d0a    6d500c07-bb73-46a3-a562-5a27b33e4187    f
\.


--
-- Data for Name: client_scope_role_mapping; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.client_scope_role_mapping (scope_id, role_id) FROM stdin;
fb60191e-c2db-4bf8-b82b-700851410d93    ae11397e-a4f0-45d1-a518-de6fad7d9fb7
1f1f7c63-013f-4862-b2ef-462c2fcbb0bf    e61cb8a9-f2ef-4e4b-945d-aa3c4cf4e2d9
\.


--
-- Data for Name: component; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.component (id, name, parent_id, provider_id, provider_type, realm_id, sub_type) FROM stdin;
064247a8-5eee-4ccc-82f3-458c881570c0    Trusted Hosts   476d693d-9abf-4f63-a268-5002ea64c060    trusted-hosts   org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy        476d693d-9abf-4f63-a268-5002ea64c060    anonymous
cba164b8-67ac-4b6f-999d-a29d4c6ee8f2    Consent Required        476d693d-9abf-4f63-a268-5002ea64c060    consent-requiredorg.keycloak.services.clientregistration.policy.ClientRegistrationPolicy        476d693d-9abf-4f63-a268-5002ea64c060   anonymous
8474c59c-76f3-4004-adaf-98b3a3bc20ef    Full Scope Disabled     476d693d-9abf-4f63-a268-5002ea64c060    scope   org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy        476d693d-9abf-4f63-a268-5002ea64c060    anonymous
62956f36-53a2-476a-90dc-53c1eef0417f    Max Clients Limit       476d693d-9abf-4f63-a268-5002ea64c060    max-clients    org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy 476d693d-9abf-4f63-a268-5002ea64c060    anonymous
02c3dd39-8781-43d1-80a7-813093d15f51    Allowed Protocol Mapper Types   476d693d-9abf-4f63-a268-5002ea64c060    allowed-protocol-mappers        org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy        476d693d-9abf-4f63-a268-5002ea64c060    anonymous
37a5269d-d7a1-48e0-b6a5-4862e2597180    Allowed Client Scopes   476d693d-9abf-4f63-a268-5002ea64c060    allowed-client-templates        org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy        476d693d-9abf-4f63-a268-5002ea64c060    anonymous
969b9d56-216a-494b-976b-6b8b317368de    Allowed Registration Web Origins        476d693d-9abf-4f63-a268-5002ea64c060   registration-web-origins org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy        476d693d-9abf-4f63-a268-5002ea64c060    anonymous
69913405-5b32-46e1-a194-060a404d89f9    Allowed Protocol Mapper Types   476d693d-9abf-4f63-a268-5002ea64c060    allowed-protocol-mappers        org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy        476d693d-9abf-4f63-a268-5002ea64c060    authenticated
aabfb337-9f40-4ac4-a4a0-abde711292c5    Allowed Client Scopes   476d693d-9abf-4f63-a268-5002ea64c060    allowed-client-templates        org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy        476d693d-9abf-4f63-a268-5002ea64c060    authenticated
1a256a99-01b6-4ff0-9c1b-fc8290aa4918    Allowed Registration Web Origins        476d693d-9abf-4f63-a268-5002ea64c060   registration-web-origins org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy        476d693d-9abf-4f63-a268-5002ea64c060    authenticated
29ef4d60-ec6d-4373-916a-fa5a7f232ddd    rsa-generated   476d693d-9abf-4f63-a268-5002ea64c060    rsa-generated   org.keycloak.keys.KeyProvider   476d693d-9abf-4f63-a268-5002ea64c060    \N
b5683588-17b5-4abf-a934-5ca995e3c90a    rsa-enc-generated       476d693d-9abf-4f63-a268-5002ea64c060    rsa-enc-generated       org.keycloak.keys.KeyProvider   476d693d-9abf-4f63-a268-5002ea64c060    \N
795196fc-905a-4eba-bdde-1ffd47825981    hmac-generated-hs512    476d693d-9abf-4f63-a268-5002ea64c060    hmac-generated org.keycloak.keys.KeyProvider    476d693d-9abf-4f63-a268-5002ea64c060    \N
0535bbb9-b814-4aa8-963c-8fcffaa2bcb0    aes-generated   476d693d-9abf-4f63-a268-5002ea64c060    aes-generated   org.keycloak.keys.KeyProvider   476d693d-9abf-4f63-a268-5002ea64c060    \N
03028368-d022-4155-9c88-c5cbab84863d    \N      476d693d-9abf-4f63-a268-5002ea64c060    declarative-user-profile       org.keycloak.userprofile.UserProfileProvider     476d693d-9abf-4f63-a268-5002ea64c060    \N
aec794d6-2a70-4fd7-aa52-6f2460990139    Max Clients Limit       f19d6621-c51d-4928-ab07-1e2d5efd6e78    max-clients    org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy f19d6621-c51d-4928-ab07-1e2d5efd6e78    anonymous
7aa0fd53-4483-4a30-aac5-931623bf4ca6    Allowed Protocol Mapper Types   f19d6621-c51d-4928-ab07-1e2d5efd6e78    allowed-protocol-mappers        org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy        f19d6621-c51d-4928-ab07-1e2d5efd6e78    anonymous
2d34e378-a5bf-4035-b39b-26cdd940e51b    Consent Required        f19d6621-c51d-4928-ab07-1e2d5efd6e78    consent-requiredorg.keycloak.services.clientregistration.policy.ClientRegistrationPolicy        f19d6621-c51d-4928-ab07-1e2d5efd6e78   anonymous
5067d809-5457-4b86-bec6-43887aac3a9c    Allowed Client Scopes   f19d6621-c51d-4928-ab07-1e2d5efd6e78    allowed-client-templates        org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy        f19d6621-c51d-4928-ab07-1e2d5efd6e78    authenticated
78601cb0-e576-48df-a2c7-c104eb55978e    Trusted Hosts   f19d6621-c51d-4928-ab07-1e2d5efd6e78    trusted-hosts   org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy        f19d6621-c51d-4928-ab07-1e2d5efd6e78    anonymous
d9ec3748-187e-49b0-bdd8-2fa7343387d0    Full Scope Disabled     f19d6621-c51d-4928-ab07-1e2d5efd6e78    scope   org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy        f19d6621-c51d-4928-ab07-1e2d5efd6e78    anonymous
72160146-8818-49bb-bde1-4142fc698cb4    Allowed Protocol Mapper Types   f19d6621-c51d-4928-ab07-1e2d5efd6e78    allowed-protocol-mappers        org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy        f19d6621-c51d-4928-ab07-1e2d5efd6e78    authenticated
4c2f83e1-6d56-4eaa-a4c1-64cf084be466    Allowed Client Scopes   f19d6621-c51d-4928-ab07-1e2d5efd6e78    allowed-client-templates        org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy        f19d6621-c51d-4928-ab07-1e2d5efd6e78    anonymous
ff3f2afe-94b6-42fa-bcc9-4e6bc46dcaf5    rsa-generated   f19d6621-c51d-4928-ab07-1e2d5efd6e78    rsa-generated   org.keycloak.keys.KeyProvider   f19d6621-c51d-4928-ab07-1e2d5efd6e78    \N
3341a17d-d0a7-4a9a-b11b-7205da2e8189    aes-generated   f19d6621-c51d-4928-ab07-1e2d5efd6e78    aes-generated   org.keycloak.keys.KeyProvider   f19d6621-c51d-4928-ab07-1e2d5efd6e78    \N
0e458a5c-159f-4914-9486-ab2892e44e91    rsa-enc-generated       f19d6621-c51d-4928-ab07-1e2d5efd6e78    rsa-enc-generated       org.keycloak.keys.KeyProvider   f19d6621-c51d-4928-ab07-1e2d5efd6e78    \N
d0f7bbe6-9610-4a60-b2a0-86e040faac95    hmac-generated-hs512    f19d6621-c51d-4928-ab07-1e2d5efd6e78    hmac-generated org.keycloak.keys.KeyProvider    f19d6621-c51d-4928-ab07-1e2d5efd6e78    \N
\.


--
-- Data for Name: component_config; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.component_config (id, component_id, name, value) FROM stdin;
afa08382-ad35-4d4b-a204-a9ed30f0cd9d    37a5269d-d7a1-48e0-b6a5-4862e2597180    allow-default-scopes    true
15912a51-c405-4486-8274-e0f98479250e    62956f36-53a2-476a-90dc-53c1eef0417f    max-clients     200
874399aa-105a-40c3-b78d-a52a9aeff273    064247a8-5eee-4ccc-82f3-458c881570c0    client-uris-must-match  true
046e5c1b-b3be-44f3-b19f-ed90f56f0ddd    064247a8-5eee-4ccc-82f3-458c881570c0    host-sending-registration-request-must-match    true
9279fb15-66ac-4e06-91e6-c188a5fa3b7a    69913405-5b32-46e1-a194-060a404d89f9    allowed-protocol-mapper-types   saml-user-property-mapper
e8fa3385-bebb-447a-afcb-7015e16788a4    69913405-5b32-46e1-a194-060a404d89f9    allowed-protocol-mapper-types   oidc-address-mapper
6fe1f802-8e68-4a42-a1d0-e5da2428dd97    69913405-5b32-46e1-a194-060a404d89f9    allowed-protocol-mapper-types   oidc-sha256-pairwise-sub-mapper
b16fe29e-824e-4470-96ff-d0544ccd7d34    69913405-5b32-46e1-a194-060a404d89f9    allowed-protocol-mapper-types   saml-user-attribute-mapper
147d2cd9-73ff-485c-840c-c442de87667c    69913405-5b32-46e1-a194-060a404d89f9    allowed-protocol-mapper-types   oidc-usermodel-attribute-mapper
d8b1033e-b3ff-4884-9047-989b87a4b4ca    69913405-5b32-46e1-a194-060a404d89f9    allowed-protocol-mapper-types   oidc-full-name-mapper
ca8a2bdb-a633-42b9-9df3-44493f8b546e    69913405-5b32-46e1-a194-060a404d89f9    allowed-protocol-mapper-types   oidc-usermodel-property-mapper
4cdfacc9-76e8-4ed8-9c07-b051619b868e    69913405-5b32-46e1-a194-060a404d89f9    allowed-protocol-mapper-types   saml-role-list-mapper
48adbbb5-cb20-430e-83b6-339ae0acbaad    02c3dd39-8781-43d1-80a7-813093d15f51    allowed-protocol-mapper-types   oidc-full-name-mapper
6553a8fd-4aa9-497c-ba45-f7cc70f8149e    02c3dd39-8781-43d1-80a7-813093d15f51    allowed-protocol-mapper-types   saml-user-property-mapper
feaceafe-e8dd-48e1-a2a5-59eaf489fd51    02c3dd39-8781-43d1-80a7-813093d15f51    allowed-protocol-mapper-types   saml-user-attribute-mapper
d326e57e-9747-4957-9600-b83111c037fc    02c3dd39-8781-43d1-80a7-813093d15f51    allowed-protocol-mapper-types   oidc-usermodel-property-mapper
f3e812f7-ab90-43d7-880a-e88f34e927df    02c3dd39-8781-43d1-80a7-813093d15f51    allowed-protocol-mapper-types   oidc-usermodel-attribute-mapper
1ebd25a6-d8ec-4c2c-97df-c019c2e1fa3f    02c3dd39-8781-43d1-80a7-813093d15f51    allowed-protocol-mapper-types   oidc-address-mapper
633e0206-7139-4990-9a68-b1eb176593ac    02c3dd39-8781-43d1-80a7-813093d15f51    allowed-protocol-mapper-types   oidc-sha256-pairwise-sub-mapper
89e93cf6-34ce-4780-ab39-8807b65b327d    02c3dd39-8781-43d1-80a7-813093d15f51    allowed-protocol-mapper-types   saml-role-list-mapper
f5e9a0ce-2195-4878-8466-dff7b46fa1c5    aabfb337-9f40-4ac4-a4a0-abde711292c5    allow-default-scopes    true
4b3dd53b-f680-427d-96c4-f70a327b13f4    29ef4d60-ec6d-4373-916a-fa5a7f232ddd    keyUse  SIG
b42593d9-0b68-4735-8fb0-702e2bcdbf26    29ef4d60-ec6d-4373-916a-fa5a7f232ddd    priority        100
31620591-1d41-4410-8605-9ee12fb3f3f9    29ef4d60-ec6d-4373-916a-fa5a7f232ddd    privateKey      MIIEogIBAAKCAQEAuJTfI5SdjQ9+GYAZANix5DGExSZVZScT6uSkZpfp1giwm5pqrGyWVxJlbXPH9JcWBhjzvNS+BykOpxULvomKZPtU6VyxULKV8Zvv3ziCwwisswbJ+Er8HMZESh0hhp8S6O9UQ/8DVGoj4FHC0wbZTrRjWMxxEqtSw8No0BWgA58WBICZRav1TRPsfprELoEq+EthOgmaZT3BOdn7/cUP5hP+cnhotHl35gFpCh8U10xpC9eKFsRDNU/GXu7mmbrP8VoqfmtvDeEbcEretXe0o3/b9jQYRe3wySGoRkXn/mBBPeTPftRqikvesPWpRlAqzOko+FXk6ltjasO1AROJYwIDAQABAoIBABj+2VFyqdE1NLYpps56tGr6ml2uSWh3cxbfMTTOw/Te3Az+S2LKbk4f6Mn6dgH1HHTlQnXNo2bJ1GOjkcxoHhclrS562xeFT5Er35RYDTvHEXKe6+Z/6lslLZCRwv1Szlc/4vvgQpMBr+u2drkSrNvKdBz4ISR45y4pE1OrvK2wovnpLhk2YYZ/VSXgKCnNk9dyQgV+7QeyLowuQ9Noq+uk6DPnp3h+MgbCY3IUy70u3eb+ARbIYo6GxQmjKtWEPj8nN30qassXrUV9/TbkMWsHxRMCUPMfMXMxUxDANg0DDeMmUak3Pu6YVm1gSVORq+YtAuG0PfRft1w4OP15eqkCgYEA4gZsCrb9DPRDYzp2qkCZWPWgCDTxYrwbiI7+hpW8NHwWPMeKnmrin+h9m5qMnrJtfNH+EBlbte6IQIpNhS335L406JCZFp60MaPFq6YR+ZczqZ1sL6AQ1b3R0/srfW6uyR0NQtDXl+JT6VX4yr9N6Ywd4JYobz8Hivs4Faz9L9kCgYEA0Q9voIMVRN4w8ZNVKWf5Jcg+lhaerPohf3zDN++pdIR2SZpu7QwHJNiOdHyIACMh15TWCWgjTsttFwXZefpJDE2ZF7UL7WIUlMRL7h4mV9YzrzsLUnmBL+D6UFZCKpqpQYb7sF2PINx1twwrq5Nl5ym9SUHQZPHvyGssQyk6eZsCgYB/1XYB0WDplLUQSB6ZSBPy9mjee2MSnqVL5OQbplBdtti0436I/pbSLiHsgcqKbwvxjqsM2+q8yP4S0qXpbwhHPTSbXDzZSEVN1fyUikacTWIQylJH1VXwLX2hUOtV8+WzJVU8tvVYl88xp0ghE3WzY2X6gbK4yIMxncgoqkBAcQKBgCc2AfXVIDQeiIeG3r45Zh2UBUkZTQGcmJPUzri7Fsln3tfHQ27qhpx+kZl/kfKUpFBO9iYlhhnNRdS/oB6ktva7xy8PIgGQF9QfTS6IMSDgaClBpcn+SCC2zbwrsZVUFNLZgnN92M6NCvceLUKtDrvgtEP9OBz208Z/c3nVTcZpAoGAVVHfNMgh2a1KLuqoJKn1fP0iNDfc5dHMIuBfPpR0lHkgmpb9ry8Hlscz8j1+f8cMJn2ZrcsNIua8QD0B24+Ht/yt37vnCqa2nKRhjjSMyIyYfXVMz1lda/3IlvNh1SOyoPD29cIp5yzvPpHGGdnwJ/1t3JOjZ25/irW4dhuTmJ8=
039b6baf-9a0a-4301-b4ff-5575558d658c    29ef4d60-ec6d-4373-916a-fa5a7f232ddd    certificate     MIICmzCCAYMCBgGerqPBbTANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjYwNjA5MjMwNTI4WhcNMzYwNjA5MjMwNzA4WjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC4lN8jlJ2ND34ZgBkA2LHkMYTFJlVlJxPq5KRml+nWCLCbmmqsbJZXEmVtc8f0lxYGGPO81L4HKQ6nFQu+iYpk+1TpXLFQspXxm+/fOILDCKyzBsn4SvwcxkRKHSGGnxLo71RD/wNUaiPgUcLTBtlOtGNYzHESq1LDw2jQFaADnxYEgJlFq/VNE+x+msQugSr4S2E6CZplPcE52fv9xQ/mE/5yeGi0eXfmAWkKHxTXTGkL14oWxEM1T8Ze7uaZus/xWip+a28N4RtwSt61d7Sjf9v2NBhF7fDJIahGRef+YEE95M9+1GqKS96w9alGUCrM6Sj4VeTqW2Nqw7UBE4ljAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAAU1EC9Tuv9Phrj19AeVfcXnrok3rx8cDiNFB1QJFrTGebyQM2uH2NWCqO5ef80NHYDXNnsXUMv1j0Db12Tux5GO3Imxy3SRr5Wvrugf24GSIQxkqVxZQnmOJK6jICouDpFQ/n3Bvdg+mSnIfnPrOXjaQQ6Z0aeFOFMvyuvOROmDMLOQ/KJvqyy5wxqtK7EH1YHc1xh42+gbdYmejk8sGdzzV/LvDO1zyOG5U2wvuvOkjoRwgStC22+2Pth7ToLVHbMOZFJKcffq2gPv1qxmAxc91bzqXhIpULoXBaE4tUp9+/3aq9QA33Sg7Yf21faW3X86rS97o+ECcFC3mk7VotY=
16e6bf97-bfda-46fd-8f4d-a2b186a61fcc    0535bbb9-b814-4aa8-963c-8fcffaa2bcb0    secret  2RP9CJ9jJ3jhDjnvSRRdgQ
79b3df98-35d4-4ee6-b7d5-50d0a0edc709    0535bbb9-b814-4aa8-963c-8fcffaa2bcb0    kid     5b550fbf-94d9-49cf-aae7-3420d2e1a87d
6644fde2-5133-4e0e-8224-629942ecc3b9    0535bbb9-b814-4aa8-963c-8fcffaa2bcb0    priority        100
22a58e08-eace-4a01-b697-d7d541c0a960    b5683588-17b5-4abf-a934-5ca995e3c90a    algorithm       RSA-OAEP
2c4a706c-ce74-4eff-908e-5ced09a6720b    b5683588-17b5-4abf-a934-5ca995e3c90a    certificate     MIICmzCCAYMCBgGerqPCcTANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjYwNjA5MjMwNTI4WhcNMzYwNjA5MjMwNzA4WjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDF11TgJKyqmI8a+FsmQ0bjc6LJGsXdAGjpnI5gKZ+BGWVWDKVOKDhVHHQ98hsvvfJPL2flGX5MbclREOK+2iNyyiF6Mj+vToZ7pK3aqOtI9q0JFDJVc3Di+9PGNlVKN1JPOzZFtmO8v9tBRwSOuytGHyuHl+k1Y26NmbfvG3PjVyVTNXMQ9Ywprs5GVnPZTDdlydMoDSPGU4Iy6yipXcIDSFgTvlQORZmDARCEJFf7c+3EFS5DLjbgz0pyNf7h5DmLARp30s9F2J4QQ8CbDUpCsIAkm499zEM7+RZDQj80Phuoem1jL0tDIhVGsn103JxH0G0mSkIoyB/a641voKRFAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAAJfGYY4shfH0yUQwGWYCo/wN8xbvoVWeQOtJMPBOXuDkrObKtWfXUERP+Se7j/G3k5sq4oS3IqAY7SNAO9wHcXncy2wVkT7FXCZhT6BNXiraFMJp0tFa+5thVUXLSTddjk/zmSIc/X4YBQfAQQMmHV7gR10Smc6mPjpa+HgBzk2uYAB92xuHffHvkB7f+oFvVnZtuNqR0rU6zUP9I08qNRuN4Q8OS3n22tdQ/PVf7CAI+VlliuyhjaDr1dMtgxGLqFme2jugHlVTCTpqRM3FT9S0x3QbgjvDMjUhwl47RYWBB4oh6ew/fpUwhB96HLsBDeb0dpBcM5PDWCijlgdDNE=
12071191-f521-4fa7-b943-ad1d9dabb787    b5683588-17b5-4abf-a934-5ca995e3c90a    keyUse  ENC
50aa01da-9314-48fb-a4f7-f387d747c8a6    b5683588-17b5-4abf-a934-5ca995e3c90a    privateKey      MIIEowIBAAKCAQEAxddU4CSsqpiPGvhbJkNG43OiyRrF3QBo6ZyOYCmfgRllVgylTig4VRx0PfIbL73yTy9n5Rl+TG3JURDivtojcsohejI/r06Ge6St2qjrSPatCRQyVXNw4vvTxjZVSjdSTzs2RbZjvL/bQUcEjrsrRh8rh5fpNWNujZm37xtz41clUzVzEPWMKa7ORlZz2Uw3ZcnTKA0jxlOCMusoqV3CA0hYE75UDkWZgwEQhCRX+3PtxBUuQy424M9KcjX+4eQ5iwEad9LPRdieEEPAmw1KQrCAJJuPfcxDO/kWQ0I/ND4bqHptYy9LQyIVRrJ9dNycR9BtJkpCKMgf2uuNb6CkRQIDAQABAoIBACA07e4amk9KoZ/4MU0jzkz7HKjUu8Q+q6roH8IQ1JSyz9ficXYClH+/2j6MBMKmDzsL0m6DKBfaFtf5wefkNrlvpWPb/UO/1U3DNm2Dv+BzY8ziuvpFM5SH/rw5nnMurq6+SsIDhJi2ukNArpcWajTdSyak426btA9yKErRCHHINeuLXRBrIDUCx/CiKcGmamCCh+o5PZMqK+UnNyLa/d2fu2fcQtZaVz18O/Wmfv9HRT9+2n/GM0M1MFDUISi6ukyucrtFO4B6wyhIdh0Ng8JD82lCnVL+nJtAjE9aRzOxMPEOzZfei7hJxHTQ7TEJP7xim+ErNy5/r+L7pQMjnUsCgYEA42CH1RFzw1oIivkcyBsQoNDJ9ngyI3fR9ZA6mbghfT/t+USSw9zNrRoEg12Jk69n3/17GpaViXJNz6bOvP0teOE1bgi9tPUtwVVLbb3yTFeCsCEAD/FwLZIhgvHkG5GjbwIbtlVZV+ceXBvaHL1mnlGfI910eOcOrkyidVvkeXcCgYEA3r75ULDl/CxlGOmOF6VKKiNJ7MDpiwdc0skUSH2uCUOwR7pMZE+41w37TATP/xYmz85Vd4fmKS0+hEa1Jl3Lxo9sSoEq6W2OIwPWG+88E+Ir9/wi5Y6TqK5MJ3+FLpTn0czkbJzvcoJ0fZPUqZEWDIsjU6XSahhMydRtMNpufyMCgYEArY45IEG6Axrt+mY7ueIuxxGXlzIX00raUH5OvJb3uQrbMrFM9YPM2pxJZZw4LypsN2TcWmcmrUs6aY4Br+/wjZwZlGvHoiCjVDcu5A1grTT+5EHMMl8wKRipy7GnVAPOpCUP0hVDpP0dB2GbEuTfN2lF97JJ/R8g7ZpBRyNlOfECgYA749M7C+U6cWFZWmq3Ft0jCUv2GURx+i/OCPyoJQqnOQjrsD6b9gd34y1/GggmyPj0hMDcG7EZvy2A+VX5k9yXbbarLaGxE6DU71IhPqjDm9tAmQ109WnkP8EAGbxgcu8FrPZ58ZQ8ELFrllTmprjr9HkyI3K4zgHPfotBSGnPSwKBgEkx0DWHh/SEmCEEAC3x6EJkl/8AVret6hJgHdO8s0VqCVUDJ5K5F7r6wrMMvuRn0Zh0ygMMj7VJvvfsp/tfKCH6031PmprMuNerZz6V+ftgOBXlDATMJWayZr3yemnLA1mrV3CoPx+IZD0N/6tIl8K7ILqz41+Xxc6BEEMJp1l5
402fb5ef-ac3a-4e9e-afd5-5655bb47a996    b5683588-17b5-4abf-a934-5ca995e3c90a    priority        100
e4d31bb2-fde0-45e9-a0e8-c2e2724f7ab7    795196fc-905a-4eba-bdde-1ffd47825981    secret  DtJqJcc1x7HdQXRZlE8IeTzIxrAQw6_MqDhRRaP3CfMjjmBy3g8Y5uSHIHcr_agbEhTRc7-JisGo_ulzQDrq6qOK0zi3ctUTHYvd45nVKWb186mcrHT1YuQC65aw9tEjaBzODePevZrCE6p2OoPPt09z2acAd1Gekfx85nZMalc
4087f576-722c-4545-b1c5-2f641b7da6d3    795196fc-905a-4eba-bdde-1ffd47825981    priority        100
a288b3ca-e81d-477b-a128-db7d42524236    795196fc-905a-4eba-bdde-1ffd47825981    kid     6ae5fc4c-eb2d-44db-a2a8-78ca31f2dc47
c072aaf7-2340-41f7-a205-1a0bd4a9ae34    795196fc-905a-4eba-bdde-1ffd47825981    algorithm       HS512
a21dba70-70ec-4163-af0f-e5a995259790    03028368-d022-4155-9c88-c5cbab84863d    kc.user.profile.config  {"attributes":[{"name":"username","displayName":"${username}","validations":{"length":{"min":3,"max":255},"username-prohibited-characters":{},"up-username-not-idn-homograph":{}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false},{"name":"email","displayName":"${email}","validations":{"email":{},"length":{"max":255}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false},{"name":"firstName","displayName":"${firstName}","validations":{"length":{"max":255},"person-name-prohibited-characters":{}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false},{"name":"lastName","displayName":"${lastName}","validations":{"length":{"max":255},"person-name-prohibited-characters":{}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false}],"groups":[{"name":"user-metadata","displayHeader":"User metadata","displayDescription":"Attributes, which refer to user metadata"}]}
11a0442b-39a2-490b-b964-3efdaecc750e    aec794d6-2a70-4fd7-aa52-6f2460990139    max-clients     20
45c942a0-e2ac-415c-bbf4-900828eeb24b    7aa0fd53-4483-4a30-aac5-931623bf4ca6    allowed-protocol-mapper-types   saml-role-list-mapper
da70a31f-bd3f-4691-b7ba-ba45e3fecbb3    7aa0fd53-4483-4a30-aac5-931623bf4ca6    allowed-protocol-mapper-types   oidc-sha256-pairwise-sub-mapper
4a4d08e4-73b6-4bcc-a303-b55776a89031    7aa0fd53-4483-4a30-aac5-931623bf4ca6    allowed-protocol-mapper-types   oidc-usermodel-property-mapper
fa1ab641-0c99-4c9d-b8db-7133b67e4389    7aa0fd53-4483-4a30-aac5-931623bf4ca6    allowed-protocol-mapper-types   oidc-usermodel-attribute-mapper
c11542d4-f5f1-4f47-a58f-51b3379a92e6    7aa0fd53-4483-4a30-aac5-931623bf4ca6    allowed-protocol-mapper-types   saml-user-property-mapper
e6c69b1a-2097-4ae9-bd6a-180451dbb22c    7aa0fd53-4483-4a30-aac5-931623bf4ca6    allowed-protocol-mapper-types   saml-user-attribute-mapper
16ddfcad-7ecf-482d-b59b-8da3f89dcfaf    7aa0fd53-4483-4a30-aac5-931623bf4ca6    allowed-protocol-mapper-types   oidc-full-name-mapper
40bd2c25-07d4-46c0-b46f-889c957774ec    7aa0fd53-4483-4a30-aac5-931623bf4ca6    allowed-protocol-mapper-types   oidc-address-mapper
a9012c5f-a72a-49d7-8009-2b6773a6d3fc    78601cb0-e576-48df-a2c7-c104eb55978e    client-uris-must-match  true
aaf8260e-a978-4ab7-9fde-5fd05fc0d659    78601cb0-e576-48df-a2c7-c104eb55978e    host-sending-registration-request-must-match    true
087b0a7e-2bd8-4b69-b559-f64b066cdef2    72160146-8818-49bb-bde1-4142fc698cb4    allowed-protocol-mapper-types   saml-user-property-mapper
a62eb008-d578-4da8-a48d-55f7a94d89fb    72160146-8818-49bb-bde1-4142fc698cb4    allowed-protocol-mapper-types   oidc-usermodel-property-mapper
9f9e5d40-bd09-41cb-b95e-a029a7bd5185    72160146-8818-49bb-bde1-4142fc698cb4    allowed-protocol-mapper-types   oidc-sha256-pairwise-sub-mapper
57a2fa7d-01a3-4819-8ee2-55a9546bb8da    72160146-8818-49bb-bde1-4142fc698cb4    allowed-protocol-mapper-types   oidc-address-mapper
54d48e71-b5b0-4e9a-9de0-b2c738e13795    72160146-8818-49bb-bde1-4142fc698cb4    allowed-protocol-mapper-types   oidc-full-name-mapper
61b895a2-b1cb-4ade-85c9-dcf4c814817a    72160146-8818-49bb-bde1-4142fc698cb4    allowed-protocol-mapper-types   saml-user-attribute-mapper
e9527dac-18cd-40fa-a82d-4b2db0f1cd2b    72160146-8818-49bb-bde1-4142fc698cb4    allowed-protocol-mapper-types   saml-role-list-mapper
236cd9b1-714a-4b33-87c9-fcda2e95a3f9    72160146-8818-49bb-bde1-4142fc698cb4    allowed-protocol-mapper-types   oidc-usermodel-attribute-mapper
4fe0232d-fa77-4025-bafa-50f0cd9bc0de    5067d809-5457-4b86-bec6-43887aac3a9c    allow-default-scopes    true
9a7b1cc8-e859-4660-96b9-74a466724f9d    ff3f2afe-94b6-42fa-bcc9-4e6bc46dcaf5    priority        100
aaca9ecf-e581-402a-be57-6f19ba3d2d04    ff3f2afe-94b6-42fa-bcc9-4e6bc46dcaf5    certificate     MIICsTCCAZkCBgGerq2cozANBgkqhkiG9w0BAQsFADAcMRowGAYDVQQDDBFYZW5vbi1EZXYtREVWLUVOVjAeFw0yNjA2MDkyMzE2MTNaFw0zNjA2MDkyMzE3NTNaMBwxGjAYBgNVBAMMEVhlbm9uLURldi1ERVYtRU5WMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAszGCqn/opyDLQwckeb1JEXqv5fxbwxFziAkNGvG6xFacSLyFcfLhjm3xsRkvz3qB5TWSvU6Vw1FavqIE5cG6rMerDBmSZrqZG2DA7KkLv4etnwH/gBDVuciYYB3MPNT/2V6qh9iPU62feqARmWmHA76a7rHzof61tDtiQH8Pi/M65oNfM7kcrK9PVdFA2OsWP2emdxsqsFlvVBcZWrLDb6c57jsZc+s2m2FKHCvcixlslTUSYfndtjIwQCse5gkhtGWW3PqbG8sZvMbImC0v1908c2LJQUk3nrxc/FMznM52T/o3MMu07Nxyo0lO5NUH5xIeeoICb68u+5ZOXnYJZQIDAQABMA0GCSqGSIb3DQEBCwUAA4IBAQChYQMYZVELpKkRgcAkZNvkTkjwvVJVeOixizRJb0M/aMoMX4CFCMwxMVbkBapEgojVjZX/ZrSSpXRk10gusQO51KNFiG2u6deeVWG8ySWhSfHLXN5AWc2e0PidePpu42BiRYpEcr94tAQdmXZ1lWzJmjQYqhicXkjJkkpgO+k8sQCdVozM4RRBrG8iJ+Yp/N7cqPVFRfji5KDRaPiKiBj4UxwbTjuYB88oACd8/OQGi77NFagRMNgh2XAYyDtLPxTCvwS6lSeS5ZNhLUXIPyRGxwbIjG48XZd3XbtUzSlqW7fmGZMXBAZEOCtgWn19XUCgu9BDzGFQgk8cgQg5K8ps
a05238df-3e26-4279-9a20-9d52ad0e834f    ff3f2afe-94b6-42fa-bcc9-4e6bc46dcaf5    privateKey      MIIEpQIBAAKCAQEAszGCqn/opyDLQwckeb1JEXqv5fxbwxFziAkNGvG6xFacSLyFcfLhjm3xsRkvz3qB5TWSvU6Vw1FavqIE5cG6rMerDBmSZrqZG2DA7KkLv4etnwH/gBDVuciYYB3MPNT/2V6qh9iPU62feqARmWmHA76a7rHzof61tDtiQH8Pi/M65oNfM7kcrK9PVdFA2OsWP2emdxsqsFlvVBcZWrLDb6c57jsZc+s2m2FKHCvcixlslTUSYfndtjIwQCse5gkhtGWW3PqbG8sZvMbImC0v1908c2LJQUk3nrxc/FMznM52T/o3MMu07Nxyo0lO5NUH5xIeeoICb68u+5ZOXnYJZQIDAQABAoIBABHb/KGpG2My08dTqik++g4Vq/vQRcYAkoLrogR+NKbWWf+u2F71vdC/+O91auwzEciqKPyYnTkI/fITfEj44LXRNaVAVDTMYq+VmkzMAVl+uIlpPdGB/Acm7LbhqWYjtXcw5e6hoRFOM9+ZHf/sAlKXd+IT1swdsnbq1z1F3KMOOWpbnODjYDq9NUxq9D0JzU8gwHOB/x0vvvZJlwUOiW4pjrVb8VdtzQp82GIaQF/T63x3pEAuc1nFWO8bOV16gW0lyX10y4skBzJGHCthbML5UVPfP9QKo8/tCfgLhXpsBANjSNTttABnQSmB9KiyYtinTvtobsnDXBtp6/qv6FECgYEA3AsZc1wCYAKG0Ld1HOB1YjdzC4YMAOwMKf7ZOQymLUDwPr2dkYHNzOvUivSJP994r8Wy91ag7bHAEWY+ZsNxe9F8SRlmHBuXYRZhXg5FR+7vq5axvNRQpN3/5qpZqX/u+/A6+vP+fODMnlJaJ6TJG/gFYO2dA620dIJZMTwspXECgYEA0HmRH/CrfmRbitAB/XarhX3vMYf+gtX+RWt7VrEgleF3K4SyyRR91EeksuOwRY98Royyze3MNBPSQ1yMoOe9NWVeBACwzan76qYNDrCa/leWOMwhJJixNU3RXbaiDLTnTLK6FSTN41EtwrVIn/MKPpIvbk2XUP82g0xpEDcr2TUCgYEAslKQaoubJSGHDehPEXrZxiG3qxQT8D9bUEFG2tPka/IfgEj8Q+pU1QgddArem5PH43KtKYLb4iVVyQP5+B/VfQl01myt8oNtt3GCsM2R2czKEF2MZsINJL8AXneZOCMEksnJkoxfpeYsDPYiN9R0YqUp/rYxs8R25KCqFZt1dxECgYEApTqUgQIYibY0r5Io4aB6VPT47QLh/wRn4NFNEeqU7vWho8YqhSBOkj6uFHJNNPSCBNBirr/4BpZnIahqdOT2mylaGEYL2xUMam9tDeV/EnKMxztSUVULrjmc5G9phDSk1a8ZuMRQwgeHAzj29H6F8g2etgedFD8SD4IyCv4PLLkCgYEAk0mIRgS+CgPuYTDrvWvRd0A4UbSlbSzjDChznA3KeET9D3LqG8Q2qP3phUYPgjF+TffeMFiYRlvLRMo9ZGJMOuIIdSoRmPhsOjYQjsNScg0+ovU9oP5tW/c5nuEysyHMVtxAz+qE0X6v0OvsawWi2ZvOiIfJQi1K3ezi/Lq982w=
43e153ba-7746-45f3-bb6d-f89eb185ec5f    d0f7bbe6-9610-4a60-b2a0-86e040faac95    priority        100
0c113933-4686-449c-b9a0-b9ab6b916763    d0f7bbe6-9610-4a60-b2a0-86e040faac95    kid     36ebec2f-cf2d-4016-a88d-c44b07605a39
ac287c2e-a26f-403f-a601-dc4d3d4d08d9    d0f7bbe6-9610-4a60-b2a0-86e040faac95    algorithm       HS512
b1230f87-f835-484b-88ae-c51b60d608da    d0f7bbe6-9610-4a60-b2a0-86e040faac95    secret  -CbHgYyIQvmbBQd2CygBPA5vJFbM1cyGVmhCuGQxaxm3CmGBuezCzg0q1K2MyHc14Ww2m2sasVdsmPkS0t3kFx14m-OrM_1Rmrcyq3ivoNJowaLeITHG_NQZz2_rG2eO4eHdoxpw_wxrWsfE7H_SzUJh9olEMtpfsZ6mFb4AJds
9f28b65f-72b6-4c08-bcd8-e49e3cbe92c5    3341a17d-d0a7-4a9a-b11b-7205da2e8189    priority        100
8bf99574-87e7-4071-a442-4f5611bff5d1    3341a17d-d0a7-4a9a-b11b-7205da2e8189    secret  Y5dsy63zqd8T8n9oeFhopQ
d2147b0f-1bf5-49ad-b3fa-5374aa234c6d    3341a17d-d0a7-4a9a-b11b-7205da2e8189    kid     ae4acfdb-866b-4440-9551-70d0bbc19eb2
eab3b009-c30d-41f9-93a3-3c0d93bc2568    0e458a5c-159f-4914-9486-ab2892e44e91    privateKey      MIIEogIBAAKCAQEAlyGl8Qprjm3IzweVN8HkYApCMYY4SjYwtM44IQT1PiCgCS2h82IiidDfK1F7a8fiAGobe3udRW45I5Ih7p0Z75ecxELkcxLLQ2g7ZSGtvVUs8QBXBaGWFdmOIaA8tlDd7JrGcd5D1QRVzptbSYqKFGMkfbznOPFGsfywnbi+cJVWslhNLRTS12HhzF2sXnhP5reBLXwf+D+j5XzZtg3GP29ZNJBmGhV727muYaTdeSxdrCLwyyyKi6CaB6FV/N69PEv6N3zWSTliEDUIh7/2OMQpvc7c56cdVI7lIQ+IyoWyZFkOi8q1PwtiG59NKOh2Mu3Q7gvFwXDUedLnA/GeAwIDAQABAoIBADOrV1ZvX5JUSmEtkIB9k5yaJUNVRg1pNYG7N0liro3NDanVphbVqEVB2eqvcujIb6YAoOC4xG4mXvagUWWI5IMbbIdU71HATSoAir3qo8GlSzYiDZ5pPiy+Mm+gnuEeCKGJ0OrBOKOtVcDLMIyWBtstgh5S5SJ8qtTTNXbW4JUQkwfwcN3AJUhnuMjdAFDuTqJrzQgcSP6S6jVIWUip9iQUaTAHkkJmG4AHq5HyyIFfPbtyOu07+SG+A14Q8bRYh1L8LP9Cz4xrURtPpEl35zn8Y+mpswsYXyVxY6DV7QG9BvsC6ZDFrNFD+ZUqOzL/kjPJvEbilcyQR1rRs19XWaECgYEAyZG7ZmD35NduXaoBHgNohAmwtaH071Ps4YmoGDbXlRk6hcE15dfo4w9Pvw/ruCjGVm3n54chdpCeFmjT7MMLalf4eM+Aum9BdWugRTNPHqQMA/6xnJSsQwhUBAVlK5BTli1rjPwJ3TTn6u7/uDZDh5XMyiGlWN/nNzonAH0PiTsCgYEAv/Ez+7oGusLzTAFj1QMITmFOXumLhOJAJkiyyvIXp2FFGrHvDV0oNeupH1s/gSxjY0d2fYPbHAzX6DuC2cxSGuO83yudVhuEpXpGeuEh4kbHY+aVGMhlJyXbZUDB/nHzrEoxQLbEx2qJttMA9/4ytX5Zceq8hSiUm0VfR2FmMdkCgYBskuATjGXa0SP0tc72QLW6cZHKtFs/0sAE2GY/7MKA4F8CjwkeLgeWzreQ3d2FjAkRow/ISaR/vfQ5c+u7W3A5rvr68CKRyb3Dpt5kh/e1NH34ZOd8xSRo0wKWS+Wr6ojrmrmU7mnNymKlzGjX6/rB/LGbqzXqQmjD+cHqZHLK4wKBgE821XRTDsnvAQfiHvhfOwNWB0kGa40Y7s6d/CPji72JWEKvInBKfPjb3D1TpD7EOfRUHuOoEjpeVpDCVrtaJpxwVpdn4ZQS4UiF0SaPWTOQcGObWvcSZSSl7Ai6lBVVo/H74J3LkCSYpGMua9ztLLJYhcOM0+bEm6gFFlBYMxvpAoGAIDun2UENwYvD2iYoMd5rAQm3KZNA/vsls05SkjoLdBLsumt95LI2MKlQGxqHInY+GcZIj1gGBpMvjq2B9WuFwAb2pIJ6T+/mw9WMWWMi1wBJa2WHNfAM73I/uJfusruQD4x+N4Eah2m0TMgH/lI46Yz/Khf9llgtfU04g5i29ec=
b153428f-8f90-4614-b10f-b48d25a7af97    0e458a5c-159f-4914-9486-ab2892e44e91    algorithm       RSA-OAEP
7f2d01cb-8c41-4df7-8de5-6b24674a5365    0e458a5c-159f-4914-9486-ab2892e44e91    certificate     MIICsTCCAZkCBgGerq2dPjANBgkqhkiG9w0BAQsFADAcMRowGAYDVQQDDBFYZW5vbi1EZXYtREVWLUVOVjAeFw0yNjA2MDkyMzE2MTRaFw0zNjA2MDkyMzE3NTRaMBwxGjAYBgNVBAMMEVhlbm9uLURldi1ERVYtRU5WMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAlyGl8Qprjm3IzweVN8HkYApCMYY4SjYwtM44IQT1PiCgCS2h82IiidDfK1F7a8fiAGobe3udRW45I5Ih7p0Z75ecxELkcxLLQ2g7ZSGtvVUs8QBXBaGWFdmOIaA8tlDd7JrGcd5D1QRVzptbSYqKFGMkfbznOPFGsfywnbi+cJVWslhNLRTS12HhzF2sXnhP5reBLXwf+D+j5XzZtg3GP29ZNJBmGhV727muYaTdeSxdrCLwyyyKi6CaB6FV/N69PEv6N3zWSTliEDUIh7/2OMQpvc7c56cdVI7lIQ+IyoWyZFkOi8q1PwtiG59NKOh2Mu3Q7gvFwXDUedLnA/GeAwIDAQABMA0GCSqGSIb3DQEBCwUAA4IBAQAvprG8TJ9v3+2fIyvqntpNI/IT8U7bzkwEWlkBnZMzv3jyqbdbdNabW8lC//Ey3oNMzGGRHpoVvrd8qDeW/4z7Rtuo4XGLG7a/nrDC86336KT/3pQrJEqZkN2Ja6shEdML0ub7yi2rPgi7o6F5pbyIrKUuPPlnFYDg9S/CSMZ1AYPC32hpJUlLow89QbE66WYpbH2s/QX4GQcQeIEPQj8a7sHnkYAOroJeDpJba3DaKIX1P9kH5jGeyLwj2UOfOhNMhEoYhFeZ7/PcS8IVuBtQMqgiQJoKcG2D00XFV80rKtchqH4dqqQgpoP+87UdYHHQKl/Ex3vnjAtI4AsZLuCn
ad5181a8-f13d-4bc1-a831-4f69668d369e    0e458a5c-159f-4914-9486-ab2892e44e91    priority        100
df43929a-9ebc-4a96-afd0-2b21065751a8    4c2f83e1-6d56-4eaa-a4c1-64cf084be466    allow-default-scopes    true
\.


--
-- Data for Name: composite_role; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.composite_role (composite, child_role) FROM stdin;
e03136b4-ad0c-4627-b8cb-0c3fb842b86e    ac79ab3f-564a-4a00-a752-e37bfe79d100
e03136b4-ad0c-4627-b8cb-0c3fb842b86e    f95d675b-3d31-480f-96a5-dc28dbec2133
e03136b4-ad0c-4627-b8cb-0c3fb842b86e    fd95a9c1-88ae-47a3-9b34-ef0376dbb7c3
e03136b4-ad0c-4627-b8cb-0c3fb842b86e    bd76352d-9096-4cbf-b96f-ce22962e14ae
e03136b4-ad0c-4627-b8cb-0c3fb842b86e    0b74cb14-6a80-49f9-9603-06e0a753f318
e03136b4-ad0c-4627-b8cb-0c3fb842b86e    c051e44b-bf41-4b6a-9ca1-5e4b00e38c46
e03136b4-ad0c-4627-b8cb-0c3fb842b86e    40ce6f1a-4a36-4fb5-ac31-1c5f5d98a993
e03136b4-ad0c-4627-b8cb-0c3fb842b86e    660767a7-c982-4a12-a96a-289eeca992df
e03136b4-ad0c-4627-b8cb-0c3fb842b86e    f11548e5-3207-4651-81f6-74128eb11858
e03136b4-ad0c-4627-b8cb-0c3fb842b86e    92c5107c-9c7f-49bd-9f07-3e3a879a9c1d
e03136b4-ad0c-4627-b8cb-0c3fb842b86e    72ec6a28-de01-4d17-b3d7-9b805a8a0487
e03136b4-ad0c-4627-b8cb-0c3fb842b86e    f7eb99c4-b839-4a29-b9ef-c62b54497357
e03136b4-ad0c-4627-b8cb-0c3fb842b86e    ee8d4e0c-bb0b-4074-9795-ad91f63c1aae
e03136b4-ad0c-4627-b8cb-0c3fb842b86e    40bcaf63-20f9-4c06-a54b-571bb9634729
e03136b4-ad0c-4627-b8cb-0c3fb842b86e    4f0b44c7-f410-4eb3-b0e4-c4c0c6b43e8b
e03136b4-ad0c-4627-b8cb-0c3fb842b86e    eac4b1bb-161e-40c4-9452-9fe0bef3b1a9
e03136b4-ad0c-4627-b8cb-0c3fb842b86e    72fa8670-d315-41ee-8283-311ecee1c95c
e03136b4-ad0c-4627-b8cb-0c3fb842b86e    815ab178-efa2-46ab-9f3d-d21621933f46
0b74cb14-6a80-49f9-9603-06e0a753f318    eac4b1bb-161e-40c4-9452-9fe0bef3b1a9
bd76352d-9096-4cbf-b96f-ce22962e14ae    4f0b44c7-f410-4eb3-b0e4-c4c0c6b43e8b
bd76352d-9096-4cbf-b96f-ce22962e14ae    815ab178-efa2-46ab-9f3d-d21621933f46
27f9ee59-8afb-4faa-a725-178d98c9f1c0    cbb0ac11-e572-448c-be96-497a80a14b88
27f9ee59-8afb-4faa-a725-178d98c9f1c0    0ad38ea0-b005-4334-a8da-a7626d3fa9d0
0ad38ea0-b005-4334-a8da-a7626d3fa9d0    c8fd4fcf-9532-4535-b5ed-700dba016320
8b83aae8-e471-4128-b870-0d0014205b3d    879eaed1-24cc-4cd6-91ce-c156ccc1ca8c
e03136b4-ad0c-4627-b8cb-0c3fb842b86e    4b3a01b4-00f6-49eb-b059-dfa61378402e
27f9ee59-8afb-4faa-a725-178d98c9f1c0    ae11397e-a4f0-45d1-a518-de6fad7d9fb7
27f9ee59-8afb-4faa-a725-178d98c9f1c0    cb196c0e-24ea-4b19-b6a8-3c52cfd7eece
e03136b4-ad0c-4627-b8cb-0c3fb842b86e    47d7845c-7083-48ce-a959-21d73421d661
e03136b4-ad0c-4627-b8cb-0c3fb842b86e    f19bb685-d234-484b-be5b-2dd46e37fcc5
e03136b4-ad0c-4627-b8cb-0c3fb842b86e    d520ba23-6279-4ef4-96ad-1b6f8dd59233
e03136b4-ad0c-4627-b8cb-0c3fb842b86e    6ff6e140-4584-4e20-b117-e53cc34fca44
e03136b4-ad0c-4627-b8cb-0c3fb842b86e    7922c5a9-a76c-4fd4-a734-19c942448208
e03136b4-ad0c-4627-b8cb-0c3fb842b86e    f6d76303-4d43-4857-a2e9-5aa4556cec17
e03136b4-ad0c-4627-b8cb-0c3fb842b86e    9228c151-cbab-4c8f-b707-01df2704b495
e03136b4-ad0c-4627-b8cb-0c3fb842b86e    cfeb32b9-952f-49db-ad97-93cc60aeef18
e03136b4-ad0c-4627-b8cb-0c3fb842b86e    f3eeb43c-0ae6-4016-9da0-3c6a397f939f
e03136b4-ad0c-4627-b8cb-0c3fb842b86e    60ede06c-7ee3-421d-8335-b58dc568e627
e03136b4-ad0c-4627-b8cb-0c3fb842b86e    bb7de2b5-dfcd-4dc6-9a58-9687aedc46d9
e03136b4-ad0c-4627-b8cb-0c3fb842b86e    5a1388bf-d375-4127-8e42-0992d82f2522
e03136b4-ad0c-4627-b8cb-0c3fb842b86e    26efee68-6ad1-4a9b-be4c-87ead0c94dd4
e03136b4-ad0c-4627-b8cb-0c3fb842b86e    be89408e-8fcb-4403-a474-2c8b190d7a5a
e03136b4-ad0c-4627-b8cb-0c3fb842b86e    83fced35-1ea1-4268-a002-8c03e035f656
e03136b4-ad0c-4627-b8cb-0c3fb842b86e    ba045c43-b03e-4e19-82c7-8cb0aa702284
e03136b4-ad0c-4627-b8cb-0c3fb842b86e    784ef712-e1d7-46dc-b93b-9d76d72ec133
6ff6e140-4584-4e20-b117-e53cc34fca44    83fced35-1ea1-4268-a002-8c03e035f656
d520ba23-6279-4ef4-96ad-1b6f8dd59233    be89408e-8fcb-4403-a474-2c8b190d7a5a
d520ba23-6279-4ef4-96ad-1b6f8dd59233    784ef712-e1d7-46dc-b93b-9d76d72ec133
c12a42cd-b2a1-4ac1-9fa4-722c4e8db40a    e61cb8a9-f2ef-4e4b-945d-aa3c4cf4e2d9
c12a42cd-b2a1-4ac1-9fa4-722c4e8db40a    c12a42cd-b2a1-4ac1-9fa4-722c4e8db40a
c12a42cd-b2a1-4ac1-9fa4-722c4e8db40a    5250a996-bcae-4745-84ec-7f4c34c67519
c12a42cd-b2a1-4ac1-9fa4-722c4e8db40a    16e2bccc-a397-4933-9258-309b4b77195d
c12a42cd-b2a1-4ac1-9fa4-722c4e8db40a    0acba8ae-6701-4ff6-8ec7-740150807ee7
c12a42cd-b2a1-4ac1-9fa4-722c4e8db40a    c54b203c-c48b-489d-8df6-5abcde3f60c5
c12a42cd-b2a1-4ac1-9fa4-722c4e8db40a    ef40816d-3ede-4d73-a6e0-e382b3951b57
c12a42cd-b2a1-4ac1-9fa4-722c4e8db40a    f2719fba-0604-43b4-8291-b0720ea9021a
c12a42cd-b2a1-4ac1-9fa4-722c4e8db40a    755e113a-4897-4c44-9773-aae10820c8f2
c12a42cd-b2a1-4ac1-9fa4-722c4e8db40a    a542dcdf-4c79-4ce3-82d1-7b3df33f01ba
c12a42cd-b2a1-4ac1-9fa4-722c4e8db40a    a9976f07-e0bb-46da-ac69-9f1483b4e839
c12a42cd-b2a1-4ac1-9fa4-722c4e8db40a    76d883aa-495e-41ad-9e55-72703f26205d
c12a42cd-b2a1-4ac1-9fa4-722c4e8db40a    63bab289-4440-467d-9580-d4c47005e5d4
c12a42cd-b2a1-4ac1-9fa4-722c4e8db40a    01e4a71a-94f9-4569-9217-026d8b502326
c12a42cd-b2a1-4ac1-9fa4-722c4e8db40a    43ea0fe9-162d-4158-9b4d-58c2e0b4fa68
bfa8d1dc-bd90-4ac6-b69e-f84d014a6cb1    292626a3-80a2-418b-bd57-cd957615a485
bfa8d1dc-bd90-4ac6-b69e-f84d014a6cb1    518330f9-7511-4527-863a-d494c14d97ab
2e7358e2-7e47-43dd-832c-c8f1424cd39f    16e2bccc-a397-4933-9258-309b4b77195d
2e7358e2-7e47-43dd-832c-c8f1424cd39f    0acba8ae-6701-4ff6-8ec7-740150807ee7
2e7358e2-7e47-43dd-832c-c8f1424cd39f    9d2116e8-2019-472e-b990-9bfc5ea93bf5
2e7358e2-7e47-43dd-832c-c8f1424cd39f    bfa8d1dc-bd90-4ac6-b69e-f84d014a6cb1
2e7358e2-7e47-43dd-832c-c8f1424cd39f    d7efca3e-cd24-4bc5-a42f-99d6175ccc2f
2e7358e2-7e47-43dd-832c-c8f1424cd39f    888bfb73-9da8-4c39-8c70-19e297ad1b68
2e7358e2-7e47-43dd-832c-c8f1424cd39f    a1ff898e-3222-4ffb-b983-b0112a0256ce
2e7358e2-7e47-43dd-832c-c8f1424cd39f    3602a511-7db2-48af-9f5d-29a4af994b43
2e7358e2-7e47-43dd-832c-c8f1424cd39f    292626a3-80a2-418b-bd57-cd957615a485
2e7358e2-7e47-43dd-832c-c8f1424cd39f    21401e33-ebc7-442d-8e72-cd49becf26d7
2e7358e2-7e47-43dd-832c-c8f1424cd39f    518330f9-7511-4527-863a-d494c14d97ab
2e7358e2-7e47-43dd-832c-c8f1424cd39f    e29c702a-09c1-49cf-aa2a-365dd87b843d
2e7358e2-7e47-43dd-832c-c8f1424cd39f    d73bcca4-d765-4a6d-b261-fa9d460687a4
2e7358e2-7e47-43dd-832c-c8f1424cd39f    1401b23f-d688-4314-bfb4-4ec0fa44bb67
2e7358e2-7e47-43dd-832c-c8f1424cd39f    0b409298-7c0c-48e9-adbb-50474968f4c9
2e7358e2-7e47-43dd-832c-c8f1424cd39f    6f5ea219-5737-47b6-908a-a5fd22ecc883
2e7358e2-7e47-43dd-832c-c8f1424cd39f    3ca1d168-eede-4722-83fa-ac3a2d99d1f8
2e7358e2-7e47-43dd-832c-c8f1424cd39f    238f7196-e097-41e5-8db4-4930bcfbcd01
1401b23f-d688-4314-bfb4-4ec0fa44bb67    6f5ea219-5737-47b6-908a-a5fd22ecc883
c54b203c-c48b-489d-8df6-5abcde3f60c5    ef40816d-3ede-4d73-a6e0-e382b3951b57
c54b203c-c48b-489d-8df6-5abcde3f60c5    76d883aa-495e-41ad-9e55-72703f26205d
c54b203c-c48b-489d-8df6-5abcde3f60c5    f2719fba-0604-43b4-8291-b0720ea9021a
c54b203c-c48b-489d-8df6-5abcde3f60c5    755e113a-4897-4c44-9773-aae10820c8f2
c54b203c-c48b-489d-8df6-5abcde3f60c5    63bab289-4440-467d-9580-d4c47005e5d4
c54b203c-c48b-489d-8df6-5abcde3f60c5    01e4a71a-94f9-4569-9217-026d8b502326
c54b203c-c48b-489d-8df6-5abcde3f60c5    a542dcdf-4c79-4ce3-82d1-7b3df33f01ba
c54b203c-c48b-489d-8df6-5abcde3f60c5    43ea0fe9-162d-4158-9b4d-58c2e0b4fa68
c54b203c-c48b-489d-8df6-5abcde3f60c5    a9976f07-e0bb-46da-ac69-9f1483b4e839
76d883aa-495e-41ad-9e55-72703f26205d    a9976f07-e0bb-46da-ac69-9f1483b4e839
a542dcdf-4c79-4ce3-82d1-7b3df33f01ba    43ea0fe9-162d-4158-9b4d-58c2e0b4fa68
e03136b4-ad0c-4627-b8cb-0c3fb842b86e    d0272f03-8fe5-4390-aaf2-f77feb2ec37e
\.


--
-- Data for Name: credential; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.credential (id, salt, type, user_id, created_date, user_label, secret_data, credential_data, priority, version) FROM stdin;
41c646f8-a9aa-4e97-9a27-8363ff1a94da    \N      password        4cd2326c-3588-4bbe-b396-17626465c850    1781047404702  My password      {"value":"2StTVnw74VClzrI692U99Pzm8Dj36k3uvl1974Fy80o=","salt":"AqX3d1k4shq2b9KSkNPNFg==","additionalParameters":{}}    {"hashIterations":5,"algorithm":"argon2","additionalParameters":{"hashLength":["32"],"memory":["7168"],"type":["id"],"version":["1.3"],"parallelism":["1"]}}    10      1
6aee2ecd-3b48-4673-8bbd-59b4250c4cef    \N      password        e9f01c19-42a9-47e5-a0c3-0119c5de7fab    1781047470263  My password      {"value":"6yumPyTQsT9UFUeBzFYxYPMIef2BiFXU9Fly9Zg1Aq0=","salt":"hB7FjhdZ4tgMVfdFBFoP/g==","additionalParameters":{}}    {"hashIterations":5,"algorithm":"argon2","additionalParameters":{"hashLength":["32"],"memory":["7168"],"type":["id"],"version":["1.3"],"parallelism":["1"]}}    10      1
\.


--
-- Data for Name: databasechangelog; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) FROM stdin;
1.0.0.Final-KEYCLOAK-5461       sthorger@redhat.com     META-INF/jpa-changelog-1.0.0.Final.xml  2026-06-09 23:06:52.072938      1       EXECUTED        9:6f1016664e21e16d26517a4418f5e3df      createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...              \N      4.33.0  \N     \N       1046405406
1.0.0.Final-KEYCLOAK-5461       sthorger@redhat.com     META-INF/db2-jpa-changelog-1.0.0.Final.xml      2026-06-09 23:06:52.106366      2       MARK_RAN        9:828775b1596a07d1200ba1d49e5e3941      createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...              \N      4.33.0 \N       \N      1046405406
1.1.0.Beta1     sthorger@redhat.com     META-INF/jpa-changelog-1.1.0.Beta1.xml  2026-06-09 23:06:52.194424      3      EXECUTED 9:5f090e44a7d595883c1fb61f4b41fd38      delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=CLIENT_ATTRIBUTES; createTable tableName=CLIENT_SESSION_NOTE; createTable tableName=APP_NODE_REGISTRATIONS; addColumn table...              \N      4.33.0  \N      \N      1046405406
1.1.0.Final     sthorger@redhat.com     META-INF/jpa-changelog-1.1.0.Final.xml  2026-06-09 23:06:52.202963      4      EXECUTED 9:c07e577387a3d2c04d1adc9aaad8730e      renameColumn newColumnName=EVENT_TIME, oldColumnName=TIME, tableName=EVENT_ENTITY               \N      4.33.0  \N      \N      1046405406
1.2.0.Beta1     psilva@redhat.com       META-INF/jpa-changelog-1.2.0.Beta1.xml  2026-06-09 23:06:52.392707      5      EXECUTED 9:b68ce996c655922dbcd2fe6b6ae72686      delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...              \N      4.33.0  \N      \N      1046405406
1.2.0.Beta1     psilva@redhat.com       META-INF/db2-jpa-changelog-1.2.0.Beta1.xml      2026-06-09 23:06:52.399871     6MARK_RAN        9:543b5c9989f024fe35c6f6c5a97de88e      delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...              \N      4.33.0  \N      \N      1046405406
1.2.0.RC1       bburke@redhat.com       META-INF/jpa-changelog-1.2.0.CR1.xml    2026-06-09 23:06:52.566175      7      EXECUTED 9:765afebbe21cf5bbca048e632df38336      delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...              \N      4.33.0  \N      \N      1046405406
1.2.0.RC1       bburke@redhat.com       META-INF/db2-jpa-changelog-1.2.0.CR1.xml        2026-06-09 23:06:52.572514     8MARK_RAN        9:db4a145ba11a6fdaefb397f6dbf829a1      delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...              \N      4.33.0  \N      \N      1046405406
1.2.0.Final     keycloak        META-INF/jpa-changelog-1.2.0.Final.xml  2026-06-09 23:06:52.590275      9       EXECUTED9:9d05c7be10cdb873f8bcb41bc3a8ab23      update tableName=CLIENT; update tableName=CLIENT; update tableName=CLIENT
\N      4.33.0  \N      \N      1046405406
1.3.0   bburke@redhat.com       META-INF/jpa-changelog-1.3.0.xml        2026-06-09 23:06:52.773782      10      EXECUTED9:18593702353128d53111f9b1ff0b82b8      delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=ADMI...              \N      4.33.0  \N      \N      1046405406
1.4.0   bburke@redhat.com       META-INF/jpa-changelog-1.4.0.xml        2026-06-09 23:06:52.873937      11      EXECUTED9:6122efe5f090e41a85c0f1c9e52cbb62      delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...              \N      4.33.0  \N      \N      1046405406
1.4.0   bburke@redhat.com       META-INF/db2-jpa-changelog-1.4.0.xml    2026-06-09 23:06:52.879669      12      MARK_RAN9:e1ff28bf7568451453f844c5d54bb0b5      delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...              \N      4.33.0  \N      \N      1046405406
1.5.0   bburke@redhat.com       META-INF/jpa-changelog-1.5.0.xml        2026-06-09 23:06:52.927578      13      EXECUTED9:7af32cd8957fbc069f796b61217483fd      delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...              \N      4.33.0  \N      \N      1046405406
1.6.1_from15    mposolda@redhat.com     META-INF/jpa-changelog-1.6.1.xml        2026-06-09 23:06:52.961025      14     EXECUTED 9:6005e15e84714cd83226bf7879f54190      addColumn tableName=REALM; addColumn tableName=KEYCLOAK_ROLE; addColumn tableName=CLIENT; createTable tableName=OFFLINE_USER_SESSION; createTable tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_US_SES_PK2, tableName=...              \N      4.33.0  \N      \N      1046405406
1.6.1_from16-pre        mposolda@redhat.com     META-INF/jpa-changelog-1.6.1.xml        2026-06-09 23:06:52.963522     15       MARK_RAN        9:bf656f5a2b055d07f314431cae76f06c      delete tableName=OFFLINE_CLIENT_SESSION; delete tableName=OFFLINE_USER_SESSION          \N      4.33.0  \N      \N      1046405406
1.6.1_from16    mposolda@redhat.com     META-INF/jpa-changelog-1.6.1.xml        2026-06-09 23:06:52.967664      16     MARK_RAN 9:f8dadc9284440469dcf71e25ca6ab99b      dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_US_SES_PK, tableName=OFFLINE_USER_SESSION; dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_CL_SES_PK, tableName=OFFLINE_CLIENT_SESSION; addColumn tableName=OFFLINE_USER_SESSION; update tableName=OF...              \N      4.33.0  \N      \N      1046405406
1.6.1   mposolda@redhat.com     META-INF/jpa-changelog-1.6.1.xml        2026-06-09 23:06:52.97496       17      EXECUTED9:d41d8cd98f00b204e9800998ecf8427e      empty           \N      4.33.0  \N      \N      1046405406
1.7.0   bburke@redhat.com       META-INF/jpa-changelog-1.7.0.xml        2026-06-09 23:06:53.053966      18      EXECUTED9:3368ff0be4c2855ee2dd9ca813b38d8e      createTable tableName=KEYCLOAK_GROUP; createTable tableName=GROUP_ROLE_MAPPING; createTable tableName=GROUP_ATTRIBUTE; createTable tableName=USER_GROUP_MEMBERSHIP; createTable tableName=REALM_DEFAULT_GROUPS; addColumn tableName=IDENTITY_PROVIDER; ...              \N      4.33.0  \N      \N      1046405406
1.8.0   mposolda@redhat.com     META-INF/jpa-changelog-1.8.0.xml        2026-06-09 23:06:53.130126      19      EXECUTED9:8ac2fb5dd030b24c0570a763ed75ed20      addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...              \N      4.33.0  \N      \N      1046405406
1.8.0-2 keycloak        META-INF/jpa-changelog-1.8.0.xml        2026-06-09 23:06:53.139101      20      EXECUTED       9:f91ddca9b19743db60e3057679810e6c       dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL                \N      4.33.0  \N      \N      1046405406
22.0.5-24031    keycloak        META-INF/jpa-changelog-22.0.0.xml       2026-06-09 23:06:59.99419       119     MARK_RAN9:a60d2d7b315ec2d3eba9e2f145f9df28      customChange            \N      4.33.0  \N      \N      1046405406
1.8.0   mposolda@redhat.com     META-INF/db2-jpa-changelog-1.8.0.xml    2026-06-09 23:06:53.143814      21      MARK_RAN9:831e82914316dc8a57dc09d755f23c51      addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...              \N      4.33.0  \N      \N      1046405406
1.8.0-2 keycloak        META-INF/db2-jpa-changelog-1.8.0.xml    2026-06-09 23:06:53.149841      22      MARK_RAN       9:f91ddca9b19743db60e3057679810e6c       dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL                \N      4.33.0  \N      \N      1046405406
1.9.0   mposolda@redhat.com     META-INF/jpa-changelog-1.9.0.xml        2026-06-09 23:06:53.254936      23      EXECUTED9:bc3d0f9e823a69dc21e23e94c7a94bb1      update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=REALM; update tableName=REALM; customChange; dr...              \N      4.33.0  \N      \N      1046405406
1.9.1   keycloak        META-INF/jpa-changelog-1.9.1.xml        2026-06-09 23:06:53.270652      24      EXECUTED       9:c9999da42f543575ab790e76439a2679       modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=PUBLIC_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM           \N      4.33.0  \N     \N       1046405406
1.9.1   keycloak        META-INF/db2-jpa-changelog-1.9.1.xml    2026-06-09 23:06:53.285893      25      MARK_RAN       9:0d6c65c6f58732d81569e77b10ba301d       modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM          \N      4.33.0  \N      \N      1046405406
1.9.2   keycloak        META-INF/jpa-changelog-1.9.2.xml        2026-06-09 23:06:53.771663      26      EXECUTED       9:fc576660fc016ae53d2d4778d84d86d0       createIndex indexName=IDX_USER_EMAIL, tableName=USER_ENTITY; createIndex indexName=IDX_USER_ROLE_MAPPING, tableName=USER_ROLE_MAPPING; createIndex indexName=IDX_USER_GROUP_MAPPING, tableName=USER_GROUP_MEMBERSHIP; createIndex indexName=IDX_USER_CO...              \N      4.33.0  \N      \N      1046405406
authz-2.0.0     psilva@redhat.com       META-INF/jpa-changelog-authz-2.0.0.xml  2026-06-09 23:06:53.937168      27     EXECUTED 9:43ed6b0da89ff77206289e87eaa9c024      createTable tableName=RESOURCE_SERVER; addPrimaryKey constraintName=CONSTRAINT_FARS, tableName=RESOURCE_SERVER; addUniqueConstraint constraintName=UK_AU8TT6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER; createTable tableName=RESOURCE_SERVER_RESOU...              \N      4.33.0  \N      \N      1046405406
authz-2.5.1     psilva@redhat.com       META-INF/jpa-changelog-authz-2.5.1.xml  2026-06-09 23:06:53.950062      28     EXECUTED 9:44bae577f551b3738740281eceb4ea70      update tableName=RESOURCE_SERVER_POLICY         \N      4.33.0  \N     \N       1046405406
2.1.0-KEYCLOAK-5461     bburke@redhat.com       META-INF/jpa-changelog-2.1.0.xml        2026-06-09 23:06:54.042231     29       EXECUTED        9:bd88e1f833df0420b01e114533aee5e8      createTable tableName=BROKER_LINK; createTable tableName=FED_USER_ATTRIBUTE; createTable tableName=FED_USER_CONSENT; createTable tableName=FED_USER_CONSENT_ROLE; createTable tableName=FED_USER_CONSENT_PROT_MAPPER; createTable tableName=FED_USER_CR...              \N      4.33.0  \N      \N     1046405406
2.2.0   bburke@redhat.com       META-INF/jpa-changelog-2.2.0.xml        2026-06-09 23:06:54.066387      30      EXECUTED9:a7022af5267f019d020edfe316ef4371      addColumn tableName=ADMIN_EVENT_ENTITY; createTable tableName=CREDENTIAL_ATTRIBUTE; createTable tableName=FED_CREDENTIAL_ATTRIBUTE; modifyDataType columnName=VALUE, tableName=CREDENTIAL; addForeignKeyConstraint baseTableName=FED_CREDENTIAL_ATTRIBU...              \N      4.33.0  \N      \N      1046405406
2.3.0   bburke@redhat.com       META-INF/jpa-changelog-2.3.0.xml        2026-06-09 23:06:54.100278      31      EXECUTED9:fc155c394040654d6a79227e56f5e25a      createTable tableName=FEDERATED_USER; addPrimaryKey constraintName=CONSTR_FEDERATED_USER, tableName=FEDERATED_USER; dropDefaultValue columnName=TOTP, tableName=USER_ENTITY; dropColumn columnName=TOTP, tableName=USER_ENTITY; addColumn tableName=IDE...              \N      4.33.0  \N      \N      1046405406
2.4.0   bburke@redhat.com       META-INF/jpa-changelog-2.4.0.xml        2026-06-09 23:06:54.112637      32      EXECUTED9:eac4ffb2a14795e5dc7b426063e54d88      customChange            \N      4.33.0  \N      \N      1046405406
2.5.0   bburke@redhat.com       META-INF/jpa-changelog-2.5.0.xml        2026-06-09 23:06:54.123153      33      EXECUTED9:54937c05672568c4c64fc9524c1e9462      customChange; modifyDataType columnName=USER_ID, tableName=OFFLINE_USER_SESSION
        \N      4.33.0  \N      \N      1046405406
2.5.0-unicode-oracle    hmlnarik@redhat.com     META-INF/jpa-changelog-2.5.0.xml        2026-06-09 23:06:54.127006     34       MARK_RAN        9:f9753208029f582525ed12011a19d054      modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...              \N      4.33.0  \N      \N     1046405406
2.5.0-unicode-other-dbs hmlnarik@redhat.com     META-INF/jpa-changelog-2.5.0.xml        2026-06-09 23:06:54.17451      35       EXECUTED        9:33d72168746f81f98ae3a1e8e0ca3554      modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...              \N      4.33.0  \N      \N     1046405406
2.5.0-duplicate-email-support   slawomir@dabek.name     META-INF/jpa-changelog-2.5.0.xml        2026-06-09 23:06:54.182651      36      EXECUTED        9:61b6d3d7a4c0e0024b0c839da283da0c      addColumn tableName=REALM               \N     4.33.0   \N      \N      1046405406
2.5.0-unique-group-names        hmlnarik@redhat.com     META-INF/jpa-changelog-2.5.0.xml        2026-06-09 23:06:54.189775      37      EXECUTED        9:8dcac7bdf7378e7d823cdfddebf72fda      addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP              \N      4.33.0  \N      \N      1046405406
2.5.1   bburke@redhat.com       META-INF/jpa-changelog-2.5.1.xml        2026-06-09 23:06:54.200305      38      EXECUTED9:a2b870802540cb3faa72098db5388af3      addColumn tableName=FED_USER_CONSENT            \N      4.33.0  \N      \N     1046405406
3.0.0   bburke@redhat.com       META-INF/jpa-changelog-3.0.0.xml        2026-06-09 23:06:54.207005      39      EXECUTED9:132a67499ba24bcc54fb5cbdcfe7e4c0      addColumn tableName=IDENTITY_PROVIDER           \N      4.33.0  \N      \N     1046405406
3.2.0-fix       keycloak        META-INF/jpa-changelog-3.2.0.xml        2026-06-09 23:06:54.209354      40      MARK_RAN9:938f894c032f5430f2b0fafb1a243462      addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS
\N      4.33.0  \N      \N      1046405406
3.2.0-fix-with-keycloak-5416    keycloak        META-INF/jpa-changelog-3.2.0.xml        2026-06-09 23:06:54.213022     41       MARK_RAN        9:845c332ff1874dc5d35974b0babf3006      dropIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS; addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS; createIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS             \N      4.33.0  \N      \N      1046405406
3.2.0-fix-offline-sessions      hmlnarik        META-INF/jpa-changelog-3.2.0.xml        2026-06-09 23:06:54.222944     42       EXECUTED        9:fc86359c079781adc577c5a217e4d04c      customChange            \N      4.33.0  \N      \N     1046405406
3.2.0-fixed     keycloak        META-INF/jpa-changelog-3.2.0.xml        2026-06-09 23:06:56.521079      43      EXECUTED9:59a64800e3c0d09b825f8a3b444fa8f4      addColumn tableName=REALM; dropPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_PK2, tableName=OFFLINE_CLIENT_SESSION; dropColumn columnName=CLIENT_SESSION_ID, tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_P...              \N      4.33.0  \N      \N      1046405406
3.3.0   keycloak        META-INF/jpa-changelog-3.3.0.xml        2026-06-09 23:06:56.528305      44      EXECUTED       9:d48d6da5c6ccf667807f633fe489ce88       addColumn tableName=USER_ENTITY         \N      4.33.0  \N      \N      1046405406
authz-3.4.0.CR1-resource-server-pk-change-part1 glavoie@gmail.com       META-INF/jpa-changelog-authz-3.4.0.CR1.xml     2026-06-09 23:06:56.537621       45      EXECUTED        9:dde36f7973e80d71fceee683bc5d2951      addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_RESOURCE; addColumn tableName=RESOURCE_SERVER_SCOPE            \N       4.33.0  \N      \N      1046405406
authz-3.4.0.CR1-resource-server-pk-change-part2-KEYCLOAK-6095   hmlnarik@redhat.com     META-INF/jpa-changelog-authz-3.4.0.CR1.xml      2026-06-09 23:06:56.546293      46      EXECUTED        9:b855e9b0a406b34fa323235a0cf4f640      customChange            \N      4.33.0  \N      \N      1046405406
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed   glavoie@gmail.com       META-INF/jpa-changelog-authz-3.4.0.CR1.xml      2026-06-09 23:06:56.548913      47      MARK_RAN        9:51abbacd7b416c50c4421a8cabf7927e      dropIndex indexName=IDX_RES_SERV_POL_RES_SERV, tableName=RESOURCE_SERVER_POLICY; dropIndex indexName=IDX_RES_SRV_RES_RES_SRV, tableName=RESOURCE_SERVER_RESOURCE; dropIndex indexName=IDX_RES_SRV_SCOPE_RES_SRV, tableName=RESOURCE_SERVER_SCOPE               \N       4.33.0  \N      \N      1046405406
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed-nodropindex       glavoie@gmail.com       META-INF/jpa-changelog-authz-3.4.0.CR1.xml      2026-06-09 23:06:56.768608      48      EXECUTED        9:bdc99e567b3398bac83263d375aad143     addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_POLICY; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_RESOURCE; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, ...               \N      4.33.0  \N      \N      1046405406
authn-3.4.0.CR1-refresh-token-max-reuse glavoie@gmail.com       META-INF/jpa-changelog-authz-3.4.0.CR1.xml      2026-06-09 23:06:56.775577      49      EXECUTED        9:d198654156881c46bfba39abd7769e69      addColumn tableName=REALM
\N      4.33.0  \N      \N      1046405406
3.4.0   keycloak        META-INF/jpa-changelog-3.4.0.xml        2026-06-09 23:06:56.833155      50      EXECUTED       9:cfdd8736332ccdd72c5256ccb42335db       addPrimaryKey constraintName=CONSTRAINT_REALM_DEFAULT_ROLES, tableName=REALM_DEFAULT_ROLES; addPrimaryKey constraintName=CONSTRAINT_COMPOSITE_ROLE, tableName=COMPOSITE_ROLE; addPrimaryKey constraintName=CONSTR_REALM_DEFAULT_GROUPS, tableName=REALM...              \N      4.33.0  \N      \N      1046405406
3.4.0-KEYCLOAK-5230     hmlnarik@redhat.com     META-INF/jpa-changelog-3.4.0.xml        2026-06-09 23:06:57.419762     51       EXECUTED        9:7c84de3d9bd84d7f077607c1a4dcb714      createIndex indexName=IDX_FU_ATTRIBUTE, tableName=FED_USER_ATTRIBUTE; createIndex indexName=IDX_FU_CONSENT, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CONSENT_RU, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CREDENTIAL, t...              \N      4.33.0  \N      \N     1046405406
3.4.1   psilva@redhat.com       META-INF/jpa-changelog-3.4.1.xml        2026-06-09 23:06:57.425655      52      EXECUTED9:5a6bb36cbefb6a9d6928452c0852af2d      modifyDataType columnName=VALUE, tableName=CLIENT_ATTRIBUTES            \N     4.33.0   \N      \N      1046405406
3.4.2   keycloak        META-INF/jpa-changelog-3.4.2.xml        2026-06-09 23:06:57.431386      53      EXECUTED       9:8f23e334dbc59f82e0a328373ca6ced0       update tableName=REALM          \N      4.33.0  \N      \N      1046405406
3.4.2-KEYCLOAK-5172     mkanis@redhat.com       META-INF/jpa-changelog-3.4.2.xml        2026-06-09 23:06:57.438458     54       EXECUTED        9:9156214268f09d970cdf0e1564d866af      update tableName=CLIENT         \N      4.33.0  \N     \N       1046405406
4.0.0-KEYCLOAK-6335     bburke@redhat.com       META-INF/jpa-changelog-4.0.0.xml        2026-06-09 23:06:57.449865     55       EXECUTED        9:db806613b1ed154826c02610b7dbdf74      createTable tableName=CLIENT_AUTH_FLOW_BINDINGS; addPrimaryKey constraintName=C_CLI_FLOW_BIND, tableName=CLIENT_AUTH_FLOW_BINDINGS              \N      4.33.0  \N      \N     1046405406
4.0.0-CLEANUP-UNUSED-TABLE      bburke@redhat.com       META-INF/jpa-changelog-4.0.0.xml        2026-06-09 23:06:57.46005       56      EXECUTED        9:229a041fb72d5beac76bb94a5fa709de      dropTable tableName=CLIENT_IDENTITY_PROV_MAPPING        \N      4.33.0  \N      \N      1046405406
4.0.0-KEYCLOAK-6228     bburke@redhat.com       META-INF/jpa-changelog-4.0.0.xml        2026-06-09 23:06:57.547313     57       EXECUTED        9:079899dade9c1e683f26b2aa9ca6ff04      dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; dropNotNullConstraint columnName=CLIENT_ID, tableName=USER_CONSENT; addColumn tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHO...              \N      4.33.0  \N      \N     1046405406
4.0.0-KEYCLOAK-5579-fixed       mposolda@redhat.com     META-INF/jpa-changelog-4.0.0.xml        2026-06-09 23:06:58.237875      58      EXECUTED        9:139b79bcbbfe903bb1c2d2a4dbf001d9      dropForeignKeyConstraint baseTableName=CLIENT_TEMPLATE_ATTRIBUTES, constraintName=FK_CL_TEMPL_ATTR_TEMPL; renameTable newTableName=CLIENT_SCOPE_ATTRIBUTES, oldTableName=CLIENT_TEMPLATE_ATTRIBUTES; renameColumn newColumnName=SCOPE_ID, oldColumnName...              \N      4.33.0  \N     \N       1046405406
authz-4.0.0.CR1 psilva@redhat.com       META-INF/jpa-changelog-authz-4.0.0.CR1.xml      2026-06-09 23:06:58.281503     59       EXECUTED        9:b55738ad889860c625ba2bf483495a04      createTable tableName=RESOURCE_SERVER_PERM_TICKET; addPrimaryKey constraintName=CONSTRAINT_FAPMT, tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRHO213XCX4WNKOG82SSPMT...              \N      4.33.0  \N      \N     1046405406
authz-4.0.0.Beta3       psilva@redhat.com       META-INF/jpa-changelog-authz-4.0.0.Beta3.xml    2026-06-09 23:06:58.29265       60      EXECUTED        9:e0057eac39aa8fc8e09ac6cfa4ae15fe      addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRPO2128CX4WNKOG82SSRFY, referencedTableName=RESOURCE_SERVER_POLICY         \N      4.33.0  \N      \N     1046405406
authz-4.2.0.Final       mhajas@redhat.com       META-INF/jpa-changelog-authz-4.2.0.Final.xml    2026-06-09 23:06:58.30932       61      EXECUTED        9:42a33806f3a0443fe0e7feeec821326c      createTable tableName=RESOURCE_URIS; addForeignKeyConstraint baseTableName=RESOURCE_URIS, constraintName=FK_RESOURCE_SERVER_URIS, referencedTableName=RESOURCE_SERVER_RESOURCE; customChange; dropColumn columnName=URI, tableName=RESOURCE_SERVER_RESO...              \N      4.33.0  \N     \N       1046405406
authz-4.2.0.Final-KEYCLOAK-9944 hmlnarik@redhat.com     META-INF/jpa-changelog-authz-4.2.0.Final.xml    2026-06-09 23:06:58.31691       62      EXECUTED        9:9968206fca46eecc1f51db9c024bfe56      addPrimaryKey constraintName=CONSTRAINT_RESOUR_URIS_PK, tableName=RESOURCE_URIS         \N      4.33.0  \N      \N      1046405406
4.2.0-KEYCLOAK-6313     wadahiro@gmail.com      META-INF/jpa-changelog-4.2.0.xml        2026-06-09 23:06:58.323075     63       EXECUTED        9:92143a6daea0a3f3b8f598c97ce55c3d      addColumn tableName=REQUIRED_ACTION_PROVIDER           \N       4.33.0  \N      \N      1046405406
4.3.0-KEYCLOAK-7984     wadahiro@gmail.com      META-INF/jpa-changelog-4.3.0.xml        2026-06-09 23:06:58.328751     64       EXECUTED        9:82bab26a27195d889fb0429003b18f40      update tableName=REQUIRED_ACTION_PROVIDER              \N       4.33.0  \N      \N      1046405406
4.6.0-KEYCLOAK-7950     psilva@redhat.com       META-INF/jpa-changelog-4.6.0.xml        2026-06-09 23:06:58.335431     65       EXECUTED        9:e590c88ddc0b38b0ae4249bbfcb5abc3      update tableName=RESOURCE_SERVER_RESOURCE              \N       4.33.0  \N      \N      1046405406
4.6.0-KEYCLOAK-8377     keycloak        META-INF/jpa-changelog-4.6.0.xml        2026-06-09 23:06:58.412989      66     EXECUTED 9:5c1f475536118dbdc38d5d7977950cc0      createTable tableName=ROLE_ATTRIBUTE; addPrimaryKey constraintName=CONSTRAINT_ROLE_ATTRIBUTE_PK, tableName=ROLE_ATTRIBUTE; addForeignKeyConstraint baseTableName=ROLE_ATTRIBUTE, constraintName=FK_ROLE_ATTRIBUTE_ID, referencedTableName=KEYCLOAK_ROLE...              \N      4.33.0  \N      \N      1046405406
4.6.0-KEYCLOAK-8555     gideonray@gmail.com     META-INF/jpa-changelog-4.6.0.xml        2026-06-09 23:06:58.476002     67       EXECUTED        9:e7c9f5f9c4d67ccbbcc215440c718a17      createIndex indexName=IDX_COMPONENT_PROVIDER_TYPE, tableName=COMPONENT          \N      4.33.0  \N      \N      1046405406
4.7.0-KEYCLOAK-1267     sguilhen@redhat.com     META-INF/jpa-changelog-4.7.0.xml        2026-06-09 23:06:58.48447      68       EXECUTED        9:88e0bfdda924690d6f4e430c53447dd5      addColumn tableName=REALM               \N      4.33.0 \N       \N      1046405406
4.7.0-KEYCLOAK-7275     keycloak        META-INF/jpa-changelog-4.7.0.xml        2026-06-09 23:06:58.549048      69     EXECUTED 9:f53177f137e1c46b6a88c59ec1cb5218      renameColumn newColumnName=CREATED_ON, oldColumnName=LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION; addNotNullConstraint columnName=CREATED_ON, tableName=OFFLINE_USER_SESSION; addColumn tableName=OFFLINE_USER_SESSION; customChange; createIn...              \N      4.33.0  \N      \N      1046405406
4.8.0-KEYCLOAK-8835     sguilhen@redhat.com     META-INF/jpa-changelog-4.8.0.xml        2026-06-09 23:06:58.560914     70       EXECUTED        9:a74d33da4dc42a37ec27121580d1459f      addNotNullConstraint columnName=SSO_MAX_LIFESPAN_REMEMBER_ME, tableName=REALM; addNotNullConstraint columnName=SSO_IDLE_TIMEOUT_REMEMBER_ME, tableName=REALM            \N     4.33.0   \N      \N      1046405406
authz-7.0.0-KEYCLOAK-10443      psilva@redhat.com       META-INF/jpa-changelog-authz-7.0.0.xml  2026-06-09 23:06:58.567102      71      EXECUTED        9:fd4ade7b90c3b67fae0bfcfcb42dfb5f      addColumn tableName=RESOURCE_SERVER            \N       4.33.0  \N      \N      1046405406
8.0.0-adding-credential-columns keycloak        META-INF/jpa-changelog-8.0.0.xml        2026-06-09 23:06:58.582011     72       EXECUTED        9:aa072ad090bbba210d8f18781b8cebf4      addColumn tableName=CREDENTIAL; addColumn tableName=FED_USER_CREDENTIAL         \N      4.33.0  \N      \N      1046405406
8.0.0-updating-credential-data-not-oracle-fixed keycloak        META-INF/jpa-changelog-8.0.0.xml        2026-06-09 23:06:58.598367      73      EXECUTED        9:1ae6be29bab7c2aa376f6983b932be37      update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL         \N      4.33.0  \N      \N      1046405406
8.0.0-updating-credential-data-oracle-fixed     keycloak        META-INF/jpa-changelog-8.0.0.xml        2026-06-09 23:06:58.602589      74      MARK_RAN        9:14706f286953fc9a25286dbd8fb30d97      update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL         \N      4.33.0  \N      \N      1046405406
8.0.0-credential-cleanup-fixed  keycloak        META-INF/jpa-changelog-8.0.0.xml        2026-06-09 23:06:58.653921     75       EXECUTED        9:2b9cc12779be32c5b40e2e67711a218b      dropDefaultValue columnName=COUNTER, tableName=CREDENTIAL; dropDefaultValue columnName=DIGITS, tableName=CREDENTIAL; dropDefaultValue columnName=PERIOD, tableName=CREDENTIAL; dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; dropColumn ...              \N      4.33.0  \N      \N     1046405406
8.0.0-resource-tag-support      keycloak        META-INF/jpa-changelog-8.0.0.xml        2026-06-09 23:06:58.732751     76       EXECUTED        9:91fa186ce7a5af127a2d7a91ee083cc5      addColumn tableName=MIGRATION_MODEL; createIndex indexName=IDX_UPDATE_TIME, tableName=MIGRATION_MODEL           \N      4.33.0  \N      \N      1046405406
9.0.0-always-display-client     keycloak        META-INF/jpa-changelog-9.0.0.xml        2026-06-09 23:06:58.748796     77       EXECUTED        9:6335e5c94e83a2639ccd68dd24e2e5ad      addColumn tableName=CLIENT              \N      4.33.0 \N       \N      1046405406
9.0.0-drop-constraints-for-column-increase      keycloak        META-INF/jpa-changelog-9.0.0.xml        2026-06-09 23:06:58.754289      78      MARK_RAN        9:6bdb5658951e028bfe16fa0a8228b530      dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5PMT, tableName=RESOURCE_SERVER_PERM_TICKET; dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER_RESOURCE; dropPrimaryKey constraintName=CONSTRAINT_O...              \N      4.33.0 \N       \N      1046405406
9.0.0-increase-column-size-federated-fk keycloak        META-INF/jpa-changelog-9.0.0.xml        2026-06-09 23:06:58.797437      79      EXECUTED        9:d5bc15a64117ccad481ce8792d4c608f      modifyDataType columnName=CLIENT_ID, tableName=FED_USER_CONSENT; modifyDataType columnName=CLIENT_REALM_CONSTRAINT, tableName=KEYCLOAK_ROLE; modifyDataType columnName=OWNER, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=CLIENT_ID, ta...              \N      4.33.0  \N     \N       1046405406
9.0.0-recreate-constraints-after-column-increase        keycloak        META-INF/jpa-changelog-9.0.0.xml        2026-06-09 23:06:58.807294      80      MARK_RAN        9:077cba51999515f4d3e7ad5619ab592c      addNotNullConstraint columnName=CLIENT_ID, tableName=OFFLINE_CLIENT_SESSION; addNotNullConstraint columnName=OWNER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNullConstraint columnName=REQUESTER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNull...              \N     4.33.0   \N      \N      1046405406
9.0.1-add-index-to-client.client_id     keycloak        META-INF/jpa-changelog-9.0.1.xml        2026-06-09 23:06:58.882138      81      EXECUTED        9:be969f08a163bf47c6b9e9ead8ac2afb      createIndex indexName=IDX_CLIENT_ID, tableName=CLIENT           \N      4.33.0  \N      \N      1046405406
9.0.1-KEYCLOAK-12579-drop-constraints   keycloak        META-INF/jpa-changelog-9.0.1.xml        2026-06-09 23:06:58.885629      82      MARK_RAN        9:6d3bb4408ba5a72f39bd8a0b301ec6e3      dropUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP             \N      4.33.0  \N      \N      1046405406
9.0.1-KEYCLOAK-12579-add-not-null-constraint    keycloak        META-INF/jpa-changelog-9.0.1.xml        2026-06-09 23:06:58.898162      83      EXECUTED        9:966bda61e46bebf3cc39518fbed52fa7      addNotNullConstraint columnName=PARENT_GROUP, tableName=KEYCLOAK_GROUP          \N      4.33.0  \N      \N      1046405406
9.0.1-KEYCLOAK-12579-recreate-constraints       keycloak        META-INF/jpa-changelog-9.0.1.xml        2026-06-09 23:06:58.902983      84      MARK_RAN        9:8dcac7bdf7378e7d823cdfddebf72fda      addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP              \N      4.33.0  \N      \N      1046405406
9.0.1-add-index-to-events       keycloak        META-INF/jpa-changelog-9.0.1.xml        2026-06-09 23:06:58.993423     85       EXECUTED        9:7d93d602352a30c0c317e6a609b56599      createIndex indexName=IDX_EVENT_TIME, tableName=EVENT_ENTITY            \N      4.33.0  \N      \N      1046405406
map-remove-ri   keycloak        META-INF/jpa-changelog-11.0.0.xml       2026-06-09 23:06:59.008882      86      EXECUTED9:71c5969e6cdd8d7b6f47cebc86d37627      dropForeignKeyConstraint baseTableName=REALM, constraintName=FK_TRAF444KK6QRKMS7N56AIWQ5Y; dropForeignKeyConstraint baseTableName=KEYCLOAK_ROLE, constraintName=FK_KJHO5LE2C0RAL09FL8CM9WFW9           \N       4.33.0  \N      \N      1046405406
map-remove-ri   keycloak        META-INF/jpa-changelog-12.0.0.xml       2026-06-09 23:06:59.029639      87      EXECUTED9:a9ba7d47f065f041b7da856a81762021      dropForeignKeyConstraint baseTableName=REALM_DEFAULT_GROUPS, constraintName=FK_DEF_GROUPS_GROUP; dropForeignKeyConstraint baseTableName=REALM_DEFAULT_ROLES, constraintName=FK_H4WPD7W4HSOOLNI3H0SW7BTJE; dropForeignKeyConstraint baseTableName=CLIENT...              \N      4.33.0  \N      \N      1046405406
12.1.0-add-realm-localization-table     keycloak        META-INF/jpa-changelog-12.0.0.xml       2026-06-09 23:06:59.045188      EXECUTED        9:fffabce2bc01e1a8f5110d5278500065      createTable tableName=REALM_LOCALIZATIONS; addPrimaryKey tableName=REALM_LOCALIZATIONS          \N      4.33.0  \N      \N      1046405406
default-roles   keycloak        META-INF/jpa-changelog-13.0.0.xml       2026-06-09 23:06:59.057477      89      EXECUTED9:fa8a5b5445e3857f4b010bafb5009957      addColumn tableName=REALM; customChange         \N      4.33.0  \N      \N     1046405406
default-roles-cleanup   keycloak        META-INF/jpa-changelog-13.0.0.xml       2026-06-09 23:06:59.074608      90     EXECUTED 9:67ac3241df9a8582d591c5ed87125f39      dropTable tableName=REALM_DEFAULT_ROLES; dropTable tableName=CLIENT_DEFAULT_ROLES               \N      4.33.0  \N      \N      1046405406
13.0.0-KEYCLOAK-16844   keycloak        META-INF/jpa-changelog-13.0.0.xml       2026-06-09 23:06:59.134529      91     EXECUTED 9:ad1194d66c937e3ffc82386c050ba089      createIndex indexName=IDX_OFFLINE_USS_PRELOAD, tableName=OFFLINE_USER_SESSION           \N      4.33.0  \N      \N      1046405406
map-remove-ri-13.0.0    keycloak        META-INF/jpa-changelog-13.0.0.xml       2026-06-09 23:06:59.151878      92     EXECUTED 9:d9be619d94af5a2f5d07b9f003543b91      dropForeignKeyConstraint baseTableName=DEFAULT_CLIENT_SCOPE, constraintName=FK_R_DEF_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SCOPE_CLIENT, constraintName=FK_C_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SC...              \N      4.33.0  \N      \N      1046405406
13.0.0-KEYCLOAK-17992-drop-constraints  keycloak        META-INF/jpa-changelog-13.0.0.xml       2026-06-09 23:06:59.154614      93      MARK_RAN        9:544d201116a0fcc5a5da0925fbbc3bde      dropPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CLSCOPE_CL, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CL_CLSCOPE, tableName=CLIENT_SCOPE_CLIENT             \N      4.33.0  \N      \N      1046405406
13.0.0-increase-column-size-federated   keycloak        META-INF/jpa-changelog-13.0.0.xml       2026-06-09 23:06:59.169384      94      EXECUTED        9:43c0c1055b6761b4b3e89de76d612ccf      modifyDataType columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; modifyDataType columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT           \N      4.33.0  \N     \N       1046405406
13.0.0-KEYCLOAK-17992-recreate-constraints      keycloak        META-INF/jpa-changelog-13.0.0.xml       2026-06-09 23:06:59.172183      95      MARK_RAN        9:8bd711fd0330f4fe980494ca43ab1139      addNotNullConstraint columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; addNotNullConstraint columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT; addPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; createIndex indexName=...              \N      4.33.0 \N       \N      1046405406
json-string-accomodation-fixed  keycloak        META-INF/jpa-changelog-13.0.0.xml       2026-06-09 23:06:59.183911     96       EXECUTED        9:e07d2bc0970c348bb06fb63b1f82ddbf      addColumn tableName=REALM_ATTRIBUTE; update tableName=REALM_ATTRIBUTE; dropColumn columnName=VALUE, tableName=REALM_ATTRIBUTE; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=REALM_ATTRIBUTE             \N      4.33.0  \N      \N      1046405406
14.0.0-KEYCLOAK-11019   keycloak        META-INF/jpa-changelog-14.0.0.xml       2026-06-09 23:06:59.357356      97     EXECUTED 9:24fb8611e97f29989bea412aa38d12b7      createIndex indexName=IDX_OFFLINE_CSS_PRELOAD, tableName=OFFLINE_CLIENT_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USER, tableName=OFFLINE_USER_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USERSESS, tableName=OFFLINE_USER_SESSION               \N      4.33.0  \N      \N      1046405406
14.0.0-KEYCLOAK-18286   keycloak        META-INF/jpa-changelog-14.0.0.xml       2026-06-09 23:06:59.36401       98     MARK_RAN 9:259f89014ce2506ee84740cbf7163aa7      createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES         \N      4.33.0  \N      \N      1046405406
14.0.0-KEYCLOAK-18286-revert    keycloak        META-INF/jpa-changelog-14.0.0.xml       2026-06-09 23:06:59.384615     99       MARK_RAN        9:04baaf56c116ed19951cbc2cca584022      dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES           \N      4.33.0  \N      \N      1046405406
14.0.0-KEYCLOAK-18286-supported-dbs     keycloak        META-INF/jpa-changelog-14.0.0.xml       2026-06-09 23:06:59.448546      100     EXECUTED        9:60ca84a0f8c94ec8c3504a5a3bc88ee8      createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES         \N      4.33.0  \N      \N      1046405406
14.0.0-KEYCLOAK-18286-unsupported-dbs   keycloak        META-INF/jpa-changelog-14.0.0.xml       2026-06-09 23:06:59.452592      101     MARK_RAN        9:d3d977031d431db16e2c181ce49d73e9      createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES         \N      4.33.0  \N      \N      1046405406
KEYCLOAK-17267-add-index-to-user-attributes     keycloak        META-INF/jpa-changelog-14.0.0.xml       2026-06-09 23:06:59.515684      102     EXECUTED        9:0b305d8d1277f3a89a0a53a659ad274c      createIndex indexName=IDX_USER_ATTRIBUTE_NAME, tableName=USER_ATTRIBUTE         \N      4.33.0  \N      \N      1046405406
KEYCLOAK-18146-add-saml-art-binding-identifier  keycloak        META-INF/jpa-changelog-14.0.0.xml       2026-06-09 23:06:59.523699      103     EXECUTED        9:2c374ad2cdfe20e2905a84c8fac48460      customChange            \N      4.33.0 \N       \N      1046405406
15.0.0-KEYCLOAK-18467   keycloak        META-INF/jpa-changelog-15.0.0.xml       2026-06-09 23:06:59.535468      104    EXECUTED 9:47a760639ac597360a8219f5b768b4de      addColumn tableName=REALM_LOCALIZATIONS; update tableName=REALM_LOCALIZATIONS; dropColumn columnName=TEXTS, tableName=REALM_LOCALIZATIONS; renameColumn newColumnName=TEXTS, oldColumnName=TEXTS_NEW, tableName=REALM_LOCALIZATIONS; addNotNullConstrai...              \N      4.33.0  \N      \N      1046405406
17.0.0-9562     keycloak        META-INF/jpa-changelog-17.0.0.xml       2026-06-09 23:06:59.596254      105     EXECUTED9:a6272f0576727dd8cad2522335f5d99e      createIndex indexName=IDX_USER_SERVICE_ACCOUNT, tableName=USER_ENTITY          \N       4.33.0  \N      \N      1046405406
18.0.0-10625-IDX_ADMIN_EVENT_TIME       keycloak        META-INF/jpa-changelog-18.0.0.xml       2026-06-09 23:06:59.651361      106     EXECUTED        9:015479dbd691d9cc8669282f4828c41d      createIndex indexName=IDX_ADMIN_EVENT_TIME, tableName=ADMIN_EVENT_ENTITY                \N      4.33.0  \N      \N      1046405406
18.0.15-30992-index-consent     keycloak        META-INF/jpa-changelog-18.0.15.xml      2026-06-09 23:06:59.728065     107      EXECUTED        9:80071ede7a05604b1f4906f3bf3b00f0      createIndex indexName=IDX_USCONSENT_SCOPE_ID, tableName=USER_CONSENT_CLIENT_SCOPE               \N      4.33.0  \N      \N      1046405406
19.0.0-10135    keycloak        META-INF/jpa-changelog-19.0.0.xml       2026-06-09 23:06:59.738684      108     EXECUTED9:9518e495fdd22f78ad6425cc30630221      customChange            \N      4.33.0  \N      \N      1046405406
20.0.0-12964-supported-dbs      keycloak        META-INF/jpa-changelog-20.0.0.xml       2026-06-09 23:06:59.802267     109      EXECUTED        9:e5f243877199fd96bcc842f27a1656ac      createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE            \N      4.33.0  \N      \N      1046405406
20.0.0-12964-supported-dbs-edb-migration        keycloak        META-INF/jpa-changelog-20.0.0.xml       2026-06-09 23:06:59.899282      110     EXECUTED        9:a6b18a8e38062df5793edbe064f4aecd      dropIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE; createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE
\N      4.33.0  \N      \N      1046405406
20.0.0-12964-unsupported-dbs    keycloak        META-INF/jpa-changelog-20.0.0.xml       2026-06-09 23:06:59.90323      111      MARK_RAN        9:1a6fcaa85e20bdeae0a9ce49b41946a5      createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE            \N      4.33.0  \N      \N      1046405406
client-attributes-string-accomodation-fixed-pre-drop-index      keycloak        META-INF/jpa-changelog-20.0.0.xml      2026-06-09 23:06:59.912071       112     EXECUTED        9:04baaf56c116ed19951cbc2cca584022      dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES           \N      4.33.0  \N      \N      1046405406
client-attributes-string-accomodation-fixed     keycloak        META-INF/jpa-changelog-20.0.0.xml       2026-06-09 23:06:59.924193      113     EXECUTED        9:3f332e13e90739ed0c35b0b25b7822ca      addColumn tableName=CLIENT_ATTRIBUTES; update tableName=CLIENT_ATTRIBUTES; dropColumn columnName=VALUE, tableName=CLIENT_ATTRIBUTES; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=CLIENT_ATTRIBUTES             \N      4.33.0  \N      \N      1046405406
client-attributes-string-accomodation-fixed-post-create-index   keycloak        META-INF/jpa-changelog-20.0.0.xml      2026-06-09 23:06:59.926653       114     MARK_RAN        9:bd2bd0fc7768cf0845ac96a8786fa735      createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES         \N      4.33.0  \N      \N      1046405406
21.0.2-17277    keycloak        META-INF/jpa-changelog-21.0.2.xml       2026-06-09 23:06:59.935937      115     EXECUTED9:7ee1f7a3fb8f5588f171fb9a6ab623c0      customChange            \N      4.33.0  \N      \N      1046405406
21.1.0-19404    keycloak        META-INF/jpa-changelog-21.1.0.xml       2026-06-09 23:06:59.977335      116     EXECUTED9:3d7e830b52f33676b9d64f7f2b2ea634      modifyDataType columnName=DECISION_STRATEGY, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=LOGIC, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=POLICY_ENFORCE_MODE, tableName=RESOURCE_SERVER              \N      4.33.0  \N      \N      1046405406
21.1.0-19404-2  keycloak        META-INF/jpa-changelog-21.1.0.xml       2026-06-09 23:06:59.981979      117     MARK_RAN9:627d032e3ef2c06c0e1f73d2ae25c26c      addColumn tableName=RESOURCE_SERVER_POLICY; update tableName=RESOURCE_SERVER_POLICY; dropColumn columnName=DECISION_STRATEGY, tableName=RESOURCE_SERVER_POLICY; renameColumn newColumnName=DECISION_STRATEGY, oldColumnName=DECISION_STRATEGY_NEW, tabl...              \N      4.33.0  \N      \N      1046405406
22.0.0-17484-updated    keycloak        META-INF/jpa-changelog-22.0.0.xml       2026-06-09 23:06:59.991726      118    EXECUTED 9:90af0bfd30cafc17b9f4d6eccd92b8b3      customChange            \N      4.33.0  \N      \N      1046405406
23.0.0-12062    keycloak        META-INF/jpa-changelog-23.0.0.xml       2026-06-09 23:07:00.005858      120     EXECUTED9:2168fbe728fec46ae9baf15bf80927b8      addColumn tableName=COMPONENT_CONFIG; update tableName=COMPONENT_CONFIG; dropColumn columnName=VALUE, tableName=COMPONENT_CONFIG; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=COMPONENT_CONFIG         \N      4.33.0  \N      \N      1046405406
23.0.0-17258    keycloak        META-INF/jpa-changelog-23.0.0.xml       2026-06-09 23:07:00.011919      121     EXECUTED9:36506d679a83bbfda85a27ea1864dca8      addColumn tableName=EVENT_ENTITY                \N      4.33.0  \N      \N     1046405406
24.0.0-9758     keycloak        META-INF/jpa-changelog-24.0.0.xml       2026-06-09 23:07:00.257714      122     EXECUTED9:502c557a5189f600f0f445a9b49ebbce      addColumn tableName=USER_ATTRIBUTE; addColumn tableName=FED_USER_ATTRIBUTE; createIndex indexName=USER_ATTR_LONG_VALUES, tableName=USER_ATTRIBUTE; createIndex indexName=FED_USER_ATTR_LONG_VALUES, tableName=FED_USER_ATTRIBUTE; createIndex indexName...              \N      4.33.0  \N      \N      1046405406
24.0.0-9758-2   keycloak        META-INF/jpa-changelog-24.0.0.xml       2026-06-09 23:07:00.267251      123     EXECUTED9:bf0fdee10afdf597a987adbf291db7b2      customChange            \N      4.33.0  \N      \N      1046405406
24.0.0-26618-drop-index-if-present      keycloak        META-INF/jpa-changelog-24.0.0.xml       2026-06-09 23:07:00.277105      124     MARK_RAN        9:04baaf56c116ed19951cbc2cca584022      dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES           \N      4.33.0  \N      \N      1046405406
24.0.0-26618-reindex    keycloak        META-INF/jpa-changelog-24.0.0.xml       2026-06-09 23:07:00.364666      125    EXECUTED 9:08707c0f0db1cef6b352db03a60edc7f      createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES         \N      4.33.0  \N      \N      1046405406
24.0.0-26618-edb-migration      keycloak        META-INF/jpa-changelog-24.0.0.xml       2026-06-09 23:07:00.441533     126      EXECUTED        9:2f684b29d414cd47efe3a3599f390741      dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES; createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES          \N     4.33.0   \N      \N      1046405406
24.0.2-27228    keycloak        META-INF/jpa-changelog-24.0.2.xml       2026-06-09 23:07:00.449626      127     EXECUTED9:eaee11f6b8aa25d2cc6a84fb86fc6238      customChange            \N      4.33.0  \N      \N      1046405406
24.0.2-27967-drop-index-if-present      keycloak        META-INF/jpa-changelog-24.0.2.xml       2026-06-09 23:07:00.453143      128     MARK_RAN        9:04baaf56c116ed19951cbc2cca584022      dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES           \N      4.33.0  \N      \N      1046405406
24.0.2-27967-reindex    keycloak        META-INF/jpa-changelog-24.0.2.xml       2026-06-09 23:07:00.45711       129    MARK_RAN 9:d3d977031d431db16e2c181ce49d73e9      createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES         \N      4.33.0  \N      \N      1046405406
25.0.0-28265-tables     keycloak        META-INF/jpa-changelog-25.0.0.xml       2026-06-09 23:07:00.468521      130    EXECUTED 9:deda2df035df23388af95bbd36c17cef      addColumn tableName=OFFLINE_USER_SESSION; addColumn tableName=OFFLINE_CLIENT_SESSION            \N      4.33.0  \N      \N      1046405406
25.0.0-28265-index-creation     keycloak        META-INF/jpa-changelog-25.0.0.xml       2026-06-09 23:07:00.526084     131      EXECUTED        9:3e96709818458ae49f3c679ae58d263a      createIndex indexName=IDX_OFFLINE_USS_BY_LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION           \N      4.33.0  \N      \N      1046405406
25.0.0-28265-index-cleanup-uss-createdon        keycloak        META-INF/jpa-changelog-25.0.0.xml       2026-06-09 23:07:00.539159      132     EXECUTED        9:78ab4fc129ed5e8265dbcc3485fba92f      dropIndex indexName=IDX_OFFLINE_USS_CREATEDON, tableName=OFFLINE_USER_SESSION           \N      4.33.0  \N      \N      1046405406
25.0.0-28265-index-cleanup-uss-preload  keycloak        META-INF/jpa-changelog-25.0.0.xml       2026-06-09 23:07:00.553633      133     EXECUTED        9:de5f7c1f7e10994ed8b62e621d20eaab      dropIndex indexName=IDX_OFFLINE_USS_PRELOAD, tableName=OFFLINE_USER_SESSION             \N      4.33.0  \N      \N      1046405406
25.0.0-28265-index-cleanup-uss-by-usersess      keycloak        META-INF/jpa-changelog-25.0.0.xml       2026-06-09 23:07:00.567627      134     EXECUTED        9:6eee220d024e38e89c799417ec33667f      dropIndex indexName=IDX_OFFLINE_USS_BY_USERSESS, tableName=OFFLINE_USER_SESSION         \N      4.33.0  \N      \N      1046405406
25.0.0-28265-index-cleanup-css-preload  keycloak        META-INF/jpa-changelog-25.0.0.xml       2026-06-09 23:07:00.580864      135     EXECUTED        9:5411d2fb2891d3e8d63ddb55dfa3c0c9      dropIndex indexName=IDX_OFFLINE_CSS_PRELOAD, tableName=OFFLINE_CLIENT_SESSION           \N      4.33.0  \N      \N      1046405406
25.0.0-28265-index-2-mysql      keycloak        META-INF/jpa-changelog-25.0.0.xml       2026-06-09 23:07:00.583461     136      MARK_RAN        9:b7ef76036d3126bb83c2423bf4d449d6      createIndex indexName=IDX_OFFLINE_USS_BY_BROKER_SESSION_ID, tableName=OFFLINE_USER_SESSION              \N      4.33.0  \N      \N      1046405406
25.0.0-28265-index-2-not-mysql  keycloak        META-INF/jpa-changelog-25.0.0.xml       2026-06-09 23:07:00.63788      137      EXECUTED        9:23396cf51ab8bc1ae6f0cac7f9f6fcf7      createIndex indexName=IDX_OFFLINE_USS_BY_BROKER_SESSION_ID, tableName=OFFLINE_USER_SESSION              \N      4.33.0  \N      \N      1046405406
25.0.0-org      keycloak        META-INF/jpa-changelog-25.0.0.xml       2026-06-09 23:07:00.666068      138     EXECUTED9:5c859965c2c9b9c72136c360649af157      createTable tableName=ORG; addUniqueConstraint constraintName=UK_ORG_NAME, tableName=ORG; addUniqueConstraint constraintName=UK_ORG_GROUP, tableName=ORG; createTable tableName=ORG_DOMAIN             \N       4.33.0  \N      \N      1046405406
unique-consentuser      keycloak        META-INF/jpa-changelog-25.0.0.xml       2026-06-09 23:07:00.684874      139    EXECUTED 9:5857626a2ea8767e9a6c66bf3a2cb32f      customChange; dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_LOCAL_CONSENT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_EXTERNAL_CONSENT, tableName=...              \N      4.33.0  \N      \N      1046405406
unique-consentuser-edb-migration        keycloak        META-INF/jpa-changelog-25.0.0.xml       2026-06-09 23:07:00.695666      140     MARK_RAN        9:5857626a2ea8767e9a6c66bf3a2cb32f      customChange; dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_LOCAL_CONSENT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_EXTERNAL_CONSENT, tableName=...              \N      4.33.0  \N     \N       1046405406
unique-consentuser-mysql        keycloak        META-INF/jpa-changelog-25.0.0.xml       2026-06-09 23:07:00.699487     141      MARK_RAN        9:b79478aad5adaa1bc428e31563f55e8e      customChange; dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_LOCAL_CONSENT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_EXTERNAL_CONSENT, tableName=...              \N      4.33.0  \N      \N     1046405406
25.0.0-28861-index-creation     keycloak        META-INF/jpa-changelog-25.0.0.xml       2026-06-09 23:07:00.812522     142      EXECUTED        9:b9acb58ac958d9ada0fe12a5d4794ab1      createIndex indexName=IDX_PERM_TICKET_REQUESTER, tableName=RESOURCE_SERVER_PERM_TICKET; createIndex indexName=IDX_PERM_TICKET_OWNER, tableName=RESOURCE_SERVER_PERM_TICKET
\N      4.33.0  \N      \N      1046405406
26.0.0-org-alias        keycloak        META-INF/jpa-changelog-26.0.0.xml       2026-06-09 23:07:00.825772      143    EXECUTED 9:6ef7d63e4412b3c2d66ed179159886a4      addColumn tableName=ORG; update tableName=ORG; addNotNullConstraint columnName=ALIAS, tableName=ORG; addUniqueConstraint constraintName=UK_ORG_ALIAS, tableName=ORG             \N      4.33.0 \N       \N      1046405406
26.0.0-org-group        keycloak        META-INF/jpa-changelog-26.0.0.xml       2026-06-09 23:07:00.838313      144    EXECUTED 9:da8e8087d80ef2ace4f89d8c5b9ca223      addColumn tableName=KEYCLOAK_GROUP; update tableName=KEYCLOAK_GROUP; addNotNullConstraint columnName=TYPE, tableName=KEYCLOAK_GROUP; customChange               \N      4.33.0  \N      \N     1046405406
26.0.0-org-indexes      keycloak        META-INF/jpa-changelog-26.0.0.xml       2026-06-09 23:07:00.892298      145    EXECUTED 9:79b05dcd610a8c7f25ec05135eec0857      createIndex indexName=IDX_ORG_DOMAIN_ORG_ID, tableName=ORG_DOMAIN
\N      4.33.0  \N      \N      1046405406
26.0.0-org-group-membership     keycloak        META-INF/jpa-changelog-26.0.0.xml       2026-06-09 23:07:00.901533     146      EXECUTED        9:a6ace2ce583a421d89b01ba2a28dc2d4      addColumn tableName=USER_GROUP_MEMBERSHIP; update tableName=USER_GROUP_MEMBERSHIP; addNotNullConstraint columnName=MEMBERSHIP_TYPE, tableName=USER_GROUP_MEMBERSHIP            \N       4.33.0  \N      \N      1046405406
31296-persist-revoked-access-tokens     keycloak        META-INF/jpa-changelog-26.0.0.xml       2026-06-09 23:07:00.911535      147     EXECUTED        9:64ef94489d42a358e8304b0e245f0ed4      createTable tableName=REVOKED_TOKEN; addPrimaryKey constraintName=CONSTRAINT_RT, tableName=REVOKED_TOKEN                \N      4.33.0  \N      \N      1046405406
31725-index-persist-revoked-access-tokens       keycloak        META-INF/jpa-changelog-26.0.0.xml       2026-06-09 23:07:00.966521      148     EXECUTED        9:b994246ec2bf7c94da881e1d28782c7b      createIndex indexName=IDX_REV_TOKEN_ON_EXPIRE, tableName=REVOKED_TOKEN          \N      4.33.0  \N      \N      1046405406
26.0.0-idps-for-login   keycloak        META-INF/jpa-changelog-26.0.0.xml       2026-06-09 23:07:01.082247      149    EXECUTED 9:51f5fffadf986983d4bd59582c6c1604      addColumn tableName=IDENTITY_PROVIDER; createIndex indexName=IDX_IDP_REALM_ORG, tableName=IDENTITY_PROVIDER; createIndex indexName=IDX_IDP_FOR_LOGIN, tableName=IDENTITY_PROVIDER; customChange
        \N      4.33.0  \N      \N      1046405406
26.0.0-32583-drop-redundant-index-on-client-session     keycloak        META-INF/jpa-changelog-26.0.0.xml       2026-06-09 23:07:01.093918      150     EXECUTED        9:24972d83bf27317a055d234187bb4af9      dropIndex indexName=IDX_US_SESS_ID_ON_CL_SESS, tableName=OFFLINE_CLIENT_SESSION         \N      4.33.0  \N      \N      1046405406
26.0.0.32582-remove-tables-user-session-user-session-note-and-client-session    keycloak        META-INF/jpa-changelog-26.0.0.xml       2026-06-09 23:07:01.135529      151     EXECUTED        9:febdc0f47f2ed241c59e60f58c3ceea5      dropTable tableName=CLIENT_SESSION_ROLE; dropTable tableName=CLIENT_SESSION_NOTE; dropTable tableName=CLIENT_SESSION_PROT_MAPPER; dropTable tableName=CLIENT_SESSION_AUTH_STATUS; dropTable tableName=CLIENT_USER_SESSION_NOTE; dropTable tableName=CLI...              \N      4.33.0  \N      \N      1046405406
26.0.0-33201-org-redirect-url   keycloak        META-INF/jpa-changelog-26.0.0.xml       2026-06-09 23:07:01.14291      152      EXECUTED        9:4d0e22b0ac68ebe9794fa9cb752ea660      addColumn tableName=ORG         \N      4.33.0  \N     \N       1046405406
29399-jdbc-ping-default keycloak        META-INF/jpa-changelog-26.1.0.xml       2026-06-09 23:07:01.1563        153    EXECUTED 9:007dbe99d7203fca403b89d4edfdf21e      createTable tableName=JGROUPS_PING; addPrimaryKey constraintName=CONSTRAINT_JGROUPS_PING, tableName=JGROUPS_PING                \N      4.33.0  \N      \N      1046405406
26.1.0-34013    keycloak        META-INF/jpa-changelog-26.1.0.xml       2026-06-09 23:07:01.164298      154     EXECUTED9:e6b686a15759aef99a6d758a5c4c6a26      addColumn tableName=ADMIN_EVENT_ENTITY          \N      4.33.0  \N      \N     1046405406
26.1.0-34380    keycloak        META-INF/jpa-changelog-26.1.0.xml       2026-06-09 23:07:01.173687      155     EXECUTED9:ac8b9edb7c2b6c17a1c7a11fcf5ccf01      dropTable tableName=USERNAME_LOGIN_FAILURE              \N      4.33.0  \N     \N       1046405406
26.2.0-36750    keycloak        META-INF/jpa-changelog-26.2.0.xml       2026-06-09 23:07:01.184874      156     EXECUTED9:b49ce951c22f7eb16480ff085640a33a      createTable tableName=SERVER_CONFIG             \N      4.33.0  \N      \N     1046405406
26.2.0-26106    keycloak        META-INF/jpa-changelog-26.2.0.xml       2026-06-09 23:07:01.190771      157     EXECUTED9:b5877d5dab7d10ff3a9d209d7beb6680      addColumn tableName=CREDENTIAL          \N      4.33.0  \N      \N      1046405406
26.2.6-39866-duplicate  keycloak        META-INF/jpa-changelog-26.2.6.xml       2026-06-09 23:07:01.198122      158    EXECUTED 9:1dc67ccee24f30331db2cba4f372e40e      customChange            \N      4.33.0  \N      \N      1046405406
26.2.6-39866-uk keycloak        META-INF/jpa-changelog-26.2.6.xml       2026-06-09 23:07:01.205721      159     EXECUTED9:b70b76f47210cf0a5f4ef0e219eac7cd      addUniqueConstraint constraintName=UK_MIGRATION_VERSION, tableName=MIGRATION_MODEL              \N      4.33.0  \N      \N      1046405406
26.2.6-40088-duplicate  keycloak        META-INF/jpa-changelog-26.2.6.xml       2026-06-09 23:07:01.212301      160    EXECUTED 9:cc7e02ed69ab31979afb1982f9670e8f      customChange            \N      4.33.0  \N      \N      1046405406
26.2.6-40088-uk keycloak        META-INF/jpa-changelog-26.2.6.xml       2026-06-09 23:07:01.219398      161     EXECUTED9:5bb848128da7bc4595cc507383325241      addUniqueConstraint constraintName=UK_MIGRATION_UPDATE_TIME, tableName=MIGRATION_MODEL          \N      4.33.0  \N      \N      1046405406
26.3.0-groups-description       keycloak        META-INF/jpa-changelog-26.3.0.xml       2026-06-09 23:07:01.227438     162      EXECUTED        9:e1a3c05574326fb5b246b73b9a4c4d49      addColumn tableName=KEYCLOAK_GROUP              \N     4.33.0   \N      \N      1046405406
26.4.0-40933-saml-encryption-attributes keycloak        META-INF/jpa-changelog-26.4.0.xml       2026-06-09 23:07:01.234888      163     EXECUTED        9:7e9eaba362ca105efdda202303a4fe49      customChange            \N      4.33.0  \N     \N       1046405406
26.4.0-51321    keycloak        META-INF/jpa-changelog-26.4.0.xml       2026-06-09 23:07:01.286688      164     EXECUTED9:34bab2bc56f75ffd7e347c580874e306      createIndex indexName=IDX_EVENT_ENTITY_USER_ID_TYPE, tableName=EVENT_ENTITY
\N      4.33.0  \N      \N      1046405406
40343-workflow-state-table      keycloak        META-INF/jpa-changelog-26.4.0.xml       2026-06-09 23:07:01.402571     165      EXECUTED        9:ed3ab4723ceed210e5b5e60ac4562106      createTable tableName=WORKFLOW_STATE; addPrimaryKey constraintName=PK_WORKFLOW_STATE, tableName=WORKFLOW_STATE; addUniqueConstraint constraintName=UQ_WORKFLOW_RESOURCE, tableName=WORKFLOW_STATE; createIndex indexName=IDX_WORKFLOW_STATE_STEP, table...              \N      4.33.0  \N      \N     1046405406
26.5.0-index-offline-css-by-client      keycloak        META-INF/jpa-changelog-26.5.0.xml       2026-06-09 23:07:01.468363      166     EXECUTED        9:383e981ce95d16e32af757b7998820f7      createIndex indexName=IDX_OFFLINE_CSS_BY_CLIENT, tableName=OFFLINE_CLIENT_SESSION               \N      4.33.0  \N      \N      1046405406
26.5.0-index-offline-css-by-client-storage-provider     keycloak        META-INF/jpa-changelog-26.5.0.xml       2026-06-09 23:07:01.552945      167     EXECUTED        9:f5bc200e6fa7d7e483854dee535ca425      createIndex indexName=IDX_OFFLINE_CSS_BY_CLIENT_STORAGE_PROVIDER, tableName=OFFLINE_CLIENT_SESSION              \N      4.33.0  \N      \N      1046405406
26.5.0-idp-config-allow-null-fixed-drop-mssql-index     keycloak        META-INF/jpa-changelog-26.5.0.xml       2026-06-09 23:07:01.555239      168     MARK_RAN        9:50c51d2c98cd1d624eb1c485c3cf1f75      dropIndex indexName=IDX_IDP_FOR_LOGIN, tableName=IDENTITY_PROVIDER              \N      4.33.0  \N      \N      1046405406
26.5.0-idp-config-allow-null    keycloak        META-INF/jpa-changelog-26.5.0.xml       2026-06-09 23:07:01.580597     169      EXECUTED        9:b667fb087874303b324c1af7fae4f606      dropDefaultValue columnName=TRUST_EMAIL, tableName=IDENTITY_PROVIDER; dropNotNullConstraint columnName=TRUST_EMAIL, tableName=IDENTITY_PROVIDER; dropNotNullConstraint columnName=STORE_TOKEN, tableName=IDENTITY_PROVIDER; dropDefaultValue columnName...              \N      4.33.0  \N      \N     1046405406
26.5.0-idp-config-allow-null-fixed-create-mssql-index   keycloak        META-INF/jpa-changelog-26.5.0.xml       2026-06-09 23:07:01.583404      170     MARK_RAN        9:dcbbb24c151c3b0b59f12fede23cc94d      createIndex indexName=IDX_IDP_FOR_LOGIN, tableName=IDENTITY_PROVIDER            \N      4.33.0  \N      \N      1046405406
26.5.0-remove-workflow-provider-id-column       keycloak        META-INF/jpa-changelog-26.5.0.xml       2026-06-09 23:07:01.653367      171     EXECUTED        9:d8eeb324484d45e946d03b953e168b21      dropIndex indexName=IDX_WORKFLOW_STATE_PROVIDER, tableName=WORKFLOW_STATE; createIndex indexName=IDX_WORKFLOW_STATE_PROVIDER, tableName=WORKFLOW_STATE; dropColumn columnName=WORKFLOW_PROVIDER_ID, tableName=WORKFLOW_STATE            \N      4.33.0  \N      \N      1046405406
26.5.0-add-remember-me  keycloak        META-INF/jpa-changelog-26.5.0.xml       2026-06-09 23:07:01.663009      172    EXECUTED 9:a7273ea8b21bd2f674c9c49141999f05      addColumn tableName=OFFLINE_USER_SESSION                \N      4.33.0 \N       \N      1046405406
26.5.0-add-sess-refresh-idx     keycloak        META-INF/jpa-changelog-26.5.0.xml       2026-06-09 23:07:01.728992     173      EXECUTED        9:ce49383d317ccbcd3434d1f21172b0b7      createIndex indexName=IDX_USER_SESSION_EXPIRATION_CREATED, tableName=OFFLINE_USER_SESSION               \N      4.33.0  \N      \N      1046405406
26.5.0-add-sess-create-idx      keycloak        META-INF/jpa-changelog-26.5.0.xml       2026-06-09 23:07:01.790373     174      EXECUTED        9:aaee09e23a4d8468fbc5c51b7b314c58      createIndex indexName=IDX_USER_SESSION_EXPIRATION_LAST_REFRESH, tableName=OFFLINE_USER_SESSION          \N      4.33.0  \N      \N      1046405406
26.5.0-drop-sess-refresh-idx    keycloak        META-INF/jpa-changelog-26.5.0.xml       2026-06-09 23:07:01.802081     175      EXECUTED        9:f0082210b6ccbbaf81287c27aa23753c      dropIndex indexName=IDX_OFFLINE_USS_BY_LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION             \N      4.33.0  \N      \N      1046405406
26.5.0-mysql-mariadb-default-charset-collation  keycloak        META-INF/jpa-changelog-26.5.0.xml       2026-06-09 23:07:01.80453       176     MARK_RAN        9:1b383fa60d2db0a8952b365e725f9d16      customChange            \N      4.33.0 \N       \N      1046405406
26.5.0-invitations-table-fixed2 keycloak        META-INF/jpa-changelog-26.5.0.xml       2026-06-09 23:07:01.994842     177      EXECUTED        9:322cb11fc03181903dcd67a54f8b3cf0      createTable tableName=ORG_INVITATION; addForeignKeyConstraint baseTableName=ORG_INVITATION, constraintName=FK_ORG_INVITATION_ORG, referencedTableName=ORG; createIndex indexName=IDX_ORG_INVITATION_ORG_ID, tableName=ORG_INVITATION; createIndex index...              \N      4.33.0  \N      \N     1046405406
26.6.0-45009-broker-link-user-id        keycloak        META-INF/jpa-changelog-26.6.0.xml       2026-06-09 23:07:02.070778      178     EXECUTED        9:05026bbbc8d2ead5afcbda2f5fdf3a2b      createIndex indexName=IDX_BROKER_LINK_USER_ID, tableName=BROKER_LINK            \N      4.33.0  \N      \N      1046405406
26.6.0-45009-broker-link-identity-provider      keycloak        META-INF/jpa-changelog-26.6.0.xml       2026-06-09 23:07:02.187609      179     EXECUTED        9:7d9a0253c9de7be754efef8bba4265bd      createIndex indexName=IDX_BROKER_LINK_IDENTITY_PROVIDER, tableName=BROKER_LINK          \N      4.33.0  \N      \N      1046405406
26.6.0-org-group-relationship   keycloak        META-INF/jpa-changelog-26.6.0.xml       2026-06-09 23:07:02.251107     180      EXECUTED        9:05685853fba030f53548ac6bf23245e3      addColumn tableName=KEYCLOAK_GROUP; addForeignKeyConstraint baseTableName=KEYCLOAK_GROUP, constraintName=FK_GROUP_ORGANIZATION, referencedTableName=ORG; createIndex indexName=IDX_GROUP_ORG_ID, tableName=KEYCLOAK_GROUP               \N      4.33.0  \N      \N      1046405406
26.6.0-44424-index-css-user-session-and-offline keycloak        META-INF/jpa-changelog-26.6.0.xml       2026-06-09 23:07:02.309685      181     EXECUTED        9:a704d8598df241a3fd3cb91b6ab4b2d4      createIndex indexName=IDX_OFFLINE_CSS_BY_USER_SESSION_AND_OFFLINE, tableName=OFFLINE_CLIENT_SESSION             \N      4.33.0  \N      \N      1046405406
26.6.0-44424-create-realm-in-client-session     keycloak        META-INF/jpa-changelog-26.6.0.xml       2026-06-09 23:07:02.321671      182     EXECUTED        9:77dbbc72d943e98cfe472ba8cc56a31c      addColumn tableName=OFFLINE_CLIENT_SESSION              \N      4.33.0  \N      \N      1046405406
26.6.0-44424-set-realm-in-client-session        keycloak        META-INF/jpa-changelog-26.6.0.xml       2026-06-09 23:07:02.329937      183     EXECUTED        9:3964a3148d32a55ef81126e23cdf6721      customChange            \N      4.33.0 \N       \N      1046405406
26.6.0-44424-idx-css-realm-and-clients  keycloak        META-INF/jpa-changelog-26.6.0.xml       2026-06-09 23:07:02.388368      184     EXECUTED        9:a093877fff41185ac24103be80e00968      createIndex indexName=IDX_OFFLINE_CSS_BY_CLIENT_AND_REALM, tableName=OFFLINE_CLIENT_SESSION             \N      4.33.0  \N      \N      1046405406
26.6.0-add-last-modified-timestamp-user keycloak        META-INF/jpa-changelog-26.6.0.xml       2026-06-09 23:07:02.397258      185     EXECUTED        9:8aa583d2cdd9e913dff42fecd626c560      addColumn tableName=USER_ENTITY         \N     4.33.0   \N      \N      1046405406
26.6.0-add-timestamps-group     keycloak        META-INF/jpa-changelog-26.6.0.xml       2026-06-09 23:07:02.406397     186      EXECUTED        9:4363d45dc25105a3fc5db9ff6936b0a9      addColumn tableName=KEYCLOAK_GROUP              \N     4.33.0   \N      \N      1046405406
26.6.0-43829-user-created-timestamp-index       keycloak        META-INF/jpa-changelog-26.6.0.xml       2026-06-09 23:07:02.468796      187     EXECUTED        9:f2531a49b8bb21a7a97966d88fd1a411      createIndex indexName=IDX_USER_CREATED_TIMESTAMP, tableName=USER_ENTITY         \N      4.33.0  \N      \N      1046405406
26.6.0-48716-create-mssql-idp-index     keycloak        META-INF/jpa-changelog-26.6.0.xml       2026-06-09 23:07:02.472044      188     MARK_RAN        9:dcbbb24c151c3b0b59f12fede23cc94d      createIndex indexName=IDX_IDP_FOR_LOGIN, tableName=IDENTITY_PROVIDER            \N      4.33.0  \N      \N      1046405406
\.


--
-- Data for Name: databasechangeloglock; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.databasechangeloglock (id, locked, lockgranted, lockedby) FROM stdin;
1       f       \N      \N
1000    f       \N      \N
\.


--
-- Data for Name: default_client_scope; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.default_client_scope (realm_id, scope_id, default_scope) FROM stdin;
476d693d-9abf-4f63-a268-5002ea64c060    fb60191e-c2db-4bf8-b82b-700851410d93    f
476d693d-9abf-4f63-a268-5002ea64c060    95a6644c-e7cc-4f7e-bb63-eec682e6a15d    t
476d693d-9abf-4f63-a268-5002ea64c060    dcce2317-090a-40bc-9bfd-83f1a91a8375    t
476d693d-9abf-4f63-a268-5002ea64c060    32e4ba85-437b-463d-b57a-2dfea4490888    t
476d693d-9abf-4f63-a268-5002ea64c060    2a2e6802-80de-465c-ba0a-8f1fe4318976    t
476d693d-9abf-4f63-a268-5002ea64c060    5df01ef7-dc49-4c68-a8e2-daad8ce010a6    f
476d693d-9abf-4f63-a268-5002ea64c060    f6d38fda-254d-403b-8b61-672f2fd91155    f
476d693d-9abf-4f63-a268-5002ea64c060    6e046e75-0771-46e2-84f8-2f52829c8709    t
476d693d-9abf-4f63-a268-5002ea64c060    e1cf00d5-c997-4b61-b0a6-74f3996fa248    t
476d693d-9abf-4f63-a268-5002ea64c060    0cef9175-9e45-4a23-a815-b64ba5d609b3    f
476d693d-9abf-4f63-a268-5002ea64c060    56883618-b18e-4f56-b9d4-ebd662c541dd    t
476d693d-9abf-4f63-a268-5002ea64c060    71db60b6-dbe1-4f0c-90ef-fa7071f4c75c    t
476d693d-9abf-4f63-a268-5002ea64c060    d4645da9-61b7-46af-9f53-58f1c2b97c1c    f
f19d6621-c51d-4928-ab07-1e2d5efd6e78    32af8254-3084-4832-903a-03692d91adcc    t
f19d6621-c51d-4928-ab07-1e2d5efd6e78    52fc0fac-d0e0-40fd-8334-2c06f93c6279    t
f19d6621-c51d-4928-ab07-1e2d5efd6e78    69274c3d-34ae-496f-97b2-2f8e839d8ade    t
f19d6621-c51d-4928-ab07-1e2d5efd6e78    8ee953da-e5cc-4363-8952-e53c9d9b72d6    t
f19d6621-c51d-4928-ab07-1e2d5efd6e78    a84c6860-6556-4e5a-810c-58ea2e9d3588    t
f19d6621-c51d-4928-ab07-1e2d5efd6e78    ae690761-0ba4-482a-aa90-58fd9f0b980f    t
f19d6621-c51d-4928-ab07-1e2d5efd6e78    cc5529dc-86c2-4c2c-9454-ba6b440056af    t
f19d6621-c51d-4928-ab07-1e2d5efd6e78    df4de68b-a57d-4c1f-a7d5-e49594e2b111    t
f19d6621-c51d-4928-ab07-1e2d5efd6e78    1f1f7c63-013f-4862-b2ef-462c2fcbb0bf    f
f19d6621-c51d-4928-ab07-1e2d5efd6e78    5c131446-96fa-460a-a2f7-bad0eedd08bd    f
f19d6621-c51d-4928-ab07-1e2d5efd6e78    6d500c07-bb73-46a3-a562-5a27b33e4187    f
f19d6621-c51d-4928-ab07-1e2d5efd6e78    94e36078-7d8b-47e8-b24e-588b57c528c4    f
f19d6621-c51d-4928-ab07-1e2d5efd6e78    a1fe3b88-c0e6-4483-90e8-319019ca945d    f
\.


--
-- Data for Name: event_entity; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.event_entity (id, client_id, details_json, error, ip_address, realm_id, session_id, event_time, type, user_id, details_json_long_value) FROM stdin;
332a3079-81bf-4a14-8779-832cd4e9f108    xenon-dev-oauth2-client-dev-env-id      \N      \N      172.17.0.1      f19d6621-c51d-4928-ab07-1e2d5efd6e78    9U6cRvXDApkjKh_zvh1JNUdG        1781627324034   LOGIN   4cd2326c-3588-4bbe-b396-17626465c850    {"auth_method":"openid-connect","auth_type":"code","response_type":"code","redirect_uri":"http://localhost:4200/landing","consent":"no_consent_required","code_id":"9U6cRvXDApkjKh_zvh1JNUdG","username":"xenon-dev-matthew-admin","response_mode":"fragment"}
ed94d75f-c39c-4a59-a082-d16e22c28adb    xenon-dev-oauth2-client-dev-env-id      \N      \N      172.17.0.1      f19d6621-c51d-4928-ab07-1e2d5efd6e78    9U6cRvXDApkjKh_zvh1JNUdG        1781627324540   CODE_TO_TOKEN   4cd2326c-3588-4bbe-b396-17626465c850    {"token_id":"onrtac:841eb948-1008-46d2-948f-d4b5eed9a1e0","grant_type":"authorization_code","refresh_token_type":"Refresh","scope":"openid profile email","refresh_token_id":"4c2076c5-e25b-47e2-6c14-eec74a7f686f","code_id":"9U6cRvXDApkjKh_zvh1JNUdG","client_auth_method":"client-secret"}
c00de59f-1a3f-4700-aac8-640cf4dbce79    xenon-dev-oauth2-client-dev-env-id      \N      \N      172.17.0.1      f19d6621-c51d-4928-ab07-1e2d5efd6e78    9U6cRvXDApkjKh_zvh1JNUdG        1781627327470   LOGIN   4cd2326c-3588-4bbe-b396-17626465c850    {"auth_method":"openid-connect","auth_type":"code","response_type":"code","redirect_uri":"http://localhost:4200/assets/silent-check-sso.html","consent":"no_consent_required","code_id":"9U6cRvXDApkjKh_zvh1JNUdG","response_mode":"fragment","username":"xenon-dev-matthew-admin"}
cd522d8f-4e7f-4903-a0fa-397c20ff0f8a    xenon-dev-oauth2-client-dev-env-id      \N      \N      172.17.0.1      f19d6621-c51d-4928-ab07-1e2d5efd6e78    9U6cRvXDApkjKh_zvh1JNUdG        1781627327526   CODE_TO_TOKEN   4cd2326c-3588-4bbe-b396-17626465c850    {"token_id":"onrtac:90dc1ee6-fb0c-6138-a723-ee3a627abd1a","grant_type":"authorization_code","refresh_token_type":"Refresh","scope":"openid profile email","refresh_token_id":"13b408c3-c174-ce45-a297-4c7ebb028344","code_id":"9U6cRvXDApkjKh_zvh1JNUdG","client_auth_method":"client-secret"}
a924fbf8-4394-494b-81c1-65d93064897f    xenon-dev-oauth2-client-dev-env-id      \N      \N      172.17.0.1      f19d6621-c51d-4928-ab07-1e2d5efd6e78    9U6cRvXDApkjKh_zvh1JNUdG        1781627344206   LOGIN   4cd2326c-3588-4bbe-b396-17626465c850    {"auth_method":"openid-connect","auth_type":"code","response_type":"code","redirect_uri":"http://localhost:4200/assets/silent-check-sso.html","consent":"no_consent_required","code_id":"9U6cRvXDApkjKh_zvh1JNUdG","response_mode":"fragment","username":"xenon-dev-matthew-admin"}
4aaa6a65-3ea3-47b3-a330-9be8bbb54ac3    xenon-dev-oauth2-client-dev-env-id      \N      \N      172.17.0.1      f19d6621-c51d-4928-ab07-1e2d5efd6e78    9U6cRvXDApkjKh_zvh1JNUdG        1781627344249   CODE_TO_TOKEN   4cd2326c-3588-4bbe-b396-17626465c850    {"token_id":"onrtac:7baced94-7272-9a77-7060-477f9dbcdd2a","grant_type":"authorization_code","refresh_token_type":"Refresh","scope":"openid profile email","refresh_token_id":"0928c8b3-7f2b-8b30-9db4-d8650e404c49","code_id":"9U6cRvXDApkjKh_zvh1JNUdG","client_auth_method":"client-secret"}
80de59f0-7ef3-42d0-b611-459a4f4f10c1    xenon-dev-oauth2-client-dev-env-id      \N      \N      172.17.0.1      f19d6621-c51d-4928-ab07-1e2d5efd6e78    9U6cRvXDApkjKh_zvh1JNUdG        1781627379432   LOGOUT  4cd2326c-3588-4bbe-b396-17626465c850    {"redirect_uri":"http://localhost:4200/landing"}
\.


--
-- Data for Name: fed_user_attribute; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.fed_user_attribute (id, name, user_id, realm_id, storage_provider_id, value, long_value_hash, long_value_hash_lower_case, long_value) FROM stdin;
\.


--
-- Data for Name: fed_user_consent; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.fed_user_consent (id, client_id, user_id, realm_id, storage_provider_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: fed_user_consent_cl_scope; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.fed_user_consent_cl_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: fed_user_credential; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.fed_user_credential (id, salt, type, created_date, user_id, realm_id, storage_provider_id, user_label, secret_data, credential_data, priority) FROM stdin;
\.


--
-- Data for Name: fed_user_group_membership; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.fed_user_group_membership (group_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_required_action; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.fed_user_required_action (required_action, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_role_mapping; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.fed_user_role_mapping (role_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: federated_identity; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.federated_identity (identity_provider, realm_id, federated_user_id, federated_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: federated_user; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.federated_user (id, storage_provider_id, realm_id) FROM stdin;
\.


--
-- Data for Name: group_attribute; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.group_attribute (id, name, value, group_id) FROM stdin;
\.


--
-- Data for Name: group_role_mapping; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.group_role_mapping (role_id, group_id) FROM stdin;
0acba8ae-6701-4ff6-8ec7-740150807ee7    a76e440f-1a8b-4bf7-be27-7631806fd855
c54b203c-c48b-489d-8df6-5abcde3f60c5    a76e440f-1a8b-4bf7-be27-7631806fd855
ef40816d-3ede-4d73-a6e0-e382b3951b57    a76e440f-1a8b-4bf7-be27-7631806fd855
76d883aa-495e-41ad-9e55-72703f26205d    a76e440f-1a8b-4bf7-be27-7631806fd855
f2719fba-0604-43b4-8291-b0720ea9021a    a76e440f-1a8b-4bf7-be27-7631806fd855
755e113a-4897-4c44-9773-aae10820c8f2    a76e440f-1a8b-4bf7-be27-7631806fd855
63bab289-4440-467d-9580-d4c47005e5d4    a76e440f-1a8b-4bf7-be27-7631806fd855
01e4a71a-94f9-4569-9217-026d8b502326    a76e440f-1a8b-4bf7-be27-7631806fd855
a542dcdf-4c79-4ce3-82d1-7b3df33f01ba    a76e440f-1a8b-4bf7-be27-7631806fd855
43ea0fe9-162d-4158-9b4d-58c2e0b4fa68    a76e440f-1a8b-4bf7-be27-7631806fd855
a9976f07-e0bb-46da-ac69-9f1483b4e839    a76e440f-1a8b-4bf7-be27-7631806fd855
\.


--
-- Data for Name: identity_provider; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.identity_provider (internal_id, enabled, provider_alias, provider_id, store_token, authenticate_by_default, realm_id, add_token_role, trust_email, first_broker_login_flow_id, post_broker_login_flow_id, provider_display_name, link_only, organization_id, hide_on_login) FROM stdin;
\.


--
-- Data for Name: identity_provider_config; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.identity_provider_config (identity_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: identity_provider_mapper; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.identity_provider_mapper (id, name, idp_alias, idp_mapper_name, realm_id) FROM stdin;
\.


--
-- Data for Name: idp_mapper_config; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.idp_mapper_config (idp_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: jgroups_ping; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.jgroups_ping (address, name, cluster_name, ip, coord) FROM stdin;
\.


--
-- Data for Name: keycloak_group; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.keycloak_group (id, name, parent_group, realm_id, type, description, org_id, created_timestamp, last_modified_timestamp) FROM stdin;
1db835b9-73b0-4485-9ead-c55a5149a793    Admin           f19d6621-c51d-4928-ab07-1e2d5efd6e78    0               \N     1781047073786    1781047073786
a76e440f-1a8b-4bf7-be27-7631806fd855    Standard-User           f19d6621-c51d-4928-ab07-1e2d5efd6e78    0              \N       1781047073808   1781047073808
\.


--
-- Data for Name: keycloak_role; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.keycloak_role (id, client_realm_constraint, client_role, description, name, realm_id, client, realm) FROM stdin;
27f9ee59-8afb-4faa-a725-178d98c9f1c0    476d693d-9abf-4f63-a268-5002ea64c060    f       ${role_default-roles}   default-roles-master    476d693d-9abf-4f63-a268-5002ea64c060    \N      \N
ac79ab3f-564a-4a00-a752-e37bfe79d100    476d693d-9abf-4f63-a268-5002ea64c060    f       ${role_create-realm}    create-realm    476d693d-9abf-4f63-a268-5002ea64c060    \N      \N
e03136b4-ad0c-4627-b8cb-0c3fb842b86e    476d693d-9abf-4f63-a268-5002ea64c060    f       ${role_admin}   admin   476d693d-9abf-4f63-a268-5002ea64c060    \N      \N
f95d675b-3d31-480f-96a5-dc28dbec2133    826781ec-e76d-47ee-8ad7-b7c764855457    t       ${role_create-client}   create-client   476d693d-9abf-4f63-a268-5002ea64c060    826781ec-e76d-47ee-8ad7-b7c764855457    \N
fd95a9c1-88ae-47a3-9b34-ef0376dbb7c3    826781ec-e76d-47ee-8ad7-b7c764855457    t       ${role_view-realm}      view-realm      476d693d-9abf-4f63-a268-5002ea64c060    826781ec-e76d-47ee-8ad7-b7c764855457    \N
bd76352d-9096-4cbf-b96f-ce22962e14ae    826781ec-e76d-47ee-8ad7-b7c764855457    t       ${role_view-users}      view-users      476d693d-9abf-4f63-a268-5002ea64c060    826781ec-e76d-47ee-8ad7-b7c764855457    \N
0b74cb14-6a80-49f9-9603-06e0a753f318    826781ec-e76d-47ee-8ad7-b7c764855457    t       ${role_view-clients}    view-clients    476d693d-9abf-4f63-a268-5002ea64c060    826781ec-e76d-47ee-8ad7-b7c764855457    \N
c051e44b-bf41-4b6a-9ca1-5e4b00e38c46    826781ec-e76d-47ee-8ad7-b7c764855457    t       ${role_view-events}     view-events     476d693d-9abf-4f63-a268-5002ea64c060    826781ec-e76d-47ee-8ad7-b7c764855457    \N
40ce6f1a-4a36-4fb5-ac31-1c5f5d98a993    826781ec-e76d-47ee-8ad7-b7c764855457    t       ${role_view-identity-providers}
view-identity-providers 476d693d-9abf-4f63-a268-5002ea64c060    826781ec-e76d-47ee-8ad7-b7c764855457    \N
660767a7-c982-4a12-a96a-289eeca992df    826781ec-e76d-47ee-8ad7-b7c764855457    t       ${role_view-authorization}     view-authorization       476d693d-9abf-4f63-a268-5002ea64c060    826781ec-e76d-47ee-8ad7-b7c764855457    \N
f11548e5-3207-4651-81f6-74128eb11858    826781ec-e76d-47ee-8ad7-b7c764855457    t       ${role_manage-realm}    manage-realm    476d693d-9abf-4f63-a268-5002ea64c060    826781ec-e76d-47ee-8ad7-b7c764855457    \N
92c5107c-9c7f-49bd-9f07-3e3a879a9c1d    826781ec-e76d-47ee-8ad7-b7c764855457    t       ${role_manage-users}    manage-users    476d693d-9abf-4f63-a268-5002ea64c060    826781ec-e76d-47ee-8ad7-b7c764855457    \N
72ec6a28-de01-4d17-b3d7-9b805a8a0487    826781ec-e76d-47ee-8ad7-b7c764855457    t       ${role_manage-clients}  manage-clients  476d693d-9abf-4f63-a268-5002ea64c060    826781ec-e76d-47ee-8ad7-b7c764855457    \N
f7eb99c4-b839-4a29-b9ef-c62b54497357    826781ec-e76d-47ee-8ad7-b7c764855457    t       ${role_manage-events}   manage-events   476d693d-9abf-4f63-a268-5002ea64c060    826781ec-e76d-47ee-8ad7-b7c764855457    \N
ee8d4e0c-bb0b-4074-9795-ad91f63c1aae    826781ec-e76d-47ee-8ad7-b7c764855457    t       ${role_manage-identity-providers}       manage-identity-providers       476d693d-9abf-4f63-a268-5002ea64c060    826781ec-e76d-47ee-8ad7-b7c764855457   \N
40bcaf63-20f9-4c06-a54b-571bb9634729    826781ec-e76d-47ee-8ad7-b7c764855457    t       ${role_manage-authorization}   manage-authorization     476d693d-9abf-4f63-a268-5002ea64c060    826781ec-e76d-47ee-8ad7-b7c764855457    \N
4f0b44c7-f410-4eb3-b0e4-c4c0c6b43e8b    826781ec-e76d-47ee-8ad7-b7c764855457    t       ${role_query-users}     query-users     476d693d-9abf-4f63-a268-5002ea64c060    826781ec-e76d-47ee-8ad7-b7c764855457    \N
eac4b1bb-161e-40c4-9452-9fe0bef3b1a9    826781ec-e76d-47ee-8ad7-b7c764855457    t       ${role_query-clients}   query-clients   476d693d-9abf-4f63-a268-5002ea64c060    826781ec-e76d-47ee-8ad7-b7c764855457    \N
72fa8670-d315-41ee-8283-311ecee1c95c    826781ec-e76d-47ee-8ad7-b7c764855457    t       ${role_query-realms}    query-realms    476d693d-9abf-4f63-a268-5002ea64c060    826781ec-e76d-47ee-8ad7-b7c764855457    \N
815ab178-efa2-46ab-9f3d-d21621933f46    826781ec-e76d-47ee-8ad7-b7c764855457    t       ${role_query-groups}    query-groups    476d693d-9abf-4f63-a268-5002ea64c060    826781ec-e76d-47ee-8ad7-b7c764855457    \N
cbb0ac11-e572-448c-be96-497a80a14b88    06a7a117-2a7e-4517-8da7-1dfe8111d9d9    t       ${role_view-profile}    view-profile    476d693d-9abf-4f63-a268-5002ea64c060    06a7a117-2a7e-4517-8da7-1dfe8111d9d9    \N
0ad38ea0-b005-4334-a8da-a7626d3fa9d0    06a7a117-2a7e-4517-8da7-1dfe8111d9d9    t       ${role_manage-account}  manage-account  476d693d-9abf-4f63-a268-5002ea64c060    06a7a117-2a7e-4517-8da7-1dfe8111d9d9    \N
c8fd4fcf-9532-4535-b5ed-700dba016320    06a7a117-2a7e-4517-8da7-1dfe8111d9d9    t       ${role_manage-account-links}   manage-account-links     476d693d-9abf-4f63-a268-5002ea64c060    06a7a117-2a7e-4517-8da7-1dfe8111d9d9    \N
7716d443-498d-4b22-b349-9d4b1a6e7220    06a7a117-2a7e-4517-8da7-1dfe8111d9d9    t       ${role_view-applications}      view-applications        476d693d-9abf-4f63-a268-5002ea64c060    06a7a117-2a7e-4517-8da7-1dfe8111d9d9    \N
879eaed1-24cc-4cd6-91ce-c156ccc1ca8c    06a7a117-2a7e-4517-8da7-1dfe8111d9d9    t       ${role_view-consent}    view-consent    476d693d-9abf-4f63-a268-5002ea64c060    06a7a117-2a7e-4517-8da7-1dfe8111d9d9    \N
8b83aae8-e471-4128-b870-0d0014205b3d    06a7a117-2a7e-4517-8da7-1dfe8111d9d9    t       ${role_manage-consent}  manage-consent  476d693d-9abf-4f63-a268-5002ea64c060    06a7a117-2a7e-4517-8da7-1dfe8111d9d9    \N
fbea6310-5cef-452c-a88c-cb5594454e89    06a7a117-2a7e-4517-8da7-1dfe8111d9d9    t       ${role_view-groups}     view-groups     476d693d-9abf-4f63-a268-5002ea64c060    06a7a117-2a7e-4517-8da7-1dfe8111d9d9    \N
485c5060-1515-4187-86ec-2e3343d2b2a2    06a7a117-2a7e-4517-8da7-1dfe8111d9d9    t       ${role_delete-account}  delete-account  476d693d-9abf-4f63-a268-5002ea64c060    06a7a117-2a7e-4517-8da7-1dfe8111d9d9    \N
568eabab-e32c-4311-b1ba-d70635a6bea9    dcaf507c-7935-4e1f-afc1-f8216b0d86e9    t       ${role_read-token}      read-token      476d693d-9abf-4f63-a268-5002ea64c060    dcaf507c-7935-4e1f-afc1-f8216b0d86e9    \N
4b3a01b4-00f6-49eb-b059-dfa61378402e    826781ec-e76d-47ee-8ad7-b7c764855457    t       ${role_impersonation}   impersonation   476d693d-9abf-4f63-a268-5002ea64c060    826781ec-e76d-47ee-8ad7-b7c764855457    \N
ae11397e-a4f0-45d1-a518-de6fad7d9fb7    476d693d-9abf-4f63-a268-5002ea64c060    f       ${role_offline-access}  offline_access  476d693d-9abf-4f63-a268-5002ea64c060    \N      \N
cb196c0e-24ea-4b19-b6a8-3c52cfd7eece    476d693d-9abf-4f63-a268-5002ea64c060    f       ${role_uma_authorization}      uma_authorization        476d693d-9abf-4f63-a268-5002ea64c060    \N      \N
c12a42cd-b2a1-4ac1-9fa4-722c4e8db40a    f19d6621-c51d-4928-ab07-1e2d5efd6e78    f       ${role_default-roles}   default-roles-xenon-dev-dev-env f19d6621-c51d-4928-ab07-1e2d5efd6e78    \N      \N
47d7845c-7083-48ce-a959-21d73421d661    7130ba2d-54dd-4607-8133-abe74a3dbac8    t       ${role_create-client}   create-client   476d693d-9abf-4f63-a268-5002ea64c060    7130ba2d-54dd-4607-8133-abe74a3dbac8    \N
f19bb685-d234-484b-be5b-2dd46e37fcc5    7130ba2d-54dd-4607-8133-abe74a3dbac8    t       ${role_view-realm}      view-realm      476d693d-9abf-4f63-a268-5002ea64c060    7130ba2d-54dd-4607-8133-abe74a3dbac8    \N
d520ba23-6279-4ef4-96ad-1b6f8dd59233    7130ba2d-54dd-4607-8133-abe74a3dbac8    t       ${role_view-users}      view-users      476d693d-9abf-4f63-a268-5002ea64c060    7130ba2d-54dd-4607-8133-abe74a3dbac8    \N
6ff6e140-4584-4e20-b117-e53cc34fca44    7130ba2d-54dd-4607-8133-abe74a3dbac8    t       ${role_view-clients}    view-clients    476d693d-9abf-4f63-a268-5002ea64c060    7130ba2d-54dd-4607-8133-abe74a3dbac8    \N
7922c5a9-a76c-4fd4-a734-19c942448208    7130ba2d-54dd-4607-8133-abe74a3dbac8    t       ${role_view-events}     view-events     476d693d-9abf-4f63-a268-5002ea64c060    7130ba2d-54dd-4607-8133-abe74a3dbac8    \N
f6d76303-4d43-4857-a2e9-5aa4556cec17    7130ba2d-54dd-4607-8133-abe74a3dbac8    t       ${role_view-identity-providers}
view-identity-providers 476d693d-9abf-4f63-a268-5002ea64c060    7130ba2d-54dd-4607-8133-abe74a3dbac8    \N
9228c151-cbab-4c8f-b707-01df2704b495    7130ba2d-54dd-4607-8133-abe74a3dbac8    t       ${role_view-authorization}     view-authorization       476d693d-9abf-4f63-a268-5002ea64c060    7130ba2d-54dd-4607-8133-abe74a3dbac8    \N
cfeb32b9-952f-49db-ad97-93cc60aeef18    7130ba2d-54dd-4607-8133-abe74a3dbac8    t       ${role_manage-realm}    manage-realm    476d693d-9abf-4f63-a268-5002ea64c060    7130ba2d-54dd-4607-8133-abe74a3dbac8    \N
f3eeb43c-0ae6-4016-9da0-3c6a397f939f    7130ba2d-54dd-4607-8133-abe74a3dbac8    t       ${role_manage-users}    manage-users    476d693d-9abf-4f63-a268-5002ea64c060    7130ba2d-54dd-4607-8133-abe74a3dbac8    \N
60ede06c-7ee3-421d-8335-b58dc568e627    7130ba2d-54dd-4607-8133-abe74a3dbac8    t       ${role_manage-clients}  manage-clients  476d693d-9abf-4f63-a268-5002ea64c060    7130ba2d-54dd-4607-8133-abe74a3dbac8    \N
bb7de2b5-dfcd-4dc6-9a58-9687aedc46d9    7130ba2d-54dd-4607-8133-abe74a3dbac8    t       ${role_manage-events}   manage-events   476d693d-9abf-4f63-a268-5002ea64c060    7130ba2d-54dd-4607-8133-abe74a3dbac8    \N
5a1388bf-d375-4127-8e42-0992d82f2522    7130ba2d-54dd-4607-8133-abe74a3dbac8    t       ${role_manage-identity-providers}       manage-identity-providers       476d693d-9abf-4f63-a268-5002ea64c060    7130ba2d-54dd-4607-8133-abe74a3dbac8   \N
26efee68-6ad1-4a9b-be4c-87ead0c94dd4    7130ba2d-54dd-4607-8133-abe74a3dbac8    t       ${role_manage-authorization}   manage-authorization     476d693d-9abf-4f63-a268-5002ea64c060    7130ba2d-54dd-4607-8133-abe74a3dbac8    \N
be89408e-8fcb-4403-a474-2c8b190d7a5a    7130ba2d-54dd-4607-8133-abe74a3dbac8    t       ${role_query-users}     query-users     476d693d-9abf-4f63-a268-5002ea64c060    7130ba2d-54dd-4607-8133-abe74a3dbac8    \N
83fced35-1ea1-4268-a002-8c03e035f656    7130ba2d-54dd-4607-8133-abe74a3dbac8    t       ${role_query-clients}   query-clients   476d693d-9abf-4f63-a268-5002ea64c060    7130ba2d-54dd-4607-8133-abe74a3dbac8    \N
ba045c43-b03e-4e19-82c7-8cb0aa702284    7130ba2d-54dd-4607-8133-abe74a3dbac8    t       ${role_query-realms}    query-realms    476d693d-9abf-4f63-a268-5002ea64c060    7130ba2d-54dd-4607-8133-abe74a3dbac8    \N
784ef712-e1d7-46dc-b93b-9d76d72ec133    7130ba2d-54dd-4607-8133-abe74a3dbac8    t       ${role_query-groups}    query-groups    476d693d-9abf-4f63-a268-5002ea64c060    7130ba2d-54dd-4607-8133-abe74a3dbac8    \N
e61cb8a9-f2ef-4e4b-945d-aa3c4cf4e2d9    f19d6621-c51d-4928-ab07-1e2d5efd6e78    f       ${role_offline-access}  offline_access  f19d6621-c51d-4928-ab07-1e2d5efd6e78    \N      \N
5250a996-bcae-4745-84ec-7f4c34c67519    f19d6621-c51d-4928-ab07-1e2d5efd6e78    f       ${role_uma_authorization}      uma_authorization        f19d6621-c51d-4928-ab07-1e2d5efd6e78    \N      \N
16e2bccc-a397-4933-9258-309b4b77195d    e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    t       ${role_create-client}   create-client   f19d6621-c51d-4928-ab07-1e2d5efd6e78    e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    \N
0acba8ae-6701-4ff6-8ec7-740150807ee7    e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    t       ${role_manage-users}    manage-users    f19d6621-c51d-4928-ab07-1e2d5efd6e78    e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    \N
9d2116e8-2019-472e-b990-9bfc5ea93bf5    e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    t       ${role_manage-clients}  manage-clients  f19d6621-c51d-4928-ab07-1e2d5efd6e78    e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    \N
d7efca3e-cd24-4bc5-a42f-99d6175ccc2f    e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    t       ${role_query-realms}    query-realms    f19d6621-c51d-4928-ab07-1e2d5efd6e78    e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    \N
bfa8d1dc-bd90-4ac6-b69e-f84d014a6cb1    e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    t       ${role_view-users}      view-users      f19d6621-c51d-4928-ab07-1e2d5efd6e78    e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    \N
a1ff898e-3222-4ffb-b983-b0112a0256ce    e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    t       ${role_manage-realm}    manage-realm    f19d6621-c51d-4928-ab07-1e2d5efd6e78    e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    \N
888bfb73-9da8-4c39-8c70-19e297ad1b68    e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    t       ${role_view-authorization}     view-authorization       f19d6621-c51d-4928-ab07-1e2d5efd6e78    e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    \N
3602a511-7db2-48af-9f5d-29a4af994b43    e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    t       ${role_manage-identity-providers}       manage-identity-providers       f19d6621-c51d-4928-ab07-1e2d5efd6e78    e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed   \N
292626a3-80a2-418b-bd57-cd957615a485    e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    t       ${role_query-groups}    query-groups    f19d6621-c51d-4928-ab07-1e2d5efd6e78    e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    \N
21401e33-ebc7-442d-8e72-cd49becf26d7    e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    t       ${role_impersonation}   impersonation   f19d6621-c51d-4928-ab07-1e2d5efd6e78    e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    \N
518330f9-7511-4527-863a-d494c14d97ab    e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    t       ${role_query-users}     query-users     f19d6621-c51d-4928-ab07-1e2d5efd6e78    e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    \N
2e7358e2-7e47-43dd-832c-c8f1424cd39f    e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    t       ${role_realm-admin}     realm-admin     f19d6621-c51d-4928-ab07-1e2d5efd6e78    e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    \N
e29c702a-09c1-49cf-aa2a-365dd87b843d    e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    t       ${role_view-events}     view-events     f19d6621-c51d-4928-ab07-1e2d5efd6e78    e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    \N
d73bcca4-d765-4a6d-b261-fa9d460687a4    e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    t       ${role_manage-events}   manage-events   f19d6621-c51d-4928-ab07-1e2d5efd6e78    e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    \N
1401b23f-d688-4314-bfb4-4ec0fa44bb67    e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    t       ${role_view-clients}    view-clients    f19d6621-c51d-4928-ab07-1e2d5efd6e78    e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    \N
0b409298-7c0c-48e9-adbb-50474968f4c9    e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    t       ${role_view-identity-providers}
view-identity-providers f19d6621-c51d-4928-ab07-1e2d5efd6e78    e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    \N
6f5ea219-5737-47b6-908a-a5fd22ecc883    e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    t       ${role_query-clients}   query-clients   f19d6621-c51d-4928-ab07-1e2d5efd6e78    e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    \N
3ca1d168-eede-4722-83fa-ac3a2d99d1f8    e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    t       ${role_manage-authorization}   manage-authorization     f19d6621-c51d-4928-ab07-1e2d5efd6e78    e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    \N
238f7196-e097-41e5-8db4-4930bcfbcd01    e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    t       ${role_view-realm}      view-realm      f19d6621-c51d-4928-ab07-1e2d5efd6e78    e6cb1b8e-40fe-4d2d-b8ec-67aca1fa28ed    \N
499c60a4-bcee-4d7e-b279-7841826fac00    79013291-edda-4ffa-8125-d87720aa6d0a    t               Admin   f19d6621-c51d-4928-ab07-1e2d5efd6e78    79013291-edda-4ffa-8125-d87720aa6d0a    \N
c54b203c-c48b-489d-8df6-5abcde3f60c5    79013291-edda-4ffa-8125-d87720aa6d0a    t       Standard Client Role    Standard-User   f19d6621-c51d-4928-ab07-1e2d5efd6e78    79013291-edda-4ffa-8125-d87720aa6d0a    \N
ef40816d-3ede-4d73-a6e0-e382b3951b57    55bec7b5-cc11-4104-8410-d018afb3dc0c    t       ${role_read-token}      read-token      f19d6621-c51d-4928-ab07-1e2d5efd6e78    55bec7b5-cc11-4104-8410-d018afb3dc0c    \N
76d883aa-495e-41ad-9e55-72703f26205d    492d289b-e100-4f7e-b6a4-f4f81bf46618    t       ${role_manage-account}  manage-account  f19d6621-c51d-4928-ab07-1e2d5efd6e78    492d289b-e100-4f7e-b6a4-f4f81bf46618    \N
f2719fba-0604-43b4-8291-b0720ea9021a    492d289b-e100-4f7e-b6a4-f4f81bf46618    t       ${role_delete-account}  delete-account  f19d6621-c51d-4928-ab07-1e2d5efd6e78    492d289b-e100-4f7e-b6a4-f4f81bf46618    \N
755e113a-4897-4c44-9773-aae10820c8f2    492d289b-e100-4f7e-b6a4-f4f81bf46618    t       ${role_view-applications}      view-applications        f19d6621-c51d-4928-ab07-1e2d5efd6e78    492d289b-e100-4f7e-b6a4-f4f81bf46618    \N
63bab289-4440-467d-9580-d4c47005e5d4    492d289b-e100-4f7e-b6a4-f4f81bf46618    t       ${role_view-groups}     view-groups     f19d6621-c51d-4928-ab07-1e2d5efd6e78    492d289b-e100-4f7e-b6a4-f4f81bf46618    \N
01e4a71a-94f9-4569-9217-026d8b502326    492d289b-e100-4f7e-b6a4-f4f81bf46618    t       ${role_view-profile}    view-profile    f19d6621-c51d-4928-ab07-1e2d5efd6e78    492d289b-e100-4f7e-b6a4-f4f81bf46618    \N
a542dcdf-4c79-4ce3-82d1-7b3df33f01ba    492d289b-e100-4f7e-b6a4-f4f81bf46618    t       ${role_manage-consent}  manage-consent  f19d6621-c51d-4928-ab07-1e2d5efd6e78    492d289b-e100-4f7e-b6a4-f4f81bf46618    \N
43ea0fe9-162d-4158-9b4d-58c2e0b4fa68    492d289b-e100-4f7e-b6a4-f4f81bf46618    t       ${role_view-consent}    view-consent    f19d6621-c51d-4928-ab07-1e2d5efd6e78    492d289b-e100-4f7e-b6a4-f4f81bf46618    \N
a9976f07-e0bb-46da-ac69-9f1483b4e839    492d289b-e100-4f7e-b6a4-f4f81bf46618    t       ${role_manage-account-links}   manage-account-links     f19d6621-c51d-4928-ab07-1e2d5efd6e78    492d289b-e100-4f7e-b6a4-f4f81bf46618    \N
d0272f03-8fe5-4390-aaf2-f77feb2ec37e    7130ba2d-54dd-4607-8133-abe74a3dbac8    t       ${role_impersonation}   impersonation   476d693d-9abf-4f63-a268-5002ea64c060    7130ba2d-54dd-4607-8133-abe74a3dbac8    \N
\.


--
-- Data for Name: migration_model; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.migration_model (id, version, update_time) FROM stdin;
cwc2j   26.6.3  1781046424
\.


--
-- Data for Name: offline_client_session; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.offline_client_session (user_session_id, client_id, offline_flag, "timestamp", data, client_storage_provider, external_client_id, version, realm_id) FROM stdin;
\.


--
-- Data for Name: offline_user_session; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.offline_user_session (user_session_id, user_id, realm_id, created_on, offline_flag, data, last_session_refresh, broker_session_id, version, remember_me) FROM stdin;
\.


--
-- Data for Name: org; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.org (id, enabled, realm_id, group_id, name, description, alias, redirect_url) FROM stdin;
\.


--
-- Data for Name: org_domain; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.org_domain (id, name, verified, org_id) FROM stdin;
\.


--
-- Data for Name: org_invitation; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.org_invitation (id, organization_id, email, first_name, last_name, created_at, expires_at, invite_link) FROM stdin;
\.


--
-- Data for Name: player_profile; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.player_profile (player_id, losses, pot, wins) FROM stdin;
1       0       4500    1
\.


--
-- Data for Name: policy_config; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.policy_config (policy_id, name, value) FROM stdin;
\.


--
-- Data for Name: protocol_mapper; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.protocol_mapper (id, name, protocol, protocol_mapper_name, client_id, client_scope_id) FROM stdin;
071dca5e-28c0-48b4-8195-7ab2a463ee41    audience resolve        openid-connect  oidc-audience-resolve-mapper    3a77a9b9-f7de-421d-9ae4-744d6549ba9c    \N
ae9ecf61-e88f-4f4a-9b18-59f9cb02b3f5    locale  openid-connect  oidc-usermodel-attribute-mapper e9211db7-c532-4a67-9aec-ab78f7f3c760    \N
34c38afd-0bea-4fc3-8b70-0d8f08d71a57    role list       saml    saml-role-list-mapper   \N      95a6644c-e7cc-4f7e-bb63-eec682e6a15d
e3640e1f-0850-4784-ab3b-c8ede53a7135    organization    saml    saml-organization-membership-mapper     \N      dcce2317-090a-40bc-9bfd-83f1a91a8375
f02144bb-898e-4211-b204-7822a19157c7    full name       openid-connect  oidc-full-name-mapper   \N      32e4ba85-437b-463d-b57a-2dfea4490888
59e1ed82-105a-45d8-a87b-e18a282fc97f    family name     openid-connect  oidc-usermodel-attribute-mapper \N      32e4ba85-437b-463d-b57a-2dfea4490888
0519c997-18c6-47f8-ab95-aa46c575b68d    given name      openid-connect  oidc-usermodel-attribute-mapper \N      32e4ba85-437b-463d-b57a-2dfea4490888
929b211d-b320-47af-8ecf-0f89154dcc66    middle name     openid-connect  oidc-usermodel-attribute-mapper \N      32e4ba85-437b-463d-b57a-2dfea4490888
4cde53cb-390f-4b98-a491-420d1f35da3b    nickname        openid-connect  oidc-usermodel-attribute-mapper \N      32e4ba85-437b-463d-b57a-2dfea4490888
ae2db9f0-ab2e-4e90-8e01-94b43db6800c    username        openid-connect  oidc-usermodel-attribute-mapper \N      32e4ba85-437b-463d-b57a-2dfea4490888
a0bfa106-0aaf-4088-b02b-9772bcacd926    profile openid-connect  oidc-usermodel-attribute-mapper \N      32e4ba85-437b-463d-b57a-2dfea4490888
1ee1e13c-94e1-4abe-a4f7-5585df126bca    picture openid-connect  oidc-usermodel-attribute-mapper \N      32e4ba85-437b-463d-b57a-2dfea4490888
c0dbedcc-364f-4c97-bb5f-cf73d2d34937    website openid-connect  oidc-usermodel-attribute-mapper \N      32e4ba85-437b-463d-b57a-2dfea4490888
eecd7953-f308-4e0f-8ac1-1ac0274d8847    gender  openid-connect  oidc-usermodel-attribute-mapper \N      32e4ba85-437b-463d-b57a-2dfea4490888
c1c5aa4b-8c08-4a64-89e9-5d47e356eb56    birthdate       openid-connect  oidc-usermodel-attribute-mapper \N      32e4ba85-437b-463d-b57a-2dfea4490888
ecda4a2c-c2ac-4db1-9611-ae56259454ad    zoneinfo        openid-connect  oidc-usermodel-attribute-mapper \N      32e4ba85-437b-463d-b57a-2dfea4490888
446296d5-12d0-4416-aebb-70781066588b    locale  openid-connect  oidc-usermodel-attribute-mapper \N      32e4ba85-437b-463d-b57a-2dfea4490888
786682a1-1286-4d4b-ae7e-a29044e39a27    updated at      openid-connect  oidc-usermodel-attribute-mapper \N      32e4ba85-437b-463d-b57a-2dfea4490888
37fa790f-7b69-4d4a-bd7d-8b558f99af3e    email   openid-connect  oidc-usermodel-attribute-mapper \N      2a2e6802-80de-465c-ba0a-8f1fe4318976
7beafad6-cd4c-4cd9-be1b-c0dae4aa87ec    email verified  openid-connect  oidc-usermodel-property-mapper  \N      2a2e6802-80de-465c-ba0a-8f1fe4318976
0ec86ac3-5eef-4918-b987-249ddc32046e    address openid-connect  oidc-address-mapper     \N      5df01ef7-dc49-4c68-a8e2-daad8ce010a6
9751e5cf-d3cb-4881-9492-3e97c1bcebf2    phone number    openid-connect  oidc-usermodel-attribute-mapper \N      f6d38fda-254d-403b-8b61-672f2fd91155
2d93a866-3084-4df7-a46c-2b98977db876    phone number verified   openid-connect  oidc-usermodel-attribute-mapper \N     f6d38fda-254d-403b-8b61-672f2fd91155
b9a8d40c-0c52-41e2-a6c3-7eac7b371ed3    realm roles     openid-connect  oidc-usermodel-realm-role-mapper        \N     6e046e75-0771-46e2-84f8-2f52829c8709
74fabead-5cc2-4f7b-8fef-8b308f65f7d3    client roles    openid-connect  oidc-usermodel-client-role-mapper       \N     6e046e75-0771-46e2-84f8-2f52829c8709
9a3b9c3a-b711-4647-ba47-d01d9bb0d4a0    audience resolve        openid-connect  oidc-audience-resolve-mapper    \N     6e046e75-0771-46e2-84f8-2f52829c8709
0fc955da-2ee5-4454-9f0f-5bc74c9a60a1    allowed web origins     openid-connect  oidc-allowed-origins-mapper     \N     e1cf00d5-c997-4b61-b0a6-74f3996fa248
6b51ca66-61cf-4fd9-83bf-e9c458efd4db    upn     openid-connect  oidc-usermodel-attribute-mapper \N      0cef9175-9e45-4a23-a815-b64ba5d609b3
7e83de7d-9ecd-4aac-be9a-7914478fa5ca    groups  openid-connect  oidc-usermodel-realm-role-mapper        \N      0cef9175-9e45-4a23-a815-b64ba5d609b3
9d65f874-7b59-455a-90db-399288eb8534    acr loa level   openid-connect  oidc-acr-mapper \N      56883618-b18e-4f56-b9d4-ebd662c541dd
bd2bfd3a-db4e-474a-80c0-009d6ca0db0f    auth_time       openid-connect  oidc-usersessionmodel-note-mapper       \N     71db60b6-dbe1-4f0c-90ef-fa7071f4c75c
d3624a54-b3ff-4571-880a-114125c28757    sub     openid-connect  oidc-sub-mapper \N      71db60b6-dbe1-4f0c-90ef-fa7071f4c75c
26f2abd2-81ce-4b1d-aa6d-0ef9f2df3b91    Client ID       openid-connect  oidc-usersessionmodel-note-mapper       \N     35863e9d-9097-463b-9764-bf14f9f436c3
9670b8fb-2711-4d05-be1b-f7e1c8a63247    Client Host     openid-connect  oidc-usersessionmodel-note-mapper       \N     35863e9d-9097-463b-9764-bf14f9f436c3
5d61516a-e860-4389-b826-0f382dc89d1a    Client IP Address       openid-connect  oidc-usersessionmodel-note-mapper      \N       35863e9d-9097-463b-9764-bf14f9f436c3
12f463a8-ac6c-4ecd-b4ab-a65a149a09cd    organization    openid-connect  oidc-organization-membership-mapper     \N     d4645da9-61b7-46af-9f53-58f1c2b97c1c
33ed090c-c214-46ca-9f60-b2493f97d534    email   openid-connect  oidc-usermodel-attribute-mapper \N      ae690761-0ba4-482a-aa90-58fd9f0b980f
ec521dd7-134b-4df0-abaf-d779995fd24f    email verified  openid-connect  oidc-usermodel-property-mapper  \N      ae690761-0ba4-482a-aa90-58fd9f0b980f
e3750d35-05d9-4169-906a-fdde36886590    phone number verified   openid-connect  oidc-usermodel-attribute-mapper \N     94e36078-7d8b-47e8-b24e-588b57c528c4
a5f51241-c577-44c2-9843-082219da674c    phone number    openid-connect  oidc-usermodel-attribute-mapper \N      94e36078-7d8b-47e8-b24e-588b57c528c4
07eadb7c-1f77-4ec6-b34b-ef013a1d3134    address openid-connect  oidc-address-mapper     \N      a1fe3b88-c0e6-4483-90e8-319019ca945d
b765f726-e4b8-454f-b6c1-e9b60fcf9b29    gender  openid-connect  oidc-usermodel-attribute-mapper \N      a84c6860-6556-4e5a-810c-58ea2e9d3588
ff62b6a9-481c-48af-aa38-5c1ce5c0e80f    given name      openid-connect  oidc-usermodel-attribute-mapper \N      a84c6860-6556-4e5a-810c-58ea2e9d3588
97712a13-0fdc-44d5-886a-0a5e5d4d3c16    website openid-connect  oidc-usermodel-attribute-mapper \N      a84c6860-6556-4e5a-810c-58ea2e9d3588
9b90d18c-ba13-4864-a280-e8ab1fab91d3    full name       openid-connect  oidc-full-name-mapper   \N      a84c6860-6556-4e5a-810c-58ea2e9d3588
68dcc10b-9db9-4819-89f9-2dfc4092bf26    updated at      openid-connect  oidc-usermodel-attribute-mapper \N      a84c6860-6556-4e5a-810c-58ea2e9d3588
89edcdc6-1587-47cc-b6dc-c206780f4649    middle name     openid-connect  oidc-usermodel-attribute-mapper \N      a84c6860-6556-4e5a-810c-58ea2e9d3588
ca05335a-d93c-49e0-8cce-ba9f7714c00a    family name     openid-connect  oidc-usermodel-attribute-mapper \N      a84c6860-6556-4e5a-810c-58ea2e9d3588
7a2cf751-74c6-40c5-9e4d-b4f7e7a4632c    birthdate       openid-connect  oidc-usermodel-attribute-mapper \N      a84c6860-6556-4e5a-810c-58ea2e9d3588
ac2d553d-c72a-4cdb-a62d-1fbaf84e40a9    profile openid-connect  oidc-usermodel-attribute-mapper \N      a84c6860-6556-4e5a-810c-58ea2e9d3588
935d6db6-e788-4ba2-b5ad-b456d3983830    picture openid-connect  oidc-usermodel-attribute-mapper \N      a84c6860-6556-4e5a-810c-58ea2e9d3588
07ab9e40-51ad-416b-b107-516174a3d47d    username        openid-connect  oidc-usermodel-attribute-mapper \N      a84c6860-6556-4e5a-810c-58ea2e9d3588
624c082f-c547-4140-9b71-922cef0b7740    locale  openid-connect  oidc-usermodel-attribute-mapper \N      a84c6860-6556-4e5a-810c-58ea2e9d3588
be160eca-6637-4c69-a2e7-ef2c1eb0e122    zoneinfo        openid-connect  oidc-usermodel-attribute-mapper \N      a84c6860-6556-4e5a-810c-58ea2e9d3588
1347a8a2-2519-46f4-bd02-9534c00997a2    nickname        openid-connect  oidc-usermodel-attribute-mapper \N      a84c6860-6556-4e5a-810c-58ea2e9d3588
c8717483-5106-4438-b10d-4121a0ab52d8    role list       saml    saml-role-list-mapper   \N      df4de68b-a57d-4c1f-a7d5-e49594e2b111
9216b606-93a5-4101-8432-7b285b168efb    auth_time       openid-connect  oidc-usersessionmodel-note-mapper       \N     8ee953da-e5cc-4363-8952-e53c9d9b72d6
d2f08b3d-c3e7-4895-85a2-1d3786821d05    sub     openid-connect  oidc-sub-mapper \N      8ee953da-e5cc-4363-8952-e53c9d9b72d6
69c20668-711f-4835-bff3-cd678cb8d049    Client IP Address       openid-connect  oidc-usersessionmodel-note-mapper      \N       6b24f028-f6d2-422d-809f-dcab22ab87ec
83a22ee4-39d9-4282-b909-3db3634d5382    Client ID       openid-connect  oidc-usersessionmodel-note-mapper       \N     6b24f028-f6d2-422d-809f-dcab22ab87ec
d5cc4640-5ef2-49c5-97e9-a235fba176b5    Client Host     openid-connect  oidc-usersessionmodel-note-mapper       \N     6b24f028-f6d2-422d-809f-dcab22ab87ec
5f06959c-805a-4ef7-8e59-e39a2a4008d7    acr loa level   openid-connect  oidc-acr-mapper \N      32af8254-3084-4832-903a-03692d91adcc
74bf9b50-0aa1-46a4-9e79-fc196d089064    client roles    openid-connect  oidc-usermodel-client-role-mapper       \N     52fc0fac-d0e0-40fd-8334-2c06f93c6279
98fb889b-edde-46f3-be11-547ff136d09d    realm roles     openid-connect  oidc-usermodel-realm-role-mapper        \N     52fc0fac-d0e0-40fd-8334-2c06f93c6279
425ecf52-9c92-4d8a-9121-e823ca7dc9aa    audience resolve        openid-connect  oidc-audience-resolve-mapper    \N     52fc0fac-d0e0-40fd-8334-2c06f93c6279
472b3585-3d48-47c6-aae1-4de6155e4534    upn     openid-connect  oidc-usermodel-attribute-mapper \N      5c131446-96fa-460a-a2f7-bad0eedd08bd
4ad3dfdc-2304-480e-baa0-2bc2a386675b    groups  openid-connect  oidc-usermodel-realm-role-mapper        \N      5c131446-96fa-460a-a2f7-bad0eedd08bd
11b262be-4dca-436c-a0df-d3d147e816b7    allowed web origins     openid-connect  oidc-allowed-origins-mapper     \N     cc5529dc-86c2-4c2c-9454-ba6b440056af
bdf4adfe-290f-4fae-aab5-f5f15d2367a1    organization    saml    saml-organization-membership-mapper     \N      69274c3d-34ae-496f-97b2-2f8e839d8ade
9eab1ccc-3701-4586-bedc-c19eff642fe4    organization    openid-connect  oidc-organization-membership-mapper     \N     6d500c07-bb73-46a3-a562-5a27b33e4187
8c177ff6-4f64-4ceb-ac34-0c66ea49bb6a    audience resolve        openid-connect  oidc-audience-resolve-mapper    4ebb77df-7b06-4f46-b29a-4aedeec0a6bd    \N
6fe3085f-ab8c-40d3-b6e3-d0ae2d323b1f    locale  openid-connect  oidc-usermodel-attribute-mapper 53e2859c-34c6-4b00-8bee-efc443e7468d    \N
\.


--
-- Data for Name: protocol_mapper_config; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.protocol_mapper_config (protocol_mapper_id, value, name) FROM stdin;
ae9ecf61-e88f-4f4a-9b18-59f9cb02b3f5    true    introspection.token.claim
ae9ecf61-e88f-4f4a-9b18-59f9cb02b3f5    true    userinfo.token.claim
ae9ecf61-e88f-4f4a-9b18-59f9cb02b3f5    locale  user.attribute
ae9ecf61-e88f-4f4a-9b18-59f9cb02b3f5    true    id.token.claim
ae9ecf61-e88f-4f4a-9b18-59f9cb02b3f5    true    access.token.claim
ae9ecf61-e88f-4f4a-9b18-59f9cb02b3f5    locale  claim.name
ae9ecf61-e88f-4f4a-9b18-59f9cb02b3f5    String  jsonType.label
34c38afd-0bea-4fc3-8b70-0d8f08d71a57    false   single
34c38afd-0bea-4fc3-8b70-0d8f08d71a57    Basic   attribute.nameformat
34c38afd-0bea-4fc3-8b70-0d8f08d71a57    Role    attribute.name
0519c997-18c6-47f8-ab95-aa46c575b68d    true    introspection.token.claim
0519c997-18c6-47f8-ab95-aa46c575b68d    true    userinfo.token.claim
0519c997-18c6-47f8-ab95-aa46c575b68d    firstName       user.attribute
0519c997-18c6-47f8-ab95-aa46c575b68d    true    id.token.claim
0519c997-18c6-47f8-ab95-aa46c575b68d    true    access.token.claim
0519c997-18c6-47f8-ab95-aa46c575b68d    given_name      claim.name
0519c997-18c6-47f8-ab95-aa46c575b68d    String  jsonType.label
1ee1e13c-94e1-4abe-a4f7-5585df126bca    true    introspection.token.claim
1ee1e13c-94e1-4abe-a4f7-5585df126bca    true    userinfo.token.claim
1ee1e13c-94e1-4abe-a4f7-5585df126bca    picture user.attribute
1ee1e13c-94e1-4abe-a4f7-5585df126bca    true    id.token.claim
1ee1e13c-94e1-4abe-a4f7-5585df126bca    true    access.token.claim
1ee1e13c-94e1-4abe-a4f7-5585df126bca    picture claim.name
1ee1e13c-94e1-4abe-a4f7-5585df126bca    String  jsonType.label
446296d5-12d0-4416-aebb-70781066588b    true    introspection.token.claim
446296d5-12d0-4416-aebb-70781066588b    true    userinfo.token.claim
446296d5-12d0-4416-aebb-70781066588b    locale  user.attribute
446296d5-12d0-4416-aebb-70781066588b    true    id.token.claim
446296d5-12d0-4416-aebb-70781066588b    true    access.token.claim
446296d5-12d0-4416-aebb-70781066588b    locale  claim.name
446296d5-12d0-4416-aebb-70781066588b    String  jsonType.label
4cde53cb-390f-4b98-a491-420d1f35da3b    true    introspection.token.claim
4cde53cb-390f-4b98-a491-420d1f35da3b    true    userinfo.token.claim
4cde53cb-390f-4b98-a491-420d1f35da3b    nickname        user.attribute
4cde53cb-390f-4b98-a491-420d1f35da3b    true    id.token.claim
4cde53cb-390f-4b98-a491-420d1f35da3b    true    access.token.claim
4cde53cb-390f-4b98-a491-420d1f35da3b    nickname        claim.name
4cde53cb-390f-4b98-a491-420d1f35da3b    String  jsonType.label
59e1ed82-105a-45d8-a87b-e18a282fc97f    true    introspection.token.claim
59e1ed82-105a-45d8-a87b-e18a282fc97f    true    userinfo.token.claim
59e1ed82-105a-45d8-a87b-e18a282fc97f    lastName        user.attribute
59e1ed82-105a-45d8-a87b-e18a282fc97f    true    id.token.claim
59e1ed82-105a-45d8-a87b-e18a282fc97f    true    access.token.claim
59e1ed82-105a-45d8-a87b-e18a282fc97f    family_name     claim.name
59e1ed82-105a-45d8-a87b-e18a282fc97f    String  jsonType.label
786682a1-1286-4d4b-ae7e-a29044e39a27    true    introspection.token.claim
786682a1-1286-4d4b-ae7e-a29044e39a27    true    userinfo.token.claim
786682a1-1286-4d4b-ae7e-a29044e39a27    updatedAt       user.attribute
786682a1-1286-4d4b-ae7e-a29044e39a27    true    id.token.claim
786682a1-1286-4d4b-ae7e-a29044e39a27    true    access.token.claim
786682a1-1286-4d4b-ae7e-a29044e39a27    updated_at      claim.name
786682a1-1286-4d4b-ae7e-a29044e39a27    long    jsonType.label
929b211d-b320-47af-8ecf-0f89154dcc66    true    introspection.token.claim
929b211d-b320-47af-8ecf-0f89154dcc66    true    userinfo.token.claim
929b211d-b320-47af-8ecf-0f89154dcc66    middleName      user.attribute
929b211d-b320-47af-8ecf-0f89154dcc66    true    id.token.claim
929b211d-b320-47af-8ecf-0f89154dcc66    true    access.token.claim
929b211d-b320-47af-8ecf-0f89154dcc66    middle_name     claim.name
929b211d-b320-47af-8ecf-0f89154dcc66    String  jsonType.label
a0bfa106-0aaf-4088-b02b-9772bcacd926    true    introspection.token.claim
a0bfa106-0aaf-4088-b02b-9772bcacd926    true    userinfo.token.claim
a0bfa106-0aaf-4088-b02b-9772bcacd926    profile user.attribute
a0bfa106-0aaf-4088-b02b-9772bcacd926    true    id.token.claim
a0bfa106-0aaf-4088-b02b-9772bcacd926    true    access.token.claim
a0bfa106-0aaf-4088-b02b-9772bcacd926    profile claim.name
a0bfa106-0aaf-4088-b02b-9772bcacd926    String  jsonType.label
ae2db9f0-ab2e-4e90-8e01-94b43db6800c    true    introspection.token.claim
ae2db9f0-ab2e-4e90-8e01-94b43db6800c    true    userinfo.token.claim
ae2db9f0-ab2e-4e90-8e01-94b43db6800c    username        user.attribute
ae2db9f0-ab2e-4e90-8e01-94b43db6800c    true    id.token.claim
ae2db9f0-ab2e-4e90-8e01-94b43db6800c    true    access.token.claim
ae2db9f0-ab2e-4e90-8e01-94b43db6800c    preferred_username      claim.name
ae2db9f0-ab2e-4e90-8e01-94b43db6800c    String  jsonType.label
c0dbedcc-364f-4c97-bb5f-cf73d2d34937    true    introspection.token.claim
c0dbedcc-364f-4c97-bb5f-cf73d2d34937    true    userinfo.token.claim
c0dbedcc-364f-4c97-bb5f-cf73d2d34937    website user.attribute
c0dbedcc-364f-4c97-bb5f-cf73d2d34937    true    id.token.claim
c0dbedcc-364f-4c97-bb5f-cf73d2d34937    true    access.token.claim
c0dbedcc-364f-4c97-bb5f-cf73d2d34937    website claim.name
c0dbedcc-364f-4c97-bb5f-cf73d2d34937    String  jsonType.label
c1c5aa4b-8c08-4a64-89e9-5d47e356eb56    true    introspection.token.claim
c1c5aa4b-8c08-4a64-89e9-5d47e356eb56    true    userinfo.token.claim
c1c5aa4b-8c08-4a64-89e9-5d47e356eb56    birthdate       user.attribute
c1c5aa4b-8c08-4a64-89e9-5d47e356eb56    true    id.token.claim
c1c5aa4b-8c08-4a64-89e9-5d47e356eb56    true    access.token.claim
c1c5aa4b-8c08-4a64-89e9-5d47e356eb56    birthdate       claim.name
c1c5aa4b-8c08-4a64-89e9-5d47e356eb56    String  jsonType.label
ecda4a2c-c2ac-4db1-9611-ae56259454ad    true    introspection.token.claim
ecda4a2c-c2ac-4db1-9611-ae56259454ad    true    userinfo.token.claim
ecda4a2c-c2ac-4db1-9611-ae56259454ad    zoneinfo        user.attribute
ecda4a2c-c2ac-4db1-9611-ae56259454ad    true    id.token.claim
ecda4a2c-c2ac-4db1-9611-ae56259454ad    true    access.token.claim
ecda4a2c-c2ac-4db1-9611-ae56259454ad    zoneinfo        claim.name
ecda4a2c-c2ac-4db1-9611-ae56259454ad    String  jsonType.label
eecd7953-f308-4e0f-8ac1-1ac0274d8847    true    introspection.token.claim
eecd7953-f308-4e0f-8ac1-1ac0274d8847    true    userinfo.token.claim
eecd7953-f308-4e0f-8ac1-1ac0274d8847    gender  user.attribute
eecd7953-f308-4e0f-8ac1-1ac0274d8847    true    id.token.claim
eecd7953-f308-4e0f-8ac1-1ac0274d8847    true    access.token.claim
eecd7953-f308-4e0f-8ac1-1ac0274d8847    gender  claim.name
eecd7953-f308-4e0f-8ac1-1ac0274d8847    String  jsonType.label
f02144bb-898e-4211-b204-7822a19157c7    true    introspection.token.claim
f02144bb-898e-4211-b204-7822a19157c7    true    userinfo.token.claim
f02144bb-898e-4211-b204-7822a19157c7    true    id.token.claim
f02144bb-898e-4211-b204-7822a19157c7    true    access.token.claim
37fa790f-7b69-4d4a-bd7d-8b558f99af3e    true    introspection.token.claim
37fa790f-7b69-4d4a-bd7d-8b558f99af3e    true    userinfo.token.claim
37fa790f-7b69-4d4a-bd7d-8b558f99af3e    email   user.attribute
37fa790f-7b69-4d4a-bd7d-8b558f99af3e    true    id.token.claim
37fa790f-7b69-4d4a-bd7d-8b558f99af3e    true    access.token.claim
37fa790f-7b69-4d4a-bd7d-8b558f99af3e    email   claim.name
37fa790f-7b69-4d4a-bd7d-8b558f99af3e    String  jsonType.label
7beafad6-cd4c-4cd9-be1b-c0dae4aa87ec    true    introspection.token.claim
7beafad6-cd4c-4cd9-be1b-c0dae4aa87ec    true    userinfo.token.claim
7beafad6-cd4c-4cd9-be1b-c0dae4aa87ec    emailVerified   user.attribute
7beafad6-cd4c-4cd9-be1b-c0dae4aa87ec    true    id.token.claim
7beafad6-cd4c-4cd9-be1b-c0dae4aa87ec    true    access.token.claim
7beafad6-cd4c-4cd9-be1b-c0dae4aa87ec    email_verified  claim.name
7beafad6-cd4c-4cd9-be1b-c0dae4aa87ec    boolean jsonType.label
0ec86ac3-5eef-4918-b987-249ddc32046e    formatted       user.attribute.formatted
0ec86ac3-5eef-4918-b987-249ddc32046e    country user.attribute.country
0ec86ac3-5eef-4918-b987-249ddc32046e    true    introspection.token.claim
0ec86ac3-5eef-4918-b987-249ddc32046e    postal_code     user.attribute.postal_code
0ec86ac3-5eef-4918-b987-249ddc32046e    true    userinfo.token.claim
0ec86ac3-5eef-4918-b987-249ddc32046e    street  user.attribute.street
0ec86ac3-5eef-4918-b987-249ddc32046e    true    id.token.claim
0ec86ac3-5eef-4918-b987-249ddc32046e    region  user.attribute.region
0ec86ac3-5eef-4918-b987-249ddc32046e    true    access.token.claim
0ec86ac3-5eef-4918-b987-249ddc32046e    locality        user.attribute.locality
2d93a866-3084-4df7-a46c-2b98977db876    true    introspection.token.claim
2d93a866-3084-4df7-a46c-2b98977db876    true    userinfo.token.claim
2d93a866-3084-4df7-a46c-2b98977db876    phoneNumberVerified     user.attribute
2d93a866-3084-4df7-a46c-2b98977db876    true    id.token.claim
2d93a866-3084-4df7-a46c-2b98977db876    true    access.token.claim
2d93a866-3084-4df7-a46c-2b98977db876    phone_number_verified   claim.name
2d93a866-3084-4df7-a46c-2b98977db876    boolean jsonType.label
9751e5cf-d3cb-4881-9492-3e97c1bcebf2    true    introspection.token.claim
9751e5cf-d3cb-4881-9492-3e97c1bcebf2    true    userinfo.token.claim
9751e5cf-d3cb-4881-9492-3e97c1bcebf2    phoneNumber     user.attribute
9751e5cf-d3cb-4881-9492-3e97c1bcebf2    true    id.token.claim
9751e5cf-d3cb-4881-9492-3e97c1bcebf2    true    access.token.claim
9751e5cf-d3cb-4881-9492-3e97c1bcebf2    phone_number    claim.name
9751e5cf-d3cb-4881-9492-3e97c1bcebf2    String  jsonType.label
74fabead-5cc2-4f7b-8fef-8b308f65f7d3    true    introspection.token.claim
74fabead-5cc2-4f7b-8fef-8b308f65f7d3    true    multivalued
74fabead-5cc2-4f7b-8fef-8b308f65f7d3    foo     user.attribute
74fabead-5cc2-4f7b-8fef-8b308f65f7d3    true    access.token.claim
74fabead-5cc2-4f7b-8fef-8b308f65f7d3    resource_access.${client_id}.roles      claim.name
74fabead-5cc2-4f7b-8fef-8b308f65f7d3    String  jsonType.label
9a3b9c3a-b711-4647-ba47-d01d9bb0d4a0    true    introspection.token.claim
9a3b9c3a-b711-4647-ba47-d01d9bb0d4a0    true    access.token.claim
b9a8d40c-0c52-41e2-a6c3-7eac7b371ed3    true    introspection.token.claim
b9a8d40c-0c52-41e2-a6c3-7eac7b371ed3    true    multivalued
b9a8d40c-0c52-41e2-a6c3-7eac7b371ed3    foo     user.attribute
b9a8d40c-0c52-41e2-a6c3-7eac7b371ed3    true    access.token.claim
b9a8d40c-0c52-41e2-a6c3-7eac7b371ed3    realm_access.roles      claim.name
b9a8d40c-0c52-41e2-a6c3-7eac7b371ed3    String  jsonType.label
0fc955da-2ee5-4454-9f0f-5bc74c9a60a1    true    introspection.token.claim
0fc955da-2ee5-4454-9f0f-5bc74c9a60a1    true    access.token.claim
6b51ca66-61cf-4fd9-83bf-e9c458efd4db    true    introspection.token.claim
6b51ca66-61cf-4fd9-83bf-e9c458efd4db    true    userinfo.token.claim
6b51ca66-61cf-4fd9-83bf-e9c458efd4db    username        user.attribute
6b51ca66-61cf-4fd9-83bf-e9c458efd4db    true    id.token.claim
6b51ca66-61cf-4fd9-83bf-e9c458efd4db    true    access.token.claim
6b51ca66-61cf-4fd9-83bf-e9c458efd4db    upn     claim.name
6b51ca66-61cf-4fd9-83bf-e9c458efd4db    String  jsonType.label
7e83de7d-9ecd-4aac-be9a-7914478fa5ca    true    introspection.token.claim
7e83de7d-9ecd-4aac-be9a-7914478fa5ca    true    multivalued
7e83de7d-9ecd-4aac-be9a-7914478fa5ca    foo     user.attribute
7e83de7d-9ecd-4aac-be9a-7914478fa5ca    true    id.token.claim
7e83de7d-9ecd-4aac-be9a-7914478fa5ca    true    access.token.claim
7e83de7d-9ecd-4aac-be9a-7914478fa5ca    groups  claim.name
7e83de7d-9ecd-4aac-be9a-7914478fa5ca    String  jsonType.label
9d65f874-7b59-455a-90db-399288eb8534    true    introspection.token.claim
9d65f874-7b59-455a-90db-399288eb8534    true    id.token.claim
9d65f874-7b59-455a-90db-399288eb8534    true    access.token.claim
bd2bfd3a-db4e-474a-80c0-009d6ca0db0f    AUTH_TIME       user.session.note
bd2bfd3a-db4e-474a-80c0-009d6ca0db0f    true    introspection.token.claim
bd2bfd3a-db4e-474a-80c0-009d6ca0db0f    true    id.token.claim
bd2bfd3a-db4e-474a-80c0-009d6ca0db0f    true    access.token.claim
bd2bfd3a-db4e-474a-80c0-009d6ca0db0f    auth_time       claim.name
bd2bfd3a-db4e-474a-80c0-009d6ca0db0f    long    jsonType.label
d3624a54-b3ff-4571-880a-114125c28757    true    introspection.token.claim
d3624a54-b3ff-4571-880a-114125c28757    true    access.token.claim
26f2abd2-81ce-4b1d-aa6d-0ef9f2df3b91    client_id       user.session.note
26f2abd2-81ce-4b1d-aa6d-0ef9f2df3b91    true    introspection.token.claim
26f2abd2-81ce-4b1d-aa6d-0ef9f2df3b91    true    id.token.claim
26f2abd2-81ce-4b1d-aa6d-0ef9f2df3b91    true    access.token.claim
26f2abd2-81ce-4b1d-aa6d-0ef9f2df3b91    client_id       claim.name
26f2abd2-81ce-4b1d-aa6d-0ef9f2df3b91    String  jsonType.label
5d61516a-e860-4389-b826-0f382dc89d1a    clientAddress   user.session.note
5d61516a-e860-4389-b826-0f382dc89d1a    true    introspection.token.claim
5d61516a-e860-4389-b826-0f382dc89d1a    true    id.token.claim
5d61516a-e860-4389-b826-0f382dc89d1a    true    access.token.claim
5d61516a-e860-4389-b826-0f382dc89d1a    clientAddress   claim.name
5d61516a-e860-4389-b826-0f382dc89d1a    String  jsonType.label
9670b8fb-2711-4d05-be1b-f7e1c8a63247    clientHost      user.session.note
9670b8fb-2711-4d05-be1b-f7e1c8a63247    true    introspection.token.claim
9670b8fb-2711-4d05-be1b-f7e1c8a63247    true    id.token.claim
9670b8fb-2711-4d05-be1b-f7e1c8a63247    true    access.token.claim
9670b8fb-2711-4d05-be1b-f7e1c8a63247    clientHost      claim.name
9670b8fb-2711-4d05-be1b-f7e1c8a63247    String  jsonType.label
12f463a8-ac6c-4ecd-b4ab-a65a149a09cd    true    introspection.token.claim
12f463a8-ac6c-4ecd-b4ab-a65a149a09cd    true    multivalued
12f463a8-ac6c-4ecd-b4ab-a65a149a09cd    true    id.token.claim
12f463a8-ac6c-4ecd-b4ab-a65a149a09cd    true    access.token.claim
12f463a8-ac6c-4ecd-b4ab-a65a149a09cd    organization    claim.name
12f463a8-ac6c-4ecd-b4ab-a65a149a09cd    String  jsonType.label
33ed090c-c214-46ca-9f60-b2493f97d534    true    introspection.token.claim
33ed090c-c214-46ca-9f60-b2493f97d534    true    userinfo.token.claim
33ed090c-c214-46ca-9f60-b2493f97d534    email   user.attribute
33ed090c-c214-46ca-9f60-b2493f97d534    true    id.token.claim
33ed090c-c214-46ca-9f60-b2493f97d534    true    access.token.claim
33ed090c-c214-46ca-9f60-b2493f97d534    email   claim.name
33ed090c-c214-46ca-9f60-b2493f97d534    String  jsonType.label
ec521dd7-134b-4df0-abaf-d779995fd24f    true    introspection.token.claim
ec521dd7-134b-4df0-abaf-d779995fd24f    true    userinfo.token.claim
ec521dd7-134b-4df0-abaf-d779995fd24f    emailVerified   user.attribute
ec521dd7-134b-4df0-abaf-d779995fd24f    true    id.token.claim
ec521dd7-134b-4df0-abaf-d779995fd24f    true    access.token.claim
ec521dd7-134b-4df0-abaf-d779995fd24f    email_verified  claim.name
ec521dd7-134b-4df0-abaf-d779995fd24f    boolean jsonType.label
a5f51241-c577-44c2-9843-082219da674c    true    introspection.token.claim
a5f51241-c577-44c2-9843-082219da674c    true    userinfo.token.claim
a5f51241-c577-44c2-9843-082219da674c    phoneNumber     user.attribute
a5f51241-c577-44c2-9843-082219da674c    true    id.token.claim
a5f51241-c577-44c2-9843-082219da674c    true    access.token.claim
a5f51241-c577-44c2-9843-082219da674c    phone_number    claim.name
a5f51241-c577-44c2-9843-082219da674c    String  jsonType.label
e3750d35-05d9-4169-906a-fdde36886590    true    introspection.token.claim
e3750d35-05d9-4169-906a-fdde36886590    true    userinfo.token.claim
e3750d35-05d9-4169-906a-fdde36886590    phoneNumberVerified     user.attribute
e3750d35-05d9-4169-906a-fdde36886590    true    id.token.claim
e3750d35-05d9-4169-906a-fdde36886590    true    access.token.claim
e3750d35-05d9-4169-906a-fdde36886590    phone_number_verified   claim.name
e3750d35-05d9-4169-906a-fdde36886590    boolean jsonType.label
07eadb7c-1f77-4ec6-b34b-ef013a1d3134    formatted       user.attribute.formatted
07eadb7c-1f77-4ec6-b34b-ef013a1d3134    country user.attribute.country
07eadb7c-1f77-4ec6-b34b-ef013a1d3134    true    introspection.token.claim
07eadb7c-1f77-4ec6-b34b-ef013a1d3134    postal_code     user.attribute.postal_code
07eadb7c-1f77-4ec6-b34b-ef013a1d3134    true    userinfo.token.claim
07eadb7c-1f77-4ec6-b34b-ef013a1d3134    street  user.attribute.street
07eadb7c-1f77-4ec6-b34b-ef013a1d3134    true    id.token.claim
07eadb7c-1f77-4ec6-b34b-ef013a1d3134    region  user.attribute.region
07eadb7c-1f77-4ec6-b34b-ef013a1d3134    true    access.token.claim
07eadb7c-1f77-4ec6-b34b-ef013a1d3134    locality        user.attribute.locality
07ab9e40-51ad-416b-b107-516174a3d47d    true    introspection.token.claim
07ab9e40-51ad-416b-b107-516174a3d47d    true    userinfo.token.claim
07ab9e40-51ad-416b-b107-516174a3d47d    username        user.attribute
07ab9e40-51ad-416b-b107-516174a3d47d    true    id.token.claim
07ab9e40-51ad-416b-b107-516174a3d47d    true    access.token.claim
07ab9e40-51ad-416b-b107-516174a3d47d    preferred_username      claim.name
07ab9e40-51ad-416b-b107-516174a3d47d    String  jsonType.label
1347a8a2-2519-46f4-bd02-9534c00997a2    true    introspection.token.claim
1347a8a2-2519-46f4-bd02-9534c00997a2    true    userinfo.token.claim
1347a8a2-2519-46f4-bd02-9534c00997a2    nickname        user.attribute
1347a8a2-2519-46f4-bd02-9534c00997a2    true    id.token.claim
1347a8a2-2519-46f4-bd02-9534c00997a2    true    access.token.claim
1347a8a2-2519-46f4-bd02-9534c00997a2    nickname        claim.name
1347a8a2-2519-46f4-bd02-9534c00997a2    String  jsonType.label
624c082f-c547-4140-9b71-922cef0b7740    true    introspection.token.claim
624c082f-c547-4140-9b71-922cef0b7740    true    userinfo.token.claim
624c082f-c547-4140-9b71-922cef0b7740    locale  user.attribute
624c082f-c547-4140-9b71-922cef0b7740    true    id.token.claim
624c082f-c547-4140-9b71-922cef0b7740    true    access.token.claim
624c082f-c547-4140-9b71-922cef0b7740    locale  claim.name
624c082f-c547-4140-9b71-922cef0b7740    String  jsonType.label
68dcc10b-9db9-4819-89f9-2dfc4092bf26    true    introspection.token.claim
68dcc10b-9db9-4819-89f9-2dfc4092bf26    true    userinfo.token.claim
68dcc10b-9db9-4819-89f9-2dfc4092bf26    updatedAt       user.attribute
68dcc10b-9db9-4819-89f9-2dfc4092bf26    true    id.token.claim
68dcc10b-9db9-4819-89f9-2dfc4092bf26    true    access.token.claim
68dcc10b-9db9-4819-89f9-2dfc4092bf26    updated_at      claim.name
68dcc10b-9db9-4819-89f9-2dfc4092bf26    long    jsonType.label
7a2cf751-74c6-40c5-9e4d-b4f7e7a4632c    true    introspection.token.claim
7a2cf751-74c6-40c5-9e4d-b4f7e7a4632c    true    userinfo.token.claim
7a2cf751-74c6-40c5-9e4d-b4f7e7a4632c    birthdate       user.attribute
7a2cf751-74c6-40c5-9e4d-b4f7e7a4632c    true    id.token.claim
7a2cf751-74c6-40c5-9e4d-b4f7e7a4632c    true    access.token.claim
7a2cf751-74c6-40c5-9e4d-b4f7e7a4632c    birthdate       claim.name
7a2cf751-74c6-40c5-9e4d-b4f7e7a4632c    String  jsonType.label
89edcdc6-1587-47cc-b6dc-c206780f4649    true    introspection.token.claim
89edcdc6-1587-47cc-b6dc-c206780f4649    true    userinfo.token.claim
89edcdc6-1587-47cc-b6dc-c206780f4649    middleName      user.attribute
89edcdc6-1587-47cc-b6dc-c206780f4649    true    id.token.claim
89edcdc6-1587-47cc-b6dc-c206780f4649    true    access.token.claim
89edcdc6-1587-47cc-b6dc-c206780f4649    middle_name     claim.name
89edcdc6-1587-47cc-b6dc-c206780f4649    String  jsonType.label
935d6db6-e788-4ba2-b5ad-b456d3983830    true    introspection.token.claim
935d6db6-e788-4ba2-b5ad-b456d3983830    true    userinfo.token.claim
935d6db6-e788-4ba2-b5ad-b456d3983830    picture user.attribute
935d6db6-e788-4ba2-b5ad-b456d3983830    true    id.token.claim
935d6db6-e788-4ba2-b5ad-b456d3983830    true    access.token.claim
935d6db6-e788-4ba2-b5ad-b456d3983830    picture claim.name
935d6db6-e788-4ba2-b5ad-b456d3983830    String  jsonType.label
97712a13-0fdc-44d5-886a-0a5e5d4d3c16    true    introspection.token.claim
97712a13-0fdc-44d5-886a-0a5e5d4d3c16    true    userinfo.token.claim
97712a13-0fdc-44d5-886a-0a5e5d4d3c16    website user.attribute
97712a13-0fdc-44d5-886a-0a5e5d4d3c16    true    id.token.claim
97712a13-0fdc-44d5-886a-0a5e5d4d3c16    true    access.token.claim
97712a13-0fdc-44d5-886a-0a5e5d4d3c16    website claim.name
97712a13-0fdc-44d5-886a-0a5e5d4d3c16    String  jsonType.label
9b90d18c-ba13-4864-a280-e8ab1fab91d3    true    id.token.claim
9b90d18c-ba13-4864-a280-e8ab1fab91d3    true    access.token.claim
9b90d18c-ba13-4864-a280-e8ab1fab91d3    true    introspection.token.claim
9b90d18c-ba13-4864-a280-e8ab1fab91d3    true    userinfo.token.claim
ac2d553d-c72a-4cdb-a62d-1fbaf84e40a9    true    introspection.token.claim
ac2d553d-c72a-4cdb-a62d-1fbaf84e40a9    true    userinfo.token.claim
ac2d553d-c72a-4cdb-a62d-1fbaf84e40a9    profile user.attribute
ac2d553d-c72a-4cdb-a62d-1fbaf84e40a9    true    id.token.claim
ac2d553d-c72a-4cdb-a62d-1fbaf84e40a9    true    access.token.claim
ac2d553d-c72a-4cdb-a62d-1fbaf84e40a9    profile claim.name
ac2d553d-c72a-4cdb-a62d-1fbaf84e40a9    String  jsonType.label
b765f726-e4b8-454f-b6c1-e9b60fcf9b29    true    introspection.token.claim
b765f726-e4b8-454f-b6c1-e9b60fcf9b29    true    userinfo.token.claim
b765f726-e4b8-454f-b6c1-e9b60fcf9b29    gender  user.attribute
b765f726-e4b8-454f-b6c1-e9b60fcf9b29    true    id.token.claim
b765f726-e4b8-454f-b6c1-e9b60fcf9b29    true    access.token.claim
b765f726-e4b8-454f-b6c1-e9b60fcf9b29    gender  claim.name
b765f726-e4b8-454f-b6c1-e9b60fcf9b29    String  jsonType.label
be160eca-6637-4c69-a2e7-ef2c1eb0e122    true    introspection.token.claim
be160eca-6637-4c69-a2e7-ef2c1eb0e122    true    userinfo.token.claim
be160eca-6637-4c69-a2e7-ef2c1eb0e122    zoneinfo        user.attribute
be160eca-6637-4c69-a2e7-ef2c1eb0e122    true    id.token.claim
be160eca-6637-4c69-a2e7-ef2c1eb0e122    true    access.token.claim
be160eca-6637-4c69-a2e7-ef2c1eb0e122    zoneinfo        claim.name
be160eca-6637-4c69-a2e7-ef2c1eb0e122    String  jsonType.label
ca05335a-d93c-49e0-8cce-ba9f7714c00a    true    introspection.token.claim
ca05335a-d93c-49e0-8cce-ba9f7714c00a    true    userinfo.token.claim
ca05335a-d93c-49e0-8cce-ba9f7714c00a    lastName        user.attribute
ca05335a-d93c-49e0-8cce-ba9f7714c00a    true    id.token.claim
ca05335a-d93c-49e0-8cce-ba9f7714c00a    true    access.token.claim
ca05335a-d93c-49e0-8cce-ba9f7714c00a    family_name     claim.name
ca05335a-d93c-49e0-8cce-ba9f7714c00a    String  jsonType.label
ff62b6a9-481c-48af-aa38-5c1ce5c0e80f    true    introspection.token.claim
ff62b6a9-481c-48af-aa38-5c1ce5c0e80f    true    userinfo.token.claim
ff62b6a9-481c-48af-aa38-5c1ce5c0e80f    firstName       user.attribute
ff62b6a9-481c-48af-aa38-5c1ce5c0e80f    true    id.token.claim
ff62b6a9-481c-48af-aa38-5c1ce5c0e80f    true    access.token.claim
ff62b6a9-481c-48af-aa38-5c1ce5c0e80f    given_name      claim.name
ff62b6a9-481c-48af-aa38-5c1ce5c0e80f    String  jsonType.label
c8717483-5106-4438-b10d-4121a0ab52d8    false   single
c8717483-5106-4438-b10d-4121a0ab52d8    Basic   attribute.nameformat
c8717483-5106-4438-b10d-4121a0ab52d8    Role    attribute.name
9216b606-93a5-4101-8432-7b285b168efb    AUTH_TIME       user.session.note
9216b606-93a5-4101-8432-7b285b168efb    true    introspection.token.claim
9216b606-93a5-4101-8432-7b285b168efb    true    userinfo.token.claim
9216b606-93a5-4101-8432-7b285b168efb    true    id.token.claim
9216b606-93a5-4101-8432-7b285b168efb    true    access.token.claim
9216b606-93a5-4101-8432-7b285b168efb    auth_time       claim.name
9216b606-93a5-4101-8432-7b285b168efb    long    jsonType.label
d2f08b3d-c3e7-4895-85a2-1d3786821d05    true    access.token.claim
d2f08b3d-c3e7-4895-85a2-1d3786821d05    true    introspection.token.claim
69c20668-711f-4835-bff3-cd678cb8d049    clientAddress   user.session.note
69c20668-711f-4835-bff3-cd678cb8d049    true    introspection.token.claim
69c20668-711f-4835-bff3-cd678cb8d049    true    userinfo.token.claim
69c20668-711f-4835-bff3-cd678cb8d049    true    id.token.claim
69c20668-711f-4835-bff3-cd678cb8d049    true    access.token.claim
69c20668-711f-4835-bff3-cd678cb8d049    clientAddress   claim.name
69c20668-711f-4835-bff3-cd678cb8d049    String  jsonType.label
83a22ee4-39d9-4282-b909-3db3634d5382    client_id       user.session.note
83a22ee4-39d9-4282-b909-3db3634d5382    true    id.token.claim
83a22ee4-39d9-4282-b909-3db3634d5382    true    introspection.token.claim
83a22ee4-39d9-4282-b909-3db3634d5382    true    access.token.claim
83a22ee4-39d9-4282-b909-3db3634d5382    client_id       claim.name
83a22ee4-39d9-4282-b909-3db3634d5382    String  jsonType.label
d5cc4640-5ef2-49c5-97e9-a235fba176b5    clientHost      user.session.note
d5cc4640-5ef2-49c5-97e9-a235fba176b5    true    id.token.claim
d5cc4640-5ef2-49c5-97e9-a235fba176b5    true    introspection.token.claim
d5cc4640-5ef2-49c5-97e9-a235fba176b5    true    access.token.claim
d5cc4640-5ef2-49c5-97e9-a235fba176b5    clientHost      claim.name
d5cc4640-5ef2-49c5-97e9-a235fba176b5    String  jsonType.label
83a22ee4-39d9-4282-b909-3db3634d5382    true    userinfo.token.claim
d5cc4640-5ef2-49c5-97e9-a235fba176b5    true    userinfo.token.claim
5f06959c-805a-4ef7-8e59-e39a2a4008d7    true    id.token.claim
5f06959c-805a-4ef7-8e59-e39a2a4008d7    true    access.token.claim
5f06959c-805a-4ef7-8e59-e39a2a4008d7    true    introspection.token.claim
5f06959c-805a-4ef7-8e59-e39a2a4008d7    true    userinfo.token.claim
425ecf52-9c92-4d8a-9121-e823ca7dc9aa    true    access.token.claim
425ecf52-9c92-4d8a-9121-e823ca7dc9aa    true    introspection.token.claim
74bf9b50-0aa1-46a4-9e79-fc196d089064    foo     user.attribute
74bf9b50-0aa1-46a4-9e79-fc196d089064    true    introspection.token.claim
74bf9b50-0aa1-46a4-9e79-fc196d089064    true    access.token.claim
74bf9b50-0aa1-46a4-9e79-fc196d089064    resource_access.${client_id}.roles      claim.name
74bf9b50-0aa1-46a4-9e79-fc196d089064    String  jsonType.label
74bf9b50-0aa1-46a4-9e79-fc196d089064    true    multivalued
98fb889b-edde-46f3-be11-547ff136d09d    foo     user.attribute
98fb889b-edde-46f3-be11-547ff136d09d    true    introspection.token.claim
98fb889b-edde-46f3-be11-547ff136d09d    true    access.token.claim
98fb889b-edde-46f3-be11-547ff136d09d    realm_access.roles      claim.name
98fb889b-edde-46f3-be11-547ff136d09d    String  jsonType.label
98fb889b-edde-46f3-be11-547ff136d09d    true    multivalued
472b3585-3d48-47c6-aae1-4de6155e4534    true    introspection.token.claim
472b3585-3d48-47c6-aae1-4de6155e4534    true    userinfo.token.claim
472b3585-3d48-47c6-aae1-4de6155e4534    username        user.attribute
472b3585-3d48-47c6-aae1-4de6155e4534    true    id.token.claim
472b3585-3d48-47c6-aae1-4de6155e4534    true    access.token.claim
472b3585-3d48-47c6-aae1-4de6155e4534    upn     claim.name
472b3585-3d48-47c6-aae1-4de6155e4534    String  jsonType.label
4ad3dfdc-2304-480e-baa0-2bc2a386675b    true    introspection.token.claim
4ad3dfdc-2304-480e-baa0-2bc2a386675b    true    multivalued
4ad3dfdc-2304-480e-baa0-2bc2a386675b    true    userinfo.token.claim
4ad3dfdc-2304-480e-baa0-2bc2a386675b    foo     user.attribute
4ad3dfdc-2304-480e-baa0-2bc2a386675b    true    id.token.claim
4ad3dfdc-2304-480e-baa0-2bc2a386675b    true    access.token.claim
4ad3dfdc-2304-480e-baa0-2bc2a386675b    groups  claim.name
4ad3dfdc-2304-480e-baa0-2bc2a386675b    String  jsonType.label
11b262be-4dca-436c-a0df-d3d147e816b7    true    access.token.claim
11b262be-4dca-436c-a0df-d3d147e816b7    true    introspection.token.claim
9eab1ccc-3701-4586-bedc-c19eff642fe4    true    introspection.token.claim
9eab1ccc-3701-4586-bedc-c19eff642fe4    true    multivalued
9eab1ccc-3701-4586-bedc-c19eff642fe4    true    userinfo.token.claim
9eab1ccc-3701-4586-bedc-c19eff642fe4    true    id.token.claim
9eab1ccc-3701-4586-bedc-c19eff642fe4    true    access.token.claim
9eab1ccc-3701-4586-bedc-c19eff642fe4    organization    claim.name
9eab1ccc-3701-4586-bedc-c19eff642fe4    String  jsonType.label
6fe3085f-ab8c-40d3-b6e3-d0ae2d323b1f    true    introspection.token.claim
6fe3085f-ab8c-40d3-b6e3-d0ae2d323b1f    true    userinfo.token.claim
6fe3085f-ab8c-40d3-b6e3-d0ae2d323b1f    locale  user.attribute
6fe3085f-ab8c-40d3-b6e3-d0ae2d323b1f    true    id.token.claim
6fe3085f-ab8c-40d3-b6e3-d0ae2d323b1f    true    access.token.claim
6fe3085f-ab8c-40d3-b6e3-d0ae2d323b1f    locale  claim.name
6fe3085f-ab8c-40d3-b6e3-d0ae2d323b1f    String  jsonType.label
\.


--
-- Data for Name: realm; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.realm (id, access_code_lifespan, user_action_lifespan, access_token_lifespan, account_theme, admin_theme, email_theme, enabled, events_enabled, events_expiration, login_theme, name, not_before, password_policy, registration_allowed, remember_me, reset_password_allowed, social, ssl_required, sso_idle_timeout, sso_max_lifespan, update_profile_on_soc_login, verify_email, master_admin_client, login_lifespan, internationalization_enabled, default_locale, reg_email_as_username, admin_events_enabled, admin_events_details_enabled, edit_username_allowed, otp_policy_counter, otp_policy_window, otp_policy_period, otp_policy_digits, otp_policy_alg, otp_policy_type, browser_flow, registration_flow, direct_grant_flow, reset_credentials_flow, client_auth_flow, offline_session_idle_timeout, revoke_refresh_token, access_token_life_implicit, login_with_email_allowed, duplicate_emails_allowed, docker_auth_flow, refresh_token_max_reuse, allow_user_managed_access, sso_max_lifespan_remember_me, sso_idle_timeout_remember_me, default_role) FROM stdin;
476d693d-9abf-4f63-a268-5002ea64c060    60      300     60      \N      \N      \N      t       f       0       \N     master   0       \N      f       f       f       f       EXTERNAL        1800    36000   f       f       826781ec-e76d-47ee-8ad7-b7c764855457    1800    f       \N      f       f       f       f       0       1       30      6       HmacSHA1totp    040fef41-5f2f-494c-978d-5a036fd5cc3d    c04df8d7-905a-4cc7-a1cd-315fa9f34fdd    a57bd553-7815-4191-b0e0-451ca19642b6    01dfb2dc-65c5-490e-9e21-ab029f8544e0    bd273089-9d5a-4070-bba7-c2cd0b89afa4    2592000 f       900     t      f96b41fed-4805-4711-9e86-649285675ae6    0       f       0       0       27f9ee59-8afb-4faa-a725-178d98c9f1c0
f19d6621-c51d-4928-ab07-1e2d5efd6e78    60      300     300                             t       t       60      xenon-dev-theme Xenon-Dev-DEV-ENV       0       \N      t       t       f       f       EXTERNAL        1800    36000   f      f7130ba2d-54dd-4607-8133-abe74a3dbac8    1800    f       \N      f       t       t       t       0       1       30     6HmacSHA1        totp    d3065499-91cd-4ffc-8dfd-ff640c427933    1a9e17a3-760f-4ff2-94aa-f9c03fc1639a    bcc4f0fe-9a6d-4c65-bd59-5ab6831157b3    68303f1c-cdbd-41d2-be1f-581609355e3d    26d68d38-fe11-4a4b-8633-1b583f5a414f    2592000 f      900      f       f       22d63ff9-27ac-49b3-8e02-01aa1591bc39    0       f       0       0       c12a42cd-b2a1-4ac1-9fa4-722c4e8db40a
\.


--
-- Data for Name: realm_attribute; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.realm_attribute (name, realm_id, value) FROM stdin;
_browser_header.contentSecurityPolicyReportOnly 476d693d-9abf-4f63-a268-5002ea64c060
_browser_header.xContentTypeOptions     476d693d-9abf-4f63-a268-5002ea64c060    nosniff
_browser_header.referrerPolicy  476d693d-9abf-4f63-a268-5002ea64c060    no-referrer
_browser_header.xRobotsTag      476d693d-9abf-4f63-a268-5002ea64c060    none
_browser_header.xFrameOptions   476d693d-9abf-4f63-a268-5002ea64c060    SAMEORIGIN
_browser_header.contentSecurityPolicy   476d693d-9abf-4f63-a268-5002ea64c060    frame-src 'self'; frame-ancestors 'self'; object-src 'none';
_browser_header.strictTransportSecurity 476d693d-9abf-4f63-a268-5002ea64c060    max-age=31536000; includeSubDomains
bruteForceProtected     476d693d-9abf-4f63-a268-5002ea64c060    false
permanentLockout        476d693d-9abf-4f63-a268-5002ea64c060    false
maxTemporaryLockouts    476d693d-9abf-4f63-a268-5002ea64c060    0
bruteForceStrategy      476d693d-9abf-4f63-a268-5002ea64c060    MULTIPLE
maxFailureWaitSeconds   476d693d-9abf-4f63-a268-5002ea64c060    900
minimumQuickLoginWaitSeconds    476d693d-9abf-4f63-a268-5002ea64c060    60
waitIncrementSeconds    476d693d-9abf-4f63-a268-5002ea64c060    60
quickLoginCheckMilliSeconds     476d693d-9abf-4f63-a268-5002ea64c060    1000
maxDeltaTimeSeconds     476d693d-9abf-4f63-a268-5002ea64c060    43200
failureFactor   476d693d-9abf-4f63-a268-5002ea64c060    30
maxSecondaryAuthFailures        476d693d-9abf-4f63-a268-5002ea64c060    0
realmReusableOtpCode    476d693d-9abf-4f63-a268-5002ea64c060    false
firstBrokerLoginFlowId  476d693d-9abf-4f63-a268-5002ea64c060    384df362-a8a3-429b-9c82-4b29cecc147a
displayName     476d693d-9abf-4f63-a268-5002ea64c060    Keycloak
displayNameHtml 476d693d-9abf-4f63-a268-5002ea64c060    <div class="kc-logo-text"><span>Keycloak</span></div>
defaultSignatureAlgorithm       476d693d-9abf-4f63-a268-5002ea64c060    RS256
offlineSessionMaxLifespanEnabled        476d693d-9abf-4f63-a268-5002ea64c060    false
offlineSessionMaxLifespan       476d693d-9abf-4f63-a268-5002ea64c060    5184000
_browser_header.contentSecurityPolicyReportOnly f19d6621-c51d-4928-ab07-1e2d5efd6e78
_browser_header.xContentTypeOptions     f19d6621-c51d-4928-ab07-1e2d5efd6e78    nosniff
_browser_header.referrerPolicy  f19d6621-c51d-4928-ab07-1e2d5efd6e78    no-referrer
_browser_header.xRobotsTag      f19d6621-c51d-4928-ab07-1e2d5efd6e78    none
_browser_header.xFrameOptions   f19d6621-c51d-4928-ab07-1e2d5efd6e78    SAMEORIGIN
_browser_header.contentSecurityPolicy   f19d6621-c51d-4928-ab07-1e2d5efd6e78    frame-src 'self'; frame-ancestors 'self'; object-src 'none';
_browser_header.strictTransportSecurity f19d6621-c51d-4928-ab07-1e2d5efd6e78    max-age=31536000; includeSubDomains
bruteForceProtected     f19d6621-c51d-4928-ab07-1e2d5efd6e78    false
permanentLockout        f19d6621-c51d-4928-ab07-1e2d5efd6e78    false
maxTemporaryLockouts    f19d6621-c51d-4928-ab07-1e2d5efd6e78    0
bruteForceStrategy      f19d6621-c51d-4928-ab07-1e2d5efd6e78    MULTIPLE
maxFailureWaitSeconds   f19d6621-c51d-4928-ab07-1e2d5efd6e78    900
minimumQuickLoginWaitSeconds    f19d6621-c51d-4928-ab07-1e2d5efd6e78    60
waitIncrementSeconds    f19d6621-c51d-4928-ab07-1e2d5efd6e78    60
quickLoginCheckMilliSeconds     f19d6621-c51d-4928-ab07-1e2d5efd6e78    1000
maxDeltaTimeSeconds     f19d6621-c51d-4928-ab07-1e2d5efd6e78    43200
failureFactor   f19d6621-c51d-4928-ab07-1e2d5efd6e78    30
maxSecondaryAuthFailures        f19d6621-c51d-4928-ab07-1e2d5efd6e78    0
realmReusableOtpCode    f19d6621-c51d-4928-ab07-1e2d5efd6e78    false
displayName     f19d6621-c51d-4928-ab07-1e2d5efd6e78
displayNameHtml f19d6621-c51d-4928-ab07-1e2d5efd6e78
defaultSignatureAlgorithm       f19d6621-c51d-4928-ab07-1e2d5efd6e78    RS256
offlineSessionMaxLifespanEnabled        f19d6621-c51d-4928-ab07-1e2d5efd6e78    false
offlineSessionMaxLifespan       f19d6621-c51d-4928-ab07-1e2d5efd6e78    5184000
clientSessionMaxLifespan        f19d6621-c51d-4928-ab07-1e2d5efd6e78    0
clientOfflineSessionIdleTimeout f19d6621-c51d-4928-ab07-1e2d5efd6e78    0
clientOfflineSessionMaxLifespan f19d6621-c51d-4928-ab07-1e2d5efd6e78    0
actionTokenGeneratedByAdminLifespan     f19d6621-c51d-4928-ab07-1e2d5efd6e78    43200
actionTokenGeneratedByUserLifespan      f19d6621-c51d-4928-ab07-1e2d5efd6e78    300
oauth2DeviceCodeLifespan        f19d6621-c51d-4928-ab07-1e2d5efd6e78    600
oauth2DevicePollingInterval     f19d6621-c51d-4928-ab07-1e2d5efd6e78    5
organizationsEnabled    f19d6621-c51d-4928-ab07-1e2d5efd6e78    false
adminPermissionsEnabled f19d6621-c51d-4928-ab07-1e2d5efd6e78    false
webAuthnPolicyRpEntityName      f19d6621-c51d-4928-ab07-1e2d5efd6e78    keycloak
webAuthnPolicySignatureAlgorithms       f19d6621-c51d-4928-ab07-1e2d5efd6e78    ES256,RS256
webAuthnPolicyRpId      f19d6621-c51d-4928-ab07-1e2d5efd6e78
webAuthnPolicyAttestationConveyancePreference   f19d6621-c51d-4928-ab07-1e2d5efd6e78    not specified
webAuthnPolicyAuthenticatorAttachment   f19d6621-c51d-4928-ab07-1e2d5efd6e78    not specified
webAuthnPolicyRequireResidentKey        f19d6621-c51d-4928-ab07-1e2d5efd6e78    not specified
webAuthnPolicyUserVerificationRequirement       f19d6621-c51d-4928-ab07-1e2d5efd6e78    not specified
webAuthnPolicyCreateTimeout     f19d6621-c51d-4928-ab07-1e2d5efd6e78    0
webAuthnPolicyAvoidSameAuthenticatorRegister    f19d6621-c51d-4928-ab07-1e2d5efd6e78    false
webAuthnPolicyRpEntityNamePasswordless  f19d6621-c51d-4928-ab07-1e2d5efd6e78    keycloak
webAuthnPolicySignatureAlgorithmsPasswordless   f19d6621-c51d-4928-ab07-1e2d5efd6e78    ES256,RS256
webAuthnPolicyRpIdPasswordless  f19d6621-c51d-4928-ab07-1e2d5efd6e78
webAuthnPolicyAttestationConveyancePreferencePasswordless       f19d6621-c51d-4928-ab07-1e2d5efd6e78    not specified
webAuthnPolicyAuthenticatorAttachmentPasswordless       f19d6621-c51d-4928-ab07-1e2d5efd6e78    not specified
webAuthnPolicyRequireResidentKeyPasswordless    f19d6621-c51d-4928-ab07-1e2d5efd6e78    not specified
webAuthnPolicyUserVerificationRequirementPasswordless   f19d6621-c51d-4928-ab07-1e2d5efd6e78    not specified
webAuthnPolicyCreateTimeoutPasswordless f19d6621-c51d-4928-ab07-1e2d5efd6e78    0
webAuthnPolicyAvoidSameAuthenticatorRegisterPasswordless        f19d6621-c51d-4928-ab07-1e2d5efd6e78    false
cibaBackchannelTokenDeliveryMode        f19d6621-c51d-4928-ab07-1e2d5efd6e78    poll
cibaExpiresIn   f19d6621-c51d-4928-ab07-1e2d5efd6e78    120
cibaInterval    f19d6621-c51d-4928-ab07-1e2d5efd6e78    5
cibaAuthRequestedUserHint       f19d6621-c51d-4928-ab07-1e2d5efd6e78    login_hint
parRequestUriLifespan   f19d6621-c51d-4928-ab07-1e2d5efd6e78    60
firstBrokerLoginFlowId  f19d6621-c51d-4928-ab07-1e2d5efd6e78    fa7fcc2d-669b-4e44-9245-9c9e1e7a648d
saml.signature.algorithm        f19d6621-c51d-4928-ab07-1e2d5efd6e78
frontendUrl     f19d6621-c51d-4928-ab07-1e2d5efd6e78
acr.loa.map     f19d6621-c51d-4928-ab07-1e2d5efd6e78    {}
adminEventsExpiration   f19d6621-c51d-4928-ab07-1e2d5efd6e78    60
darkMode        f19d6621-c51d-4928-ab07-1e2d5efd6e78    true
verifiableCredentialsEnabled    f19d6621-c51d-4928-ab07-1e2d5efd6e78    false
client-policies.profiles        f19d6621-c51d-4928-ab07-1e2d5efd6e78    {"profiles":[]}
client-policies.policies        f19d6621-c51d-4928-ab07-1e2d5efd6e78    {"policies":[]}
scimApiEnabled  f19d6621-c51d-4928-ab07-1e2d5efd6e78    false
clientSessionIdleTimeout        f19d6621-c51d-4928-ab07-1e2d5efd6e78    300
\.


--
-- Data for Name: realm_default_groups; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.realm_default_groups (realm_id, group_id) FROM stdin;
f19d6621-c51d-4928-ab07-1e2d5efd6e78    a76e440f-1a8b-4bf7-be27-7631806fd855
\.


--
-- Data for Name: realm_enabled_event_types; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.realm_enabled_event_types (realm_id, value) FROM stdin;
f19d6621-c51d-4928-ab07-1e2d5efd6e78    UPDATE_CONSENT_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    UPDATE_TOTP
f19d6621-c51d-4928-ab07-1e2d5efd6e78    PERMISSION_TOKEN_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    IDENTITY_PROVIDER_RETRIEVE_TOKEN_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    UPDATE_CREDENTIAL
f19d6621-c51d-4928-ab07-1e2d5efd6e78    IMPERSONATE_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    CUSTOM_REQUIRED_ACTION
f19d6621-c51d-4928-ab07-1e2d5efd6e78    RESTART_AUTHENTICATION
f19d6621-c51d-4928-ab07-1e2d5efd6e78    CLIENT_INFO
f19d6621-c51d-4928-ab07-1e2d5efd6e78    IMPERSONATE
f19d6621-c51d-4928-ab07-1e2d5efd6e78    LOGIN
f19d6621-c51d-4928-ab07-1e2d5efd6e78    CLIENT_INITIATED_ACCOUNT_LINKING
f19d6621-c51d-4928-ab07-1e2d5efd6e78    OAUTH2_EXTENSION_GRANT
f19d6621-c51d-4928-ab07-1e2d5efd6e78    USER_DISABLED_BY_PERMANENT_LOCKOUT
f19d6621-c51d-4928-ab07-1e2d5efd6e78    REMOVE_CREDENTIAL_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    USER_DISABLED_BY_TEMPORARY_LOCKOUT_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    TOKEN_EXCHANGE
f19d6621-c51d-4928-ab07-1e2d5efd6e78    REGISTER
f19d6621-c51d-4928-ab07-1e2d5efd6e78    DELETE_ACCOUNT_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    IDENTITY_PROVIDER_LINK_ACCOUNT
f19d6621-c51d-4928-ab07-1e2d5efd6e78    INTROSPECT_TOKEN_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    USER_DISABLED_BY_TEMPORARY_LOCKOUT
f19d6621-c51d-4928-ab07-1e2d5efd6e78    DELETE_ACCOUNT
f19d6621-c51d-4928-ab07-1e2d5efd6e78    UPDATE_PASSWORD
f19d6621-c51d-4928-ab07-1e2d5efd6e78    IDENTITY_PROVIDER_FIRST_LOGIN
f19d6621-c51d-4928-ab07-1e2d5efd6e78    VERIFY_EMAIL
f19d6621-c51d-4928-ab07-1e2d5efd6e78    CLIENT_LOGIN_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    RESTART_AUTHENTICATION_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    EXECUTE_ACTIONS
f19d6621-c51d-4928-ab07-1e2d5efd6e78    REMOVE_FEDERATED_IDENTITY_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    TOKEN_EXCHANGE_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    UNREGISTER_NODE
f19d6621-c51d-4928-ab07-1e2d5efd6e78    FEDERATED_IDENTITY_OVERRIDE_LINK
f19d6621-c51d-4928-ab07-1e2d5efd6e78    SEND_IDENTITY_PROVIDER_LINK_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    USER_INFO_REQUEST_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    EXECUTE_ACTION_TOKEN_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    OAUTH2_EXTENSION_GRANT_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    SEND_VERIFY_EMAIL
f19d6621-c51d-4928-ab07-1e2d5efd6e78    IDENTITY_PROVIDER_RESPONSE
f19d6621-c51d-4928-ab07-1e2d5efd6e78    EXECUTE_ACTIONS_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    IDENTITY_PROVIDER_RETRIEVE_TOKEN
f19d6621-c51d-4928-ab07-1e2d5efd6e78    OAUTH2_DEVICE_CODE_TO_TOKEN
f19d6621-c51d-4928-ab07-1e2d5efd6e78    USER_DISABLED_BY_PERMANENT_LOCKOUT_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    UNREGISTER_NODE_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    VALIDATE_ACCESS_TOKEN_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    OAUTH2_DEVICE_VERIFY_USER_CODE_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    REVOKE_GRANT_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    UPDATE_EMAIL_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    INVITE_ORG_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    UPDATE_PROFILE
f19d6621-c51d-4928-ab07-1e2d5efd6e78    USER_INFO_REQUEST
f19d6621-c51d-4928-ab07-1e2d5efd6e78    SEND_IDENTITY_PROVIDER_LINK
f19d6621-c51d-4928-ab07-1e2d5efd6e78    SEND_VERIFY_EMAIL_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    CLIENT_INITIATED_ACCOUNT_LINKING_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    OAUTH2_DEVICE_AUTH_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    REMOVE_TOTP_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    VERIFY_EMAIL_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    CLIENT_UPDATE
f19d6621-c51d-4928-ab07-1e2d5efd6e78    UPDATE_TOTP_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    VERIFY_PROFILE
f19d6621-c51d-4928-ab07-1e2d5efd6e78    GRANT_CONSENT_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    SEND_RESET_PASSWORD
f19d6621-c51d-4928-ab07-1e2d5efd6e78    GRANT_CONSENT
f19d6621-c51d-4928-ab07-1e2d5efd6e78    REGISTER_NODE_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    VERIFY_PROFILE_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    REMOVE_TOTP
f19d6621-c51d-4928-ab07-1e2d5efd6e78    REVOKE_GRANT
f19d6621-c51d-4928-ab07-1e2d5efd6e78    LOGIN_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    CLIENT_LOGIN
f19d6621-c51d-4928-ab07-1e2d5efd6e78    RESET_PASSWORD_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    CODE_TO_TOKEN_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    OAUTH2_DEVICE_CODE_TO_TOKEN_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    UPDATE_PROFILE_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    VALIDATE_ACCESS_TOKEN
f19d6621-c51d-4928-ab07-1e2d5efd6e78    OAUTH2_DEVICE_VERIFY_USER_CODE
f19d6621-c51d-4928-ab07-1e2d5efd6e78    UPDATE_PASSWORD_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    IDENTITY_PROVIDER_LOGIN
f19d6621-c51d-4928-ab07-1e2d5efd6e78    AUTHREQID_TO_TOKEN
f19d6621-c51d-4928-ab07-1e2d5efd6e78    LOGOUT
f19d6621-c51d-4928-ab07-1e2d5efd6e78    CLIENT_INFO_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    CLIENT_REGISTER
f19d6621-c51d-4928-ab07-1e2d5efd6e78    PUSHED_AUTHORIZATION_REQUEST
f19d6621-c51d-4928-ab07-1e2d5efd6e78    REFRESH_TOKEN
f19d6621-c51d-4928-ab07-1e2d5efd6e78    INTROSPECT_TOKEN
f19d6621-c51d-4928-ab07-1e2d5efd6e78    CLIENT_DELETE
f19d6621-c51d-4928-ab07-1e2d5efd6e78    FEDERATED_IDENTITY_LINK_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    CLIENT_DELETE_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    PERMISSION_TOKEN
f19d6621-c51d-4928-ab07-1e2d5efd6e78    REGISTER_NODE
f19d6621-c51d-4928-ab07-1e2d5efd6e78    INVALID_SIGNATURE
f19d6621-c51d-4928-ab07-1e2d5efd6e78    UPDATE_CREDENTIAL_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    PUSHED_AUTHORIZATION_REQUEST_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    OAUTH2_DEVICE_AUTH
f19d6621-c51d-4928-ab07-1e2d5efd6e78    REMOVE_FEDERATED_IDENTITY
f19d6621-c51d-4928-ab07-1e2d5efd6e78    IDENTITY_PROVIDER_POST_LOGIN
f19d6621-c51d-4928-ab07-1e2d5efd6e78    IDENTITY_PROVIDER_LINK_ACCOUNT_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    FEDERATED_IDENTITY_OVERRIDE_LINK_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    UPDATE_EMAIL
f19d6621-c51d-4928-ab07-1e2d5efd6e78    REGISTER_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    EXECUTE_ACTION_TOKEN
f19d6621-c51d-4928-ab07-1e2d5efd6e78    LOGOUT_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    CLIENT_UPDATE_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    AUTHREQID_TO_TOKEN_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    INVALID_SIGNATURE_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    CLIENT_REGISTER_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    FEDERATED_IDENTITY_LINK
f19d6621-c51d-4928-ab07-1e2d5efd6e78    IDENTITY_PROVIDER_RESPONSE_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    INVITE_ORG
f19d6621-c51d-4928-ab07-1e2d5efd6e78    IDENTITY_PROVIDER_LOGIN_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    RESET_PASSWORD
f19d6621-c51d-4928-ab07-1e2d5efd6e78    REMOVE_CREDENTIAL
f19d6621-c51d-4928-ab07-1e2d5efd6e78    UPDATE_CONSENT
f19d6621-c51d-4928-ab07-1e2d5efd6e78    SEND_RESET_PASSWORD_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    REFRESH_TOKEN_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    CUSTOM_REQUIRED_ACTION_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    IDENTITY_PROVIDER_POST_LOGIN_ERROR
f19d6621-c51d-4928-ab07-1e2d5efd6e78    CODE_TO_TOKEN
f19d6621-c51d-4928-ab07-1e2d5efd6e78    IDENTITY_PROVIDER_FIRST_LOGIN_ERROR
\.


--
-- Data for Name: realm_events_listeners; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.realm_events_listeners (realm_id, value) FROM stdin;
476d693d-9abf-4f63-a268-5002ea64c060    jboss-logging
f19d6621-c51d-4928-ab07-1e2d5efd6e78    jboss-logging
f19d6621-c51d-4928-ab07-1e2d5efd6e78    email
\.


--
-- Data for Name: realm_localizations; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.realm_localizations (realm_id, locale, texts) FROM stdin;
\.


--
-- Data for Name: realm_required_credential; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.realm_required_credential (type, form_label, input, secret, realm_id) FROM stdin;
password        password        t       t       476d693d-9abf-4f63-a268-5002ea64c060
password        password        t       t       f19d6621-c51d-4928-ab07-1e2d5efd6e78
\.


--
-- Data for Name: realm_smtp_config; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.realm_smtp_config (realm_id, value, name) FROM stdin;
f19d6621-c51d-4928-ab07-1e2d5efd6e78    true    debug
f19d6621-c51d-4928-ab07-1e2d5efd6e78            replyToDisplayName
f19d6621-c51d-4928-ab07-1e2d5efd6e78    true    starttls
f19d6621-c51d-4928-ab07-1e2d5efd6e78    true    auth
f19d6621-c51d-4928-ab07-1e2d5efd6e78            envelopeFrom
f19d6621-c51d-4928-ab07-1e2d5efd6e78    false   ssl
f19d6621-c51d-4928-ab07-1e2d5efd6e78    **********      password
f19d6621-c51d-4928-ab07-1e2d5efd6e78    587     port
f19d6621-c51d-4928-ab07-1e2d5efd6e78    email-smtp.eu-west-2.amazonaws.com      host
f19d6621-c51d-4928-ab07-1e2d5efd6e78            replyTo
f19d6621-c51d-4928-ab07-1e2d5efd6e78    no-reply@xenon-dev.com  from
f19d6621-c51d-4928-ab07-1e2d5efd6e78            fromDisplayName
f19d6621-c51d-4928-ab07-1e2d5efd6e78    basic   authType
f19d6621-c51d-4928-ab07-1e2d5efd6e78    AKIA3RYC6JGNQE5AK5O7    user
\.


--
-- Data for Name: realm_supported_locales; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.realm_supported_locales (realm_id, value) FROM stdin;
\.


--
-- Data for Name: redirect_uris; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.redirect_uris (client_id, value) FROM stdin;
06a7a117-2a7e-4517-8da7-1dfe8111d9d9    /realms/master/account/*
3a77a9b9-f7de-421d-9ae4-744d6549ba9c    /realms/master/account/*
e9211db7-c532-4a67-9aec-ab78f7f3c760    /admin/master/console/*
492d289b-e100-4f7e-b6a4-f4f81bf46618    /realms/Xenon-Dev-DEV-ENV/account/*
4ebb77df-7b06-4f46-b29a-4aedeec0a6bd    /realms/Xenon-Dev-DEV-ENV/account/*
53e2859c-34c6-4b00-8bee-efc443e7468d    /admin/Xenon-Dev-DEV-ENV/console/*
79013291-edda-4ffa-8125-d87720aa6d0a    http://localhost:4200/assets/silent-check-sso.html
79013291-edda-4ffa-8125-d87720aa6d0a    http://localhost:4200/*
79013291-edda-4ffa-8125-d87720aa6d0a    http://localhost:4200/landing
\.


--
-- Data for Name: required_action_config; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.required_action_config (required_action_id, value, name) FROM stdin;
\.


--
-- Data for Name: required_action_provider; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.required_action_provider (id, alias, name, realm_id, enabled, default_action, provider_id, priority) FROM stdin;
2fc46eb7-0840-4845-8296-7aea241760da    VERIFY_EMAIL    Verify Email    476d693d-9abf-4f63-a268-5002ea64c060    t      fVERIFY_EMAIL    50
9c96883a-c42a-4962-a4ab-eb4410964e24    UPDATE_PROFILE  Update Profile  476d693d-9abf-4f63-a268-5002ea64c060    t      fUPDATE_PROFILE  40
f095d5da-1bfd-4131-b72a-8c50f192757e    CONFIGURE_TOTP  Configure OTP   476d693d-9abf-4f63-a268-5002ea64c060    t      fCONFIGURE_TOTP  10
30eb38d6-c4b3-49c0-b1f8-c8d28c1ba1e3    UPDATE_PASSWORD Update Password 476d693d-9abf-4f63-a268-5002ea64c060    t      fUPDATE_PASSWORD 30
b50dbc0c-aada-4bb8-a5f7-c7d1e627eadc    TERMS_AND_CONDITIONS    Terms and Conditions    476d693d-9abf-4f63-a268-5002ea64c060    f       f       TERMS_AND_CONDITIONS    20
d83f8fd7-e162-4f75-b5b6-b744b74dfc4f    delete_account  Delete Account  476d693d-9abf-4f63-a268-5002ea64c060    f      fdelete_account  60
79bc6624-5fdc-494b-9f57-6e008053992f    delete_credential       Delete Credential       476d693d-9abf-4f63-a268-5002ea64c060    t       f       delete_credential       110
20c0f586-665c-400f-97e2-4642123ef9b0    update_user_locale      Update User Locale      476d693d-9abf-4f63-a268-5002ea64c060    t       f       update_user_locale      1000
acf9b57d-b26f-4c83-ad90-e31dbac553fe    UPDATE_EMAIL    Update Email    476d693d-9abf-4f63-a268-5002ea64c060    f      fUPDATE_EMAIL    70
ebae5136-2ce7-4de0-bdcd-51103cd336e5    CONFIGURE_RECOVERY_AUTHN_CODES  Recovery Authentication Codes   476d693d-9abf-4f63-a268-5002ea64c060    t       f       CONFIGURE_RECOVERY_AUTHN_CODES  130
a20186fe-14ca-4cd0-9ee3-be599ef6d423    webauthn-register       Webauthn Register       476d693d-9abf-4f63-a268-5002ea64c060    t       f       webauthn-register       80
8faee44b-e6b9-4bd4-bd34-10666dd1ddba    webauthn-register-passwordless  Webauthn Register Passwordless  476d693d-9abf-4f63-a268-5002ea64c060    t       f       webauthn-register-passwordless  90
0cf51dc2-edc5-40a8-bb9d-37bd467ceed3    VERIFY_PROFILE  Verify Profile  476d693d-9abf-4f63-a268-5002ea64c060    t      fVERIFY_PROFILE  100
77603785-57fd-453a-a62e-a18454b475a4    idp_link        Linking Identity Provider       476d693d-9abf-4f63-a268-5002ea64c060    t       f       idp_link        120
6ffa48f1-1ca2-4998-94ba-76ff3615a085    CONFIGURE_TOTP  Configure OTP   f19d6621-c51d-4928-ab07-1e2d5efd6e78    t      fCONFIGURE_TOTP  10
98c28c32-974e-4bdf-b0e5-c10ed2d4c780    TERMS_AND_CONDITIONS    Terms and Conditions    f19d6621-c51d-4928-ab07-1e2d5efd6e78    f       f       TERMS_AND_CONDITIONS    20
0de928dd-8295-47a9-bd87-2fffbe36f673    UPDATE_PASSWORD Update Password f19d6621-c51d-4928-ab07-1e2d5efd6e78    t      fUPDATE_PASSWORD 30
c553cc55-7956-4d1d-b5ae-9ca13452c8a5    UPDATE_PROFILE  Update Profile  f19d6621-c51d-4928-ab07-1e2d5efd6e78    t      fUPDATE_PROFILE  40
320132c5-b869-468e-aa57-060e49fd082a    VERIFY_EMAIL    Verify Email    f19d6621-c51d-4928-ab07-1e2d5efd6e78    t      fVERIFY_EMAIL    50
85b72a71-4690-4ee0-bd9a-90ed22a14450    delete_account  Delete Account  f19d6621-c51d-4928-ab07-1e2d5efd6e78    f      fdelete_account  60
18dcead8-9d3a-462c-8ac0-2226b351900e    webauthn-register       Webauthn Register       f19d6621-c51d-4928-ab07-1e2d5efd6e78    t       f       webauthn-register       70
bee6e32f-ec7f-43c7-9e7b-fc2838c20ecc    webauthn-register-passwordless  Webauthn Register Passwordless  f19d6621-c51d-4928-ab07-1e2d5efd6e78    t       f       webauthn-register-passwordless  80
7c169e45-80c0-4123-9fb1-4bdf36cd4590    VERIFY_PROFILE  Verify Profile  f19d6621-c51d-4928-ab07-1e2d5efd6e78    t      fVERIFY_PROFILE  90
ef4e4d2f-0da1-4b09-8a4e-97e0568bd5b8    delete_credential       Delete Credential       f19d6621-c51d-4928-ab07-1e2d5efd6e78    t       f       delete_credential       100
5158c913-da28-4511-a374-2e34aaa70d7e    idp_link        Linking Identity Provider       f19d6621-c51d-4928-ab07-1e2d5efd6e78    t       f       idp_link        110
7f88a6a6-d6aa-4b0b-8e4d-c4285b63ed2e    CONFIGURE_RECOVERY_AUTHN_CODES  Recovery Authentication Codes   f19d6621-c51d-4928-ab07-1e2d5efd6e78    t       f       CONFIGURE_RECOVERY_AUTHN_CODES  120
bd935dfd-34c1-41c6-b2d4-b4b4ade87514    update_user_locale      Update User Locale      f19d6621-c51d-4928-ab07-1e2d5efd6e78    t       f       update_user_locale      1000
\.


--
-- Data for Name: resource_attribute; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.resource_attribute (id, name, value, resource_id) FROM stdin;
\.


--
-- Data for Name: resource_policy; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.resource_policy (resource_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_scope; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.resource_scope (resource_id, scope_id) FROM stdin;
\.


--
-- Data for Name: resource_server; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.resource_server (id, allow_rs_remote_mgmt, policy_enforce_mode, decision_strategy) FROM stdin;
\.


--
-- Data for Name: resource_server_perm_ticket; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.resource_server_perm_ticket (id, owner, requester, created_timestamp, granted_timestamp, resource_id, scope_id, resource_server_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_server_policy; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.resource_server_policy (id, name, description, type, decision_strategy, logic, resource_server_id, owner) FROM stdin;
\.


--
-- Data for Name: resource_server_resource; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.resource_server_resource (id, name, type, icon_uri, owner, resource_server_id, owner_managed_access, display_name) FROM stdin;
\.


--
-- Data for Name: resource_server_scope; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.resource_server_scope (id, name, icon_uri, resource_server_id, display_name) FROM stdin;
\.


--
-- Data for Name: resource_uris; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.resource_uris (resource_id, value) FROM stdin;
\.


--
-- Data for Name: revoked_token; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.revoked_token (id, expire) FROM stdin;
\.


--
-- Data for Name: role_attribute; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.role_attribute (id, role_id, name, value) FROM stdin;
\.


--
-- Data for Name: scope_mapping; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.scope_mapping (client_id, role_id) FROM stdin;
3a77a9b9-f7de-421d-9ae4-744d6549ba9c    0ad38ea0-b005-4334-a8da-a7626d3fa9d0
3a77a9b9-f7de-421d-9ae4-744d6549ba9c    fbea6310-5cef-452c-a88c-cb5594454e89
4ebb77df-7b06-4f46-b29a-4aedeec0a6bd    76d883aa-495e-41ad-9e55-72703f26205d
4ebb77df-7b06-4f46-b29a-4aedeec0a6bd    63bab289-4440-467d-9580-d4c47005e5d4
\.


--
-- Data for Name: scope_policy; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.scope_policy (scope_id, policy_id) FROM stdin;
\.


--
-- Data for Name: server_config; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.server_config (server_config_key, value, version) FROM stdin;
\.


--
-- Data for Name: user_attribute; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.user_attribute (name, value, user_id, id, long_value_hash, long_value_hash_lower_case, long_value) FROM stdin;
\.


--
-- Data for Name: user_consent; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.user_consent (id, client_id, user_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: user_consent_client_scope; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.user_consent_client_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: user_entity; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.user_entity (id, email, email_constraint, email_verified, enabled, federation_link, first_name, last_name, realm_id, username, created_timestamp, service_account_client_link, not_before, last_modified_timestamp, player_profile_id) FROM stdin;
e9f01c19-42a9-47e5-a0c3-0119c5de7fab    mhyndman6464@gmail.com  mhyndman6464@gmail.com  t       t       \N      Matthew
Hyndman 476d693d-9abf-4f63-a268-5002ea64c060    matthew-admin   1781047447421   \N      0       1781047447421   \N
4cd2326c-3588-4bbe-b396-17626465c850    mhyndman6464@gmail.com  mhyndman6464@gmail.com  t       t       \N      Matthew
Hyndman f19d6621-c51d-4928-ab07-1e2d5efd6e78    xenon-dev-matthew-admin 1781047367952   \N      0       1781047367952  1
\.


--
-- Data for Name: user_federation_config; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.user_federation_config (user_federation_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.user_federation_mapper (id, name, federation_provider_id, federation_mapper_type, realm_id) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper_config; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.user_federation_mapper_config (user_federation_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_provider; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.user_federation_provider (id, changed_sync_period, display_name, full_sync_period, last_sync, priority, provider_name, realm_id) FROM stdin;
\.


--
-- Data for Name: user_group_membership; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.user_group_membership (group_id, user_id, membership_type) FROM stdin;
a76e440f-1a8b-4bf7-be27-7631806fd855    4cd2326c-3588-4bbe-b396-17626465c850    UNMANAGED
1db835b9-73b0-4485-9ead-c55a5149a793    4cd2326c-3588-4bbe-b396-17626465c850    UNMANAGED
\.


--
-- Data for Name: user_required_action; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.user_required_action (user_id, required_action) FROM stdin;
\.


--
-- Data for Name: user_role_mapping; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.user_role_mapping (role_id, user_id) FROM stdin;
c12a42cd-b2a1-4ac1-9fa4-722c4e8db40a    4cd2326c-3588-4bbe-b396-17626465c850
27f9ee59-8afb-4faa-a725-178d98c9f1c0    e9f01c19-42a9-47e5-a0c3-0119c5de7fab
e03136b4-ad0c-4627-b8cb-0c3fb842b86e    e9f01c19-42a9-47e5-a0c3-0119c5de7fab
ac79ab3f-564a-4a00-a752-e37bfe79d100    e9f01c19-42a9-47e5-a0c3-0119c5de7fab
ae11397e-a4f0-45d1-a518-de6fad7d9fb7    e9f01c19-42a9-47e5-a0c3-0119c5de7fab
cb196c0e-24ea-4b19-b6a8-3c52cfd7eece    e9f01c19-42a9-47e5-a0c3-0119c5de7fab
\.


--
-- Data for Name: web_origins; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.web_origins (client_id, value) FROM stdin;
e9211db7-c532-4a67-9aec-ab78f7f3c760    +
53e2859c-34c6-4b00-8bee-efc443e7468d    +
79013291-edda-4ffa-8125-d87720aa6d0a    http://localhost:8443
79013291-edda-4ffa-8125-d87720aa6d0a    *
79013291-edda-4ffa-8125-d87720aa6d0a    http://localhost:4200
\.


--
-- Data for Name: workflow_state; Type: TABLE DATA; Schema: public; Owner: Xenon-Dev-Admin
--

COPY public.workflow_state (execution_id, resource_id, workflow_id, resource_type, scheduled_step_id, scheduled_step_timestamp) FROM stdin;
\.


--
-- Name: player_profile_player_id_seq; Type: SEQUENCE SET; Schema: public; Owner: Xenon-Dev-Admin
--

SELECT pg_catalog.setval('public.player_profile_player_id_seq', 1, true);


--
-- Name: org_domain ORG_DOMAIN_pkey; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.org_domain
    ADD CONSTRAINT "ORG_DOMAIN_pkey" PRIMARY KEY (id, name);


--
-- Name: org ORG_pkey; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT "ORG_pkey" PRIMARY KEY (id);


--
-- Name: server_config SERVER_CONFIG_pkey; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.server_config
    ADD CONSTRAINT "SERVER_CONFIG_pkey" PRIMARY KEY (server_config_key);


--
-- Name: keycloak_role UK_J3RWUVD56ONTGSUHOGM184WW2-2; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT "UK_J3RWUVD56ONTGSUHOGM184WW2-2" UNIQUE (name, client_realm_constraint);


--
-- Name: client_auth_flow_bindings c_cli_flow_bind; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.client_auth_flow_bindings
    ADD CONSTRAINT c_cli_flow_bind PRIMARY KEY (client_id, binding_name);


--
-- Name: client_scope_client c_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.client_scope_client
    ADD CONSTRAINT c_cli_scope_bind PRIMARY KEY (client_id, scope_id);


--
-- Name: client_initial_access cnstr_client_init_acc_pk; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT cnstr_client_init_acc_pk PRIMARY KEY (id);


--
-- Name: realm_default_groups con_group_id_def_groups; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT con_group_id_def_groups UNIQUE (group_id);


--
-- Name: broker_link constr_broker_link_pk; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.broker_link
    ADD CONSTRAINT constr_broker_link_pk PRIMARY KEY (identity_provider, user_id);


--
-- Name: component_config constr_component_config_pk; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT constr_component_config_pk PRIMARY KEY (id);


--
-- Name: component constr_component_pk; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT constr_component_pk PRIMARY KEY (id);


--
-- Name: fed_user_required_action constr_fed_required_action; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.fed_user_required_action
    ADD CONSTRAINT constr_fed_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: fed_user_attribute constr_fed_user_attr_pk; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.fed_user_attribute
    ADD CONSTRAINT constr_fed_user_attr_pk PRIMARY KEY (id);


--
-- Name: fed_user_consent constr_fed_user_consent_pk; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.fed_user_consent
    ADD CONSTRAINT constr_fed_user_consent_pk PRIMARY KEY (id);


--
-- Name: fed_user_credential constr_fed_user_cred_pk; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.fed_user_credential
    ADD CONSTRAINT constr_fed_user_cred_pk PRIMARY KEY (id);


--
-- Name: fed_user_group_membership constr_fed_user_group; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.fed_user_group_membership
    ADD CONSTRAINT constr_fed_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: fed_user_role_mapping constr_fed_user_role; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.fed_user_role_mapping
    ADD CONSTRAINT constr_fed_user_role PRIMARY KEY (role_id, user_id);


--
-- Name: federated_user constr_federated_user; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.federated_user
    ADD CONSTRAINT constr_federated_user PRIMARY KEY (id);


--
-- Name: realm_default_groups constr_realm_default_groups; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT constr_realm_default_groups PRIMARY KEY (realm_id, group_id);


--
-- Name: realm_enabled_event_types constr_realm_enabl_event_types; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT constr_realm_enabl_event_types PRIMARY KEY (realm_id, value);


--
-- Name: realm_events_listeners constr_realm_events_listeners; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT constr_realm_events_listeners PRIMARY KEY (realm_id, value);


--
-- Name: realm_supported_locales constr_realm_supported_locales; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT constr_realm_supported_locales PRIMARY KEY (realm_id, value);


--
-- Name: identity_provider constraint_2b; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT constraint_2b PRIMARY KEY (internal_id);


--
-- Name: client_attributes constraint_3c; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT constraint_3c PRIMARY KEY (client_id, name);


--
-- Name: event_entity constraint_4; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.event_entity
    ADD CONSTRAINT constraint_4 PRIMARY KEY (id);


--
-- Name: federated_identity constraint_40; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT constraint_40 PRIMARY KEY (identity_provider, user_id);


--
-- Name: realm constraint_4a; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT constraint_4a PRIMARY KEY (id);


--
-- Name: user_federation_provider constraint_5c; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT constraint_5c PRIMARY KEY (id);


--
-- Name: client constraint_7; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT constraint_7 PRIMARY KEY (id);


--
-- Name: scope_mapping constraint_81; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT constraint_81 PRIMARY KEY (client_id, role_id);


--
-- Name: client_node_registrations constraint_84; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT constraint_84 PRIMARY KEY (client_id, name);


--
-- Name: realm_attribute constraint_9; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT constraint_9 PRIMARY KEY (name, realm_id);


--
-- Name: realm_required_credential constraint_92; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT constraint_92 PRIMARY KEY (realm_id, type);


--
-- Name: keycloak_role constraint_a; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT constraint_a PRIMARY KEY (id);


--
-- Name: admin_event_entity constraint_admin_event_entity; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.admin_event_entity
    ADD CONSTRAINT constraint_admin_event_entity PRIMARY KEY (id);


--
-- Name: authenticator_config_entry constraint_auth_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.authenticator_config_entry
    ADD CONSTRAINT constraint_auth_cfg_pk PRIMARY KEY (authenticator_id, name);


--
-- Name: authentication_execution constraint_auth_exec_pk; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT constraint_auth_exec_pk PRIMARY KEY (id);


--
-- Name: authentication_flow constraint_auth_flow_pk; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT constraint_auth_flow_pk PRIMARY KEY (id);


--
-- Name: authenticator_config constraint_auth_pk; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT constraint_auth_pk PRIMARY KEY (id);


--
-- Name: user_role_mapping constraint_c; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT constraint_c PRIMARY KEY (role_id, user_id);


--
-- Name: composite_role constraint_composite_role; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT constraint_composite_role PRIMARY KEY (composite, child_role);


--
-- Name: identity_provider_config constraint_d; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT constraint_d PRIMARY KEY (identity_provider_id, name);


--
-- Name: policy_config constraint_dpc; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT constraint_dpc PRIMARY KEY (policy_id, name);


--
-- Name: realm_smtp_config constraint_e; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT constraint_e PRIMARY KEY (realm_id, name);


--
-- Name: credential constraint_f; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT constraint_f PRIMARY KEY (id);


--
-- Name: user_federation_config constraint_f9; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT constraint_f9 PRIMARY KEY (user_federation_provider_id, name);


--
-- Name: resource_server_perm_ticket constraint_fapmt; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT constraint_fapmt PRIMARY KEY (id);


--
-- Name: resource_server_resource constraint_farsr; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT constraint_farsr PRIMARY KEY (id);


--
-- Name: resource_server_policy constraint_farsrp; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT constraint_farsrp PRIMARY KEY (id);


--
-- Name: associated_policy constraint_farsrpap; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT constraint_farsrpap PRIMARY KEY (policy_id, associated_policy_id);


--
-- Name: resource_policy constraint_farsrpp; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT constraint_farsrpp PRIMARY KEY (resource_id, policy_id);


--
-- Name: resource_server_scope constraint_farsrs; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT constraint_farsrs PRIMARY KEY (id);


--
-- Name: resource_scope constraint_farsrsp; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT constraint_farsrsp PRIMARY KEY (resource_id, scope_id);


--
-- Name: scope_policy constraint_farsrsps; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT constraint_farsrsps PRIMARY KEY (scope_id, policy_id);


--
-- Name: user_entity constraint_fb; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT constraint_fb PRIMARY KEY (id);


--
-- Name: user_federation_mapper_config constraint_fedmapper_cfg_pm; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT constraint_fedmapper_cfg_pm PRIMARY KEY (user_federation_mapper_id, name);


--
-- Name: user_federation_mapper constraint_fedmapperpm; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT constraint_fedmapperpm PRIMARY KEY (id);


--
-- Name: fed_user_consent_cl_scope constraint_fgrntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.fed_user_consent_cl_scope
    ADD CONSTRAINT constraint_fgrntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent_client_scope constraint_grntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT constraint_grntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent constraint_grntcsnt_pm; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT constraint_grntcsnt_pm PRIMARY KEY (id);


--
-- Name: keycloak_group constraint_group; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT constraint_group PRIMARY KEY (id);


--
-- Name: group_attribute constraint_group_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT constraint_group_attribute_pk PRIMARY KEY (id);


--
-- Name: group_role_mapping constraint_group_role; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT constraint_group_role PRIMARY KEY (role_id, group_id);


--
-- Name: identity_provider_mapper constraint_idpm; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT constraint_idpm PRIMARY KEY (id);


--
-- Name: idp_mapper_config constraint_idpmconfig; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT constraint_idpmconfig PRIMARY KEY (idp_mapper_id, name);


--
-- Name: jgroups_ping constraint_jgroups_ping; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.jgroups_ping
    ADD CONSTRAINT constraint_jgroups_ping PRIMARY KEY (address);


--
-- Name: migration_model constraint_migmod; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.migration_model
    ADD CONSTRAINT constraint_migmod PRIMARY KEY (id);


--
-- Name: offline_client_session constraint_offl_cl_ses_pk3; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.offline_client_session
    ADD CONSTRAINT constraint_offl_cl_ses_pk3 PRIMARY KEY (user_session_id, client_id, client_storage_provider, external_client_id, offline_flag);


--
-- Name: offline_user_session constraint_offl_us_ses_pk2; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.offline_user_session
    ADD CONSTRAINT constraint_offl_us_ses_pk2 PRIMARY KEY (user_session_id, offline_flag);


--
-- Name: org_invitation constraint_org_invitation; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.org_invitation
    ADD CONSTRAINT constraint_org_invitation PRIMARY KEY (id);


--
-- Name: protocol_mapper constraint_pcm; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT constraint_pcm PRIMARY KEY (id);


--
-- Name: protocol_mapper_config constraint_pmconfig; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT constraint_pmconfig PRIMARY KEY (protocol_mapper_id, name);


--
-- Name: redirect_uris constraint_redirect_uris; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT constraint_redirect_uris PRIMARY KEY (client_id, value);


--
-- Name: required_action_config constraint_req_act_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.required_action_config
    ADD CONSTRAINT constraint_req_act_cfg_pk PRIMARY KEY (required_action_id, name);


--
-- Name: required_action_provider constraint_req_act_prv_pk; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT constraint_req_act_prv_pk PRIMARY KEY (id);


--
-- Name: user_required_action constraint_required_action; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT constraint_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: resource_uris constraint_resour_uris_pk; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT constraint_resour_uris_pk PRIMARY KEY (resource_id, value);


--
-- Name: role_attribute constraint_role_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT constraint_role_attribute_pk PRIMARY KEY (id);


--
-- Name: revoked_token constraint_rt; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.revoked_token
    ADD CONSTRAINT constraint_rt PRIMARY KEY (id);


--
-- Name: user_attribute constraint_user_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT constraint_user_attribute_pk PRIMARY KEY (id);


--
-- Name: user_group_membership constraint_user_group; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT constraint_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: web_origins constraint_web_origins; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT constraint_web_origins PRIMARY KEY (client_id, value);


--
-- Name: databasechangeloglock databasechangeloglock_pkey; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT databasechangeloglock_pkey PRIMARY KEY (id);


--
-- Name: client_scope_attributes pk_cl_tmpl_attr; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT pk_cl_tmpl_attr PRIMARY KEY (scope_id, name);


--
-- Name: client_scope pk_cli_template; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT pk_cli_template PRIMARY KEY (id);


--
-- Name: resource_server pk_resource_server; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.resource_server
    ADD CONSTRAINT pk_resource_server PRIMARY KEY (id);


--
-- Name: client_scope_role_mapping pk_template_scope; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT pk_template_scope PRIMARY KEY (scope_id, role_id);


--
-- Name: workflow_state pk_workflow_state; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.workflow_state
    ADD CONSTRAINT pk_workflow_state PRIMARY KEY (execution_id);


--
-- Name: player_profile player_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.player_profile
    ADD CONSTRAINT player_profile_pkey PRIMARY KEY (player_id);


--
-- Name: default_client_scope r_def_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT r_def_cli_scope_bind PRIMARY KEY (realm_id, scope_id);


--
-- Name: realm_localizations realm_localizations_pkey; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.realm_localizations
    ADD CONSTRAINT realm_localizations_pkey PRIMARY KEY (realm_id, locale);


--
-- Name: resource_attribute res_attr_pk; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT res_attr_pk PRIMARY KEY (id);


--
-- Name: keycloak_group sibling_names; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT sibling_names UNIQUE (realm_id, parent_group, name);


--
-- Name: user_entity uk7wgjrrdlfgih211o2r17auvta; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk7wgjrrdlfgih211o2r17auvta UNIQUE (player_profile_id);


--
-- Name: identity_provider uk_2daelwnibji49avxsrtuf6xj33; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT uk_2daelwnibji49avxsrtuf6xj33 UNIQUE (provider_alias, realm_id);


--
-- Name: client uk_b71cjlbenv945rb6gcon438at; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT uk_b71cjlbenv945rb6gcon438at UNIQUE (realm_id, client_id);


--
-- Name: client_scope uk_cli_scope; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT uk_cli_scope UNIQUE (realm_id, name);


--
-- Name: user_entity uk_dykn684sl8up1crfei6eckhd7; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_dykn684sl8up1crfei6eckhd7 UNIQUE (realm_id, email_constraint);


--
-- Name: user_consent uk_external_consent; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT uk_external_consent UNIQUE (client_storage_provider, external_client_id, user_id);


--
-- Name: resource_server_resource uk_frsr6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5ha6 UNIQUE (name, owner, resource_server_id);


--
-- Name: resource_server_perm_ticket uk_frsr6t700s9v50bu18ws5pmt; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5pmt UNIQUE (owner, requester, resource_server_id, resource_id, scope_id);


--
-- Name: resource_server_policy uk_frsrpt700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT uk_frsrpt700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: resource_server_scope uk_frsrst700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT uk_frsrst700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: user_consent uk_local_consent; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT uk_local_consent UNIQUE (client_id, user_id);


--
-- Name: migration_model uk_migration_update_time; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.migration_model
    ADD CONSTRAINT uk_migration_update_time UNIQUE (update_time);


--
-- Name: migration_model uk_migration_version; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.migration_model
    ADD CONSTRAINT uk_migration_version UNIQUE (version);


--
-- Name: org uk_org_alias; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT uk_org_alias UNIQUE (realm_id, alias);


--
-- Name: org uk_org_group; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT uk_org_group UNIQUE (group_id);


--
-- Name: org_invitation uk_org_invitation_email; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.org_invitation
    ADD CONSTRAINT uk_org_invitation_email UNIQUE (organization_id, email);


--
-- Name: org uk_org_name; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT uk_org_name UNIQUE (realm_id, name);


--
-- Name: realm uk_orvsdmla56612eaefiq6wl5oi; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT uk_orvsdmla56612eaefiq6wl5oi UNIQUE (name);


--
-- Name: user_entity uk_ru8tt6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_ru8tt6t700s9v50bu18ws5ha6 UNIQUE (realm_id, username);


--
-- Name: workflow_state uq_workflow_resource; Type: CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.workflow_state
    ADD CONSTRAINT uq_workflow_resource UNIQUE (workflow_id, resource_id);


--
-- Name: fed_user_attr_long_values; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX fed_user_attr_long_values ON public.fed_user_attribute USING btree (long_value_hash, name);


--
-- Name: fed_user_attr_long_values_lower_case; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX fed_user_attr_long_values_lower_case ON public.fed_user_attribute USING btree (long_value_hash_lower_case, name);


--
-- Name: idx_admin_event_time; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_admin_event_time ON public.admin_event_entity USING btree (realm_id, admin_event_time);


--
-- Name: idx_assoc_pol_assoc_pol_id; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_assoc_pol_assoc_pol_id ON public.associated_policy USING btree (associated_policy_id);


--
-- Name: idx_auth_config_realm; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_auth_config_realm ON public.authenticator_config USING btree (realm_id);


--
-- Name: idx_auth_exec_flow; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_auth_exec_flow ON public.authentication_execution USING btree (flow_id);


--
-- Name: idx_auth_exec_realm_flow; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_auth_exec_realm_flow ON public.authentication_execution USING btree (realm_id, flow_id);


--
-- Name: idx_auth_flow_realm; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_auth_flow_realm ON public.authentication_flow USING btree (realm_id);


--
-- Name: idx_broker_link_identity_provider; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_broker_link_identity_provider ON public.broker_link USING btree (realm_id, identity_provider, broker_user_id);


--
-- Name: idx_broker_link_user_id; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_broker_link_user_id ON public.broker_link USING btree (user_id);


--
-- Name: idx_cl_clscope; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_cl_clscope ON public.client_scope_client USING btree (scope_id);


--
-- Name: idx_client_att_by_name_value; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_client_att_by_name_value ON public.client_attributes USING btree (name, substr(value, 1, 255));


--
-- Name: idx_client_id; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_client_id ON public.client USING btree (client_id);


--
-- Name: idx_client_init_acc_realm; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_client_init_acc_realm ON public.client_initial_access USING btree (realm_id);


--
-- Name: idx_clscope_attrs; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_clscope_attrs ON public.client_scope_attributes USING btree (scope_id);


--
-- Name: idx_clscope_cl; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_clscope_cl ON public.client_scope_client USING btree (client_id);


--
-- Name: idx_clscope_protmap; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_clscope_protmap ON public.protocol_mapper USING btree (client_scope_id);


--
-- Name: idx_clscope_role; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_clscope_role ON public.client_scope_role_mapping USING btree (scope_id);


--
-- Name: idx_compo_config_compo; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_compo_config_compo ON public.component_config USING btree (component_id);


--
-- Name: idx_component_provider_type; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_component_provider_type ON public.component USING btree (provider_type);


--
-- Name: idx_component_realm; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_component_realm ON public.component USING btree (realm_id);


--
-- Name: idx_composite; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_composite ON public.composite_role USING btree (composite);


--
-- Name: idx_composite_child; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_composite_child ON public.composite_role USING btree (child_role);


--
-- Name: idx_defcls_realm; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_defcls_realm ON public.default_client_scope USING btree (realm_id);


--
-- Name: idx_defcls_scope; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_defcls_scope ON public.default_client_scope USING btree (scope_id);


--
-- Name: idx_event_entity_user_id_type; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_event_entity_user_id_type ON public.event_entity USING btree (user_id, type, event_time);


--
-- Name: idx_event_time; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_event_time ON public.event_entity USING btree (realm_id, event_time);


--
-- Name: idx_fedidentity_feduser; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_fedidentity_feduser ON public.federated_identity USING btree (federated_user_id);


--
-- Name: idx_fedidentity_user; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_fedidentity_user ON public.federated_identity USING btree (user_id);


--
-- Name: idx_fu_attribute; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_fu_attribute ON public.fed_user_attribute USING btree (user_id, realm_id, name);


--
-- Name: idx_fu_cnsnt_ext; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_fu_cnsnt_ext ON public.fed_user_consent USING btree (user_id, client_storage_provider, external_client_id);


--
-- Name: idx_fu_consent; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_fu_consent ON public.fed_user_consent USING btree (user_id, client_id);


--
-- Name: idx_fu_consent_ru; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_fu_consent_ru ON public.fed_user_consent USING btree (realm_id, user_id);


--
-- Name: idx_fu_credential; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_fu_credential ON public.fed_user_credential USING btree (user_id, type);


--
-- Name: idx_fu_credential_ru; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_fu_credential_ru ON public.fed_user_credential USING btree (realm_id, user_id);


--
-- Name: idx_fu_group_membership; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_fu_group_membership ON public.fed_user_group_membership USING btree (user_id, group_id);


--
-- Name: idx_fu_group_membership_ru; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_fu_group_membership_ru ON public.fed_user_group_membership USING btree (realm_id, user_id);


--
-- Name: idx_fu_required_action; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_fu_required_action ON public.fed_user_required_action USING btree (user_id, required_action);


--
-- Name: idx_fu_required_action_ru; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_fu_required_action_ru ON public.fed_user_required_action USING btree (realm_id, user_id);


--
-- Name: idx_fu_role_mapping; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_fu_role_mapping ON public.fed_user_role_mapping USING btree (user_id, role_id);


--
-- Name: idx_fu_role_mapping_ru; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_fu_role_mapping_ru ON public.fed_user_role_mapping USING btree (realm_id, user_id);


--
-- Name: idx_group_att_by_name_value; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_group_att_by_name_value ON public.group_attribute USING btree (name, ((value)::character varying(250)));


--
-- Name: idx_group_attr_group; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_group_attr_group ON public.group_attribute USING btree (group_id);


--
-- Name: idx_group_org_id; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_group_org_id ON public.keycloak_group USING btree (org_id);


--
-- Name: idx_group_role_mapp_group; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_group_role_mapp_group ON public.group_role_mapping USING btree (group_id);


--
-- Name: idx_id_prov_mapp_realm; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_id_prov_mapp_realm ON public.identity_provider_mapper USING btree (realm_id);


--
-- Name: idx_ident_prov_realm; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_ident_prov_realm ON public.identity_provider USING btree (realm_id);


--
-- Name: idx_idp_for_login; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_idp_for_login ON public.identity_provider USING btree (realm_id, enabled, link_only, hide_on_login, organization_id);


--
-- Name: idx_idp_realm_org; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_idp_realm_org ON public.identity_provider USING btree (realm_id, organization_id);


--
-- Name: idx_keycloak_role_client; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_keycloak_role_client ON public.keycloak_role USING btree (client);


--
-- Name: idx_keycloak_role_realm; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_keycloak_role_realm ON public.keycloak_role USING btree (realm);


--
-- Name: idx_offline_css_by_client; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_offline_css_by_client ON public.offline_client_session USING btree (client_id, offline_flag) WHERE ((client_id)::text <> 'external'::text);


--
-- Name: idx_offline_css_by_client_and_realm; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_offline_css_by_client_and_realm ON public.offline_client_session USING btree (realm_id, offline_flag, client_id, client_storage_provider, external_client_id);


--
-- Name: idx_offline_css_by_client_storage_provider; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_offline_css_by_client_storage_provider ON public.offline_client_session USING btree (client_storage_provider, external_client_id, offline_flag) WHERE ((client_storage_provider)::text <> 'internal'::text);


--
-- Name: idx_offline_css_by_user_session_and_offline; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_offline_css_by_user_session_and_offline ON public.offline_client_session USING btree (offline_flag, user_session_id);


--
-- Name: idx_offline_uss_by_broker_session_id; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_offline_uss_by_broker_session_id ON public.offline_user_session USING btree (broker_session_id, realm_id);


--
-- Name: idx_offline_uss_by_user; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_offline_uss_by_user ON public.offline_user_session USING btree (user_id, realm_id, offline_flag);


--
-- Name: idx_org_domain_org_id; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_org_domain_org_id ON public.org_domain USING btree (org_id);


--
-- Name: idx_org_invitation_email; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_org_invitation_email ON public.org_invitation USING btree (email);


--
-- Name: idx_org_invitation_expires; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_org_invitation_expires ON public.org_invitation USING btree (expires_at);


--
-- Name: idx_org_invitation_org_id; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_org_invitation_org_id ON public.org_invitation USING btree (organization_id);


--
-- Name: idx_perm_ticket_owner; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_perm_ticket_owner ON public.resource_server_perm_ticket USING btree (owner);


--
-- Name: idx_perm_ticket_requester; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_perm_ticket_requester ON public.resource_server_perm_ticket USING btree (requester);


--
-- Name: idx_protocol_mapper_client; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_protocol_mapper_client ON public.protocol_mapper USING btree (client_id);


--
-- Name: idx_realm_attr_realm; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_realm_attr_realm ON public.realm_attribute USING btree (realm_id);


--
-- Name: idx_realm_clscope; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_realm_clscope ON public.client_scope USING btree (realm_id);


--
-- Name: idx_realm_def_grp_realm; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_realm_def_grp_realm ON public.realm_default_groups USING btree (realm_id);


--
-- Name: idx_realm_evt_list_realm; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_realm_evt_list_realm ON public.realm_events_listeners USING btree (realm_id);


--
-- Name: idx_realm_evt_types_realm; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_realm_evt_types_realm ON public.realm_enabled_event_types USING btree (realm_id);


--
-- Name: idx_realm_master_adm_cli; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_realm_master_adm_cli ON public.realm USING btree (master_admin_client);


--
-- Name: idx_realm_supp_local_realm; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_realm_supp_local_realm ON public.realm_supported_locales USING btree (realm_id);


--
-- Name: idx_redir_uri_client; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_redir_uri_client ON public.redirect_uris USING btree (client_id);


--
-- Name: idx_req_act_prov_realm; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_req_act_prov_realm ON public.required_action_provider USING btree (realm_id);


--
-- Name: idx_res_policy_policy; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_res_policy_policy ON public.resource_policy USING btree (policy_id);


--
-- Name: idx_res_scope_scope; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_res_scope_scope ON public.resource_scope USING btree (scope_id);


--
-- Name: idx_res_serv_pol_res_serv; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_res_serv_pol_res_serv ON public.resource_server_policy USING btree (resource_server_id);


--
-- Name: idx_res_srv_res_res_srv; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_res_srv_res_res_srv ON public.resource_server_resource USING btree (resource_server_id);


--
-- Name: idx_res_srv_scope_res_srv; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_res_srv_scope_res_srv ON public.resource_server_scope USING btree (resource_server_id);


--
-- Name: idx_rev_token_on_expire; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_rev_token_on_expire ON public.revoked_token USING btree (expire);


--
-- Name: idx_role_attribute; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_role_attribute ON public.role_attribute USING btree (role_id);


--
-- Name: idx_role_clscope; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_role_clscope ON public.client_scope_role_mapping USING btree (role_id);


--
-- Name: idx_scope_mapping_role; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_scope_mapping_role ON public.scope_mapping USING btree (role_id);


--
-- Name: idx_scope_policy_policy; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_scope_policy_policy ON public.scope_policy USING btree (policy_id);


--
-- Name: idx_update_time; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_update_time ON public.migration_model USING btree (update_time);


--
-- Name: idx_usconsent_clscope; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_usconsent_clscope ON public.user_consent_client_scope USING btree (user_consent_id);


--
-- Name: idx_usconsent_scope_id; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_usconsent_scope_id ON public.user_consent_client_scope USING btree (scope_id);


--
-- Name: idx_user_attribute; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_user_attribute ON public.user_attribute USING btree (user_id);


--
-- Name: idx_user_attribute_name; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_user_attribute_name ON public.user_attribute USING btree (name, value);


--
-- Name: idx_user_consent; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_user_consent ON public.user_consent USING btree (user_id);


--
-- Name: idx_user_created_timestamp; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_user_created_timestamp ON public.user_entity USING btree (realm_id, created_timestamp);


--
-- Name: idx_user_credential; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_user_credential ON public.credential USING btree (user_id);


--
-- Name: idx_user_email; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_user_email ON public.user_entity USING btree (email);


--
-- Name: idx_user_group_mapping; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_user_group_mapping ON public.user_group_membership USING btree (user_id);


--
-- Name: idx_user_reqactions; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_user_reqactions ON public.user_required_action USING btree (user_id);


--
-- Name: idx_user_role_mapping; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_user_role_mapping ON public.user_role_mapping USING btree (user_id);


--
-- Name: idx_user_service_account; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_user_service_account ON public.user_entity USING btree (realm_id, service_account_client_link);


--
-- Name: idx_user_session_expiration_created; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_user_session_expiration_created ON public.offline_user_session USING btree (realm_id, offline_flag, remember_me, created_on, user_session_id, user_id);


--
-- Name: idx_user_session_expiration_last_refresh; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_user_session_expiration_last_refresh ON public.offline_user_session USING btree (realm_id, offline_flag, remember_me, last_session_refresh, user_session_id, user_id);


--
-- Name: idx_usr_fed_map_fed_prv; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_usr_fed_map_fed_prv ON public.user_federation_mapper USING btree (federation_provider_id);


--
-- Name: idx_usr_fed_map_realm; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_usr_fed_map_realm ON public.user_federation_mapper USING btree (realm_id);


--
-- Name: idx_usr_fed_prv_realm; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_usr_fed_prv_realm ON public.user_federation_provider USING btree (realm_id);


--
-- Name: idx_web_orig_client; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_web_orig_client ON public.web_origins USING btree (client_id);


--
-- Name: idx_workflow_state_provider; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_workflow_state_provider ON public.workflow_state USING btree (resource_id);


--
-- Name: idx_workflow_state_step; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX idx_workflow_state_step ON public.workflow_state USING btree (workflow_id, scheduled_step_id);


--
-- Name: user_attr_long_values; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX user_attr_long_values ON public.user_attribute USING btree (long_value_hash, name);


--
-- Name: user_attr_long_values_lower_case; Type: INDEX; Schema: public; Owner: Xenon-Dev-Admin
--

CREATE INDEX user_attr_long_values_lower_case ON public.user_attribute USING btree (long_value_hash_lower_case, name);


--
-- Name: identity_provider fk2b4ebc52ae5c3b34; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT fk2b4ebc52ae5c3b34 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_attributes fk3c47c64beacca966; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT fk3c47c64beacca966 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: federated_identity fk404288b92ef007a6; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT fk404288b92ef007a6 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_node_registrations fk4129723ba992f594; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT fk4129723ba992f594 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: redirect_uris fk_1burs8pb4ouj97h5wuppahv9f; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT fk_1burs8pb4ouj97h5wuppahv9f FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: user_federation_provider fk_1fj32f6ptolw2qy60cd8n01e8; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT fk_1fj32f6ptolw2qy60cd8n01e8 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_required_credential fk_5hg65lybevavkqfki3kponh9v; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT fk_5hg65lybevavkqfki3kponh9v FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_attribute fk_5hrm2vlf9ql5fu022kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu022kqepovbr FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: user_attribute fk_5hrm2vlf9ql5fu043kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu043kqepovbr FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: user_required_action fk_6qj3w1jw9cvafhe19bwsiuvmd; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT fk_6qj3w1jw9cvafhe19bwsiuvmd FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: keycloak_role fk_6vyqfe4cn4wlq8r6kt5vdsj5c; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT fk_6vyqfe4cn4wlq8r6kt5vdsj5c FOREIGN KEY (realm) REFERENCES public.realm(id);


--
-- Name: realm_smtp_config fk_70ej8xdxgxd0b9hh6180irr0o; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT fk_70ej8xdxgxd0b9hh6180irr0o FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_attribute fk_8shxd6l3e9atqukacxgpffptw; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT fk_8shxd6l3e9atqukacxgpffptw FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: composite_role fk_a63wvekftu8jo1pnj81e7mce2; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_a63wvekftu8jo1pnj81e7mce2 FOREIGN KEY (composite) REFERENCES public.keycloak_role(id);


--
-- Name: authentication_execution fk_auth_exec_flow; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_flow FOREIGN KEY (flow_id) REFERENCES public.authentication_flow(id);


--
-- Name: authentication_execution fk_auth_exec_realm; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authentication_flow fk_auth_flow_realm; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT fk_auth_flow_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authenticator_config fk_auth_realm; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT fk_auth_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_role_mapping fk_c4fqv34p1mbylloxang7b1q3l; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT fk_c4fqv34p1mbylloxang7b1q3l FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_scope_attributes fk_cl_scope_attr_scope; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT fk_cl_scope_attr_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_scope_role_mapping fk_cl_scope_rm_scope; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT fk_cl_scope_rm_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: protocol_mapper fk_cli_scope_mapper; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_cli_scope_mapper FOREIGN KEY (client_scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_initial_access fk_client_init_acc_realm; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT fk_client_init_acc_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: component_config fk_component_config; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT fk_component_config FOREIGN KEY (component_id) REFERENCES public.component(id);


--
-- Name: component fk_component_realm; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT fk_component_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_default_groups fk_def_groups_realm; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT fk_def_groups_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_mapper_config fk_fedmapper_cfg; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT fk_fedmapper_cfg FOREIGN KEY (user_federation_mapper_id) REFERENCES public.user_federation_mapper(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_fedprv; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_fedprv FOREIGN KEY (federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: associated_policy fk_frsr5s213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsr5s213xcx4wnkog82ssrfy FOREIGN KEY (associated_policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrasp13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrasp13xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog82sspmt; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82sspmt FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_resource fk_frsrho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog83sspmt; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog83sspmt FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog84sspmt; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog84sspmt FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: associated_policy fk_frsrpas14xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsrpas14xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrpass3xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrpass3xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_perm_ticket fk_frsrpo2128cx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrpo2128cx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_policy fk_frsrpo213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT fk_frsrpo213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_scope fk_frsrpos13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrpos13xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpos53xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpos53xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpp213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpp213xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_scope fk_frsrps213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrps213xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_scope fk_frsrso213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT fk_frsrso213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: composite_role fk_gr7thllb9lu8q4vqa4524jjy8; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_gr7thllb9lu8q4vqa4524jjy8 FOREIGN KEY (child_role) REFERENCES public.keycloak_role(id);


--
-- Name: user_consent_client_scope fk_grntcsnt_clsc_usc; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT fk_grntcsnt_clsc_usc FOREIGN KEY (user_consent_id) REFERENCES public.user_consent(id);


--
-- Name: user_consent fk_grntcsnt_user; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT fk_grntcsnt_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: group_attribute fk_group_attribute_group; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT fk_group_attribute_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: keycloak_group fk_group_organization; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT fk_group_organization FOREIGN KEY (org_id) REFERENCES public.org(id);


--
-- Name: group_role_mapping fk_group_role_group; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT fk_group_role_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: realm_enabled_event_types fk_h846o4h0w8epx5nwedrf5y69j; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT fk_h846o4h0w8epx5nwedrf5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_events_listeners fk_h846o4h0w8epx5nxev9f5y69j; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT fk_h846o4h0w8epx5nxev9f5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: identity_provider_mapper fk_idpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT fk_idpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: idp_mapper_config fk_idpmconfig; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT fk_idpmconfig FOREIGN KEY (idp_mapper_id) REFERENCES public.identity_provider_mapper(id);


--
-- Name: web_origins fk_lojpho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT fk_lojpho213xcx4wnkog82ssrfy FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: org_invitation fk_org_invitation_org; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.org_invitation
    ADD CONSTRAINT fk_org_invitation_org FOREIGN KEY (organization_id) REFERENCES public.org(id) ON DELETE CASCADE;


--
-- Name: scope_mapping fk_ouse064plmlr732lxjcn1q5f1; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT fk_ouse064plmlr732lxjcn1q5f1 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: protocol_mapper fk_pcm_realm; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_pcm_realm FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: credential fk_pfyr0glasqyl0dei3kl69r6v0; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT fk_pfyr0glasqyl0dei3kl69r6v0 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: protocol_mapper_config fk_pmconfig; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT fk_pmconfig FOREIGN KEY (protocol_mapper_id) REFERENCES public.protocol_mapper(id);


--
-- Name: default_client_scope fk_r_def_cli_scope_realm; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT fk_r_def_cli_scope_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: required_action_provider fk_req_act_realm; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT fk_req_act_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_uris fk_resource_server_uris; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT fk_resource_server_uris FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: role_attribute fk_role_attribute_id; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT fk_role_attribute_id FOREIGN KEY (role_id) REFERENCES public.keycloak_role(id);


--
-- Name: realm_supported_locales fk_supported_locales_realm; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT fk_supported_locales_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_config fk_t13hpu1j94r2ebpekr39x5eu5; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT fk_t13hpu1j94r2ebpekr39x5eu5 FOREIGN KEY (user_federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_group_membership fk_user_group_user; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT fk_user_group_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: policy_config fkdc34197cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT fkdc34197cf864c4e43 FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: identity_provider_config fkdc4897cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT fkdc4897cf864c4e43 FOREIGN KEY (identity_provider_id) REFERENCES public.identity_provider(internal_id);


--
-- Name: user_entity fkqpsincxd64v643nui9mtnw529; Type: FK CONSTRAINT; Schema: public; Owner: Xenon-Dev-Admin
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT fkqpsincxd64v643nui9mtnw529 FOREIGN KEY (player_profile_id) REFERENCES public.player_profile(player_id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: Xenon-Dev-Admin
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

\unrestrict n3Z0tA83MXV9bWUYuwRd9ezH2uudUeZfcCcy4mEsmFavQexHhoOZwoVFA5rG60n
