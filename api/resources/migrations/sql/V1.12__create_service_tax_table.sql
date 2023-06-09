CREATE TABLE public.service_tax (
	service_id char(36) NOT NULL,
	tax_id char(36) NOT NULL,
	CONSTRAINT service_tax_pk PRIMARY KEY (service_id, tax_id),
	CONSTRAINT service_tax_fk FOREIGN KEY (service_id) REFERENCES public.service(id),
	CONSTRAINT service_tax_fk_1 FOREIGN KEY (tax_id) REFERENCES public.tax(id)
);
