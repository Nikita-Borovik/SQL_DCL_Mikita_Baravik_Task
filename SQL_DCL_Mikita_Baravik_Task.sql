1. 
CREATE USER rentaluser WITH PASSWORD 'rentalpassword';

2.
GRANT CONNECT ON DATABASE dvd_rental TO rentaluser;
GRANT USAGE ON SCHEMA public TO rentaluser;
GRANT SELECT ON TABLE public.customer TO rentaluser;

3.
CREATE ROLE rental;
GRANT rental TO rentaluser;

4.
GRANT INSERT, UPDATE ON TABLE public.rental TO rental;

INSERT INTO public.rental (rental_date, inventory_id, customer_id, return_date, staff_id)
VALUES ('2024-06-14', 1, 1, '2024-06-20', 1)
RETURNING rental_id;


UPDATE public.rental SET return_date = '2024-06-21' WHERE rental_id = 10002;
 
5.
REVOKE INSERT ON TABLE public.rental FROM rental;

INSERT INTO public.rental (rental_date, inventory_id, customer_id, return_date, staff_id)
VALUES ('2024-06-15', 2, 2, '2024-06-22', 2);

6.
SELECT c.customer_id, c.first_name, c.last_name
FROM public.customer c
JOIN public.rental r ON c.customer_id = r.customer_id
JOIN public.payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id
HAVING COUNT(r.rental_id) > 0 AND COUNT(p.payment_id) > 0
LIMIT 1;

CREATE ROLE client_John_Doe;

GRANT CONNECT ON DATABASE dvd_rental TO client_John_Doe;
GRANT USAGE ON SCHEMA public TO client_John_Doe;

GRANT SELECT ON TABLE public.rental TO client_John_Doe;
GRANT SELECT ON TABLE public.payment TO client_John_Doe;

ALTER TABLE public.rental ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payment ENABLE ROW LEVEL SECURITY;

CREATE POLICY rental_policy ON public.rental
    FOR SELECT
    USING (customer_id = 1);

CREATE POLICY payment_policy ON public.payment
    FOR SELECT
    USING (customer_id = 1);

ALTER TABLE public.rental FORCE ROW LEVEL SECURITY;
ALTER TABLE public.payment FORCE ROW LEVEL SECURITY;

-- Log in as client_John_Doe and execute:
SELECT * FROM public.rental;
SELECT * FROM public.payment;
