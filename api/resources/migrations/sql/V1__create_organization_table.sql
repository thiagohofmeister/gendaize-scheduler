CREATE TABLE public.organization (
	id char(36) NOT NULL,
	"name" varchar NOT NULL,
	document_name varchar NULL,
	document_type varchar NOT NULL,
	document_number varchar NOT NULL,
	email varchar NULL,
	phone varchar NULL,
  created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT organization_pk PRIMARY KEY (id)
);
