CREATE TABLE public.authentication (
	id char(36) NOT NULL,
	"token" text NOT NULL,
	device varchar NOT NULL,
	status varchar NOT NULL,
	user_organization_id char(36) NULL,
  customer_id char(36) NULL,
	created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT authentication_pk PRIMARY KEY (id),
	CONSTRAINT authentication_fk FOREIGN KEY (user_organization_id) REFERENCES public.user_organization(id),
  CONSTRAINT authentication_fk_1 FOREIGN KEY (customer_id) REFERENCES public.customer(id)
);
