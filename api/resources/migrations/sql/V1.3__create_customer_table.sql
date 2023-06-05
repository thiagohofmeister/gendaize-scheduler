CREATE TABLE public.customer (
	id char(36) NOT NULL,
	"name" varchar NOT NULL,
	phone varchar NOT NULL,
	email varchar NULL,
	"password" varchar NULL,
	organization_id char(36) NOT NULL,
	CONSTRAINT customer_pk PRIMARY KEY (id),
	CONSTRAINT customer_fk FOREIGN KEY (organization_id) REFERENCES public.organization(id),
  CONSTRAINT customer_un UNIQUE (email,organization_id,phone)
);
