ALTER TABLE public.scheduled DROP CONSTRAINT scheduled_fk_1;
ALTER TABLE public.scheduled ADD CONSTRAINT scheduled_fk_1 FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON DELETE CASCADE;
