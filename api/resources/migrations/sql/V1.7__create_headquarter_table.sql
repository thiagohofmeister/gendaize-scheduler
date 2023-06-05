CREATE TABLE public.headquarter (
	id char(36) NOT NULL,
	"name" varchar NULL,
	address_state char(2) NOT NULL,
	address_city varchar NOT NULL,
	address_district varchar NOT NULL,
	address_street varchar NOT NULL,
	address_number varchar NOT NULL,
	address_complement varchar NULL,
  address_zip_code varchar NOT NULL,
	schedules json NULL,
	organization_id char(36) NOT NULL,
	CONSTRAINT headquarter_pk PRIMARY KEY (id),
	CONSTRAINT headquarter_fk FOREIGN KEY (organization_id) REFERENCES public.organization(id)
);
