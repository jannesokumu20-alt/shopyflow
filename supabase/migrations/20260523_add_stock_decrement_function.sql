CREATE OR REPLACE FUNCTION decrement_stock(product_id UUID, quantity INTEGER)
RETURNS INTEGER AS $$
DECLARE
  current_stock INTEGER;
  new_stock INTEGER;
BEGIN
  SELECT stock INTO current_stock FROM products WHERE id = product_id FOR UPDATE;
  IF current_stock < quantity THEN
    RAISE EXCEPTION 'Insufficient stock for product %', product_id;
  END IF;
  new_stock := current_stock - quantity;
  UPDATE products SET stock = new_stock, updated_at = NOW() WHERE id = product_id;
  RETURN new_stock;
END;
$$ LANGUAGE plpgsql;
