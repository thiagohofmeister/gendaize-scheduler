CREATE TABLE public.customer_package_service (
	id char(36) NOT NULL,
	service_id char(36) NOT NULL,
	customer_package_id char(36) NOT NULL,
	quantity int NOT NULL,
	CONSTRAINT customer_package_service_pk PRIMARY KEY (id),
	CONSTRAINT customer_package_service_fk FOREIGN KEY (service_id) REFERENCES public.service(id),
	CONSTRAINT customer_package_service_fk_1 FOREIGN KEY (customer_package_id) REFERENCES public.customer_package(id)
);
