CREATE TABLE public.service (
	id char(36) NOT NULL,
	"name" varchar NOT NULL,
	price int NOT NULL,
	"type" varchar NOT NULL,
	same_time_quantity int NOT NULL,
  organization_id char(36) NOT NULL,
	CONSTRAINT service_pk PRIMARY KEY (id),
  CONSTRAINT service_fk FOREIGN KEY (organization_id) REFERENCES public.organization(id)
);
