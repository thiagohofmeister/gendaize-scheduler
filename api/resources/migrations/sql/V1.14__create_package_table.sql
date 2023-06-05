CREATE TABLE public.package (
	id char(36) NOT NULL,
	"label" varchar NOT NULL,
	price int NOT NULL,
	total_discount int NOT NULL,
	organization_id char(36) NOT NULL,
	CONSTRAINT package_pk PRIMARY KEY (id),
	CONSTRAINT package_fk FOREIGN KEY (organization_id) REFERENCES public.organization(id)
);
