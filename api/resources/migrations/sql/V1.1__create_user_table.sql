CREATE TABLE public."user" (
	id char(36) NOT NULL,
	"name" varchar NOT NULL,
	document_number varchar NOT NULL,
	email varchar NOT NULL,
	"password" varchar NOT NULL,
	status varchar NOT NULL,
	created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT user_pk PRIMARY KEY (id)
);
