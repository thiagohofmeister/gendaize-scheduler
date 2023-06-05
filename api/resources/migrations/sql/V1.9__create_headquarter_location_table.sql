CREATE TABLE public.headquarter_location (
	id char(36) NOT NULL,
	headquarter_id char(36) NOT NULL,
	location_id char(36) NOT NULL,
	CONSTRAINT headquarter_location_pk PRIMARY KEY (id),
	CONSTRAINT headquarter_location_fk FOREIGN KEY (headquarter_id) REFERENCES public.headquarter(id),
	CONSTRAINT headquarter_location_fk_1 FOREIGN KEY (location_id) REFERENCES public."location"(id)
);
