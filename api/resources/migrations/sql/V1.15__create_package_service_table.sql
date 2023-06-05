CREATE TABLE public.package_service (
	id char(36) NOT NULL,
	package_id char(36) NOT NULL,
	service_id char(36) NOT NULL,
	discount int NOT NULL,
	discount_type varchar NOT NULL,
	CONSTRAINT package_service_pk PRIMARY KEY (id),
	CONSTRAINT package_service_fk FOREIGN KEY (package_id) REFERENCES public.package(id),
	CONSTRAINT package_service_fk_1 FOREIGN KEY (service_id) REFERENCES public.service(id)
);
