CREATE TABLE public."location" (
	id char(36) NOT NULL,
	state char(2) NOT NULL,
	city varchar NOT NULL,
	CONSTRAINT location_pk PRIMARY KEY (id)
);
