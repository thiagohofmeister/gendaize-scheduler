CREATE TABLE public.service_user (
	service_id char(36) NOT NULL,
	user_id char(36) NOT NULL,
	CONSTRAINT service_user_pk PRIMARY KEY (service_id, user_id),
	CONSTRAINT service_user_fk FOREIGN KEY (service_id) REFERENCES public.service(id),
	CONSTRAINT service_user_fk_1 FOREIGN KEY (user_id) REFERENCES public."user"(id)
);
