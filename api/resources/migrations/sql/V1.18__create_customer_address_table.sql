CREATE TABLE public.customer_address (
	id char(36) NOT NULL,
	state char(2) NOT NULL,
	city varchar NOT NULL,
	district varchar NOT NULL,
	street varchar NOT NULL,
	"number" varchar NOT NULL,
	complement varchar NULL,
	zip_code varchar NOT NULL,
	customer_id char(36) NOT NULL,
	CONSTRAINT customer_address_pk PRIMARY KEY (id),
	CONSTRAINT customer_address_fk FOREIGN KEY (customer_id) REFERENCES public.customer(id)
);
