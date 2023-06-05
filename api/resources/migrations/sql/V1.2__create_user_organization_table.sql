CREATE TABLE public.user_organization (
	id char(36) NOT NULL,
	user_id char(36) NOT NULL,
	organization_id char(36) NOT NULL,
	role_type varchar NOT NULL,
	status varchar NOT NULL,
	CONSTRAINT user_organization_pk PRIMARY KEY (id),
	CONSTRAINT user_organization_un UNIQUE (user_id,organization_id,role_type),
	CONSTRAINT user_organization_fk FOREIGN KEY (user_id) REFERENCES public."user"(id),
	CONSTRAINT user_organization_fk_1 FOREIGN KEY (organization_id) REFERENCES public.organization(id)
);
