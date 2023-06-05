CREATE TABLE public.tax (
	id char(36) NOT NULL,
	"label" varchar NOT NULL,
	"type" varchar NOT NULL,
	value_type varchar NOT NULL,
	value int NOT NULL,
	value_details json NULL,
  organization_id char(36) NOT NULL,
	CONSTRAINT tax_pk PRIMARY KEY (id),
  CONSTRAINT tax_fk FOREIGN KEY (organization_id) REFERENCES public.organization(id)
);
