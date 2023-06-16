ALTER TABLE public.customer_address DROP CONSTRAINT customer_address_fk;
ALTER TABLE public.customer_address ADD CONSTRAINT customer_address_fk FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON DELETE CASCADE;
