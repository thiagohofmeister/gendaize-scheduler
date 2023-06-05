CREATE TABLE public."configuration" (
	id char(36) NOT NULL,
	identifier varchar NOT NULL,
	"label" varchar NOT NULL,
	"type" varchar NOT NULL,
	type_values json NULL,
	CONSTRAINT configuration_pk PRIMARY KEY (id),
	CONSTRAINT configuration_un UNIQUE (identifier)
);
