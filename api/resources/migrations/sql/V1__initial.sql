-- -----------------------------------------------------
-- Table `organization`
-- -----------------------------------------------------
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


-- -----------------------------------------------------
-- Table `user`
-- -----------------------------------------------------
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


-- -----------------------------------------------------
-- Table `user_organization`
-- -----------------------------------------------------
CREATE TABLE public.user_organization (
	id char(36) NOT NULL,
	user_id char(36) NOT NULL,
	organization_id char(36) NOT NULL,
	role_type varchar NOT NULL,
	status varchar NOT NULL,
	CONSTRAINT user_organization_pk PRIMARY KEY (id),
	CONSTRAINT user_organization_un UNIQUE (user_id,organization_id,role_type),
	CONSTRAINT user_organization_fk FOREIGN KEY (user_id) REFERENCES public."user"(id),
	CONSTRAINT user_organization_fk_1 FOREIGN KEY (organization_id) REFERENCES public.organization(id)
);


-- -----------------------------------------------------
-- Table `customer`
-- -----------------------------------------------------
CREATE TABLE public.customer (
	id char(36) NOT NULL,
	"name" varchar NOT NULL,
	phone varchar NOT NULL,
	email varchar NULL,
	"password" varchar NULL,
	organization_id char(36) NOT NULL,
	CONSTRAINT customer_pk PRIMARY KEY (id),
	CONSTRAINT customer_fk FOREIGN KEY (organization_id) REFERENCES public.organization(id),
  CONSTRAINT customer_un UNIQUE (email,organization_id,phone)
);


-- -----------------------------------------------------
-- Table `authentication`
-- -----------------------------------------------------
CREATE TABLE public.authentication (
	id char(36) NOT NULL,
	"token" text NOT NULL,
	device varchar NOT NULL,
	status varchar NOT NULL,
	user_organization_id char(36) NULL,
  customer_id char(36) NULL,
	created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT authentication_pk PRIMARY KEY (id),
	CONSTRAINT authentication_fk FOREIGN KEY (user_organization_id) REFERENCES public.user_organization(id),
  CONSTRAINT authentication_fk_1 FOREIGN KEY (customer_id) REFERENCES public.customer(id)
);
