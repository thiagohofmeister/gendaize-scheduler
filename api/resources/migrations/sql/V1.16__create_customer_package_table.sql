CREATE TABLE public.customer_package (
	id char(36) NOT NULL,
	created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	status varchar NOT NULL,
	package_id char(36) NOT NULL,
	customer_id char(36) NOT NULL,
	CONSTRAINT customer_package_pk PRIMARY KEY (id),
	CONSTRAINT customer_package_fk FOREIGN KEY (package_id) REFERENCES public.package(id),
	CONSTRAINT customer_package_fk_1 FOREIGN KEY (customer_id) REFERENCES public.customer(id)
);
