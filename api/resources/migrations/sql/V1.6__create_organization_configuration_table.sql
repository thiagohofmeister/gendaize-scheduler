CREATE TABLE public.organization_configuration (
	id char(36) NOT NULL,
	value varchar NOT NULL,
	organization_id char(36) NOT NULL,
	configuration_id char(36) NOT NULL,
	CONSTRAINT organization_configuration_pk PRIMARY KEY (id),
	CONSTRAINT organization_configuration_fk FOREIGN KEY (organization_id) REFERENCES public.organization(id),
	CONSTRAINT organization_configuration_fk_1 FOREIGN KEY (configuration_id) REFERENCES public."configuration"(id)
);
